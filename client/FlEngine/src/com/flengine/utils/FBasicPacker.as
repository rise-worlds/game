// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.utils.FBasicPacker

package com.flengine.utils
{
    import __AS3__.vec.Vector;

    public class FBasicPacker extends FPacker 
    {

        private var __iXOffset:int = 0;
        private var __iYOffset:int = 0;
        private var __iRowOffset:int = 0;

        public function FBasicPacker(p_width:int=1, p_height:int=1, p_maxWidth:int=0x0800, p_maxHeight:int=0x0800):void
        {
            super(p_width, p_height, p_maxWidth, p_maxHeight);
        }

        override public function packRectangles(p_rectangles:Vector.<FPackerRectangle>, p_padding:int=0, p_sort:int=2):Boolean
        {
            var _local10:Boolean;
            var _local11:int;
            var _local5:Boolean;
            var _local8:*;
            var _local7:int;
            var _local9 = null;
            if ((((p_sort == 1)) || ((p_sort == 2))))
            {
                p_rectangles.sort((((p_sort)==1) ? sortOnHeightAscending : sortOnHeightDescending));
            };
            var _local4:int = p_rectangles.length;
            var _local6:Vector.<FPackerRectangle> = ((_bAutoExpand) ? new Vector.<FPackerRectangle>() : null);
            _local11 = 0;
            while (_local11 < _local4)
            {
                _local9 = p_rectangles[_local11];
                _local5 = addRectangle(_local9.width, _local9.height, p_padding);
                if (((!(_local5)) && (_bAutoExpand)))
                {
                    _local6.push(p_rectangles[_local11]);
                };
                _local10 = ((_local10) && (_local5));
                _local11++;
            };
            if (((!(_local10)) && (_bAutoExpand)))
            {
                _local8 = rectangles;
                _local8 = _local8.concat(_local6);
                if ((((_iSortOnExpand == 1)) || ((_iSortOnExpand == 2))))
                {
                    _local8.sort((((_iSortOnExpand)==1) ? sortOnHeightAscending : sortOnHeightDescending));
                };
                _local7 = getRectanglesArea(_local8);
                do 
                {
                    if ((((((_iWidth <= _iHeight)) || ((_iHeight == _iMaxHeight)))) && ((_iWidth < _iMaxWidth))))
                    {
                        _iWidth = ((_bForceValidTextureSizeOnExpand) ? (_iWidth * 2) : (_iWidth + 1));
                    }
                    else
                    {
                        _iHeight = ((_bForceValidTextureSizeOnExpand) ? (_iHeight * 2) : (_iHeight + 1));
                    };
                } while (((((_iWidth * _iHeight) < _local7)) && ((((_iWidth < _iMaxWidth)) || ((_iHeight < _iMaxHeight))))));
                clear();
                _local10 = addRectangles(_local8, p_padding);
                while (((!(_local10)) && ((((_iWidth < _iMaxWidth)) || ((_iHeight < _iMaxHeight))))))
                {
                    if ((((((_iWidth <= _iHeight)) || ((_iHeight == _iMaxHeight)))) && ((_iWidth < _iMaxWidth))))
                    {
                        _iWidth = ((_bForceValidTextureSizeOnExpand) ? (_iWidth * 2) : (_iWidth + nonValidTextureSizePrecision));
                    }
                    else
                    {
                        _iHeight = ((_bForceValidTextureSizeOnExpand) ? (_iHeight * 2) : (_iHeight + nonValidTextureSizePrecision));
                    };
                    clear();
                    _local10 = addRectangles(_local8, p_padding);
                };
                _local10 = (((_iWidth <= _iMaxWidth)) && ((_iHeight <= _iMaxHeight)));
            };
            return (_local10);
        }

        private function addRectangles(p_rectangles:Vector.<FPackerRectangle>, p_padding:int=0, p_force:Boolean=true):Boolean
        {
            var _local7:int;
            var _local5 = null;
            var _local4:int = p_rectangles.length;
            var _local6:Boolean = true;
            _local7 = 0;
            while (_local7 < _local4)
            {
                _local5 = p_rectangles[_local7];
                _local6 = addRectangle(_local5.width, _local5.height, p_padding);
                if (((!(_local6)) && (!(p_force))))
                {
                    return (false);
                };
                _local7++;
            };
            return (_local6);
        }

        private function addRectangle(p_width:int, p_height:int, p_padding:int=0):Boolean
        {
            var _local4:int = (p_padding * 2);
            var _local6:int = __iXOffset;
            var _local7:int = __iYOffset;
            var _local5:int = __iRowOffset;
            if (((__iXOffset + p_width) + _local4) > _iWidth)
            {
                __iXOffset = 0;
                __iYOffset = (__iYOffset + __iRowOffset);
                __iRowOffset = 0;
            };
            if ((p_height + _local4) > __iRowOffset)
            {
                __iRowOffset = (p_height + _local4);
            };
            if (((__iYOffset + p_height) + _local4) > _iHeight)
            {
                __iXOffset = _local6;
                __iYOffset = _local7;
                __iRowOffset = _local5;
                return (false);
            };
            _aRectangles.push(FPackerRectangle.get((__iXOffset + p_padding), (__iYOffset + p_padding), p_width, p_height));
            __iXOffset = (__iXOffset + (p_width + _local4));
            return (true);
        }

        override public function clear():void
        {
            super.clear();
            __iXOffset = 0;
            __iYOffset = 0;
            __iRowOffset = 0;
        }


    }
}//package com.flengine.utils

