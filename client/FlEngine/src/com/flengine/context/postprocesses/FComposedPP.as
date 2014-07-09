// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FComposedPP

package com.flengine.context.postprocesses
{
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import com.flengine.core.FNode;
    import com.flengine.textures.FTexture;

    public class FComposedPP extends FPostProcess 
    {

        protected var _cEmptyPass:FFilterPP;
        protected var _aPostProcesses:Vector.<FPostProcess>;

        public function FComposedPP(p_postProcesses:Vector.<FPostProcess>)
        {
            super((p_postProcesses.length + 1));
            throw (new Error("Not supported yet."));
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle, p_node:FNode, p_bounds:Rectangle=null, p_source:FTexture=null, p_target:FTexture=null):void
        {
            var _local10:int;
            var _local8:Rectangle = ((_rDefinedBounds) ? _rDefinedBounds : p_node.getWorldBounds(_rActiveBounds));
            if (_local8.x == 1.79769313486232E308)
            {
                return;
            };
            updatePassTextures(_local8);
            _cEmptyPass.render(p_context, p_camera, p_maskRect, p_node, _local8, null, _aPassTextures[0]);
            var _local9:int = _aPostProcesses.length;
            _local10 = 0;
            while (_local10 < (_local9 - 1))
            {
                _aPostProcesses[_local10].render(p_context, p_camera, p_maskRect, p_node, _local8, _aPassTextures[_local10], _aPassTextures[(_local10 + 1)]);
                _local10++;
            };
            _aPostProcesses[(_local9 - 1)].render(p_context, p_camera, p_maskRect, p_node, _local8, _aPassTextures[(_local9 - 1)], null);
        }


    }
}//package com.flengine.context.postprocesses

