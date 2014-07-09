// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTextureFilteringType

package com.flengine.textures
{
    import com.flengine.error.FError;

    public class FTextureFilteringType 
    {

        public static const NEAREST:int = 0;
        public static const LINEAR:int = 1;

        public function FTextureFilteringType()
        {
            throw (new FError("FError: Cannot instantiate abstract class."));
        }

        static function isValid(p_type:int):Boolean
        {
            if ((((p_type == 0)) || ((p_type == 1))))
            {
                return (true);
            };
            return (false);
        }


    }
}//package com.flengine.textures

