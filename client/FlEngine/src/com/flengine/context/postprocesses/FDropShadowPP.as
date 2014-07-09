// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FDropShadowPP

package com.flengine.context.postprocesses
{
    public class FDropShadowPP extends FGlowPP 
    {

        public function FDropShadowPP(p_blurX:int=2, p_blurY:int=2, p_offsetX:int=0, p_offsetY:Number=0, p_blurPasses:int=1)
        {
            _iOffsetX = p_offsetX;
            _iOffsetY = p_offsetY;
            super(p_blurX, p_blurY, p_blurPasses);
        }

        public function get offsetX():int
        {
            return (_iOffsetX);
        }

        public function set offsetX(p_value:int):void
        {
            _iOffsetX = p_value;
        }

        public function get offsetY():int
        {
            return (_iOffsetY);
        }

        public function set offsetY(p_value:int):void
        {
            _iOffsetY = p_value;
        }


    }
}//package com.flengine.context.postprocesses

