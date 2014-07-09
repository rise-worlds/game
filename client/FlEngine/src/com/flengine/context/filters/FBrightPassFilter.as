// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FBrightPassFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;

    public class FBrightPassFilter extends FFilter 
    {

        protected var _nTreshold:Number = 0.5;

        public function FBrightPassFilter(p_treshold:Number)
        {
            iId = 4;
            fragmentCode = "sub ft0.xyz, ft0.xyz, fc1.xxx    \nmul ft0.xyz, ft0.xyz, fc1.yyy    \nsat ft0, ft0           \t\t\t \n";
            _aFragmentConstants = new <Number>[0.5, 2, 0, 0];
            treshold = p_treshold;
        }

        public function get treshold():Number
        {
            return (_nTreshold);
        }

        public function set treshold(p_value:Number):void
        {
            _nTreshold = p_value;
            _aFragmentConstants[0] = _nTreshold;
            _aFragmentConstants[1] = (1 / (1 - _nTreshold));
        }


    }
}//package com.flengine.context.filters

