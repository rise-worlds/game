// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FTextureText

package com.flengine.components.renderables
{
    import com.flengine.textures.FTextureAtlas;
    import com.flengine.core.FNode;
    import com.flengine.error.FError;
    import com.flengine.core.FNodeFactory;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.events.MouseEvent;

    public class FTextureText extends FRenderable 
    {

        protected var _cTextureAtlas:FTextureAtlas;
        protected var _bInvalidate:Boolean = false;
        protected var _nTracking:Number = 0;
        protected var _nLineSpace:Number = 0;
        protected var _iAlign:int;
        public var maxWidth:Number = 0;
        protected var _sText:String = "";
        protected var _nWidth:Number = 0;
        protected var _nHeight:Number = 0;

        public function FTextureText(p_node:FNode)
        {
            _iAlign = FTextureTextAlignType.TOP_LEFT;
            super(p_node);
        }

        public function get tracking():Number
        {
            return (_nTracking);
        }

        public function set tracking(p_tracking:Number):void
        {
            _nTracking = p_tracking;
            _bInvalidate = true;
        }

        public function get lineSpace():Number
        {
            return (_nLineSpace);
        }

        public function set lineSpace(p_value:Number):void
        {
            _nLineSpace = p_value;
            _bInvalidate = true;
        }

        public function get align():int
        {
            return (_iAlign);
        }

        public function set align(p_align:int):void
        {
            _iAlign = p_align;
            _bInvalidate = true;
        }

        public function get textureAtlasId():String
        {
            if (_cTextureAtlas)
            {
                return (_cTextureAtlas.id);
            };
            return ("");
        }

        public function set textureAtlasId(p_value:String):void
        {
            setTextureAtlas(FTextureAtlas.getTextureAtlasById(p_value));
        }

        public function setTextureAtlas(p_textureAtlas:FTextureAtlas):void
        {
            _cTextureAtlas = p_textureAtlas;
            _bInvalidate = true;
        }

        public function get text():String
        {
            return (_sText);
        }

        public function set text(p_text:String):void
        {
            _sText = p_text;
            _bInvalidate = true;
        }

        public function get width():Number
        {
            if (_bInvalidate)
            {
                invalidateText();
            };
            return ((_nWidth * cNode.cTransform.nWorldScaleX));
        }

        public function get height():Number
        {
            if (_bInvalidate)
            {
                invalidateText();
            };
            return ((_nHeight * cNode.cTransform.nWorldScaleY));
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            if (!_bInvalidate)
            {
                return;
            };
            invalidateText();
        }

        protected function invalidateText():void
        {
            var _local6 = null;
            var _local3 = null;
            var _local7:int;
            var _local5 = null;
            if (_cTextureAtlas == null)
            {
                return;
            };
            _nWidth = 0;
            var _local4 = 0;
            var _local2 = 0;
            var _local1:FNode = cNode.firstChild;
            _local7 = 0;
            while (_local7 < _sText.length)
            {
                if (_sText.charCodeAt(_local7) == 10)
                {
                    _nWidth = (((_local4)>_nWidth) ? _local4 : _nWidth);
                    _local4 = 0;
                    _local2 = (_local2 + (_local3.height + _nLineSpace));
                }
                else
                {
                    _local3 = _cTextureAtlas.getTexture(_sText.charCodeAt(_local7));
                    if (_local3 == null)
                    {
                        throw (new FError((((("Texture for character " + _sText.charAt(_local7)) + " with code ") + _sText.charCodeAt(_local7)) + " not found!")));
                    };
                    if (_local1 == null)
                    {
                        _local6 = (FNodeFactory.createNodeWithComponent(FSprite) as FSprite);
                        _local1 = _local6.cNode;
                        cNode.addChild(_local1);
                    }
                    else
                    {
                        _local6 = (_local1.getComponent(FSprite) as FSprite);
                    };
                    _local6.node.cameraGroup = node.cameraGroup;
                    _local6.setTexture(_local3);
                    if ((((maxWidth > 0)) && (((_local4 + _local3.width) > maxWidth))))
                    {
                        _nWidth = (((_local4)>_nWidth) ? _local4 : _nWidth);
                        _local4 = 0;
                        _local2 = (_local2 + (_local3.height + _nLineSpace));
                    };
                    _local4 = (_local4 + (_local3.width / 2));
                    _local6.cNode.cTransform.x = _local4;
                    _local6.cNode.cTransform.y = (_local2 + (_local3.height / 2));
                    _local4 = (_local4 + ((_local3.width / 2) + _nTracking));
                    _local1 = _local1.next;
                };
                _local7++;
            };
            _nWidth = (((_local4)>_nWidth) ? _local4 : _nWidth);
            _nHeight = (_local2 + (((_local3)!=null) ? _local3.height : 0));
            while (_local1)
            {
                _local5 = _local1.next;
                cNode.removeChild(_local1);
                _local1 = _local5;
            };
            invalidateAlign();
            _bInvalidate = false;
        }

        private function invalidateAlign():void
        {
            var _local1 = null;
            switch (_iAlign)
            {
                case FTextureTextAlignType.MIDDLE_CENTER:
                    _local1 = cNode.firstChild;
                    while (_local1)
                    {
                        _local1.transform.x = (_local1.transform.x - (_nWidth / 2));
                        _local1.transform.y = (_local1.transform.y - (_nHeight / 2));
                        _local1 = _local1.next;
                    };
                    return;
                case FTextureTextAlignType.TOP_RIGHT:
                    _local1 = cNode.firstChild;
                    while (_local1)
                    {
                        _local1.transform.x = (_local1.transform.x - _nWidth);
                        _local1 = _local1.next;
                    };
                    return;
                case FTextureTextAlignType.TOP_LEFT:
                    return;
                case FTextureTextAlignType.MIDDLE_RIGHT:
                    _local1 = cNode.firstChild;
                    while (_local1)
                    {
                        _local1.transform.x = (_local1.transform.x - _nWidth);
                        _local1.transform.y = (_local1.transform.y - (_nHeight / 2));
                        _local1 = _local1.next;
                    };
                    return;
                case FTextureTextAlignType.MIDDLE_LEFT:
                    _local1 = cNode.firstChild;
                    while (_local1)
                    {
                        _local1.transform.y = (_local1.transform.y - (_nHeight / 2));
                        _local1 = _local1.next;
                    };
                    return;
            };
        }

        override public function processMouseEvent(p_captured:Boolean, p_event:MouseEvent, p_position:Vector3D):Boolean
        {
            if ((((_nWidth == 0)) || ((_nHeight == 0))))
            {
                return (false);
            };
            if (p_captured)
            {
                if (cNode.cMouseOver == cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOut", NaN, NaN, p_event.buttonDown, p_event.ctrlKey);
                };
                return (false);
            };
            var _local6:Matrix3D = cNode.cTransform.getTransformedWorldTransformMatrix(_nWidth, _nHeight, 0, true);
            var _local7:Vector3D = _local6.transformVector(p_position);
            _local6.prependScale((1 / _nWidth), (1 / _nHeight), 1);
            var _local5 = 0;
            var _local4 = 0;
            switch (_iAlign)
            {
                case FTextureTextAlignType.MIDDLE_CENTER:
                    _local5 = -0.5;
                    _local4 = -0.5;
            };
            if ((((((((_local7.x >= _local5)) && ((_local7.x <= (1 + _local5))))) && ((_local7.y >= _local4)))) && ((_local7.y <= (1 + _local4)))))
            {
                cNode.handleMouseEvent(cNode, p_event.type, (_local7.x * _nWidth), (_local7.y * _nHeight), p_event.buttonDown, p_event.ctrlKey);
                if (cNode.cMouseOver != cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOver", (_local7.x * _nWidth), (_local7.y * _nHeight), p_event.buttonDown, p_event.ctrlKey);
                };
                return (true);
            };
            if (cNode.cMouseOver == cNode)
            {
                cNode.handleMouseEvent(cNode, "mouseOut", (_local7.x * _nWidth), (_local7.y * _nHeight), p_event.buttonDown, p_event.ctrlKey);
            };
            return (false);
        }


    }
}//package com.flengine.components.renderables

