// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FBlitColorVertexShaderBatchMaterial

package com.flengine.context.materials
{
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Context3D;
    import com.flengine.components.FCamera;
    import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FBlitColorVertexShaderBatchMaterial implements IGMaterial 
    {

        private static const NORMALIZED_VERTICES:Vector.<Number> = Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);

        private const CONSTANTS_PER_BATCH:int = 2;
        private const BATCH_SIZE:int = 62;
        private const VertexShaderEmbed:Class = FBlitColorVertexShaderBatchMaterialVertex_ash;
        private const VertexShaderCode:ByteArray = (new VertexShaderEmbed() as ByteArray);

        private var _p3ShaderProgram:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __cContext:Context3D;


        fl2d function initialize(p_context:Context3D):void
        {
            var _local7:int;
            var _local3:int;
            __cContext = p_context;
            VertexShaderCode.endian = "littleEndian";
            _p3ShaderProgram = p_context.createProgram();
            _p3ShaderProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
            var _local4:Vector.<Number> = new Vector.<Number>();
            var _local6:Vector.<Number> = new Vector.<Number>();
            var _local2:Vector.<Number> = new Vector.<Number>();
            _local7 = 0;
            while (_local7 < 62)
            {
                _local4 = _local4.concat(NORMALIZED_VERTICES);
                _local6 = _local6.concat(NORMALIZED_UVS);
                _local3 = (4 + (_local7 * 2));
                _local2.push(_local3, (_local3 + 1));
                _local2.push(_local3, (_local3 + 1));
                _local2.push(_local3, (_local3 + 1));
                _local2.push(_local3, (_local3 + 1));
                _local7++;
            };
            __vb3VertexBuffer = p_context.createVertexBuffer(248, 2);
            __vb3VertexBuffer.uploadFromVector(_local4, 0, 248);
            __vb3UVBuffer = p_context.createVertexBuffer(248, 2);
            __vb3UVBuffer.uploadFromVector(_local6, 0, 248);
            __vb3RegisterIndexBuffer = p_context.createVertexBuffer(248, 2);
            __vb3RegisterIndexBuffer.uploadFromVector(_local2, 0, 248);
            var _local5:Vector.<uint> = new Vector.<uint>();
            _local7 = 0;
            while (_local7 < 62)
            {
                _local5 = _local5.concat(Vector.<uint>([(4 * _local7), ((4 * _local7) + 1), ((4 * _local7) + 2), (4 * _local7), ((4 * _local7) + 2), ((4 * _local7) + 3)]));
                _local7++;
            };
            __ib3IndexBuffer = p_context.createIndexBuffer(372);
            __ib3IndexBuffer.uploadFromVector(_local5, 0, 372);
        }

        public function bind(p_context:Context3D, p_reinitialize:Boolean=false, p_camera:FCamera=null):void
        {
            if ((((_p3ShaderProgram == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame))))))
            {
                initialize(p_context);
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgram(_p3ShaderProgram);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, "float2");
            __cContext.setVertexBufferAt(2, __vb3RegisterIndexBuffer, 0, "float2");
            __iQuadCount = 0;
        }

        public function draw(p_transform:Vector.<Number>):void
        {
            __cContext.setProgramConstantsFromVector("vertex", (4 + (__iQuadCount * 2)), p_transform, 2);
            __iQuadCount++;
            if (__iQuadCount == 62)
            {
                push();
            };
        }

        public function push():void
        {
            FStats.iDrawCalls = (FStats.iDrawCalls + 1);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, (__iQuadCount * 2));
            __iQuadCount = 0;
        }

        public function clear():void
        {
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
        }


    }
}//package com.flengine.context.materials

