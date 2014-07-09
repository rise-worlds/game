// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.signals.FMouseSignal

package com.flengine.signals
{
    import flash.events.Event;
    import com.flengine.core.FNode;

    public class FMouseSignal extends Event 
    {

        private var __cTarget:FNode;
        private var __cDispatcher:FNode;
        private var __nLocalX:Number;
        private var __nLocalY:Number;
        private var __bButtonDown:Boolean;
        private var __bCtrlDown:Boolean;
        private var __sType:String;

        public function FMouseSignal(p_target:FNode, p_dispatcher:FNode, p_localX:Number, p_localY:Number, p_buttonDown:Boolean, p_ctrlDown:Boolean, p_type:String)
        {
            super("MouseSignal");
            __cTarget = p_target;
            __cDispatcher = p_dispatcher;
            __nLocalX = p_localX;
            __nLocalY = p_localY;
            __bButtonDown = p_buttonDown;
            __bCtrlDown = p_ctrlDown;
            __sType = p_type;
        }

        override public function get target():Object
        {
            return (__cTarget);
        }

        public function get dispatcher():FNode
        {
            return (__cDispatcher);
        }

        public function get localX():Number
        {
            return (__nLocalX);
        }

        public function get localY():Number
        {
            return (__nLocalY);
        }

        public function get buttonDown():Boolean
        {
            return (__bButtonDown);
        }

        public function get ctrlDown():Boolean
        {
            return (__bCtrlDown);
        }

        override public function get type():String
        {
            return (__sType);
        }


    }
}//package com.flengine.signals

