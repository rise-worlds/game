// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FColorMatrixFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;

    public class FColorMatrixFilter extends FFilter 
    {

        private static const IDENTITY_MATRIX:Vector.<Number> = new <Number>[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];

        public function FColorMatrixFilter(p_matrix:Vector.<Number>=null)
        {
            iId = 5;
            setMatrix((((p_matrix)==null) ? IDENTITY_MATRIX : p_matrix));
            fragmentCode = "max ft0, ft0, fc6             \ndiv ft0.xyz, ft0.xyz, ft0.www \nm44 ft0, ft0, fc1             \nadd ft0, ft0, fc5             \nmul ft0.xyz, ft0.xyz, ft0.www \n";
        }

        public function setMatrix(p_matrix:Vector.<Number>):void
        {
            _aFragmentConstants.unshift(p_matrix[0], p_matrix[1], p_matrix[2], p_matrix[3], p_matrix[5], p_matrix[6], p_matrix[7], p_matrix[8], p_matrix[10], p_matrix[11], p_matrix[12], p_matrix[13], p_matrix[15], p_matrix[16], p_matrix[17], p_matrix[18], (p_matrix[4] / 0xFF), (p_matrix[9] / 0xFF), (p_matrix[14] / 0xFF), (p_matrix[19] / 0xFF), 0, 0, 0, 0.0001);
            _aFragmentConstants.length = 24;
        }


    }
}//package com.flengine.context.filters

