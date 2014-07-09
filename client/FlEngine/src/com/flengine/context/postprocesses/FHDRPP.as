// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FHDRPP

package com.flengine.context.postprocesses
{
    import __AS3__.vec.Vector;
    import com.flengine.context.filters.FHDRPassFilter;
    import com.flengine.context.filters.FFilter;
    import flash.geom.Rectangle;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import com.flengine.core.FNode;
    import com.flengine.textures.FTexture;

    public class FHDRPP extends FPostProcess 
    {

        protected var _cEmpty:FFilterPP;
        protected var _cBlur:FBlurPP;
        protected var _cHDRPassFilter:FHDRPassFilter;

        public function FHDRPP(p_blurX:int=3, p_blurY:int=3, p_blurPasses:int=2, p_saturation:Number=1.3)
        {
            super(2);
            _iLeftMargin = (_iRightMargin = ((p_blurX * 2) * p_blurPasses));
            _iTopMargin = (_iBottomMargin = ((p_blurY * 2) * p_blurPasses));
            _cEmpty = new FFilterPP(new <FFilter>[null]);
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
            _cBlur = new FBlurPP(p_blurX, p_blurY, p_blurPasses);
            _cHDRPassFilter = new FHDRPassFilter(p_saturation);
        }

        public function get blurX():int
        {
            return (_cBlur.blurX);
        }

        public function set blurX(p_value:int):void
        {
            _cBlur.blurX = p_value;
            _iLeftMargin = (_iRightMargin = ((p_value * 2) * _cBlur.passes));
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
        }

        public function get blurY():int
        {
            return (_cBlur.blurY);
        }

        public function set blurY(p_value:int):void
        {
            _cBlur.blurY = p_value;
            _iTopMargin = (_iBottomMargin = ((p_value * 2) * _cBlur.passes));
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
        }

        public function get saturation():Number
        {
            return (_cHDRPassFilter.saturation);
        }

        public function set saturation(p_value:Number):void
        {
            _cHDRPassFilter.saturation = p_value;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle, p_node:FNode, p_bounds:Rectangle=null, p_source:FTexture=null, p_target:FTexture=null):void
        {
            var _local8:Rectangle = ((_rDefinedBounds) ? _rDefinedBounds : p_node.getWorldBounds(_rActiveBounds));
            if (_local8.x == 1.79769313486232E308)
            {
                return;
            };
            updatePassTextures(_local8);
            _cEmpty.render(p_context, p_camera, p_maskRect, p_node, _local8, null, _aPassTextures[0]);
            _cBlur.render(p_context, p_camera, p_maskRect, p_node, _local8, _aPassTextures[0], _aPassTextures[1]);
            _cHDRPassFilter.texture = _cEmpty.getPassTexture(0);
            p_context.setRenderTarget(null);
            p_context.setCamera(p_camera);
            p_context.draw(_aPassTextures[1], (_local8.x - _iLeftMargin), (_local8.y - _iTopMargin), 1, 1, 0, 1, 1, 1, 1, 1, p_maskRect, _cHDRPassFilter);
        }

        override public function dispose():void
        {
            _cBlur.dispose();
            super.dispose();
        }


    }
}//package com.flengine.context.postprocesses

