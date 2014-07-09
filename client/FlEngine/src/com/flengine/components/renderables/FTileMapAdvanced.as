// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FTileMapAdvanced

package com.flengine.components.renderables
{
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import com.flengine.core.FNode;
    import com.flengine.components.FTransform;
    import com.flengine.textures.FTexture;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FTileMapAdvanced extends FRenderable 
    {

        private var __iWidth:int;
        private var __iHeight:int;
        private var __iCols:int;
        private var __iRows:int;
        private var __aTiles:Vector.<int>;
        private var __aNewTileIndices:Vector.<int>;
        private var __aTileset:Vector.<FTile>;
        private var __iTileWidth:int;
        private var __iTileHeight:int;
        private var __iTileWidthHalf:Number;
        private var __iTileHeightHalf:Number;
        public var pivotX:Number = 0;
        public var pivotY:Number = 0;
        public var tilesDrawn:int = 0;
        public var debugMargin:int = 0;
        private var _tempCol:int = 0;
        private var _tempRow:int = 0;
        private var _tempPoint:Point;

        public function FTileMapAdvanced(p_node:FNode)
        {
            super(p_node);
            _tempPoint = new Point();
            __aNewTileIndices = new Vector.<int>();
        }

        override public function dispose():void
        {
            var _local1 = null;
            if (!__aTiles)
            {
                return;
            };
            __aTiles.length = 0;
            __aTiles = null;
            while (__aTileset.length > 0)
            {
                _local1 = __aTileset.pop();
                if (("destroy" in _local1))
                {
                    Object(_local1).destroy();
                };
                if (("dispose" in _local1))
                {
                    Object(_local1).dispose();
                };
            };
            __aTileset.length = 0;
            __aTileset = null;
            __aNewTileIndices.length = 0;
            __aNewTileIndices = null;
            super.dispose();
        }

        public function setTileSet(pTileset:Vector.<FTile>):void
        {
            __aTileset = pTileset;
        }

        public function setTiles(pTiles:Vector.<int>, pMapCols:int, pMapRows:int, pTileWidth:int, pTileHeight:int):void
        {
            if ((((pTiles == null)) || (!(((pMapCols * pMapRows) == pTiles.length)))))
            {
                throw (new Error(("Cols x Rows don't match the length of Tiles supplied! - " + [pMapCols, pMapRows, pTiles.length].join(" : "))));
            };
            __aTiles = pTiles;
            __iCols = pMapCols;
            __iRows = pMapRows;
            setTileSize(pTileWidth, pTileHeight);
        }

        public function setTileSize(pTileWidth:int, pTileHeight:int):void
        {
            __iTileWidth = pTileWidth;
            __iTileHeight = pTileHeight;
            __iWidth = (__iCols * __iTileWidth);
            __iHeight = (__iRows * __iTileHeight);
            __iTileWidthHalf = (__iTileWidth * 0.5);
            __iTileHeightHalf = (__iTileHeight * 0.5);
        }

        public function pivotCentered():void
        {
            pivotX = (-(__iWidth) * 0.5);
            pivotY = (-(__iHeight) * 0.5);
        }

        public function setTileAtIndex(pTileIndex:int, pTile:int):void
        {
            if ((((pTileIndex < 0)) || ((pTileIndex >= __aTiles.length))))
            {
                return;
            };
            __aTiles[pTileIndex] = pTile;
        }

        public function getTileAtColRow(pTileCol:int, pTileRow:int):FTile
        {
            if ((((((((pTileCol < 0)) || ((pTileCol >= __iCols)))) || ((pTileRow < 0)))) || ((pTileRow >= __iRows))))
            {
                return (null);
            };
            return (inline_getTileAtColRow(pTileCol, pTileRow));
        }

        public function getTileAtXAndY(pX:Number, pY:Number):FTile
        {
            var _local3:int = (pX / (__iTileWidth * node.transform.nWorldScaleX));
            var _local4:int = (pY / (__iTileHeight * node.transform.nWorldScaleY));
            return (inline_getTileAtColRow(_local3, _local4));
        }

        public function getTileAtIndex(pTileIndex:int):FTile
        {
            if ((((pTileIndex < 0)) || ((pTileIndex >= __aTiles.length))))
            {
                return (null);
            };
            inline_applyNewTileIndices();
            var _local2:int = __aTiles[pTileIndex];
            if ((((_local2 < 0)) || ((_local2 >= __aTileset.length))))
            {
                return (null);
            };
            return (__aTileset[_local2]);
        }

        public function setTileAtPosition(pX:Number, pY:Number, pNewTileID:int):int
        {
            var _local5:FTransform = node.transform;
            inline_getColRowAtPosition(pX, pY, _local5.nWorldX, _local5.nWorldY, _local5.nWorldScaleX, _local5.nWorldScaleY, _local5.nWorldRotation);
            var _local4:int = inline_setTileIndexAtColRow(_tempCol, _tempRow, pNewTileID);
            return (_local4);
        }

        public function getColRowAtPosition(pX:Number, pY:Number):Point
        {
            var _local3:FTransform = node.transform;
            inline_getColRowAtPosition(pX, pY, _local3.nWorldX, _local3.nWorldY, _local3.nWorldScaleX, _local3.nWorldScaleY, _local3.nWorldRotation);
            _tempPoint.setTo(_tempCol, _tempRow);
            return (_tempPoint);
        }

        [Inline]
        final private function inline_getColRowAtPosition(pX:Number, pY:Number, worldX:Number, worldY:Number, worldScaleX:Number, worldScaleY:Number, worldRotation:Number):void
        {
            var _local10:Number = (pX - worldX);
            var _local9:Number = (pY - worldY);
            var _local8:Number = (Math.atan2(_local9, _local10) - worldRotation);
            var _local11:Number = Math.sqrt(((_local10 * _local10) + (_local9 * _local9)));
            _local10 = (Math.cos(_local8) * _local11);
            _local9 = (Math.sin(_local8) * _local11);
            _tempCol = (((_local10 - (pivotX * worldScaleX)) / worldScaleX) / __iTileWidth);
            _tempRow = (((_local9 - (pivotY * worldScaleY)) / worldScaleY) / __iTileHeight);
        }

        [Inline]
        final private function inline_getTileAtColRow(pTileCol:int, pTileRow:int):FTile
        {
            var _local3:int = __aTiles[(pTileCol + (pTileRow * __iCols))];
            if ((((_local3 < 0)) || ((_local3 >= __aTileset.length))))
            {
                return (null);
            };
            return (__aTileset[_local3]);
        }

        [Inline]
        final private function inline_setTileIndexAtColRow(pTileCol:int, pTileRow:int, pNewTileID:int):int
        {
            if ((((((((pTileCol < 0)) || ((pTileCol >= __iCols)))) || ((pTileRow < 0)))) || ((pTileRow >= __iRows))))
            {
                return (-1);
            };
            var _local5:int = (pTileCol + (pTileRow * __iCols));
            var _local4:int = __aTiles[_local5];
            __aNewTileIndices[__aNewTileIndices.length] = _local5;
            __aNewTileIndices[__aNewTileIndices.length] = pNewTileID;
            return (_local4);
        }

        [Inline]
        final private function inline_applyNewTileIndices():void
        {
            var _local2:int;
            var _local1:int;
            while (__aNewTileIndices.length > 0)
            {
                _local2 = __aNewTileIndices[(__aNewTileIndices.length - 1)];
                _local1 = __aNewTileIndices[(__aNewTileIndices.length - 2)];
                __aTiles[_local1] = _local2;
                __aNewTileIndices.length = (__aNewTileIndices.length - 2);
            };
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            var _local17:Number;
            var _local6:Number;
            var _local4:Number;
            var _local11:Number;
            var _local30:Number;
            var _local29:Number;
            var _local14:int;
            var _local9:int;
            var _local26:int;
            var _local5:int;
            var _local27 = null;
            var _local8 = null;
            if (((!(__aTiles)) || ((__aTiles.length == 0))))
            {
                return;
            };
            tilesDrawn = 0;
            inline_applyNewTileIndices();
            var _local20 = 57.2957795130823;
            var _local12:FTransform = node.transform;
            var _local16:Number = (__iTileWidth * _local12.nWorldScaleX);
            var _local10:Number = (__iTileHeight * _local12.nWorldScaleY);
            var _local22:Number = p_camera.rViewRectangle.width;
            var _local7:Number = p_camera.rViewRectangle.height;
            var _local21:Number = _local12.nWorldScaleX;
            var _local18:Number = _local12.nWorldScaleY;
            var _local28:Number = _local12.nWorldRotation;
            var _local15:Number = _local12.nWorldRed;
            var _local24:Number = _local12.nWorldGreen;
            var _local13:Number = _local12.nWorldBlue;
            var _local25:Number = _local12.nWorldAlpha;
            var _local19:Number = _local12.nWorldX;
            var _local23:Number = _local12.nWorldY;
            _local26 = 0;
            _local5 = __iRows;
            _local5;
            while (_local26 < _local5)
            {
                _local29 = ((((_local26 * __iTileHeight) + pivotY) + __iTileHeightHalf) * _local18);
                _local14 = 0;
                _local9 = __iCols;
                _local9;
                while (_local14 < _local9)
                {
                    _local27 = inline_getTileAtColRow(_local14, _local26);
                    if (_local27)
                    {
                        _local8 = FTexture.getTextureById(_local27.textureId);
                        _local30 = ((((_local14 * __iTileWidth) + pivotX) + __iTileWidthHalf) * _local21);
                        _local17 = Math.sqrt(((_local30 * _local30) + (_local29 * _local29)));
                        _local6 = (Math.atan2(_local29, _local30) + _local28);
                        _local4 = (_local19 + (Math.cos(_local6) * _local17));
                        _local11 = (_local23 + (Math.sin(_local6) * _local17));
                        if (!((((((((_local4 + _local16) < debugMargin)) || ((((_local4 - _local16) + debugMargin) > _local22)))) || (((_local11 + _local10) < debugMargin)))) || ((((_local11 - _local10) + debugMargin) > _local7))))
                        {
                            tilesDrawn++;
                            p_context.draw(_local8, _local4, _local11, _local21, _local18, _local28, _local15, _local24, _local13, _local25, 1, p_maskRect);
                        };
                    };
                    _local14++;
                };
                _local26++;
            };
        }

        public function get mapCols():int
        {
            return (__iCols);
        }

        public function get mapRows():int
        {
            return (__iRows);
        }

        public function get mapWidth():int
        {
            return (__iWidth);
        }

        public function get mapHeight():int
        {
            return (__iHeight);
        }

        public function get tileWidth():int
        {
            return (__iTileWidth);
        }

        public function get tileHeight():int
        {
            return (__iTileHeight);
        }


    }
}//package com.flengine.components.renderables

