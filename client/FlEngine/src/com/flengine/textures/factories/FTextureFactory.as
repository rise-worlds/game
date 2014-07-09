// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.factories.FTextureFactory

package com.flengine.textures.factories
{
    import flash.display.Bitmap;
    import com.flengine.textures.FTexture;
    import com.flengine.textures.FTextureUtils;
    import flash.display.BitmapData;
    import com.flengine.error.FError;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

    public class FTextureFactory 
    {


        public static function createFromAsset(p_id:String, p_asset:Class):FTexture
        {
            var _local3:Bitmap = new (p_asset)();
            return (new FTexture(p_id, 3, _local3.bitmapData, _local3.bitmapData.rect, FTextureUtils.isBitmapDataTransparent(_local3.bitmapData), _local3.bitmapData.rect.width, _local3.bitmapData.rect.height));
        }

        public static function createFromColor(p_id:String, p_color:uint, p_width:int, p_height:int):FTexture
        {
            var _local5:BitmapData = new BitmapData(p_width, p_height, false, p_color);
            return (new FTexture(p_id, 3, _local5, _local5.rect, false, _local5.rect.width, _local5.rect.height));
        }

        public static function createFromBitmapData(p_id:String, p_bitmapData:BitmapData):FTexture
        {
            if (p_bitmapData == null)
            {
                throw (new FError("FError: BitmapData cannot be null."));
            };
            return (new FTexture(p_id, 3, p_bitmapData, p_bitmapData.rect, FTextureUtils.isBitmapDataTransparent(p_bitmapData), p_bitmapData.rect.width, p_bitmapData.rect.height));
        }

        public static function createFromATF(p_id:String, p_atfData:ByteArray, p_uploadCallback:Function=null):FTexture
        {
            var _local8:int;
            var _local6:String = String.fromCharCode(p_atfData[0], p_atfData[1], p_atfData[2]);
            if (_local6 != "ATF")
            {
                throw (new FError("FError: Invalid ATF data."));
            };
            var _local7:Boolean = true;
            switch (p_atfData[6])
            {
                case 1:
                    _local8 = 0;
                    break;
                case 3:
                    _local8 = 1;
                    _local7 = false;
                    break;
                case 5:
                    _local8 = 2;
            };
            var _local5:int = Math.pow(2, p_atfData[7]);
            var _local4:int = Math.pow(2, p_atfData[8]);
            return (new FTexture(p_id, _local8, p_atfData, new Rectangle(0, 0, _local5, _local4), _local7, _local5, _local4, 0, 0, p_uploadCallback));
        }

        public static function createFromByteArray(p_id:String, p_byteArray:ByteArray, p_width:int, p_height:int, p_transparent:Boolean):FTexture
        {
            return (new FTexture(p_id, 2, p_byteArray, new Rectangle(0, 0, p_width, p_height), p_transparent, p_width, p_height));
        }

        public static function createRenderTexture(p_id:String, p_width:int, p_height:int, p_transparent:Boolean):FTexture
        {
            return (new FTexture(p_id, 4, null, new Rectangle(0, 0, p_width, p_height), p_transparent, p_width, p_height));
        }


    }
}//package com.flengine.textures.factories

