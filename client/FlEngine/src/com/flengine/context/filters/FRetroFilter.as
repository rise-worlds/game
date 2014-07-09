// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FRetroFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;

    public class FRetroFilter extends FFilter 
    {

        public function FRetroFilter()
        {
            iId = 12;
            fragmentCode = "dp3 ft2.x, ft0.xyz, fc1.xyz    \nsub ft3.xyz, fc1.www, ft2.xxx  \nsub ft4.xyz, fc1.www, ft0.xyz  \nmul ft3.xyz, ft3.xyz, ft4.xyz  \nadd ft3.xyz, ft3.xyz, ft3.xyz  \nsub ft3.xyz, fc1.www, ft3.xyz  \nmul ft4.xyz, ft2.xxx, ft0.xyz  \nadd ft4.xyz, ft4.xyz, ft4.xyz  \nsge ft1.xyz, ft0.xyz, fc2.www  \nslt ft5.xyz, ft0.xyz, fc2.www  \nmul ft1.xyz, ft1.xyz, ft3.xyz  \nmul ft5.xyz, ft5.xyz, ft4.xyz  \nadd ft1.xyz, ft1.xyz, ft5.xyz  \nmul ft1.xyz, ft1.xyz, fc2.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmul ft1.xyz, fc3.xyz, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmul ft1.xyz, fc4.xyz, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmov ft0.xyz, ft1.xyz           \n";
            _aFragmentConstants = new <Number>[0.3, 0.59, 0.11, 1, 0.579007784313725, 0.558246549019608, 0.376009039215686, 0.5, 0.818039215686274, 0.92078431372549, 0.859607843137255, 0, 0.994048458823529, 0.951726388235294, 0.845921211764706, 0];
        }

    }
}//package com.flengine.context.filters

