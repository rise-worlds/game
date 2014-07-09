// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTexture

package com.flengine.textures
{
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FTexture extends FTextureBase 
    {

        fl2d var doNativeObject:DisplayObject;
        fl2d var nUvX:Number = 0;
        fl2d var nUvY:Number = 0;
        fl2d var nUvScaleX:Number = 1;
        fl2d var nUvScaleY:Number = 1;
        fl2d var nFrameWidth:Number = 0;
        fl2d var nFrameHeight:Number = 0;
        fl2d var nPivotX:Number = 0;
        fl2d var nPivotY:Number = 0;
        fl2d var cParent:FTextureAtlas;
        fl2d var sSubId:String = "";
        fl2d var rRegion:Rectangle;

        public function FTexture(p_id:String, p_sourceType:int, p_source:*, p_region:Rectangle, p_transparent:Boolean, p_frameWidth:Number, p_frameHeight:Number, p_pivotX:Number=0, p_pivotY:Number=0, p_asyncCallback:Function=null, p_parent:FTextureAtlas=null)
        {
            super(p_id, p_sourceType, p_source, p_transparent, p_asyncCallback);
            rRegion = p_region;
            iWidth = rRegion.width;
            iHeight = rRegion.height;
            nPivotX = p_pivotX;
            nPivotY = p_pivotY;
            nFrameWidth = p_frameWidth;
            nFrameHeight = p_frameHeight;
            cParent = p_parent;
            if (cParent != null)
            {
                nUvX = (p_region.x / cParent.iWidth);
                nUvY = (p_region.y / cParent.iHeight);
                nUvScaleX = (p_region.width / cParent.iWidth);
                nUvScaleY = (p_region.height / cParent.iHeight);
            }
            else
            {
                invalidate();
            };
        }

        public static function getTextureById(p_id:String):FTexture
        {
            return ((FTextureBase.getTextureBaseById(p_id) as FTexture));
        }


        public function get nativeObject():DisplayObject
        {
            return (doNativeObject);
        }

        public function set bitmapData(p_bitmapData:BitmapData):void
        {
            if (cParent)
            {
                return;
            };
            bdBitmapData = p_bitmapData;
            rRegion = bdBitmapData.rect;
            iWidth = rRegion.width;
            iHeight = rRegion.height;
            invalidateContextTexture(false);
        }

        public function get uvX():Number
        {
            return (nUvX);
        }

        public function get uvY():Number
        {
            return (nUvY);
        }

        public function set uvY(p_value:Number):void
        {
            nUvY = p_value;
        }

        public function get uvScaleX():Number
        {
            return (nUvScaleX);
        }

        public function get uvScaleY():Number
        {
            return (nUvScaleY);
        }

        public function get frameWidth():Number
        {
            return (nFrameWidth);
        }

        public function set frameWidth(p_value:Number):void
        {
            nFrameWidth = p_value;
        }

        public function get frameHeight():Number
        {
            return (nFrameHeight);
        }

        public function set frameHeight(p_value:Number):void
        {
            nFrameHeight = p_value;
        }

        public function get pivotX():Number
        {
            return (nPivotX);
        }

        public function set pivotX(p_value:Number):void
        {
            nPivotX = p_value;
        }

        public function get pivotY():Number
        {
            return (nPivotY);
        }

        public function set pivotY(p_value:Number):void
        {
            nPivotY = p_value;
        }

        override public function get gpuWidth():int
        {
            if (cParent)
            {
                return (cParent.gpuWidth);
            };
            return (FTextureUtils.getNextValidTextureSize(iWidth));
        }

        override public function get gpuHeight():int
        {
            if (cParent)
            {
                return (cParent.gpuHeight);
            };
            return (FTextureUtils.getNextValidTextureSize(iHeight));
        }

        override public function hasParent():Boolean
        {
            return (!((cParent == null)));
        }

        public function alignTexture(p_align:int):void
        {
            switch (p_align)
            {
                case 1:
                    nPivotX = 0;
                    nPivotY = 0;
                    return;
                case 2:
                    nPivotX = (-(iWidth) / 2);
                    nPivotY = (-(iHeight) / 2);
                default:
            };
        }

        override public function get resampleType():int
        {
            if (cParent != null)
            {
                return (cParent.resampleType);
            };
            return (_iResampleType);
        }

        override public function set resampleType(p_type:int):void
        {
            if (cParent != null)
            {
                return;
            };
            super.resampleType = p_type;
        }

        override public function get resampleScale():int
        {
            if (cParent != null)
            {
                return (cParent.resampleScale);
            };
            return (_iResampleScale);
        }

        override public function set resampleScale(p_scale:int):void
        {
            if (cParent != null)
            {
                return;
            };
            super.resampleScale = p_scale;
        }

        override public function set filteringType(p_type:int):void
        {
            if (cParent != null)
            {
                return;
            };
            super.filteringType = p_type;
        }

        public function get parent():FTextureAtlas
        {
            return (cParent);
        }

        public function get region():Rectangle
        {
            return (rRegion);
        }

        public function set region(p_region:Rectangle):void
        {
            rRegion = p_region;
            iWidth = rRegion.width;
            iHeight = rRegion.height;
            if (cParent)
            {
                nUvX = (rRegion.x / cParent.iWidth);
                nUvY = (rRegion.y / cParent.iHeight);
                nUvScaleX = (iWidth / cParent.iWidth);
                nUvScaleY = (iHeight / cParent.iHeight);
            }
            else
            {
                invalidateContextTexture(false);
            };
        }

        public function set width(p_value:int):void
        {
            rRegion.width = (iWidth = p_value);
            nUvScaleX = (iWidth / cParent.iWidth);
        }

        public function getAlphaAtUV(p_u:Number, p_v:Number):uint
        {
            if (bdBitmapData == null)
            {
                return (0xFF);
            };
            return (((bdBitmapData.getPixel32((rRegion.x + (p_u * rRegion.width)), (rRegion.y + (p_v * rRegion.height))) >> 24) & 0xFF));
        }

        protected function updateUVScale():void
        {
            var _local4:int;
            var _local3:int;
            var _local1:Number;
            var _local2:Number;
            switch (_iResampleType)
            {
                case 2:
                    nUvScaleX = (rRegion.width / FTextureUtils.getNextValidTextureSize(iWidth));
                    nUvScaleY = (rRegion.height / FTextureUtils.getNextValidTextureSize(iHeight));
                    return;
                case 1:
                    _local4 = FTextureUtils.getNearestValidTextureSize(iWidth);
                    _local3 = FTextureUtils.getNearestValidTextureSize(iHeight);
                    _local1 = (_local4 / rRegion.width);
                    _local2 = (_local3 / rRegion.height);
                    nUvScaleX = (((_local1)>_local2) ? (_local2 / _local1) : 1);
                    nUvScaleY = (((_local2)>_local1) ? (_local1 / _local2) : 1);
                default:
            };
        }

        override protected function invalidateContextTexture(p_reinitialize:Boolean):void
        {
            if (cParent != null)
            {
                return;
            };
            updateUVScale();
            super.invalidateContextTexture(p_reinitialize);
        }

        fl2d function setParent(p_parent:FTextureAtlas, p_region:Rectangle):void
        {
            cParent = p_parent;
            region = p_region;
        }

        override public function dispose():void
        {
            if (cParent == null)
            {
                if (doNativeObject)
                {
                    doNativeObject = null;
                };
                if (baByteArray)
                {
                    baByteArray = null;
                };
                if (bdBitmapData)
                {
                    bdBitmapData = null;
                };
                if (cContextTexture)
                {
                    cContextTexture.dispose();
                };
            };
            cParent = null;
            super.dispose();
        }

        public function toString():String
        {
            return ((((((("[FTexture id:" + _sId) + ", width:") + width) + ", height:") + height) + "]"));
        }


    }
}//package com.flengine.textures

