// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FDesaturateFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;

    public class FDesaturateFilter extends FFilter 
    {

        public function FDesaturateFilter()
        {
            iId = 6;
            fragmentCode = "dp3 ft0.xyz, ft0.xyz, fc1.xyz";
            _aFragmentConstants = new <Number>[0.299, 0.587, 0.114, 0];
        }

    }
}//package com.flengine.context.filters

