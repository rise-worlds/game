// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FDrawTextureCameraVertexBufferCPUBatchMaterial

package com.flengine.context.materials
{
    import __AS3__.vec.Vector;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.textures.Texture;
    import com.flengine.context.filters.FFilter;
    import flash.utils.Dictionary;
    import flash.display3D.Context3D;
    import com.adobe.utils.AGALMiniAssembler;
    import flash.display3D.Program3D;
    import com.flengine.core.FlEngine;
    import com.flengine.textures.FTextureBase;
    import com.flengine.components.FCamera;
    import com.flengine.textures.FTexture;
    import flash.geom.Matrix;
    import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;

    public final class FDrawTextureCameraVertexBufferCPUBatchMaterial implements IGMaterial 
    {

        private static const BATCH_SIZE:int = 1000;
        private static const DATA_PER_VERTEX:int = 8;
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va2", "mov vt0, va0", "sub vt1, vt0.xy, vc5.xy", "mul vt1, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0", "mov v0, va1"];
        private static const VERTEX_SHADER_ALPHA_CODE:Array = VERTEX_SHADER_CODE.concat(["mov v1, va2"]);

        private static var _helpBindVector:Vector.<Number> = Vector.<Number>([1, 0, 0, 0.5]);

        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __aVertexVector:Vector.<Number>;
        private var __ib3QuadIndexBuffer:IndexBuffer3D;
        private var __ib3TriangleIndexBuffer:IndexBuffer3D;
        private var __iTriangleCount:int = 0;
        private var __bInitializedThisFrame:Boolean = false;
        private var __cActiveContextTexture:Texture;
        private var __iActiveFiltering:int;
        private var __bActiveAlpha:Boolean = false;
        private var __bUseSeparatedAlphaShaders:Boolean;
        private var __iActiveAtf:int = 0;
        private var __cActiveFilter:FFilter;
        private var __bDrawQuads:Boolean = true;
        private var __aCachedPrograms:Dictionary;
        private var __cContext:Context3D;
        private var vertexShader:AGALMiniAssembler;
        private var vertexShaderAlpha:AGALMiniAssembler;


        private function getCachedProgram(p_repeat:Boolean, p_filtering:int, p_alpha:Boolean, p_atf:int, p_filter:FFilter):Program3D
        {
            var _local6 = (((((((p_repeat) ? 1 : 0) << 31) | (((p_alpha) ? 1 : 0) << 30)) | ((p_filtering & 1) << 29)) | ((p_atf & 3) << 27)) | (((p_filter) ? p_filter.iId : 0) & 0xFFFF));
            if (__aCachedPrograms[_local6] != null)
            {
                return (__aCachedPrograms[_local6]);
            };
            var _local7:Program3D = __cContext.createProgram();
            _local7.upload(((p_alpha) ? vertexShaderAlpha.agalcode : vertexShader.agalcode), FFragmentShadersCommon.getTexturedShaderCode(p_repeat, p_filtering, p_alpha, p_atf, p_filter));
            __aCachedPrograms[_local6] = _local7;
            return (_local7);
        }

        fl2d function initialize(p_context:Context3D):void
        {
            var _local3:int;
            __cContext = p_context;
            __bUseSeparatedAlphaShaders = FlEngine.getInstance().cConfig.useSeparatedAlphaShaders;
            __aCachedPrograms = new Dictionary();
            vertexShader = new AGALMiniAssembler();
            vertexShader.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
            vertexShaderAlpha = new AGALMiniAssembler();
            vertexShaderAlpha.assemble("vertex", VERTEX_SHADER_ALPHA_CODE.join("\n"));
            __aVertexVector = new Vector.<Number>(24000);
            __vb3VertexBuffer = __cContext.createVertexBuffer(3000, 8);
            var _local2:Vector.<uint> = new Vector.<uint>();
            _local3 = 0;
            while (_local3 < 3000)
            {
                _local2.push(_local3);
                _local3++;
            };
            __ib3TriangleIndexBuffer = p_context.createIndexBuffer(3000);
            __ib3TriangleIndexBuffer.uploadFromVector(_local2, 0, 3000);
            _local2.length = 0;
            _local3 = 0;
            while (_local3 < 500)
            {
                _local2 = _local2.concat(Vector.<uint>([(4 * _local3), ((4 * _local3) + 1), ((4 * _local3) + 2), (4 * _local3), ((4 * _local3) + 2), ((4 * _local3) + 3)]));
                _local3++;
            };
            __ib3QuadIndexBuffer = p_context.createIndexBuffer(3000);
            __ib3QuadIndexBuffer.uploadFromVector(_local2, 0, 3000);
            __iTriangleCount = 0;
        }

        fl2d function bind(p_context:Context3D, p_reinitialize:Boolean, p_camera:FCamera):void
        {
            if ((((__aCachedPrograms == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame))))))
            {
                initialize(p_context);
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgram(getCachedProgram(true, FTextureBase.defaultFilteringType, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
            __cContext.setProgramConstantsFromVector("vertex", 4, p_camera.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("fragment", 0, _helpBindVector, 1);
            __iTriangleCount = 0;
            __cActiveContextTexture = null;
            __iActiveFiltering = FTextureBase.defaultFilteringType;
            __cActiveFilter = null;
        }

        public function draw(p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number, p_texture:FTexture, p_filter:FFilter):void
        {
            __bDrawQuads = true;
            var _local13:Texture = p_texture.cContextTexture.tTexture;
            var _local29 = !((__cActiveContextTexture == _local13));
            var _local18 = !((__iActiveFiltering == p_texture.iFilteringType));
            var _local31:Boolean = ((((((((!(__bUseSeparatedAlphaShaders)) || (!((p_red == 1))))) || (!((p_green == 1))))) || (!((p_blue == 1))))) || (!((p_alpha == 1))));
            var _local15 = !((__bActiveAlpha == _local31));
            var _local27 = !((__iActiveAtf == p_texture.iAtfType));
            var _local30 = !((__cActiveFilter == p_filter));
            if (((((((_local29) || (_local18))) || (_local15))) || (_local27)))
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                };
                if (_local29)
                {
                    __cActiveContextTexture = _local13;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                };
                if (((((_local18) || (_local15))) || (_local27)))
                {
                    __iActiveFiltering = p_texture.iFilteringType;
                    __bActiveAlpha = _local31;
                    __iActiveAtf = p_texture.iAtfType;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.clear(__cContext);
                    };
                    __cActiveFilter = p_filter;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.bind(__cContext, p_texture);
                    };
                    __cContext.setProgram(getCachedProgram(true, __iActiveFiltering, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
                };
            };
            var _local21:Number = p_texture.uvX;
            var _local16:Number = p_texture.uvY;
            var _local22:Number = p_texture.uvScaleX;
            var _local12:Number = p_texture.uvScaleY;
            var _local14:Number = Math.cos(p_rotation);
            var _local28:Number = Math.sin(p_rotation);
            var _local23:Number = ((0.5 * p_scaleX) * p_texture.iWidth);
            var _local20:Number = ((0.5 * p_scaleY) * p_texture.iHeight);
            var _local25:Number = (_local14 * _local23);
            var _local26:Number = (_local14 * _local20);
            var _local17:Number = (_local28 * _local23);
            var _local19:Number = (_local28 * _local20);
            if (p_texture.premultiplied)
            {
                p_red = (p_red * p_alpha);
                p_green = (p_green * p_alpha);
                p_blue = (p_blue * p_alpha);
            };
            var _local24:int = (24 * __iTriangleCount);
            __aVertexVector[_local24] = ((-(_local25) - _local19) + p_x);
            __aVertexVector[(_local24 + 1)] = ((_local26 - _local17) + p_y);
            __aVertexVector[(_local24 + 2)] = _local21;
            __aVertexVector[(_local24 + 3)] = (_local12 + _local16);
            __aVertexVector[(_local24 + 4)] = p_red;
            __aVertexVector[(_local24 + 5)] = p_green;
            __aVertexVector[(_local24 + 6)] = p_blue;
            __aVertexVector[(_local24 + 7)] = p_alpha;
            __aVertexVector[(_local24 + 8)] = ((-(_local25) + _local19) + p_x);
            __aVertexVector[(_local24 + 9)] = ((-(_local26) - _local17) + p_y);
            __aVertexVector[(_local24 + 10)] = _local21;
            __aVertexVector[(_local24 + 11)] = _local16;
            __aVertexVector[(_local24 + 12)] = p_red;
            __aVertexVector[(_local24 + 13)] = p_green;
            __aVertexVector[(_local24 + 14)] = p_blue;
            __aVertexVector[(_local24 + 15)] = p_alpha;
            __aVertexVector[(_local24 + 16)] = ((_local25 + _local19) + p_x);
            __aVertexVector[(_local24 + 17)] = ((-(_local26) + _local17) + p_y);
            __aVertexVector[(_local24 + 18)] = (_local22 + _local21);
            __aVertexVector[(_local24 + 19)] = _local16;
            __aVertexVector[(_local24 + 20)] = p_red;
            __aVertexVector[(_local24 + 21)] = p_green;
            __aVertexVector[(_local24 + 22)] = p_blue;
            __aVertexVector[(_local24 + 23)] = p_alpha;
            __aVertexVector[(_local24 + 24)] = ((_local25 - _local19) + p_x);
            __aVertexVector[(_local24 + 25)] = ((_local26 + _local17) + p_y);
            __aVertexVector[(_local24 + 26)] = (_local22 + _local21);
            __aVertexVector[(_local24 + 27)] = (_local12 + _local16);
            __aVertexVector[(_local24 + 28)] = p_red;
            __aVertexVector[(_local24 + 29)] = p_green;
            __aVertexVector[(_local24 + 30)] = p_blue;
            __aVertexVector[(_local24 + 31)] = p_alpha;
            __iTriangleCount = (__iTriangleCount + 2);
            if (__iTriangleCount == 1000)
            {
                push();
            };
        }

        public function drawPoly(p_vertices:Vector.<Number>, p_uvs:Vector.<Number>, p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number, p_texture:FTexture, p_filter:FFilter):void
        {
            var _local25:int;
            __bDrawQuads = false;
            var _local15:Texture = p_texture.cContextTexture.tTexture;
            var _local29 = !((__cActiveContextTexture == _local15));
            var _local23 = !((__iActiveFiltering == p_texture.iFilteringType));
            var _local31:Boolean = ((((((((!(__bUseSeparatedAlphaShaders)) || (!((p_red == 1))))) || (!((p_green == 1))))) || (!((p_blue == 1))))) || (!((p_alpha == 1))));
            var _local17 = !((__bActiveAlpha == _local31));
            var _local27 = !((__iActiveAtf == p_texture.iAtfType));
            var _local30 = !((__cActiveFilter == p_filter));
            if (((((((_local29) || (_local23))) || (_local17))) || (_local27)))
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                };
                if (_local29)
                {
                    __cActiveContextTexture = _local15;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                };
                if (((((_local23) || (_local17))) || (_local27)))
                {
                    __iActiveFiltering = p_texture.iFilteringType;
                    __bActiveAlpha = _local31;
                    __iActiveAtf = p_texture.iAtfType;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.clear(__cContext);
                    };
                    __cActiveFilter = p_filter;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.bind(__cContext, p_texture);
                    };
                    __cContext.setProgram(getCachedProgram(true, __iActiveFiltering, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
                };
            };
            var _local16:Number = Math.cos(p_rotation);
            var _local28:Number = Math.sin(p_rotation);
            var _local20:Number = p_texture.nUvX;
            var _local21:Number = p_texture.nUvScaleX;
            var _local18:Number = p_texture.nUvY;
            var _local19:Number = p_texture.nUvScaleY;
            if (p_texture.premultiplied)
            {
                p_red = (p_red * p_alpha);
                p_green = (p_green * p_alpha);
                p_blue = (p_blue * p_alpha);
            };
            var _local14:int = p_vertices.length;
            var _local26 = (_local14 >> 1);
            var _local22:int = (_local26 / 3);
            if ((__iTriangleCount + _local22) > 1000)
            {
                push();
            };
            var _local24:int = (24 * __iTriangleCount);
            _local25 = 0;
            while (_local25 < _local14)
            {
                __aVertexVector[_local24] = ((((_local16 * p_vertices[_local25]) * p_scaleX) - ((_local28 * p_vertices[(_local25 + 1)]) * p_scaleY)) + p_x);
                __aVertexVector[(_local24 + 1)] = ((((_local28 * p_vertices[_local25]) * p_scaleY) + ((_local16 * p_vertices[(_local25 + 1)]) * p_scaleX)) + p_y);
                __aVertexVector[(_local24 + 2)] = (_local20 + (p_uvs[_local25] * _local21));
                __aVertexVector[(_local24 + 3)] = (_local18 + (p_uvs[(_local25 + 1)] * _local19));
                __aVertexVector[(_local24 + 4)] = p_red;
                __aVertexVector[(_local24 + 5)] = p_green;
                __aVertexVector[(_local24 + 6)] = p_blue;
                __aVertexVector[(_local24 + 7)] = p_alpha;
                _local24 = (_local24 + 8);
                _local25 = (_local25 + 2);
            };
            __iTriangleCount = (__iTriangleCount + _local22);
            if (__iTriangleCount >= 1000)
            {
                push();
            };
        }

        public function drawMatrix(p_matrix:Matrix, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number, p_texture:FTexture, p_filter:FFilter):void
        {
            __bDrawQuads = true;
            var _local9:Texture = p_texture.cContextTexture.tTexture;
            var _local14 = !((__cActiveContextTexture == _local9));
            var _local16 = !((__iActiveFiltering == p_texture.iFilteringType));
            var _local17:Boolean = ((!(__bUseSeparatedAlphaShaders)) || (!((((((((p_red == 1)) && ((p_green == 1)))) && ((p_blue == 1)))) && ((p_alpha == 1))))));
            var _local10 = !((__bActiveAlpha == _local17));
            var _local13 = !((__iActiveAtf == p_texture.iAtfType));
            var _local15 = !((__cActiveFilter == p_filter));
            if (((((((_local14) || (_local16))) || (_local10))) || (_local13)))
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                };
                if (_local14)
                {
                    __cActiveContextTexture = _local9;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                };
                if (((((_local16) || (_local10))) || (_local13)))
                {
                    __iActiveFiltering = p_texture.iFilteringType;
                    __bActiveAlpha = _local17;
                    __iActiveAtf = p_texture.iAtfType;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.clear(__cContext);
                    };
                    __cActiveFilter = p_filter;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.bind(__cContext, p_texture);
                    };
                    __cContext.setProgram(getCachedProgram(true, __iActiveFiltering, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
                };
            };
            if (p_texture.premultiplied)
            {
                p_red = (p_red * p_alpha);
                p_green = (p_green * p_alpha);
                p_blue = (p_blue * p_alpha);
            };
            var _local8:int = (16 * __iTriangleCount);
            var _local12:Number = (0.5 * p_texture.iWidth);
            var _local11:Number = (0.5 * p_texture.iHeight);
            __aVertexVector[_local8] = (((p_matrix.a * -(_local12)) + (p_matrix.c * _local11)) + p_matrix.tx);
            __aVertexVector[(_local8 + 1)] = (((p_matrix.d * _local11) + (p_matrix.b * -(_local12))) + p_matrix.ty);
            __aVertexVector[(_local8 + 2)] = p_texture.uvX;
            __aVertexVector[(_local8 + 3)] = (p_texture.uvScaleY + p_texture.uvY);
            __aVertexVector[(_local8 + 4)] = p_red;
            __aVertexVector[(_local8 + 5)] = p_green;
            __aVertexVector[(_local8 + 6)] = p_blue;
            __aVertexVector[(_local8 + 7)] = p_alpha;
            __aVertexVector[(_local8 + 8)] = (((p_matrix.a * -(_local12)) + (p_matrix.c * -(_local11))) + p_matrix.tx);
            __aVertexVector[(_local8 + 9)] = (((p_matrix.d * -(_local11)) + (p_matrix.b * -(_local12))) + p_matrix.ty);
            __aVertexVector[(_local8 + 10)] = p_texture.uvX;
            __aVertexVector[(_local8 + 11)] = p_texture.uvY;
            __aVertexVector[(_local8 + 12)] = p_red;
            __aVertexVector[(_local8 + 13)] = p_green;
            __aVertexVector[(_local8 + 14)] = p_blue;
            __aVertexVector[(_local8 + 15)] = p_alpha;
            __aVertexVector[(_local8 + 16)] = (((p_matrix.a * _local12) + (p_matrix.c * -(_local11))) + p_matrix.tx);
            __aVertexVector[(_local8 + 17)] = (((p_matrix.d * -(_local11)) + (p_matrix.b * _local12)) + p_matrix.ty);
            __aVertexVector[(_local8 + 18)] = (p_texture.uvScaleX + p_texture.uvX);
            __aVertexVector[(_local8 + 19)] = p_texture.uvY;
            __aVertexVector[(_local8 + 20)] = p_red;
            __aVertexVector[(_local8 + 21)] = p_green;
            __aVertexVector[(_local8 + 22)] = p_blue;
            __aVertexVector[(_local8 + 23)] = p_alpha;
            __aVertexVector[(_local8 + 24)] = (((p_matrix.a * _local12) + (p_matrix.c * _local11)) + p_matrix.tx);
            __aVertexVector[(_local8 + 25)] = (((p_matrix.d * _local11) + (p_matrix.b * _local12)) + p_matrix.ty);
            __aVertexVector[(_local8 + 26)] = (p_texture.uvScaleX + p_texture.uvX);
            __aVertexVector[(_local8 + 27)] = (p_texture.uvScaleY + p_texture.uvY);
            __aVertexVector[(_local8 + 28)] = p_red;
            __aVertexVector[(_local8 + 29)] = p_green;
            __aVertexVector[(_local8 + 30)] = p_blue;
            __aVertexVector[(_local8 + 31)] = p_alpha;
            __iTriangleCount = (__iTriangleCount + 2);
            if (__iTriangleCount == 1000)
            {
                push();
            };
        }

        public function push():void
        {
            FStats.iDrawCalls++;
            __vb3VertexBuffer.uploadFromVector(__aVertexVector, 0, 3000);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3VertexBuffer, 2, "float2");
            __cContext.setVertexBufferAt(2, __vb3VertexBuffer, 4, "float4");
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
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
            __cActiveContextTexture = null;
            if (__cActiveFilter)
            {
                __cActiveFilter.clear(__cContext);
            };
            __cActiveFilter = null;
            __iActiveFiltering = FTextureBase.defaultFilteringType;
        }


    }
}//package com.flengine.context.materials

