// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FDrawColorCameraVertexShaderBatchMaterial

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

    public class FDrawColorCameraVertexShaderBatchMaterial implements IGMaterial 
    {

        private static const NORMALIZED_VERTICES:Vector.<Number> = Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);

        private const CONSTANTS_OFFSET:int = 6;
        private const CONSTANTS_PER_BATCH:int = 3;
        private const BATCH_CONSTANTS:int = 122;
        private const BATCH_SIZE:int = 40;
        private const VertexShaderEmbed:Class = FCameraColorQuadVertexShaderBatchMaterialVertex_ash;
        private const VertexShaderCode:ByteArray = (new VertexShaderEmbed() as ByteArray);

        private var __p3ShaderProgram:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __aVertexConstants:Vector.<Number>;
        private var __cContext:Context3D;

        public function FDrawColorCameraVertexShaderBatchMaterial()
        {
            __aVertexConstants = new Vector.<Number>((122 * 4));
            super();
        }

        fl2d function initialize(p_context:Context3D):void
        {
            var _local6:int;
            var _local3:int;
            __cContext = p_context;
            VertexShaderCode.endian = "littleEndian";
            __p3ShaderProgram = p_context.createProgram();
            __p3ShaderProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
            var _local4:Vector.<Number> = new Vector.<Number>();
            var _local2:Vector.<Number> = new Vector.<Number>();
            _local6 = 0;
            while (_local6 < 40)
            {
                _local4 = _local4.concat(NORMALIZED_VERTICES);
                _local3 = (6 + (_local6 * 3));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2));
                _local6++;
            };
            __vb3VertexBuffer = p_context.createVertexBuffer((4 * 40), 2);
            __vb3VertexBuffer.uploadFromVector(_local4, 0, (4 * 40));
            __vb3RegisterIndexBuffer = p_context.createVertexBuffer((4 * 40), 3);
            __vb3RegisterIndexBuffer.uploadFromVector(_local2, 0, (4 * 40));
            var _local5:Vector.<uint> = new Vector.<uint>();
            _local6 = 0;
            while (_local6 < 40)
            {
                _local5 = _local5.concat(Vector.<uint>([(4 * _local6), ((4 * _local6) + 1), ((4 * _local6) + 2), (4 * _local6), ((4 * _local6) + 2), ((4 * _local6) + 3)]));
                _local6++;
            };
            __ib3IndexBuffer = p_context.createIndexBuffer((6 * 40));
            __ib3IndexBuffer.uploadFromVector(_local5, 0, (6 * 40));
        }

        public function bind(p_context:Context3D, p_reinitialize:Boolean, p_camera:FCamera):void
        {
            if ((((__p3ShaderProgram == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame))))))
            {
                initialize(p_context);
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgram(__p3ShaderProgram);
            __cContext.setProgramConstantsFromVector("vertex", 4, p_camera.aCameraVector, 2);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3RegisterIndexBuffer, 0, "float3");
            __iQuadCount = 0;
        }

        public function draw(p_x:Number, p_y:Number, p_width:Number, p_height:Number, p_rotation:Number, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number):void
        {
            var _local10:int = (__iQuadCount * 12);
            __aVertexConstants[_local10] = p_x;
            __aVertexConstants[(_local10 + 1)] = p_y;
            __aVertexConstants[(_local10 + 2)] = p_width;
            __aVertexConstants[(_local10 + 3)] = p_height;
            __aVertexConstants[(_local10 + 4)] = p_rotation;
            __aVertexConstants[(_local10 + 8)] = (p_red * p_alpha);
            __aVertexConstants[(_local10 + 9)] = (p_green * p_alpha);
            __aVertexConstants[(_local10 + 10)] = (p_blue * p_alpha);
            __aVertexConstants[(_local10 + 11)] = p_alpha;
            __iQuadCount++;
            if (__iQuadCount == 40)
            {
                push();
            };
        }

        public function push():void
        {
            if (__iQuadCount == 0)
            {
                return;
            };
            __cContext.setProgramConstantsFromVector("vertex", 6, __aVertexConstants, 122);
            FStats.iDrawCalls++;
            __cContext.drawTriangles(__ib3IndexBuffer, 0, (__iQuadCount * 2));
            __iQuadCount = 0;
        }

        public function clear():void
        {
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
        }


    }
}//package com.flengine.context.materials

