// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FBloomPP

package com.flengine.context.postprocesses
{
    import __AS3__.vec.Vector;
    import com.flengine.context.filters.FBloomPassFilter;
    import com.flengine.context.filters.FFilter;
    import com.flengine.context.filters.FBrightPassFilter;
    import flash.geom.Rectangle;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import com.flengine.core.FNode;
    import com.flengine.textures.FTexture;

    public class FBloomPP extends FPostProcess 
    {

        protected var _cBlur:FBlurPP;
        protected var _cBright:FFilterPP;
        protected var _cBloomFilter:FBloomPassFilter;

        public function FBloomPP(p_blurX:int=2, p_blurY:int=2, p_blurPasses:int=1, p_brightTreshold:Number=0.75)
        {
            super(2);
            _cBlur = new FBlurPP(p_blurX, p_blurY, p_blurPasses);
            _cBright = new FFilterPP(new <FFilter>[new FBrightPassFilter(p_brightTreshold)]);
            _cBloomFilter = new FBloomPassFilter();
            _iLeftMargin = (_iRightMargin = ((_cBlur.blurX * _cBlur.passes) * 0.5));
            _iTopMargin = (_iBottomMargin = ((_cBlur.blurY * _cBlur.passes) * 0.5));
            _cBright.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
        }

        public function get blurX():int
        {
            return (_cBlur.blurX);
        }

        public function set blurX(p_value:int):void
        {
            _cBlur.blurX = p_value;
            _iLeftMargin = (_iRightMargin = ((_cBlur.blurX * _cBlur.passes) * 0.5));
            _cBright.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
        }

        public function get blurY():int
        {
            return (_cBlur.blurY);
        }

        public function set blurY(p_value:int):void
        {
            _cBlur.blurY = p_value;
            _iTopMargin = (_iBottomMargin = ((_cBlur.blurY * _cBlur.passes) * 0.5));
            _cBright.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
        }

        public function get brightTreshold():Number
        {
            return ((_cBright.getPassFilter(0) as FBrightPassFilter).treshold);
        }

        public function set brightTreshold(p_value:Number):void
        {
            (_cBright.getPassFilter(0) as FBrightPassFilter).treshold = p_value;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle, p_node:FNode, p_bounds:Rectangle=null, p_source:FTexture=null, p_target:FTexture=null):void
        {
            var _local8:Rectangle = ((_rDefinedBounds) ? _rDefinedBounds : p_node.getWorldBounds(_rActiveBounds));
            if (_local8.x == 1.79769313486232E308)
            {
                return;
            };
            updatePassTextures(_local8);
            _cBright.render(p_context, p_camera, p_maskRect, p_node, _local8, null, _aPassTextures[0]);
            _cBlur.render(p_context, p_camera, p_maskRect, p_node, _local8, _aPassTextures[0], _aPassTextures[1]);
            _cBloomFilter.texture = _cBright.getPassTexture(0);
            p_context.setRenderTarget(null);
            p_context.setCamera(p_camera);
            p_context.draw(_aPassTextures[1], (_local8.x - _iLeftMargin), (_local8.y - _iTopMargin), 1, 1, 0, 1, 1, 1, 1, 1, p_maskRect, _cBloomFilter);
        }

        override public function dispose():void
        {
            _cBlur.dispose();
            _cBright.dispose();
            super.dispose();
        }


    }
}//package com.flengine.context.postprocesses

