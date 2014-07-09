// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.postprocesses.FFilterPP

package com.flengine.context.postprocesses
{
    import __AS3__.vec.Vector;
    import com.flengine.context.filters.FFilter;

    public class FFilterPP extends FPostProcess 
    {

        public function FFilterPP(p_filters:Vector.<FFilter>)
        {
            super(p_filters.length);
            _aPassFilters = p_filters;
        }

    }
}//package com.flengine.context.postprocesses

