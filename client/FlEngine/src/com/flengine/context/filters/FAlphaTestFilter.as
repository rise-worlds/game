// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FAlphaTestFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;

    public class FAlphaTestFilter extends FFilter 
    {

        protected var _nTreshold:Number = 0.5;

        public function FAlphaTestFilter(p_treshold:Number)
        {
            iId = 1;
            fragmentCode = "sub ft1.w, ft0.w, fc1.x   \nkil ft1.w                 \n";
            _aFragmentConstants = new <Number>[0.5, 0, 0, 1];
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
        }


    }
}//package com.flengine.context.filters

