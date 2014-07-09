// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAVec2

package com.genome2d.components.renderables.jointanim
{
    public class JAVec2 
    {

        public var x:Number;
        public var y:Number;

        public function JAVec2(_x:Number=0, _y:Number=0)
        {
            x = _x;
            y = _y;
        }

        public function Magnitude():Number
        {
            return (Math.sqrt(((x * x) + (y * y))));
        }

        public function Normalize():JAVec2
        {
            var _local1:Number = Magnitude();
            if (_local1 != 0)
            {
                x = (x / _local1);
                y = (y / _local1);
            };
            return (this);
        }

        public function Perp():void
        {
            var _local1:Number = this.x;
            this.x = -(this.y);
            this.y = this.x;
        }

        public function Dot(v:JAVec2):Number
        {
            return (((x * v.x) + (y * v.y)));
        }


    }
}//package com.flengine.components.renderables.jointanim

