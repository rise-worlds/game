// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAObjectPos

package com.genome2d.components.renderables.jointanim
{
    import flash.geom.Rectangle;

    public class JAObjectPos 
    {

        public var name:String;
        public var objectNum:int;
        public var isSprite:Boolean;
        public var isAdditive:Boolean;
        public var resNum:int;
        public var hasSrcRect:Boolean;
        public var srcRect:Rectangle;
        public var color:JAColor;
        public var animFrameNum:int;
        public var timeScale:Number;
        public var preloadFrames:int;
        public var transform:JATransform;

        public function JAObjectPos()
        {
            transform = new JATransform();
        }

        public function clone(from:JAObjectPos):void
        {
            this.name = from.name;
            this.objectNum = from.objectNum;
            this.isSprite = from.isSprite;
            this.isAdditive = from.isAdditive;
            this.resNum = from.resNum;
            this.hasSrcRect = from.hasSrcRect;
            if (this.hasSrcRect)
            {
                if (from.srcRect != null)
                {
                    this.srcRect = from.srcRect.clone();
                };
            };
            if (from.color != JAColor.White)
            {
                this.color = new JAColor();
                this.color.clone(from.color);
            }
            else
            {
                this.color = from.color;
            };
            this.animFrameNum = from.animFrameNum;
            this.timeScale = from.timeScale;
            this.preloadFrames = from.preloadFrames;
            transform.clone(from.transform);
        }


    }
}//package com.flengine.components.renderables.jointanim

