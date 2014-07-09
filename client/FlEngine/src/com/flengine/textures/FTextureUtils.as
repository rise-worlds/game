// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTextureUtils

package com.flengine.textures
{
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.geom.Matrix;

    public class FTextureUtils 
    {

        private static const ZERO_POINT:Point = new Point();


        public static function isBitmapDataTransparent(p_bitmapData:BitmapData):Boolean
        {
            return (!((p_bitmapData.getColorBoundsRect(0xFF000000, 0xFF000000, false).width == 0)));
        }

        public static function isValidTextureSize(p_size:int):Boolean
        {
            var _local2:int = 1;
            while (_local2 < p_size)
            {
                _local2 = (_local2 * 2);
            };
            return ((_local2 == p_size));
        }

        public static function getNextValidTextureSize(p_size:int):int
        {
            var _local2:int = 1;
            while (p_size > _local2)
            {
                _local2 = (_local2 * 2);
            };
            return (_local2);
        }

        public static function getPreviousValidTextureSize(p_size:int):int
        {
            var _local2:int = 1;
            while (p_size > _local2)
            {
                _local2 = (_local2 * 2);
            };
            return ((_local2 / 2));
        }

        public static function getNearestValidTextureSize(p_size:int):int
        {
            var _local2:int = getPreviousValidTextureSize(p_size);
            var _local3:int = getNextValidTextureSize(p_size);
            return (((((p_size - _local2))<(_local3 - p_size)) ? _local2 : _local3));
        }

        public static function resampleBitmapData(p_bitmapData:BitmapData, p_resampleType:int, p_resampleScale:int):BitmapData
        {
            var _local11:int;
            var _local10:int;
            var _local7 = null;
            var _local9 = null;
            var _local4:Number;
            var _local6:Number;
            var _local5:Number;
            var _local8:int = p_bitmapData.width;
            var _local12:int = p_bitmapData.height;
            switch (p_resampleType)
            {
                case 2:
                case 3:
                    _local11 = getNextValidTextureSize(_local8);
                    _local10 = getNextValidTextureSize(_local12);
                    break;
                case 4:
                    _local11 = getPreviousValidTextureSize(_local8);
                    _local10 = getPreviousValidTextureSize(_local12);
                    break;
                case 0:
                case 1:
                    _local11 = getNearestValidTextureSize(_local8);
                    _local10 = getNearestValidTextureSize(_local12);
                default:
            };
            if ((((((_local11 == _local8)) && ((_local10 == _local12)))) && ((p_resampleScale == 1))))
            {
                return (p_bitmapData);
            };
            switch (p_resampleType)
            {
                case 2:
                    _local9 = new Matrix();
                    _local9.scale((1 / p_resampleScale), (1 / p_resampleScale));
                    _local7 = new BitmapData((_local11 / p_resampleScale), (_local10 / p_resampleScale), true, 0);
                    if (p_resampleScale == 1)
                    {
                        _local7.copyPixels(p_bitmapData, p_bitmapData.rect, ZERO_POINT);
                    }
                    else
                    {
                        _local7.draw(p_bitmapData, _local9);
                    };
                    break;
                case 0:
                case 3:
                case 4:
                    _local9 = new Matrix();
                    _local9.scale((_local11 / (_local8 * p_resampleScale)), (_local10 / (_local12 * p_resampleScale)));
                    _local7 = new BitmapData((_local11 / p_resampleScale), (_local10 / p_resampleScale), true, 0);
                    _local7.draw(p_bitmapData, _local9);
                    break;
                case 1:
                    _local9 = new Matrix();
                    _local4 = (_local11 / _local8);
                    _local6 = (_local10 / _local12);
                    _local5 = (((_local4)>_local6) ? _local6 : _local4);
                    _local9.scale((_local5 / p_resampleScale), (_local5 / p_resampleScale));
                    _local7 = new BitmapData((_local11 / p_resampleScale), (_local10 / p_resampleScale), true, 0);
                    _local7.draw(p_bitmapData, _local9);
                default:
            };
            return (_local7);
        }


    }
}//package com.flengine.textures

