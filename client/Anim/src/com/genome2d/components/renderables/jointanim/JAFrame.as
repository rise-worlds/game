// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAFrame

package com.genome2d.components.renderables.jointanim
{
    import __AS3__.vec.Vector;

    public class JAFrame 
    {

        public var hasStop:Boolean;
        public var commandVector:Vector.<JACommand>;
        public var frameObjectPosVector:Vector.<JAObjectPos>;

        public function JAFrame()
        {
            commandVector = new Vector.<JACommand>();
            frameObjectPosVector = new Vector.<JAObjectPos>();
        }

    }
}//package com.flengine.components.renderables.jointanim

