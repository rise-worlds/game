// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FBlurPP

package com.flengine.context.postprocesses
{
    import com.flengine.context.filters.FBlurPassFilter;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;
    import com.flengine.core.FNode;
    import com.flengine.textures.FTexture;

    public class FBlurPP extends FPostProcess 
    {

        protected var _bInvalidate:Boolean = false;
        protected var _bColorize:Boolean = false;
        protected var _nRed:Number = 0;
        protected var _nGreen:Number = 0;
        protected var _nBlue:Number = 0;
        protected var _nAlpha:Number = 1;
        protected var _nBlurX:Number = 0;
        protected var _nBlurY:Number = 0;

        public function FBlurPP(p_blurX:int, p_blurY:int, p_passes:int=1)
        {
            var _local5:int;
            var _local4 = null;
            super((p_passes * 2));
            _nBlurX = ((2 * p_blurX) / _iPasses);
            _nBlurY = ((2 * p_blurY) / _iPasses);
            _iLeftMargin = (_iRightMargin = ((_nBlurX * _iPasses) * 0.5));
            _iTopMargin = (_iBottomMargin = ((_nBlurY * _iPasses) * 0.5));
            _local5 = 0;
            while (_local5 < _iPasses)
            {
                _local4 = new FBlurPassFilter((((_local5)<(_iPasses / 2)) ? _nBlurY : _nBlurX), (((_local5)<(_iPasses / 2)) ? 0 : 1));
                _aPassFilters[_local5] = _local4;
                _local5++;
            };
        }

        public function get colorize():Boolean
        {
            return (_bColorize);
        }

        public function set colorize(p_value:Boolean):void
        {
            _bColorize = p_value;
            _bInvalidate = true;
        }

        public function get red():Number
        {
            return (_nRed);
        }

        public function set red(p_value:Number):void
        {
            _nRed = p_value;
            _bInvalidate = true;
        }

        public function get green():Number
        {
            return (_nGreen);
        }

        public function set green(p_value:Number):void
        {
            _nGreen = p_value;
            _bInvalidate = true;
        }

        public function get blue():Number
        {
            return (_nBlue);
        }

        public function set blue(p_value:Number):void
        {
            _nBlue = p_value;
            _bInvalidate = true;
        }

        public function get alpha():Number
        {
            return (_nAlpha);
        }

        public function set alpha(p_value:Number):void
        {
            _nAlpha = p_value;
            _bInvalidate = true;
        }

        override public function get passes():int
        {
            return ((_iPasses / 2));
        }

        public function get blurX():int
        {
            return (((_iPasses * _nBlurX) / 2));
        }

        public function set blurX(p_value:int):void
        {
            _nBlurX = ((2 * p_value) / _iPasses);
            _bInvalidate = true;
        }

        public function get blurY():int
        {
            return (((_iPasses * _nBlurY) / 2));
        }

        public function set blurY(p_value:int):void
        {
            _nBlurY = ((2 * p_value) / _iPasses);
            _bInvalidate = true;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle, p_node:FNode, p_bounds:Rectangle=null, p_source:FTexture=null, p_target:FTexture=null):void
        {
            if (_bInvalidate)
            {
                invalidateBlurFilters();
            };
            super.render(p_context, p_camera, p_maskRect, p_node, p_bounds, p_source, p_target);
        }

        private function invalidateBlurFilters():void
        {
            var _local2:int;
            var _local1 = null;
            _local2 = (_aPassFilters.length - 1);
            while (_local2 >= 0)
            {
                _local1 = (_aPassFilters[_local2] as FBlurPassFilter);
                _local1.blur = (((_local2)<(_iPasses / 2)) ? _nBlurY : _nBlurX);
                _local1.colorize = _bColorize;
                _local1.red = _nRed;
                _local1.green = _nGreen;
                _local1.blue = _nBlue;
                _local1.alpha = _nAlpha;
                _local2--;
            };
            _iLeftMargin = (_iRightMargin = ((_nBlurX * _iPasses) * 0.5));
            _iTopMargin = (_iBottomMargin = ((_nBlurY * _iPasses) * 0.5));
            _bInvalidate = false;
        }


    }
}//package com.flengine.context.postprocesses

