// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.FPrototypePropertyType

package com.flengine.components
{
    public class FPrototypePropertyType 
    {

        public static const UNKNOWN:String = "unknown";
        public static const NUMBER:String = "number";
        public static const INT:String = "int";
        public static const BOOLEAN:String = "boolean";
        public static const OBJECT:String = "object";
        public static const STRING:String = "string";


        public static function getPrototypeType(p_value:*):String
        {
            var _local2:String = typeof(p_value);
            switch (_local2)
            {
                case "number":
                    return ("number");
                case "boolean":
                    return ("boolean");
                case "string":
                    return ("string");
                case "object":
                    return ("object");
            };
            return ("unknown");
        }


    }
}//package com.flengine.components

