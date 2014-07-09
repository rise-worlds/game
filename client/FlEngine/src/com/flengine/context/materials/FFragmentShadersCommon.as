// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FFragmentShadersCommon

package com.flengine.context.materials
{
    import flash.utils.Dictionary;
    import com.adobe.utils.AGALMiniAssembler;
    import flash.utils.ByteArray;
    import com.flengine.context.filters.FFilter;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FFragmentShadersCommon 
    {

        private static const COLOR_FRAGMENT_CODE:String = "mov oc, v1";
        private static const ALPHA_FRAGMENT_CODE:String = "mul ft0, ft0, v1";
        private static const FINAL_FRAGMENT_CODE:String = "mov oc, ft0";

        private static var CACHED_CODE:Dictionary = new Dictionary();


        private static function getSamplerFragmentCode(p_repeat:Boolean, p_filtering:int, p_atf:int):String
        {
            return ((((("tex ft0, v0, fs0 <2d," + ((p_repeat) ? "repeat" : "clamp")) + (((p_atf)!=0) ? (("," + (((p_atf)==1) ? "dxt1" : "dxt5")) + ",") : ",")) + (((p_filtering)==0) ? "nearest" : "linear")) + ",mipnone>"));
        }

        public static function getColorShaderCode():ByteArray
        {
            var _local1:AGALMiniAssembler = new AGALMiniAssembler();
            _local1.assemble("fragment", "mov oc, v1");
            return (_local1.agalcode);
        }

        public static function getTexturedShaderCode(p_repeat:Boolean, p_filtering:int, p_alpha:Boolean, p_atf:int=0, p_filter:FFilter=null):ByteArray
        {
            var _local6:String;
            if ((((p_filter == null)) || (!(p_filter.bOverrideFragmentShader))))
            {
                _local6 = getSamplerFragmentCode(p_repeat, p_filtering, p_atf);
                if (p_filter)
                {
                    _local6 = (_local6 + ("\n" + p_filter.fragmentCode));
                };
                if (p_alpha)
                {
                    _local6 = (_local6 + "\nmul ft0, ft0, v1");
                };
                _local6 = (_local6 + "\nmov oc, ft0");
            }
            else
            {
                _local6 = p_filter.fragmentCode;
            };
            var _local7:AGALMiniAssembler = new AGALMiniAssembler();
            _local7.assemble("fragment", _local6);
            return (_local7.agalcode);
        }


    }
}//package com.flengine.context.materials

