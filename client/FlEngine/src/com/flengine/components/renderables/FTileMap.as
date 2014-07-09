// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FTileMap

package com.flengine.components.renderables
{
    import __AS3__.vec.Vector;
    import com.flengine.core.FNode;
    import com.flengine.textures.FTexture;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FTileMap extends FRenderable 
    {

        protected var _iWidth:int;
        protected var _iHeight:int;
        protected var _aTiles:Vector.<FTile>;
        protected var _iTileWidth:int = 0;
        protected var _iTileHeight:int = 0;
        protected var _bIso:Boolean = false;

        public function FTileMap(p_node:FNode)
        {
            super(p_node);
        }

        public function setTiles(p_tiles:Vector.<FTile>, p_mapWidth:int, p_mapHeight:int, p_tileWidth:int, p_tileHeight:int, p_iso:Boolean=false):void
        {
            if ((p_mapWidth * p_mapHeight) != p_tiles.length)
            {
                throw (new Error("Invalid tile map."));
            };
            _aTiles = p_tiles;
            _iWidth = p_mapWidth;
            _iHeight = p_mapHeight;
            _bIso = p_iso;
            setTileSize(p_tileWidth, p_tileHeight);
        }

        public function setTile(p_tileIndex:int, p_tile:int):void
        {
            if ((((p_tileIndex < 0)) || ((p_tileIndex >= _aTiles.length))))
            {
                return;
            };
            _aTiles[p_tileIndex] = p_tile;
        }

        public function setTileSize(p_width:int, p_height:int):void
        {
            _iTileWidth = p_width;
            _iTileHeight = p_height;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            var _local14:int;
            var _local13:int;
            var _local22:Number;
            var _local21:Number;
            var _local5:int;
            var _local18 = null;
            if (_aTiles == null)
            {
                return;
            };
            var _local6:Number = ((_iTileWidth * _iWidth) * 0.5);
            var _local11:Number = ((_iTileHeight * _iHeight) * ((_bIso) ? 0.25 : 0.5));
            var _local16:Number = ((p_camera.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX) - (p_camera.rViewRectangle.width * 0.5));
            var _local17:Number = ((p_camera.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY) - (p_camera.rViewRectangle.height * 0.5));
            var _local9:Number = (-(_local6) + ((_bIso) ? (_iTileWidth / 2) : 0));
            var _local7:Number = (-(_local11) + ((_bIso) ? (_iTileHeight / 2) : 0));
            var _local19:int = ((_local16 - _local9) / _iTileWidth);
            if (_local19 < 0)
            {
                _local19 = 0;
            };
            var _local20:int = ((_local17 - _local7) / ((_bIso) ? (_iTileHeight / 2) : _iTileHeight));
            if (_local20 < 0)
            {
                _local20 = 0;
            };
            var _local8:Number = (((p_camera.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX) + (p_camera.rViewRectangle.width * 0.5)) - ((_bIso) ? (_iTileWidth / 2) : _iTileWidth));
            var _local10:Number = (((p_camera.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY) + (p_camera.rViewRectangle.height * 0.5)) - ((_bIso) ? 0 : _iTileHeight));
            var _local15:int = ((((_local8 - _local9) / _iTileWidth) - _local19) + 2);
            if (_local15 > (_iWidth - _local19))
            {
                _local15 = (_iWidth - _local19);
            };
            var _local4:int = ((((_local10 - _local7) / ((_bIso) ? (_iTileHeight / 2) : _iTileHeight)) - _local20) + 2);
            if (_local4 > (_iHeight - _local20))
            {
                _local4 = (_iHeight - _local20);
            };
            var _local12:int = (_local15 * _local4);
            _local14 = 0;
            while (_local14 < _local12)
            {
                _local13 = (_local14 / _local15);
                _local22 = (((cNode.cTransform.nWorldX + ((_local19 + (_local14 % _local15)) * _iTileWidth)) - _local6) + ((((_bIso) && ((((_local20 + _local13) % 2) == 1)))) ? _iTileWidth : (_iTileWidth / 2)));
                _local21 = (((cNode.cTransform.nWorldY + ((_local20 + _local13) * ((_bIso) ? (_iTileHeight / 2) : _iTileHeight))) - _local11) + (_iTileHeight / 2));
                _local5 = ((((_local20 * _iWidth) + _local19) + ((_local14 / _local15) * _iWidth)) + (_local14 % _local15));
                _local18 = _aTiles[_local5];
                if (((!((_local18 == null))) && (!((_local18.textureId == null)))))
                {
                    p_context.draw(FTexture.getTextureById(_local18.textureId), _local22, _local21, 1, 1, 0, 1, 1, 1, 1, 1, p_maskRect);
                };
                _local14++;
            };
        }

        public function getTileAt(p_x:Number, p_y:Number, p_camera:FCamera=null):FTile
        {
            if (p_camera == null)
            {
                p_camera = node.core.defaultCamera;
            };
            p_x = (p_x - (p_camera.rViewRectangle.x + (p_camera.rViewRectangle.width / 2)));
            p_y = (p_y - (p_camera.rViewRectangle.y + (p_camera.rViewRectangle.height / 2)));
            var _local7:Number = ((_iTileWidth * _iWidth) * 0.5);
            var _local10:Number = ((_iTileHeight * _iHeight) * ((_bIso) ? 0.25 : 0.5));
            var _local8:Number = (-(_local7) + ((_bIso) ? (_iTileWidth / 2) : 0));
            var _local6:Number = (-(_local10) + ((_bIso) ? (_iTileHeight / 2) : 0));
            var _local5:Number = ((p_camera.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX) + p_x);
            var _local4:Number = ((p_camera.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY) + p_y);
            var _local9:int = Math.floor(((_local5 - _local8) / _iTileWidth));
            var _local11:int = Math.floor(((_local4 - _local6) / _iTileHeight));
            if ((((((((_local9 < 0)) || ((_local9 >= _iWidth)))) || ((_local11 < 0)))) || ((_local11 >= _iHeight))))
            {
                return (null);
            };
            return (_aTiles[((_local11 * _iWidth) + _local9)]);
        }


    }
}//package com.flengine.components.renderables

