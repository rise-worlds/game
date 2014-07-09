// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FDrawTextureCameraVertexShaderBatchMaterial

package com.flengine.context.materials
{
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.textures.Texture;
    import com.flengine.context.filters.FFilter;
    import flash.utils.Dictionary;
    import flash.display3D.Context3D;
    import flash.display3D.Program3D;
    import com.flengine.core.FlEngine;
    import com.flengine.textures.FTextureBase;
    import com.flengine.components.FCamera;
    import com.flengine.textures.FTexture;
    import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;

    public final class FDrawTextureCameraVertexShaderBatchMaterial implements IGMaterial 
    {

        private static const NORMALIZED_VERTICES:Vector.<Number> = Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);

        private static var _helpBindVector:Vector.<Number> = Vector.<Number>([1, 0, 0, 0.5]);

        private const CONSTANTS_OFFSET:int = 6;
        private const BATCH_CONSTANTS:int = 122;
        private const CONSTANTS_PER_BATCH:int = 4;
        private const BATCH_SIZE:int = 30;
        private const VertexShaderEmbed:Class = FCameraTexturedQuadVertexShaderBatchMaterialVertex_ash;
        private const VertexShaderCode:ByteArray = (new VertexShaderEmbed() as ByteArray);
        private const VertexShaderNoAlphaEmbed:Class = FCameraTexturedQuadVertexShaderBatchMaterialVertexNoAlpha_ash;
        private const VertexShaderNoAlphaCode:ByteArray = (new VertexShaderNoAlphaEmbed() as ByteArray);

        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean = false;
        private var __iQuadCount:int = 0;
        private var __iConstantsOffset:int = 0;
        private var __cActiveContextTexture:Texture;
        private var __iActiveFiltering:int;
        private var __bActiveAlpha:Boolean = true;
        private var __iActiveAtf:int = 0;
        private var __cActiveFilter:FFilter;
        private var __bUseFastMem:Boolean = true;
        private var __bUseSeparatedAlphaShaders:Boolean;
        private var __aCachedPrograms:Dictionary;
        private var __cContext:Context3D;
        private var __aVertexConstants:Vector.<Number>;
        private var __baVertexArray:ByteArray;


        private function getCachedProgram(p_repeat:Boolean, p_filtering:int, p_alpha:Boolean, p_atf:int, p_filter:FFilter):Program3D
        {
            var _local6 = (((((((p_repeat) ? 1 : 0) << 31) | (((p_alpha) ? 1 : 0) << 30)) | ((p_filtering & 1) << 29)) | ((p_atf & 3) << 27)) | (((p_filter) ? p_filter.iId : 0) & 0xFFFF));
            if (__aCachedPrograms[_local6] != null)
            {
                return (__aCachedPrograms[_local6]);
            };
            var _local7:Program3D = __cContext.createProgram();
            _local7.upload(((p_alpha) ? VertexShaderCode : VertexShaderNoAlphaCode), FFragmentShadersCommon.getTexturedShaderCode(p_repeat, p_filtering, p_alpha, p_atf, p_filter));
            __aCachedPrograms[_local6] = _local7;
            return (_local7);
        }

        fl2d function initialize(p_context:Context3D):void
        {
            var _local7:int;
            var _local3:int;
            __cContext = p_context;
            __bUseSeparatedAlphaShaders = FlEngine.getInstance().cConfig.useSeparatedAlphaShaders;
            __bUseFastMem = FlEngine.getInstance().cConfig.useFastMem;
            VertexShaderCode.endian = "littleEndian";
            VertexShaderNoAlphaCode.endian = "littleEndian";
            __aCachedPrograms = new Dictionary();
            var _local4:Vector.<Number> = new Vector.<Number>();
            var _local6:Vector.<Number> = new Vector.<Number>();
            var _local2:Vector.<Number> = new Vector.<Number>();
            _local7 = 0;
            while (_local7 < 30)
            {
                _local4 = _local4.concat(NORMALIZED_VERTICES);
                _local6 = _local6.concat(NORMALIZED_UVS);
                _local3 = (6 + (_local7 * 4));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2), (_local3 + 3));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2), (_local3 + 3));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2), (_local3 + 3));
                _local2.push(_local3, (_local3 + 1), (_local3 + 2), (_local3 + 3));
                _local7++;
            };
            __vb3VertexBuffer = __cContext.createVertexBuffer(120, 2);
            __vb3VertexBuffer.uploadFromVector(_local4, 0, 120);
            __vb3UVBuffer = __cContext.createVertexBuffer(120, 2);
            __vb3UVBuffer.uploadFromVector(_local6, 0, 120);
            __vb3RegisterIndexBuffer = __cContext.createVertexBuffer(120, 4);
            __vb3RegisterIndexBuffer.uploadFromVector(_local2, 0, 120);
            var _local5:Vector.<uint> = new Vector.<uint>();
            _local7 = 0;
            while (_local7 < 30)
            {
                _local5 = _local5.concat(Vector.<uint>([(4 * _local7), ((4 * _local7) + 1), ((4 * _local7) + 2), (4 * _local7), ((4 * _local7) + 2), ((4 * _local7) + 3)]));
                _local7++;
            };
            __ib3IndexBuffer = __cContext.createIndexBuffer(180);
            __ib3IndexBuffer.uploadFromVector(_local5, 0, 180);
            __aVertexConstants = new Vector.<Number>(488);
            __baVertexArray = new ByteArray();
            __baVertexArray.endian = "littleEndian";
            __baVertexArray.length = 0x0800;
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
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, "float2");
            __cContext.setVertexBufferAt(2, __vb3RegisterIndexBuffer, 0, "float4");
            __iQuadCount = 0;
            __cActiveContextTexture = null;
            __iActiveFiltering = FTextureBase.defaultFilteringType;
            __cActiveFilter = null;
        }

        public function draw(p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number, p_texture:FTexture, p_filter:FFilter):void
        {
            var _local12:Texture = p_texture.cContextTexture.tTexture;
            var _local14 = !((__cActiveContextTexture == _local12));
            var _local16 = !((__iActiveFiltering == p_texture.iFilteringType));
            var _local17:Boolean = ((((((((!(__bUseSeparatedAlphaShaders)) || (!((p_red == 1))))) || (!((p_green == 1))))) || (!((p_blue == 1))))) || (!((p_alpha == 1))));
            var _local18 = !((__bActiveAlpha == _local17));
            var _local13 = !((__iActiveAtf == p_texture.iAtfType));
            var _local15 = !((__cActiveFilter == p_filter));
            if (((((((((_local14) || (_local16))) || (_local18))) || (_local13))) || (_local15)))
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                };
                if (_local14)
                {
                    __cActiveContextTexture = _local12;
                    __cContext.setTextureAt(0, _local12);
                };
                if (((((((_local16) || (_local18))) || (_local13))) || (_local15)))
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
            __iConstantsOffset = (__iQuadCount << 4);
            __aVertexConstants[__iConstantsOffset] = p_x;
            __aVertexConstants[(__iConstantsOffset + 1)] = p_y;
            __aVertexConstants[(__iConstantsOffset + 2)] = (p_texture.iWidth * p_scaleX);
            __aVertexConstants[(__iConstantsOffset + 3)] = (p_texture.iHeight * p_scaleY);
            __aVertexConstants[(__iConstantsOffset + 4)] = p_texture.nUvX;
            __aVertexConstants[(__iConstantsOffset + 5)] = p_texture.nUvY;
            __aVertexConstants[(__iConstantsOffset + 6)] = p_texture.nUvScaleX;
            __aVertexConstants[(__iConstantsOffset + 7)] = p_texture.nUvScaleY;
            __aVertexConstants[(__iConstantsOffset + 8)] = p_rotation;
            __aVertexConstants[(__iConstantsOffset + 10)] = (p_texture.nPivotX * p_scaleX);
            __aVertexConstants[(__iConstantsOffset + 11)] = (p_texture.nPivotY * p_scaleY);
            __aVertexConstants[(__iConstantsOffset + 12)] = p_red;
            __aVertexConstants[(__iConstantsOffset + 13)] = p_green;
            __aVertexConstants[(__iConstantsOffset + 14)] = p_blue;
            __aVertexConstants[(__iConstantsOffset + 15)] = p_alpha;
            __iQuadCount = (__iQuadCount + 1);
            if (__iQuadCount == 30)
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
            if (__bUseFastMem)
            {
                __cContext.setProgramConstantsFromByteArray("vertex", 6, 122, __baVertexArray, 0);
            }
            else
            {
                __cContext.setProgramConstantsFromVector("vertex", 6, __aVertexConstants, 122);
            };
            FStats.iDrawCalls = (FStats.iDrawCalls + 1);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, (__iQuadCount * 2));
            __iQuadCount = 0;
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
        }


    }
}//package com.flengine.context.materials

