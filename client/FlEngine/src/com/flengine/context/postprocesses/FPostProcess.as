// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FPostProcess

package com.flengine.context.postprocesses
{
    import __AS3__.vec.Vector;
    import com.flengine.context.filters.FFilter;
    import com.flengine.textures.FTexture;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import com.flengine.error.FError;
    import com.flengine.core.FlEngine;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import com.flengine.core.FNode;
    import com.flengine.textures.factories.FTextureFactory;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FPostProcess 
    {

        private static var __iCount:int = 0;

        protected var _iPasses:int = 1;
        protected var _aPassFilters:Vector.<FFilter>;
        protected var _aPassTextures:Vector.<FTexture>;
        protected var _cMatrix:Matrix3D;
        protected var _rDefinedBounds:Rectangle;
        protected var _rActiveBounds:Rectangle;
        protected var _iLeftMargin:int = 0;
        protected var _iRightMargin:int = 0;
        protected var _iTopMargin:int = 0;
        protected var _iBottomMargin:int = 0;
        protected var _sId:String;

        public function FPostProcess(p_passes:int=1)
        {
            _cMatrix = new Matrix3D();
            super();
            _sId = (__iCount++).toString();
            if (p_passes < 1)
            {
                throw (new FError("FError: Post process needs atleast one pass."));
            };
            _iPasses = p_passes;
            _aPassFilters = new Vector.<FFilter>(_iPasses);
            _aPassTextures = new Vector.<FTexture>(_iPasses);
            createPassTextures();
        }

        public function get passes():int
        {
            return (_iPasses);
        }

        public function setBounds(p_bounds:Rectangle):void
        {
            _rDefinedBounds = p_bounds;
        }

        public function setMargins(p_leftMargin:int=0, p_rightMargin:int=0, p_topMargin:int=0, p_bottomMargin:int=0):void
        {
            _iLeftMargin = p_leftMargin;
            _iRightMargin = p_rightMargin;
            _iTopMargin = p_topMargin;
            _iBottomMargin = p_bottomMargin;
        }

        public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle, p_node:FNode, p_bounds:Rectangle=null, p_source:FTexture=null, p_target:FTexture=null):void
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
            _local10 = 1;
            while (_local10 < _iPasses)
            {
                p_context.setRenderTarget(_aPassTextures[_local10]);
                p_context.draw(_aPassTextures[(_local10 - 1)], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, _aPassTextures[_local10].region, _aPassFilters[(_local10 - 1)]);
                _local10++;
            };
            p_context.setRenderTarget(p_target);
            if (p_target == null)
            {
                p_context.setCamera(p_camera);
                p_context.draw(_aPassTextures[(_iPasses - 1)], (_local8.x - _iLeftMargin), (_local8.y - _iTopMargin), 1, 1, 0, 1, 1, 1, 1, 1, p_maskRect, _aPassFilters[(_iPasses - 1)]);
            }
            else
            {
                p_context.draw(_aPassTextures[(_iPasses - 1)], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, p_target.region, _aPassFilters[(_iPasses - 1)]);
            };
            _aPassTextures[0] = _local9;
        }

        public function getPassTexture(p_pass:int):FTexture
        {
            return (_aPassTextures[p_pass]);
        }

        public function getPassFilter(p_pass:int):FFilter
        {
            return (_aPassFilters[p_pass]);
        }

        protected function updatePassTextures(p_bounds:Rectangle):void
        {
            var _local5:int;
            var _local3 = null;
            var _local2:Number = ((p_bounds.width + _iLeftMargin) + _iRightMargin);
            var _local4:Number = ((p_bounds.height + _iTopMargin) + _iBottomMargin);
            if (((!((_aPassTextures[0].width == _local2))) || (!((_aPassTextures[0].height == _local4)))))
            {
                _local5 = (_aPassTextures.length - 1);
                while (_local5 >= 0)
                {
                    _local3 = _aPassTextures[_local5];
                    _local3.region = new Rectangle(0, 0, _local2, _local4);
                    _local3.pivotX = (-(_local3.iWidth) / 2);
                    _local3.pivotY = (-(_local3.iHeight) / 2);
                    _local5--;
                };
            };
        }

        protected function createPassTextures():void
        {
            var _local2:int;
            var _local1 = null;
            _local2 = 0;
            while (_local2 < _iPasses)
            {
                _local1 = FTextureFactory.createRenderTexture(((("g2d_pp_" + _sId) + "_") + _local2), 2, 2, true);
                _local1.filteringType = 0;
                _local1.pivotX = (-(_local1.iWidth) / 2);
                _local1.pivotY = (-(_local1.iHeight) / 2);
                _aPassTextures[_local2] = _local1;
                _local2++;
            };
        }

        public function dispose():void
        {
            var _local1:int;
            _local1 = (_aPassTextures.length - 1);
            while (_local1 >= 0)
            {
                _aPassTextures[_local1].dispose();
                _local1--;
            };
        }


    }
}//package com.flengine.context.postprocesses

