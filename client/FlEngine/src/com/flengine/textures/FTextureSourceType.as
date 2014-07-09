// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTextureSourceType

package com.flengine.textures
{
    import com.flengine.error.FError;

    public class FTextureSourceType 
    {

        public static const ATF_BGRA:int = 0;
        public static const ATF_COMPRESSED:int = 1;
        public static const ATF_COMPRESSEDALPHA:int = 2;
        public static const BYTEARRAY:int = 2;
        public static const BITMAPDATA:int = 3;
        public static const RENDER_TARGET:int = 4;

        public function FTextureSourceType()
        {
            throw (new FError("FError: Cannot instantiate abstract class."));
        }

        static function isValid(p_type:int):Boolean
        {
            if ((((((((((p_type == 1)) || ((p_type == 2)))) || ((p_type == 2)))) || ((p_type == 3)))) || ((p_type == 4))))
            {
                return (true);
            };
            return (false);
        }


    }
}//package com.flengine.textures

