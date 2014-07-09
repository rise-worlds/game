// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTextureBase

package com.flengine.textures
{
    import flash.utils.Dictionary;
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import com.flengine.context.FContextTexture;
    import com.flengine.core.FlEngine;
    import com.flengine.error.FError;
    import flash.events.Event;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FTextureBase 
    {

        public static var alwaysUseCompressed:Boolean = false;
        private static var __iDefaultResampleType:int = 2;
        public static var defaultResampleScale:int = 1;
        private static var __iDefaultFilteringType:int = 1;
        private static var __dReferences:Dictionary = new Dictionary();

        fl2d var bdBitmapData:BitmapData;
        fl2d var baByteArray:ByteArray;
        protected var _iResampleType:int;
        protected var _iResampleScale:int;
        fl2d var iFilteringType:int;
        fl2d var nSourceWidth:int;
        fl2d var nSourceHeight:int;
        public var premultiplied:Boolean = true;
        fl2d var iWidth:int;
        fl2d var iHeight:int;
        protected var _sId:String;
        fl2d var cContextTexture:FContextTexture;
        fl2d var iSourceType:int;
        fl2d var iAtfType:int;
        fl2d var bTransparent:Boolean;
        protected var _fAsyncCallback:Function;
        public var resampled:BitmapData;

        public function FTextureBase(p_id:String, p_sourceType:int, p_source:*, p_transparent:Boolean, p_asyncCallback:Function)
        {
            _iResampleType = defaultResampleType;
            _iResampleScale = defaultResampleScale;
            iFilteringType = __iDefaultFilteringType;
            super();
            if (!FlEngine.getInstance().isInitialized())
            {
                throw (new FError("FError: FlEngine is not initialized."));
            };
            if ((((p_id == null)) || ((p_id.length == 0))))
            {
                throw (new FError("FError: Texture ID cannot be null or empty."));
            };
            if (__dReferences[p_id] != null)
            {
                throw (new FError("FError: Texture with specified ID already exists.", p_id));
            };
            __dReferences[p_id] = this;
            _sId = p_id;
            iSourceType = p_sourceType;
            bTransparent = p_transparent;
            _fAsyncCallback = p_asyncCallback;
            switch (p_sourceType)
            {
                case 3:
                    bdBitmapData = (p_source as BitmapData);
                    premultiplied = true;
                    return;
                case 0:
                    baByteArray = (p_source as ByteArray);
                    premultiplied = false;
                    return;
                case 1:
                    baByteArray = (p_source as ByteArray);
                    iAtfType = 1;
                    premultiplied = false;
                    return;
                case 2:
                    baByteArray = (p_source as ByteArray);
                    iAtfType = 2;
                    premultiplied = false;
                default:
            };
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

        public static function get defaultFilteringType():int
        {
            return (__iDefaultFilteringType);
        }

        public static function set defaultFilteringType(p_type:int):void
        {
            if (!FTextureFilteringType.isValid(p_type))
            {
                throw (new FError("FError: Invalid filtering type."));
            };
            __iDefaultFilteringType = p_type;
        }

        public static function getTextureBaseById(p_id:String):FTextureBase
        {
            return (__dReferences[p_id]);
        }

        public static function getGPUTextureCount():int
        {
            var _local2:int;
            for each (var _local1:FTextureBase in __dReferences)
            {
                if (((_local1.cContextTexture) && (!(_local1.hasParent()))))
                {
                    _local2++;
                };
            };
            return (_local2);
        }

        public static function getTextureCount():int
        {
            var _local2:int;
            for each (var _local1:FTextureBase in __dReferences)
            {
                if ((_local1 is FTexture))
                {
                    _local2++;
                };
            };
            return (_local2);
        }

        fl2d static function invalidate():void
        {
            for (var _local1:String in __dReferences)
            {
                (__dReferences[_local1] as FTextureBase).invalidateContextTexture(true);
            };
        }


        public function invalidate():void
        {
            invalidateContextTexture(false);
        }

        public function get bitmapData():BitmapData
        {
            return (bdBitmapData);
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
        }

        public function get resampleScale():int
        {
            return (_iResampleScale);
        }

        public function set resampleScale(p_scale:int):void
        {
            _iResampleScale = (((p_scale)>0) ? p_scale : 1);
            invalidateContextTexture(false);
        }

        public function get filteringType():int
        {
            return (iFilteringType);
        }

        public function set filteringType(p_type:int):void
        {
            if (!FTextureFilteringType.isValid(p_type))
            {
                throw (new FError("FError: Invalid filtering type."));
            };
            iFilteringType = p_type;
        }

        public function get width():int
        {
            return (iWidth);
        }

        public function get gpuWidth():int
        {
            return (FTextureUtils.getNextValidTextureSize(iWidth));
        }

        public function get height():int
        {
            return (iHeight);
        }

        public function get gpuHeight():int
        {
            return (FTextureUtils.getNextValidTextureSize(iHeight));
        }

        public function hasParent():Boolean
        {
            return (false);
        }

        public function get id():String
        {
            return (_sId);
        }

        fl2d function getSource()
        {
            switch (iSourceType)
            {
                case 3:
                    return (bdBitmapData);
                case 1:
                    return (baByteArray);
                case 2:
                    return (baByteArray);
                default:
                    return;
            };
        }

        protected function invalidateContextTexture(p_reinitialize:Boolean):void
        {
            var _local4 = null;
            var _local3:int;
            var _local2:int;
            switch (iSourceType)
            {
                case 3:
                    resampled = FTextureUtils.resampleBitmapData(bdBitmapData, _iResampleType, resampleScale);
                    if ((((((((cContextTexture == null)) || (p_reinitialize))) || (!((cContextTexture.iWidth == resampled.width))))) || (!((cContextTexture.iHeight == resampled.height)))))
                    {
                        if (cContextTexture)
                        {
                            cContextTexture.dispose();
                        };
                        _local4 = "bgra";
                        if (alwaysUseCompressed)
                        {
                            _local4 = ((bTransparent) ? "compressedAlpha" : "compressed");
                            iAtfType = ((bTransparent) ? 2 : 1);
                        }
                        else
                        {
                            iAtfType = 0;
                        };
                        cContextTexture = FlEngine.getInstance().cContext.createTexture(resampled.width, resampled.height, _local4, false);
                    };
                    cContextTexture.uploadFromBitmapData(resampled);
                    return;
                case 0:
                    if ((((((((cContextTexture == null)) || (p_reinitialize))) || (!((cContextTexture.iWidth == iWidth))))) || (!((cContextTexture.iHeight == iHeight)))))
                    {
                        if (cContextTexture)
                        {
                            cContextTexture.dispose();
                        };
                        cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "bgra", false);
                        if (_fAsyncCallback != null)
                        {
                            cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
                        };
                    };
                    cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, !((_fAsyncCallback == null)));
                    return;
                case 1:
                    if ((((((((cContextTexture == null)) || (p_reinitialize))) || (!((cContextTexture.iWidth == iWidth))))) || (!((cContextTexture.iHeight == iHeight)))))
                    {
                        if (cContextTexture)
                        {
                            cContextTexture.dispose();
                        };
                        cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "compressed", false);
                        if (_fAsyncCallback != null)
                        {
                            cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
                        };
                        iAtfType = 1;
                    };
                    cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, !((_fAsyncCallback == null)));
                    return;
                case 2:
                    if ((((((((cContextTexture == null)) || (p_reinitialize))) || (!((cContextTexture.iWidth == iWidth))))) || (!((cContextTexture.iHeight == iHeight)))))
                    {
                        if (cContextTexture)
                        {
                            cContextTexture.dispose();
                        };
                        cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "compressedAlpha", false);
                        if (_fAsyncCallback != null)
                        {
                            cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
                        };
                        iAtfType = 2;
                    };
                    cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, !((_fAsyncCallback == null)));
                    return;
                case 4:
                    _local3 = FTextureUtils.getNextValidTextureSize(iWidth);
                    _local2 = FTextureUtils.getNextValidTextureSize(iHeight);
                    if ((((((((cContextTexture == null)) || (p_reinitialize))) || (!((cContextTexture.iWidth == _local3))))) || (!((cContextTexture.iHeight == _local2)))))
                    {
                        if (cContextTexture)
                        {
                            cContextTexture.dispose();
                        };
                        cContextTexture = FlEngine.getInstance().cContext.createTexture(_local3, _local2, "bgra", true);
                    };
                default:
            };
        }

        protected function onATFUploaded(event:Event):void
        {
            cContextTexture.tTexture.removeEventListener("textureReady", onATFUploaded);
            (_fAsyncCallback(this));
            _fAsyncCallback = null;
        }

        public function dispose():void
        {
            delete __dReferences[_sId]; //not popped
        }


    }
}//package com.flengine.textures

