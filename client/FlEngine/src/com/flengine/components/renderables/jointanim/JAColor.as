// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAColor

package com.flengine.components.renderables.jointanim
{
    public class JAColor 
    {

        public static const White:JAColor = new (JAColor)(0xFF, 0xFF, 0xFF);

        public var red:int;
        public var green:int;
        public var blue:int;
        public var alpha:int;

        public function JAColor(r:int=0, g:int=0, b:int=0, a:int=0xFF)
        {
            red = r;
            green = g;
            blue = b;
            alpha = a;
        }

        public static function FromInt(theColor:int, out:JAColor):JAColor
        {
            out.Set(((theColor >> 16) & 0xFF), ((theColor >> 8) & 0xFF), (theColor & 0xFF), ((theColor >> 24) & 0xFF));
            return (out);
        }


        public function clone(from:JAColor):void
        {
            this.red = from.red;
            this.green = from.green;
            this.blue = from.blue;
            this.alpha = from.alpha;
        }

        public function Set(r:int, g:int, b:int, a:int=0xFF):void
        {
            red = r;
            green = g;
            blue = b;
            alpha = a;
        }

        public function IsWhite():Boolean
        {
            return ((((((red == 0xFF)) && ((green == 0xFF)))) && ((blue == 0xFF))));
        }

        public function toInt():uint
        {
            return ((((((alpha << 24) & 0xFF000000) | ((red << 16) & 0xFF0000)) | ((green << 8) & 0xFF00)) | (blue & 0xFF)));
        }


    }
}//package com.flengine.components.renderables.jointanim

