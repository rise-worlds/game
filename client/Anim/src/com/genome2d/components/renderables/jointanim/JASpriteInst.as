// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JASpriteInst

package com.genome2d.components.renderables.jointanim
{
    import __AS3__.vec.Vector;

    public class JASpriteInst 
    {

        public var parent:JASpriteInst;
        public var delayFrames:int;
        public var frameNum:Number;
        public var lastFrameNum:Number;
        public var frameRepeats:int;
        public var onNewFrame:Boolean;
        public var lastUpdated:int;
        public var curTransform:JATransform;
        public var curColor:JAColor;
        public var children:Vector.<JAObjectInst>;
        public var spriteDef:JASpriteDef;

        public function JASpriteInst()
        {
            children = new Vector.<JAObjectInst>();
            curTransform = new JATransform();
            spriteDef = null;
        }

        public function Dispose():void
        {
            var _local1:int;
            _local1 = 0;
            while (_local1 < children.length)
            {
                children[_local1].Dispose();
                _local1++;
            };
            children.splice(0, children.length);
            children = null;
            curTransform = null;
            spriteDef = null;
            curColor = null;
        }

        public function Reset():void
        {
            var _local1:int;
            _local1 = 0;
            while (_local1 < children.length)
            {
                children[_local1].Dispose();
                _local1++;
            };
            children.splice(0, children.length);
        }


    }
}//package com.flengine.components.renderables.jointanim

