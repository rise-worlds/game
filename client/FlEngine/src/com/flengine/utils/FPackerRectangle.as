// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.utils.FPackerRectangle

package com.flengine.utils
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    public class FPackerRectangle 
    {

        private static var availableInstance:FPackerRectangle;

        var cNext:FPackerRectangle;
        var cPrevious:FPackerRectangle;
        private var __cNextInstance:FPackerRectangle;
        public var x:int = 0;
        public var y:int = 0;
        public var width:int = 0;
        public var height:int = 0;
        public var right:int = 0;
        public var bottom:int = 0;
        public var id:String;
        public var bitmapData:BitmapData;
        public var pivotX:Number;
        public var pivotY:Number;
        public var padding:int = 0;


        public static function get(p_x:int, p_y:int, p_width:int, p_height:int, p_id:String=null, p_bitmapData:BitmapData=null, p_pivotX:Number=0, p_pivotY:Number=0):FPackerRectangle
        {
            var _local9:FPackerRectangle = availableInstance;
            if (_local9)
            {
                availableInstance = _local9.__cNextInstance;
                _local9.__cNextInstance = null;
            }
            else
            {
                _local9 = new (FPackerRectangle)();
            };
            _local9.x = p_x;
            _local9.y = p_y;
            _local9.width = p_width;
            _local9.height = p_height;
            _local9.right = (p_x + p_width);
            _local9.bottom = (p_y + p_height);
            _local9.id = p_id;
            _local9.bitmapData = p_bitmapData;
            _local9.pivotX = p_pivotX;
            _local9.pivotY = p_pivotY;
            return (_local9);
        }


        public function set(p_x:int, p_y:int, p_width:int, p_height:int):void
        {
            x = p_x;
            y = p_y;
            width = p_width;
            height = p_height;
            right = (p_x + p_width);
            bottom = (p_y + p_height);
        }

        public function dispose():void
        {
            cNext = null;
            cPrevious = null;
            __cNextInstance = availableInstance;
            availableInstance = this;
            bitmapData = null;
        }

        public function setPadding(p_value:int):void
        {
            x = (x - (p_value - padding));
            y = (y - (p_value - padding));
            width = (width + ((p_value - padding) * 2));
            height = (height + ((p_value - padding) * 2));
            right = (right + (p_value - padding));
            bottom = (bottom + (p_value - padding));
            padding = p_value;
        }

        public function get rect():Rectangle
        {
            return (new Rectangle(x, y, width, height));
        }

        public function toString():String
        {
            return (((((((((((((("[" + id) + "] x: ") + x) + " y: ") + y) + " w: ") + width) + " h: ") + height) + " bd: ") + bitmapData.rect) + " p: ") + padding));
        }


    }
}//package com.flengine.utils

