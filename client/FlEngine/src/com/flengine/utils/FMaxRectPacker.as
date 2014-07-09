// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.utils.FMaxRectPacker

package com.flengine.utils
{
    import __AS3__.vec.Vector;

    public class FMaxRectPacker extends FPacker 
    {

        public static const BOTTOM_LEFT:int = 0;
        public static const SHORT_SIDE_FIT:int = 1;
        public static const LONG_SIDE_FIT:int = 2;
        public static const AREA_FIT:int = 3;

        private var __iHeuristics:int = 0;
        private var __cFirstAvailableArea:FPackerRectangle;
        private var __cLastAvailableArea:FPackerRectangle;
        private var __cFirstNewArea:FPackerRectangle;
        private var __cLastNewArea:FPackerRectangle;
        private var __cNewBoundingArea:FPackerRectangle;
        private var __cNegativeArea:FPackerRectangle;

        public function FMaxRectPacker(p_width:int=1, p_height:int=1, p_maxWidth:int=0x0800, p_maxHeight:int=0x0800, p_autoExpand:Boolean=false, p_heuristics:int=0)
        {
            __cNewBoundingArea = FPackerRectangle.get(0, 0, 0, 0);
            super(p_width, p_height, p_maxWidth, p_maxHeight, p_autoExpand);
            __iHeuristics = p_heuristics;
        }

        override public function packRectangles(p_rectangles:Vector.<FPackerRectangle>, p_padding:int=0, p_sort:int=2):Boolean
        {
            var _local5:Boolean;
            var _local8:*;
            var _local7:int;
            var _local9:FPackerRectangle;
            if (p_sort != 0)
            {
                p_rectangles.sort((((p_sort)==1) ? sortOnHeightAscending : sortOnHeightDescending));
            };
            var _local4:int = p_rectangles.length;
            var _local10:Boolean = true;
            var _local6:Vector.<FPackerRectangle> = ((_bAutoExpand) ? new Vector.<FPackerRectangle>() : null);
            var _local11:int;
            while (_local11 < _local4)
            {
                _local9 = p_rectangles[_local11];
                _local5 = addRectangle(_local9, p_padding);
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
                if (_iSortOnExpand != 0)
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

        override public function packRectangle(p_rect:FPackerRectangle, p_padding:int=0, p_forceValidTextureSize:Boolean=true):Boolean
        {
            var _local4:*;
            var _local5:Boolean = addRectangle(p_rect, p_padding);
            if (((!(_local5)) && (_bAutoExpand)))
            {
                _local4 = rectangles;
                _local4.push(p_rect);
                clear();
                packRectangles(_local4, p_padding, _iSortOnExpand);
                _local5 = true;
            };
            return (_local5);
        }

        private function addRectangles(p_rectangles:Vector.<FPackerRectangle>, p_padding:int=0, p_force:Boolean=true):Boolean
        {
            var _local5:FPackerRectangle;
            var _local4:int = p_rectangles.length;
            var _local6:Boolean = true;
            var _local7:int;
            while (_local7 < _local4)
            {
                _local5 = p_rectangles[_local7];
                _local6 = ((_local6) && (addRectangle(_local5, p_padding)));
                if (((!(_local6)) && (!(p_force))))
                {
                    return (false);
                };
                _local7++;
            };
            return (_local6);
        }

        private function addRectangle(p_rect:FPackerRectangle, p_padding:int):Boolean
        {
            var _local3:FPackerRectangle = getAvailableArea((p_rect.width + ((p_padding - p_rect.padding) * 2)), (p_rect.height + ((p_padding - p_rect.padding) * 2)));
            if (_local3 == null)
            {
                return (false);
            };
            p_rect.set(_local3.x, _local3.y, (p_rect.width + ((p_padding - p_rect.padding) * 2)), (p_rect.height + ((p_padding - p_rect.padding) * 2)));
            p_rect.padding = p_padding;
            splitAvailableAreas(p_rect);
            pushNewAreas();
            if (p_padding != 0)
            {
                p_rect.setPadding(0);
            };
            _aRectangles.push(p_rect);
            return (true);
        }

        private function createNewArea(p_x:int, p_y:int, p_width:int, p_height:int):FPackerRectangle
        {
            var _local6:FPackerRectangle;
            var _local7:FPackerRectangle;
            var _local5:Boolean = true;
            _local6 = __cFirstNewArea;
            while (_local6)
            {
                _local7 = _local6.cNext;
                if (!(((((((_local6.x > p_x)) || ((_local6.y > p_y)))) || ((_local6.right < (p_x + p_width))))) || ((_local6.bottom < (p_y + p_height)))))
                {
                    _local5 = false;
                    break;
                };
                if (!(((((((_local6.x < p_x)) || ((_local6.y < p_y)))) || ((_local6.right > (p_x + p_width))))) || ((_local6.bottom > (p_y + p_height)))))
                {
                    if (_local6.cNext)
                    {
                        _local6.cNext.cPrevious = _local6.cPrevious;
                    }
                    else
                    {
                        __cLastNewArea = _local6.cPrevious;
                    };
                    if (_local6.cPrevious)
                    {
                        _local6.cPrevious.cNext = _local6.cNext;
                    }
                    else
                    {
                        __cFirstNewArea = _local6.cNext;
                    };
                    _local6.dispose();
                };
                _local6 = _local7;
            };
            if (!_local5)
            {
                return (null);
            };
            _local6 = FPackerRectangle.get(p_x, p_y, p_width, p_height);
            if (__cNewBoundingArea.x < p_x)
            {
                __cNewBoundingArea.x = p_x;
            };
            if (__cNewBoundingArea.right > _local6.right)
            {
                __cNewBoundingArea.right = _local6.right;
            };
            if (__cNewBoundingArea.y < p_y)
            {
                __cNewBoundingArea.y = p_y;
            };
            if (__cNewBoundingArea.bottom < _local6.bottom)
            {
                __cNewBoundingArea.bottom = _local6.bottom;
            };
            if (__cLastNewArea)
            {
                _local6.cPrevious = __cLastNewArea;
                __cLastNewArea.cNext = _local6;
                __cLastNewArea = _local6;
            }
            else
            {
                __cLastNewArea = _local6;
                __cFirstNewArea = _local6;
            };
            return (_local6);
        }

        private function splitAvailableAreas(p_splitter:FPackerRectangle):void
        {
            var _local6:FPackerRectangle;
            var _local7:FPackerRectangle;
            var _local5:int = p_splitter.x;
            var _local4:int = p_splitter.y;
            var _local2:int = p_splitter.right;
            var _local3:int = p_splitter.bottom;
            _local6 = __cFirstAvailableArea;
            while (_local6)
            {
                _local7 = _local6.cNext;
                if (!(((((((_local5 >= _local6.right)) || ((_local2 <= _local6.x)))) || ((_local4 >= _local6.bottom)))) || ((_local3 <= _local6.y))))
                {
                    if (_local5 > _local6.x)
                    {
                        createNewArea(_local6.x, _local6.y, (_local5 - _local6.x), _local6.height);
                    };
                    if (_local2 < _local6.right)
                    {
                        createNewArea(_local2, _local6.y, (_local6.right - _local2), _local6.height);
                    };
                    if (_local4 > _local6.y)
                    {
                        createNewArea(_local6.x, _local6.y, _local6.width, (_local4 - _local6.y));
                    };
                    if (_local3 < _local6.bottom)
                    {
                        createNewArea(_local6.x, _local3, _local6.width, (_local6.bottom - _local3));
                    };
                    if (_local6.cNext)
                    {
                        _local6.cNext.cPrevious = _local6.cPrevious;
                    }
                    else
                    {
                        __cLastAvailableArea = _local6.cPrevious;
                    };
                    if (_local6.cPrevious)
                    {
                        _local6.cPrevious.cNext = _local6.cNext;
                    }
                    else
                    {
                        __cFirstAvailableArea = _local6.cNext;
                    };
                    _local6.dispose();
                };
                _local6 = _local7;
            };
        }

        private function pushNewAreas():void
        {
            var _local1:FPackerRectangle;
            while (__cFirstNewArea)
            {
                _local1 = __cFirstNewArea;
                if (_local1.cNext)
                {
                    __cFirstNewArea = _local1.cNext;
                    __cFirstNewArea.cPrevious = null;
                }
                else
                {
                    __cFirstNewArea = null;
                };
                _local1.cPrevious = null;
                _local1.cNext = null;
                if (__cLastAvailableArea)
                {
                    _local1.cPrevious = __cLastAvailableArea;
                    __cLastAvailableArea.cNext = _local1;
                    __cLastAvailableArea = _local1;
                }
                else
                {
                    __cLastAvailableArea = _local1;
                    __cFirstAvailableArea = _local1;
                };
            };
            __cLastNewArea = null;
            __cNewBoundingArea.set(0, 0, 0, 0);
        }

        private function getAvailableArea(p_width:int, p_height:int):FPackerRectangle
        {
            var _local3:int;
            var _local11:int;
            var _local7:int;
            var _local9:int;
            var _local6:int;
            var _local8:int;
            var _local5:FPackerRectangle;
            var _local10:FPackerRectangle = __cNegativeArea;
            var _local4:int = -1;
            switch (__iHeuristics)
            {
                case 0:
                    _local5 = __cFirstAvailableArea;
                    while (_local5)
                    {
                        if ((((_local5.width >= p_width)) && ((_local5.height >= p_height))))
                        {
                            if ((((_local5.y < _local10.y)) || ((((_local5.y == _local10.y)) && ((_local5.x < _local10.x))))))
                            {
                                _local10 = _local5;
                            };
                        };
                        _local5 = _local5.cNext;
                    };
                    break;
                case 1:
                    _local10.width = (_iWidth + 1);
                    _local5 = __cFirstAvailableArea;
                    while (_local5)
                    {
                        if ((((_local5.width >= p_width)) && ((_local5.height >= p_height))))
                        {
                            _local3 = (_local5.width - p_width);
                            _local11 = (_local5.height - p_height);
                            _local7 = (((_local3)<_local11) ? _local3 : _local11);
                            _local3 = (_local10.width - p_width);
                            _local11 = (_local10.height - p_height);
                            _local9 = (((_local3)<_local11) ? _local3 : _local11);
                            if (_local7 < _local9)
                            {
                                _local10 = _local5;
                            };
                        };
                        _local5 = _local5.cNext;
                    };
                    break;
                case 2:
                    _local10.width = (_iWidth + 1);
                    _local5 = __cFirstAvailableArea;
                    while (_local5)
                    {
                        if ((((_local5.width >= p_width)) && ((_local5.height >= p_height))))
                        {
                            _local3 = (_local5.width - p_width);
                            _local11 = (_local5.height - p_height);
                            _local7 = (((_local3)>_local11) ? _local3 : _local11);
                            _local3 = (_local10.width - p_width);
                            _local11 = (_local10.height - p_height);
                            _local9 = (((_local3)>_local11) ? _local3 : _local11);
                            if (_local7 < _local9)
                            {
                                _local10 = _local5;
                            };
                        };
                        _local5 = _local5.cNext;
                    };
                    break;
                case 3:
                    _local10.width = (_iWidth + 1);
                    _local5 = __cFirstAvailableArea;
                    while (_local5)
                    {
                        if ((((_local5.width >= p_width)) && ((_local5.height >= p_height))))
                        {
                            _local6 = (_local5.width * _local5.height);
                            _local8 = (_local10.width * _local10.height);
                            if ((((_local6 < _local8)) || ((((_local6 == _local8)) && ((_local5.width < _local10.width))))))
                            {
                                _local10 = _local5;
                            };
                        };
                        _local5 = _local5.cNext;
                    };
                default:
            };
            return ((((_local10)!=__cNegativeArea) ? _local10 : null));
        }

        override public function clear():void
        {
            var _local1 = null;
            super.clear();
            while (__cFirstAvailableArea)
            {
                _local1 = __cFirstAvailableArea;
                __cFirstAvailableArea = _local1.cNext;
                _local1.dispose();
            };
            __cLastAvailableArea = FPackerRectangle.get(0, 0, _iWidth, _iHeight);
            __cFirstAvailableArea = FPackerRectangle.get(0, 0, _iWidth, _iHeight);
            __cNegativeArea = FPackerRectangle.get((_iWidth + 1), (_iHeight + 1), (_iWidth + 1), (_iHeight + 1));
        }


    }
}//package com.flengine.utils

