// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FMovieClip

package com.flengine.components.renderables
{
    import com.flengine.textures.FTextureAtlas;
    import com.flengine.core.FNode;

    public class FMovieClip extends FTexturedQuad 
    {

        private static var __iCount:int = 0;

        protected var _nSpeed:Number = 33.3333333333333;
        protected var _nAccumulatedTime:Number = 0;
        protected var _iCurrentFrame:int = -1;
        protected var _iStartIndex:int = -1;
        protected var _iEndIndex:int = -1;
        protected var _bPlaying:Boolean = true;
        protected var _cTextureAtlas:FTextureAtlas;
        protected var _aFrameIds:Array;
        protected var _iFrameIdsLength:int = 0;
        public var repeatable:Boolean = true;

        public function FMovieClip(p_node:FNode)
        {
            super(p_node);
        }

        public function get currentFrame():int
        {
            return (_iCurrentFrame);
        }

        public function get textureAtlasId():String
        {
            return (((_cTextureAtlas) ? _cTextureAtlas.id : ""));
        }

        public function set textureAtlasId(p_value:String):void
        {
            _cTextureAtlas = (((p_value)!="") ? FTextureAtlas.getTextureAtlasById(p_value) : null);
            if (_aFrameIds)
            {
                cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
            };
        }

        public function get frames():Array
        {
            return (_aFrameIds);
        }

        public function set frames(p_value:Array):void
        {
            _aFrameIds = p_value;
            _iFrameIdsLength = _aFrameIds.length;
            _iCurrentFrame = 0;
            if (_cTextureAtlas)
            {
                cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
            };
        }

        public function setTextureAtlas(p_textureAtlas:FTextureAtlas):void
        {
            _cTextureAtlas = p_textureAtlas;
            if (_aFrameIds)
            {
                cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
            };
        }

        public function get frameRate():int
        {
            return ((1000 / _nSpeed));
        }

        public function set frameRate(p_frameRate:int):void
        {
            _nSpeed = (1000 / p_frameRate);
        }

        public function get numFrames():int
        {
            return (_iFrameIdsLength);
        }

        public function gotoFrame(p_frame:int):void
        {
            if (_aFrameIds == null)
            {
                return;
            };
            _iCurrentFrame = p_frame;
            _iCurrentFrame = (_iCurrentFrame % _aFrameIds.length);
            cTexture = _cTextureAtlas.getTexture(_aFrameIds[_iCurrentFrame]);
        }

        public function gotoAndPlay(p_frame:int):void
        {
            gotoFrame(p_frame);
            play();
        }

        public function gotoAndStop(p_frame:int):void
        {
            gotoFrame(p_frame);
            stop();
        }

        public function stop():void
        {
            _bPlaying = false;
        }

        public function play():void
        {
            _bPlaying = true;
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            if (cTexture == null)
            {
                return;
            };
            if (_bPlaying)
            {
                _nAccumulatedTime = (_nAccumulatedTime + p_deltaTime);
                if (_nAccumulatedTime >= _nSpeed)
                {
                    _iCurrentFrame = (_iCurrentFrame + (_nAccumulatedTime / _nSpeed));
                    if ((((_iCurrentFrame < _iFrameIdsLength)) || (repeatable)))
                    {
                        _iCurrentFrame = (_iCurrentFrame % _aFrameIds.length);
                    }
                    else
                    {
                        _iCurrentFrame = (_iFrameIdsLength - 1);
                    };
                    cTexture = _cTextureAtlas.getTexture(_aFrameIds[_iCurrentFrame]);
                };
                _nAccumulatedTime = (_nAccumulatedTime % _nSpeed);
            };
        }


    }
}//package com.flengine.components.renderables

