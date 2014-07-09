// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JASpriteDef

package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.Vector;

    public class JASpriteDef 
    {

        public var name:String;
        public var animRate:Number;
        public var workAreaStart:int;
        public var workAreaDuration:int;
        public var frames:Vector.<JAFrame>;
        public var objectDefVector:Vector.<JAObjectDef>;
        public var label:Object;

        public function JASpriteDef()
        {
            frames = new Vector.<JAFrame>();
            objectDefVector = new Vector.<JAObjectDef>();
            label = {};
        }

        public function GetLabelFrame(theLabel:String):int
        {
            var _local2:String = theLabel.toUpperCase();
            if (label[_local2] != null)
            {
                return (label[_local2]);
            };
            return (-1);
        }


    }
}//package com.flengine.components.renderables.jointanim

