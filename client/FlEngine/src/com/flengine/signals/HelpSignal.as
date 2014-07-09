// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.signals.HelpSignal

package com.flengine.signals
{
    import flash.utils.Dictionary;

    public class HelpSignal 
    {

        private var funcList:Dictionary;

        public function HelpSignal()
        {
            funcList = new Dictionary();
        }

        public function dispose():void
        {
            for (var _local1:Object in funcList)
            {
                delete funcList[_local1];
                _local1 = null;
            };
            funcList = null;
        }

        public function dispatch(e:Object):void
        {
            for (var _local2:Object in funcList)
            {
                (_local2(e));
                if (funcList[_local2])
                {
                    delete funcList[_local2];
                    _local2 = null;
                };
            };
        }

        public function add(func:Function):void
        {
            if (funcList[func] == undefined)
            {
                funcList[func] = false;
            };
        }

        public function addOnce(func:Function):void
        {
            if (funcList[func] == undefined)
            {
                funcList[func] = true;
            };
        }

        public function remove(func:Function):void
        {
            if (funcList[func] != undefined)
            {
                delete funcList[func];
            };
        }


    }
}//package com.flengine.signals

