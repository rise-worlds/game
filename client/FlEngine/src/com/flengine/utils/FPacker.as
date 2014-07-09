// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.utils.FPacker

package com.flengine.utils
{
    import __AS3__.vec.Vector;
    import flash.geom.Matrix;
    import flash.display.BitmapData;

    public class FPacker 
    {

        public static const SORT_NONE:int = 0;
        public static const SORT_ASCENDING:int = 1;
        public static const SORT_DESCENDING:int = 2;

        public static var nonValidTextureSizePrecision:int = 5;

        protected var _iMaxWidth:int;
        protected var _iMaxHeight:int;
        protected var _bAutoExpand:Boolean = false;
        protected var _iSortOnExpand:int = 2;
        protected var _bForceValidTextureSizeOnExpand:Boolean = true;
        protected var _iWidth:int;
        protected var _iHeight:int;
        protected var _aRectangles:Vector.<FPackerRectangle>;

        public function FPacker(p_width:int=1, p_height:int=1, p_maxWidth:int=0x0800, p_maxHeight:int=0x0800, p_autoExpand:Boolean=false):void
        {
            if ((((p_width <= 0)) || ((p_height <= 0))))
            {
                throw (new Error("Invalid packer size"));
            };
            _iWidth = p_width;
            _iHeight = p_height;
            _iMaxWidth = p_maxWidth;
            _iMaxHeight = p_maxHeight;
            _bAutoExpand = p_autoExpand;
            clear();
        }

        public function get width():int
        {
            return (_iWidth);
        }

        public function get height():int
        {
            return (_iHeight);
        }

        public function get rectangles():Vector.<FPackerRectangle>
        {
            return (_aRectangles.concat());
        }

        public function packRectangles(p_rectangles:Vector.<FPackerRectangle>, p_padding:int=0, p_sort:int=2):Boolean
        {
            return (false);
        }

        public function packRectangle(p_rect:FPackerRectangle, p_padding:int=0, p_forceValidTextureSize:Boolean=true):Boolean
        {
            return (false);
        }

        protected function getRectanglesArea(p_rectangles:Vector.<FPackerRectangle>):int
        {
            var _local2:int;
            var _local3:int = (p_rectangles.length - 1);
            while (_local3 >= 0)
            {
                _local2 = (_local2 + (p_rectangles[_local3].width * p_rectangles[_local3].height));
                _local3--;
            };
            return (_local2);
        }

        protected function sortOnAreaAscending(a:FPackerRectangle, b:FPackerRectangle):Number
        {
            var _local4:int = (a.width * a.height);
            var _local3:int = (b.width * b.height);
            if (_local4 < _local3)
            {
                return (-1);
            };
            if (_local4 > _local3)
            {
                return (1);
            };
            return (0);
        }

        protected function sortOnAreaDescending(a:FPackerRectangle, b:FPackerRectangle):Number
        {
            var _local4:int = (a.width * a.height);
            var _local3:int = (b.width * b.height);
            if (_local4 > _local3)
            {
                return (-1);
            };
            if (_local4 < _local3)
            {
                return (1);
            };
            return (0);
        }

        protected function sortOnHeightAscending(a:FPackerRectangle, b:FPackerRectangle):Number
        {
            if (a.height < b.height)
            {
                return (-1);
            };
            if (a.height > b.height)
            {
                return (1);
            };
            return (0);
        }

        protected function sortOnHeightDescending(a:FPackerRectangle, b:FPackerRectangle):Number
        {
            if (a.height > b.height)
            {
                return (-1);
            };
            if (a.height < b.height)
            {
                return (1);
            };
            return (0);
        }

        public function clear():void
        {
            _aRectangles = new Vector.<FPackerRectangle>();
        }

        public function draw(p_bitmapData:BitmapData):void
        {
            var _local4:int;
            var _local3 = null;
            var _local2:Matrix = new Matrix();
            _local4 = 0;
            while (_local4 < _aRectangles.length)
            {
                _local3 = _aRectangles[_local4];
                _local2.tx = _aRectangles[_local4].x;
                _local2.ty = _aRectangles[_local4].y;
                p_bitmapData.draw(_local3.bitmapData, _local2);
                _local4++;
            };
        }


    }
}//package com.flengine.utils

