// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTextureAtfType

package com.flengine.textures
{
    import com.flengine.error.FError;

    public class FTextureAtfType 
    {

        public static const ATF_Type_None:int = 0;
        public static const ATF_Type_Dxt1:int = 1;
        public static const ATF_Type_Dxt5:int = 2;

        public function FTextureAtfType()
        {
            throw (new FError("FError: Cannot instantiate abstract class."));
        }

        static function isValid(p_type:int):Boolean
        {
            if ((((p_type == 1)) || ((p_type == 2))))
            {
                return (true);
            };
            return (false);
        }


    }
}//package com.flengine.textures

