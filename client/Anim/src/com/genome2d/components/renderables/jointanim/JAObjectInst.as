// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAObjectInst

package com.genome2d.components.renderables.jointanim
{
    public class JAObjectInst 
    {

        public var name:String;
        public var spriteInst:JASpriteInst;
        public var blendSrcTransform:JATransform;
        public var blendSrcColor:JAColor;
        public var isBlending:Boolean;
        public var transform:JATransform2D;
        public var colorMult:JAColor;
        public var predrawCallback:Boolean;
        public var imagePredrawCallback:Boolean;
        public var postdrawCallback:Boolean;

        public function JAObjectInst()
        {
            name = null;
            spriteInst = null;
            predrawCallback = true;
            predrawCallback = true;
            imagePredrawCallback = true;
            isBlending = false;
            transform = new JATransform2D();
            colorMult = new JAColor();
            blendSrcColor = new JAColor();
            blendSrcTransform = new JATransform();
        }

        public function Dispose():void
        {
        }


    }
}//package com.flengine.components.renderables.jointanim

