// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTextureResampleType

package com.flengine.textures
{
    import com.flengine.error.FError;

    public class FTextureResampleType 
    {

        public static const NEAREST_RESAMPLE:int = 0;
        public static const NEAREST_DOWN_RESAMPLE_UP_CROP:int = 1;
        public static const UP_CROP:int = 2;
        public static const UP_RESAMPLE:int = 3;
        public static const DOWN_RESAMPLE:int = 4;
        public static const NEAREST_RESAMPLE_WIDTH:int = 5;
        public static const NEAREST_RESAMPLE_HEIGHT:int = 6;

        public function FTextureResampleType()
        {
            throw (new FError("FError: Cannot instantiate abstract class."));
        }

        static function isValid(p_type:int):Boolean
        {
            if ((((((((((p_type == 0)) || ((p_type == 1)))) || ((p_type == 2)))) || ((p_type == 3)))) || ((p_type == 4))))
            {
                return (true);
            };
            return (false);
        }


    }
}//package com.flengine.textures

