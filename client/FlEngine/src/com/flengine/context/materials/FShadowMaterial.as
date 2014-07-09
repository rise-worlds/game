// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FShadowMaterial

package com.flengine.context.materials
{
    import __AS3__.vec.Vector;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Context3D;
    import com.adobe.utils.AGALMiniAssembler;
    import com.flengine.components.FCamera;
    import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FShadowMaterial implements IGMaterial 
    {

        private static const NORMALIZED_VERTICES:Vector.<Number> = Vector.<Number>([-0.5, 0.5, 0, -0.5, -0.5, 0, -0.5, -0.5, 1, -0.5, 0.5, 1, 0.5, 0.5, 0, -0.5, 0.5, 0, -0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, -0.5, 0, 0.5, 0.5, 0, 0.5, 0.5, 1, 0.5, -0.5, 1, -0.5, -0.5, 0, 0.5, -0.5, 0, 0.5, -0.5, 1, -0.5, -0.5, 1]);
        private static const VERTEX_SHADER_CODE2:Array = ["mov vt0, va0", "mul vt5, va0.xy, vc[va1.x].zw", "mov vt5.zw, vt0.zw", "m44 op, vt5, vc0"];
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va0", "mul vt5, va0.xy, vc[va1.x].zw", "mov vt4.x, vc[va1.y].x", "sin vt1.x, vt4.x", "cos vt1.y, vt4.x", "mul vt2.x, vt5.x, vt1.y", "mul vt3.y, vt5.y, vt1.x", "sub vt4.x, vt2.x, vt3.y", "mul vt2.y, vt5.y, vt1.y", "mul vt3.x, vt5.x, vt1.x", "add vt4.y, vt2.y, vt3.x", "add vt1, vt4.xy, vc[va1.x].xy", "sub vt2, vt1.xy, vc[va1.y].zw", "mul vt2, vt2, va0.z", "mul vt2, vt2, vc[va1.y].y", "add vt1.xy, vt1.xy, vt2.xy", "sub vt1, vt1.xy, vc5.xy", "mul vt1, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0"];
        private static const FRAGMENT_SHADER_CODE:Array = ["mov oc, fc0"];

        private const CONSTANTS_OFFSET:int = 7;
        private const BATCH_CONSTANTS:int = 121;
        private const CONSTANTS_PER_BATCH:int = 2;
        private const BATCH_SIZE:int = 60;

        private var __p3ShaderProgram:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __aTransformVector:Vector.<Number>;
        private var __vb3TransformBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __iConstantsOffset:int = 0;
        private var __aVertexConstants:Vector.<Number>;
        private var __cContext:Context3D;

        public function FShadowMaterial()
        {
            __aVertexConstants = new Vector.<Number>(484);
            super();
        }

        fl2d function initialize(p_context:Context3D):void
        {
            var _local8:int;
            var _local4:int;
            __cContext = p_context;
            var _local3:AGALMiniAssembler = new AGALMiniAssembler();
            _local3.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
            var _local7:AGALMiniAssembler = new AGALMiniAssembler();
            _local7.assemble("fragment", FRAGMENT_SHADER_CODE.join("\n"));
            __p3ShaderProgram = p_context.createProgram();
            __p3ShaderProgram.upload(_local3.agalcode, _local7.agalcode);
            var _local5:Vector.<Number> = new Vector.<Number>();
            var _local2:Vector.<Number> = new Vector.<Number>();
            _local8 = 0;
            while (_local8 < 60)
            {
                _local5 = _local5.concat(NORMALIZED_VERTICES);
                _local4 = (7 + (_local8 * 2));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local2.push(_local4, (_local4 + 1));
                _local8++;
            };
            __vb3VertexBuffer = p_context.createVertexBuffer(960, 3);
            __vb3VertexBuffer.uploadFromVector(_local5, 0, 960);
            __vb3RegisterIndexBuffer = p_context.createVertexBuffer(960, 2);
            __vb3RegisterIndexBuffer.uploadFromVector(_local2, 0, 960);
            var _local6:Vector.<uint> = new Vector.<uint>();
            _local8 = 0;
            while (_local8 < 240)
            {
                _local6 = _local6.concat(Vector.<uint>([(4 * _local8), ((4 * _local8) + 1), ((4 * _local8) + 2), (4 * _local8), ((4 * _local8) + 2), ((4 * _local8) + 3)]));
                _local8++;
            };
            __ib3IndexBuffer = p_context.createIndexBuffer(1440);
            __ib3IndexBuffer.uploadFromVector(_local6, 0, 1440);
        }

        fl2d function bind(p_context:Context3D, p_reinitialize:Boolean, p_camera:FCamera):void
        {
            if ((((__p3ShaderProgram == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame))))))
            {
                initialize(p_context);
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgramConstantsFromVector("vertex", 4, p_camera.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("vertex", 6, Vector.<Number>([0, -1, 0.5, 1]), 1);
            __cContext.setProgramConstantsFromVector("fragment", 0, Vector.<Number>([0, 0, 0, 1]), 1);
            __cContext.setProgram(__p3ShaderProgram);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float3");
            __cContext.setVertexBufferAt(1, __vb3RegisterIndexBuffer, 0, "float2");
            __iQuadCount = 0;
            __iConstantsOffset = 0;
        }

        fl2d function draw(p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_lightX:Number, p_lightY:Number, p_depth:Number=1):void
        {
            __aVertexConstants[__iConstantsOffset] = p_x;
            __aVertexConstants[(__iConstantsOffset + 1)] = p_y;
            __aVertexConstants[(__iConstantsOffset + 2)] = p_scaleX;
            __aVertexConstants[(__iConstantsOffset + 3)] = p_scaleY;
            __aVertexConstants[(__iConstantsOffset + 4)] = p_rotation;
            __aVertexConstants[(__iConstantsOffset + 5)] = p_depth;
            __aVertexConstants[(__iConstantsOffset + 6)] = p_lightX;
            __aVertexConstants[(__iConstantsOffset + 7)] = p_lightY;
            __iQuadCount = (__iQuadCount + 1);
            __iConstantsOffset = (__iQuadCount * 8);
            if (__iQuadCount == 60)
            {
                push();
            };
        }

        public function push():void
        {
            FStats.iDrawCalls = (FStats.iDrawCalls + 1);
            __cContext.setProgramConstantsFromVector("vertex", 7, __aVertexConstants, 121);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, (__iQuadCount * 8));
            __iQuadCount = 0;
        }

        public function clear():void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
        }


    }
}//package com.flengine.context.materials

