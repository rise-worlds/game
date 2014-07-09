// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FDrawColorCameraVertexBufferCPUBatchMaterial

package com.flengine.context.materials
{
    import flash.display3D.VertexBuffer3D;
    import __AS3__.vec.Vector;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
    import flash.display3D.Context3D;
    import com.adobe.utils.AGALMiniAssembler;
    import com.flengine.components.FCamera;
    import flash.geom.Matrix;
    import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;

    public final class FDrawColorCameraVertexBufferCPUBatchMaterial implements IGMaterial 
    {

        private static const BATCH_SIZE:int = 1000;
        private static const DATA_PER_VERTEX:int = 6;
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va0", "sub vt1, vt0.xy, vc5.xy", "mul vt1, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0", "mov v1, va1"];

        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __aVertexVector:Vector.<Number>;
        private var __ib3QuadIndexBuffer:IndexBuffer3D;
        private var __ib3TriangleIndexBuffer:IndexBuffer3D;
        private var __iTriangleCount:int = 0;
        private var __bInitializedThisFrame:Boolean = false;
        private var __bDrawQuads:Boolean = true;
        private var __p3ShaderProgram:Program3D;
        private var __cContext:Context3D;
        private var vertexShader:AGALMiniAssembler;
        private var vertexShaderAlpha:AGALMiniAssembler;


        fl2d function initialize(p_context:Context3D):void
        {
            var _local3:int;
            __cContext = p_context;
            vertexShader = new AGALMiniAssembler();
            vertexShader.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
            __p3ShaderProgram = p_context.createProgram();
            __p3ShaderProgram.upload(vertexShader.agalcode, FFragmentShadersCommon.getColorShaderCode());
            __aVertexVector = new Vector.<Number>(((3 * 1000) * 6));
            __vb3VertexBuffer = __cContext.createVertexBuffer((3 * 1000), 6);
            var _local2:Vector.<uint> = new Vector.<uint>();
            _local3 = 0;
            while (_local3 < (3 * 1000))
            {
                _local2.push(_local3);
                _local3++;
            };
            __ib3TriangleIndexBuffer = p_context.createIndexBuffer((3 * 1000));
            __ib3TriangleIndexBuffer.uploadFromVector(_local2, 0, (3 * 1000));
            _local2.length = 0;
            _local3 = 0;
            while (_local3 < (1000 / 2))
            {
                _local2 = _local2.concat(Vector.<uint>([(4 * _local3), ((4 * _local3) + 1), ((4 * _local3) + 2), (4 * _local3), ((4 * _local3) + 2), ((4 * _local3) + 3)]));
                _local3++;
            };
            __ib3QuadIndexBuffer = p_context.createIndexBuffer((3 * 1000));
            __ib3QuadIndexBuffer.uploadFromVector(_local2, 0, (3 * 1000));
            __iTriangleCount = 0;
        }

        fl2d function bind(p_context:Context3D, p_reinitialize:Boolean, p_camera:FCamera):void
        {
            if ((((__p3ShaderProgram == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame))))))
            {
                initialize(p_context);
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgram(__p3ShaderProgram);
            __cContext.setProgramConstantsFromVector("vertex", 4, p_camera.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("fragment", 0, Vector.<Number>([1, 0, 0, 0.5]), 1);
            __iTriangleCount = 0;
        }

        public function draw(p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number):void
        {
            __bDrawQuads = true;
            var _local11:Number = Math.cos(p_rotation);
            var _local14:Number = Math.sin(p_rotation);
            var _local18:Number = (0.5 * p_scaleX);
            var _local17:Number = (0.5 * p_scaleY);
            var _local12:Number = (_local11 * _local18);
            var _local13:Number = (_local11 * _local17);
            var _local15:Number = (_local14 * _local18);
            var _local16:Number = (_local14 * _local17);
            var _local10:int = ((6 * 3) * __iTriangleCount);
            __aVertexVector[_local10] = ((-(_local12) - _local16) + p_x);
            __aVertexVector[(_local10 + 1)] = ((_local13 - _local15) + p_y);
            __aVertexVector[(_local10 + 2)] = p_red;
            __aVertexVector[(_local10 + 3)] = p_green;
            __aVertexVector[(_local10 + 4)] = p_blue;
            __aVertexVector[(_local10 + 5)] = p_alpha;
            __aVertexVector[(_local10 + 6)] = ((-(_local12) + _local16) + p_x);
            __aVertexVector[(_local10 + 7)] = ((-(_local13) - _local15) + p_y);
            __aVertexVector[(_local10 + 8)] = p_red;
            __aVertexVector[(_local10 + 9)] = p_green;
            __aVertexVector[(_local10 + 10)] = p_blue;
            __aVertexVector[(_local10 + 11)] = p_alpha;
            __aVertexVector[(_local10 + 12)] = ((_local12 + _local16) + p_x);
            __aVertexVector[(_local10 + 13)] = ((-(_local13) + _local15) + p_y);
            __aVertexVector[(_local10 + 14)] = p_red;
            __aVertexVector[(_local10 + 15)] = p_green;
            __aVertexVector[(_local10 + 16)] = p_blue;
            __aVertexVector[(_local10 + 17)] = p_alpha;
            __aVertexVector[(_local10 + 18)] = ((_local12 - _local16) + p_x);
            __aVertexVector[(_local10 + 19)] = ((_local13 + _local15) + p_y);
            __aVertexVector[(_local10 + 20)] = p_red;
            __aVertexVector[(_local10 + 21)] = p_green;
            __aVertexVector[(_local10 + 22)] = p_blue;
            __aVertexVector[(_local10 + 23)] = p_alpha;
            __iTriangleCount = (__iTriangleCount + 2);
            if (__iTriangleCount == 1000)
            {
                push();
            };
        }

        public function drawPoly(p_vertices:Vector.<Number>, p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number):void
        {
            var _local14:int;
            __bDrawQuads = false;
            var _local13:Number = Math.cos(p_rotation);
            var _local16:Number = Math.sin(p_rotation);
            var _local12:int = p_vertices.length;
            var _local15 = (_local12 >> 1);
            var _local17:int = (_local15 / 3);
            if ((__iTriangleCount + _local17) > 1000)
            {
                push();
            };
            var _local11:int = ((6 * 3) * __iTriangleCount);
            _local14 = 0;
            while (_local14 < _local12)
            {
                __aVertexVector[_local11] = ((((_local13 * p_vertices[_local14]) * p_scaleX) - ((_local16 * p_vertices[(_local14 + 1)]) * p_scaleY)) + p_x);
                __aVertexVector[(_local11 + 1)] = ((((_local16 * p_vertices[_local14]) * p_scaleX) + ((_local13 * p_vertices[(_local14 + 1)]) * p_scaleY)) + p_y);
                __aVertexVector[(_local11 + 2)] = p_red;
                __aVertexVector[(_local11 + 3)] = p_green;
                __aVertexVector[(_local11 + 4)] = p_blue;
                __aVertexVector[(_local11 + 5)] = p_alpha;
                _local11 = (_local11 + 6);
                _local14 = (_local14 + 2);
            };
            __iTriangleCount = (__iTriangleCount + _local17);
            if (__iTriangleCount >= 1000)
            {
                push();
            };
        }

        public function drawMatrix(p_matrix:Matrix, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number):void
        {
            __bDrawQuads = true;
            var _local7:int = ((6 * 2) * __iTriangleCount);
            var _local6 = 0.5;
            var _local8 = 0.5;
            __aVertexVector[_local7] = (((p_matrix.a * -(_local6)) + (p_matrix.c * _local8)) + p_matrix.tx);
            __aVertexVector[(_local7 + 1)] = (((p_matrix.d * _local8) + (p_matrix.b * -(_local6))) + p_matrix.ty);
            __aVertexVector[(_local7 + 2)] = p_red;
            __aVertexVector[(_local7 + 3)] = p_green;
            __aVertexVector[(_local7 + 4)] = p_blue;
            __aVertexVector[(_local7 + 5)] = p_alpha;
            __aVertexVector[(_local7 + 6)] = (((p_matrix.a * -(_local6)) + (p_matrix.c * -(_local8))) + p_matrix.tx);
            __aVertexVector[(_local7 + 7)] = (((p_matrix.d * -(_local8)) + (p_matrix.b * -(_local6))) + p_matrix.ty);
            __aVertexVector[(_local7 + 8)] = p_red;
            __aVertexVector[(_local7 + 9)] = p_green;
            __aVertexVector[(_local7 + 10)] = p_blue;
            __aVertexVector[(_local7 + 11)] = p_alpha;
            __aVertexVector[(_local7 + 12)] = (((p_matrix.a * _local6) + (p_matrix.c * -(_local8))) + p_matrix.tx);
            __aVertexVector[(_local7 + 13)] = (((p_matrix.d * -(_local8)) + (p_matrix.b * _local6)) + p_matrix.ty);
            __aVertexVector[(_local7 + 14)] = p_red;
            __aVertexVector[(_local7 + 15)] = p_green;
            __aVertexVector[(_local7 + 16)] = p_blue;
            __aVertexVector[(_local7 + 17)] = p_alpha;
            __aVertexVector[(_local7 + 18)] = (((p_matrix.a * _local6) + (p_matrix.c * _local8)) + p_matrix.tx);
            __aVertexVector[(_local7 + 19)] = (((p_matrix.d * _local8) + (p_matrix.b * _local6)) + p_matrix.ty);
            __aVertexVector[(_local7 + 20)] = p_red;
            __aVertexVector[(_local7 + 21)] = p_green;
            __aVertexVector[(_local7 + 22)] = p_blue;
            __aVertexVector[(_local7 + 23)] = p_alpha;
            __iTriangleCount = (__iTriangleCount + 2);
            if (__iTriangleCount == 1000)
            {
                push();
            };
        }

        public function push():void
        {
            FStats.iDrawCalls++;
            __vb3VertexBuffer.uploadFromVector(__aVertexVector, 0, (3 * 1000));
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3VertexBuffer, 2, "float4");
            if (__bDrawQuads)
            {
                __cContext.drawTriangles(__ib3QuadIndexBuffer, 0, __iTriangleCount);
            }
            else
            {
                __cContext.drawTriangles(__ib3TriangleIndexBuffer, 0, __iTriangleCount);
            };
            __iTriangleCount = 0;
        }

        public function clear():void
        {
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
        }


    }
}//package com.flengine.context.materials

