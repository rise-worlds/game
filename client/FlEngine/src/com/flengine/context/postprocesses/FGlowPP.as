// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FGlowPP

package com.flengine.context.postprocesses
{
    import __AS3__.vec.Vector;
    import com.flengine.context.filters.FFilter;
    import flash.geom.Rectangle;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import com.flengine.core.FNode;
    import com.flengine.textures.FTexture;

    public class FGlowPP extends FPostProcess 
    {

        protected var _cEmpty:FFilterPP;
        protected var _cBlur:FBlurPP;
        protected var _iOffsetX:int;
        protected var _iOffsetY:int;

        public function FGlowPP(p_blurX:int=2, p_blurY:int=2, p_blurPasses:int=1)
        {
            super(2);
            _cEmpty = new FFilterPP(new <FFilter>[null]);
            _cBlur = new FBlurPP(p_blurX, p_blurY, p_blurPasses);
            _cBlur.colorize = true;
            _iLeftMargin = (_iRightMargin = ((_cBlur.blurX * _cBlur.passes) * 0.5));
            _iTopMargin = (_iBottomMargin = ((_cBlur.blurY * _cBlur.passes) * 0.5));
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
        }

        public function get color():int
        {
            var _local1:uint = ((_cBlur.red * 0xFF) << 16);
            var _local3:uint = ((_cBlur.green * 0xFF) << 8);
            var _local2:uint = (_cBlur.blue * 0xFF);
            return (((_local1 + _local3) + _local2));
        }

        public function set color(p_value:int):void
        {
            _cBlur.red = (((p_value >> 16) & 0xFF) / 0xFF);
            _cBlur.green = (((p_value >> 8) & 0xFF) / 0xFF);
            _cBlur.blue = ((p_value & 0xFF) / 0xFF);
        }

        public function get alpha():Number
        {
            return (_cBlur.alpha);
        }

        public function set alpha(p_value:Number):void
        {
            _cBlur.alpha = p_value;
        }

        public function get blurX():Number
        {
            return (_cBlur.blurX);
        }

        public function set blurX(p_value:Number):void
        {
            _cBlur.blurX = p_value;
            _iLeftMargin = (_iRightMargin = ((_cBlur.blurX * _cBlur.passes) * 0.5));
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
        }

        public function get blurY():int
        {
            return (_cBlur.blurY);
        }

        public function set blurY(p_value:int):void
        {
            _cBlur.blurY = p_value;
            _iTopMargin = (_iBottomMargin = ((_cBlur.blurY * _cBlur.passes) * 0.5));
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
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
            p_context.setRenderTarget(null);
            p_context.setCamera(p_camera);
            p_context.draw(_aPassTextures[1], ((_local8.x - _iLeftMargin) + _iOffsetX), ((_local8.y - _iTopMargin) + _iOffsetY), 1, 1, 0, 1, 1, 1, 1, 1, p_maskRect);
            p_context.draw(_aPassTextures[0], (_local8.x - _iLeftMargin), (_local8.y - _iTopMargin), 1, 1, 0, 1, 1, 1, 1, 1, p_maskRect);
        }

        override public function dispose():void
        {
            _cEmpty.dispose();
            _cBlur.dispose();
            super.dispose();
        }


    }
}//package com.flengine.context.postprocesses

