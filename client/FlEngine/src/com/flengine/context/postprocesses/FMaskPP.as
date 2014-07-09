// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FMaskPP

package com.flengine.context.postprocesses
{
    import com.flengine.core.FNode;
    import com.flengine.context.filters.FMaskPassFilter;
    import com.flengine.core.FlEngine;
    import com.flengine.textures.FTexture;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FMaskPP extends FPostProcess 
    {

        protected var _cMask:FNode;
        protected var _cMaskFilter:FMaskPassFilter;

        public function FMaskPP()
        {
            super(2);
            _cMaskFilter = new FMaskPassFilter(_aPassTextures[1]);
        }

        public function get mask():FNode
        {
            return (_cMask);
        }

        public function set mask(p_value:FNode):void
        {
            if (_cMask != null)
            {
                _cMask.iUsedAsPPMask--;
            };
            _cMask = p_value;
            _cMask.iUsedAsPPMask++;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle, p_node:FNode, p_bounds:Rectangle=null, p_source:FTexture=null, p_target:FTexture=null):void
        {
            var _local10:int;
            var _local8 = p_bounds;
            if (_local8 == null)
            {
                _local8 = ((_rDefinedBounds) ? _rDefinedBounds : p_node.getWorldBounds(_rActiveBounds));
            };
            if (_local8.x == 1.79769313486232E308)
            {
                return;
            };
            updatePassTextures(_local8);
            if (p_source == null)
            {
                _cMatrix.identity();
                _cMatrix.prependTranslation((-(_local8.x) + _iLeftMargin), (-(_local8.y) + _iTopMargin), 0);
                p_context.setRenderTarget(_aPassTextures[0], _cMatrix);
                p_context.setCamera(FlEngine.getInstance().defaultCamera);
                p_node.render(p_context, p_camera, _aPassTextures[0].region, false);
            };
            var _local9:FTexture = _aPassTextures[0];
            if (p_source)
            {
                _aPassTextures[0] = p_source;
            };
            var _local11:FMaskPassFilter;
            if (_cMask != null)
            {
                p_context.setRenderTarget(_aPassTextures[1]);
                _local10 = _cMask.iUsedAsPPMask;
                _cMask.iUsedAsPPMask = 0;
                _cMask.render(p_context, p_camera, _aPassTextures[1].region, false);
                _cMask.iUsedAsPPMask = _local10;
                _local11 = _cMaskFilter;
            };
            if (p_target == null)
            {
                p_context.setRenderTarget(null);
                p_context.setCamera(p_camera);
                p_context.draw(_aPassTextures[0], (_local8.x - _iLeftMargin), (_local8.y - _iTopMargin), 1, 1, 0, 1, 1, 1, 1, 1, p_maskRect, _local11);
            }
            else
            {
                p_context.setRenderTarget(p_target);
                p_context.draw(_aPassTextures[0], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, p_target.region, _local11);
            };
            _aPassTextures[0] = _local9;
        }


    }
}//package com.flengine.context.postprocesses

