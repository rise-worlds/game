// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.flash.FFlashObject

package com.flengine.components.renderables.flash
{
    import com.flengine.components.renderables.FTexturedQuad;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import com.flengine.core.FNode;
    import com.flengine.textures.FTextureResampleType;
    import com.flengine.error.FError;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import com.flengine.textures.factories.FTextureFactory;

    public class FFlashObject extends FTexturedQuad 
    {

        public static var defaultSampleScale:int = 1;
        public static var defaultUpdateFrameRate:int = 20;
        private static var __iDefaultResampleType:int = 2;
        private static var __iCount:int = 0;

        protected var _iAlign:int = 1;
        protected var _doNative:DisplayObject;
        private var __mNativeMatrix:Matrix;
        private var __sTextureId:String;
        protected var _bInvalidate:Boolean = false;
        protected var _iResampleScale:int;
        protected var _iFilteringType:int = 0;
        protected var _iResampleType:int;
        private var __nLastNativeWidth:Number = 0;
        private var __nLastNativeHeight:Number = 0;
        private var __nAccumulatedTime:Number = 0;
        public var updateFrameRate:int;
        protected var _bTransparent:Boolean = false;

        public function FFlashObject(p_node:FNode)
        {
            _iResampleScale = defaultSampleScale;
            _iResampleType = __iDefaultResampleType;
            updateFrameRate = defaultUpdateFrameRate;
            super(p_node);
            iBlendMode = 0;
            __sTextureId = ("G2DFlashObject#" + __iCount++);
            __mNativeMatrix = new Matrix();
        }

        public static function get defaultResampleType():int
        {
            return (__iDefaultResampleType);
        }

        public static function set defaultResampleType(p_type:int):void
        {
            if (!FTextureResampleType.isValid(p_type))
            {
                throw (new FError("FError: Invalid resample type."));
            };
            __iDefaultResampleType = p_type;
        }


        public function get align():int
        {
            return (_iAlign);
        }

        public function set align(p_align:int):void
        {
            _iAlign = p_align;
            invalidateTexture(true);
        }

        public function get native():DisplayObject
        {
            return (_doNative);
        }

        public function set native(p_native:DisplayObject):void
        {
            _doNative = p_native;
        }

        public function invalidate(p_force:Boolean=false):void
        {
            if (p_force)
            {
                invalidateTexture(true);
            }
            else
            {
                _bInvalidate = true;
            };
        }

        public function get resampleScale():int
        {
            return (_iResampleScale);
        }

        public function set resampleScale(p_scale:int):void
        {
            if (p_scale <= 0)
            {
                return;
            };
            _iResampleScale = p_scale;
            if (_doNative != null)
            {
                invalidateTexture(true);
            };
        }

        public function get filteringType():int
        {
            return (_iFilteringType);
        }

        public function set filteringType(p_filteringType:int):void
        {
            _iFilteringType = p_filteringType;
            if (cTexture)
            {
                cTexture.filteringType = _iFilteringType;
            };
        }

        public function get resampleType():int
        {
            return (_iResampleType);
        }

        public function set resampleType(p_type:int):void
        {
            if (!FTextureResampleType.isValid(p_type))
            {
                throw (new FError("FError: Invalid resample type."));
            };
            _iResampleType = p_type;
            if (_doNative != null)
            {
                invalidateTexture(true);
            };
        }

        public function set transparent(p_transparent:Boolean):void
        {
            _bTransparent = p_transparent;
            if (_doNative != null)
            {
                invalidateTexture(true);
            };
        }

        public function get transparent():Boolean
        {
            return (_bTransparent);
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            if (_doNative == null)
            {
                return;
            };
            invalidateTexture(false);
            __nAccumulatedTime = (__nAccumulatedTime + p_deltaTime);
            var _local4:Number = (1000 / updateFrameRate);
            if (((_bInvalidate) || ((__nAccumulatedTime > _local4))))
            {
                cTexture.bitmapData.fillRect(cTexture.bitmapData.rect, 0);
                cTexture.bitmapData.draw(_doNative, __mNativeMatrix);
                cTexture.invalidate();
                __nAccumulatedTime = (__nAccumulatedTime % _local4);
            };
            _bInvalidate = false;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            cNode.cTransform.nWorldScaleX = (cNode.cTransform.nWorldScaleX * _iResampleScale);
            cNode.cTransform.nWorldScaleY = (cNode.cTransform.nWorldScaleY * _iResampleScale);
            super.render(p_context, p_camera, p_maskRect);
            cNode.cTransform.nWorldScaleX = (cNode.cTransform.nWorldScaleX / _iResampleScale);
            cNode.cTransform.nWorldScaleY = (cNode.cTransform.nWorldScaleY / _iResampleScale);
        }

        protected function invalidateTexture(p_force:Boolean):void
        {
            if (_doNative == null)
            {
                return;
            };
            if (((((!(p_force)) && ((__nLastNativeWidth == _doNative.width)))) && ((__nLastNativeHeight == _doNative.height))))
            {
                return;
            };
            __nLastNativeWidth = _doNative.width;
            __nLastNativeHeight = _doNative.height;
            __mNativeMatrix.identity();
            __mNativeMatrix.scale((_doNative.scaleX / _iResampleScale), (_doNative.scaleY / _iResampleScale));
            var _local2:BitmapData = new BitmapData((__nLastNativeWidth / _iResampleScale), (__nLastNativeHeight / _iResampleScale), _bTransparent, 0);
            if (cTexture == null)
            {
                cTexture = FTextureFactory.createFromBitmapData(__sTextureId, _local2);
                cTexture.resampleType = _iResampleType;
                cTexture.filteringType = _iFilteringType;
            }
            else
            {
                cTexture.bitmapData = _local2;
            };
            cTexture.alignTexture(_iAlign);
            _bInvalidate = true;
        }

        override public function dispose():void
        {
            cTexture.dispose();
            super.dispose();
        }


    }
}//package com.flengine.components.renderables.flash

