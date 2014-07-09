// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;
    import flash.display3D.Context3D;
    import com.flengine.textures.FTexture;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FFilter 
    {

        public var fragmentCode:String;
        protected var _aFragmentConstants:Vector.<Number>;
        fl2d var iId:int;
        fl2d var bOverrideFragmentShader:Boolean = false;

        public function FFilter()
        {
            iId = 0;
            _aFragmentConstants = new Vector.<Number>();
        }

        public function bind(p_context:Context3D, p_texture:FTexture):void
        {
            p_context.setProgramConstantsFromVector("fragment", 1, _aFragmentConstants, (_aFragmentConstants.length / 4));
        }

        public function clear(p_context:Context3D):void
        {
        }


    }
}//package com.flengine.context.filters

