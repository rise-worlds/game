// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAAnimDef

package com.genome2d.components.renderables.jointanim
{
    import __AS3__.vec.Vector;

    public class JAAnimDef 
    {

        public var mainSpriteDef:JASpriteDef;
        public var spriteDefVector:Vector.<JASpriteDef>;
        public var objectNamePool:Array;

        public function JAAnimDef()
        {
            mainSpriteDef = null;
            spriteDefVector = new Vector.<JASpriteDef>();
            objectNamePool = [];
        }

    }
}//package com.flengine.components.renderables.jointanim

