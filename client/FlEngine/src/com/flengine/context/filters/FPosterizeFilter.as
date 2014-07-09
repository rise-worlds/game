// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FPosterizeFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;

    public class FPosterizeFilter extends FFilter 
    {

        protected var _iRed:int = 0;
        protected var _iGreen:int = 0;
        protected var _iBlue:int = 0;

        public function FPosterizeFilter(p_red:int, p_green:int, p_blue:int)
        {
            iId = 11;
            fragmentCode = "mul ft0.xyz, ft0.xyz, fc1.xyz \nfrc ft1.xyz, ft0.xyz \t\t   \nsub ft0.xyz, ft0.xyz, ft1.xyz \ndiv ft0.xyz, ft0.xyz, fc1.xyz \n";
            _aFragmentConstants = new <Number>[0, 0, 0, 0];
            red = p_red;
            green = p_green;
            blue = p_blue;
        }

        public function get red():int
        {
            return (_iRed);
        }

        public function set red(p_value:int):void
        {
            _iRed = p_value;
            _aFragmentConstants[0] = _iRed;
        }

        public function get green():int
        {
            return (_iGreen);
        }

        public function set green(p_value:int):void
        {
            _iGreen = p_value;
            _aFragmentConstants[1] = _iGreen;
        }

        public function get blue():int
        {
            return (_iBlue);
        }

        public function set blue(p_value:int):void
        {
            _iBlue = p_value;
            _aFragmentConstants[2] = _iBlue;
        }


    }
}//package com.flengine.context.filters

