// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.core.FNodePool

package com.flengine.core
{
	import com.flengine.fl2d;
	use namespace fl2d;
    public class FNodePool 
    {

        private var __cFirst:FNode;
        private var __cLast:FNode;
        private var __xPrototype:XML;
        private var __iMaxCount:int;
        private var __iCachedCount:int = 0;
        private var __bDisposing:Boolean = false;

        public function FNodePool(p_prototype:XML, p_maxCount:int=0, p_precacheCount:int=0)
        {
            var _local4:int;
            super();
            __xPrototype = p_prototype;
            __iMaxCount = p_maxCount;
            _local4 = 0;
            while (_local4 < p_precacheCount)
            {
                createNew(true);
                _local4++;
            };
        }

        public function get cachedCount():int
        {
            return (__iCachedCount);
        }

        public function getNext():FNode
        {
            var _local1:FNode;
            if ((((__cFirst == null)) || (__cFirst.active)))
            {
                _local1 = createNew();
            }
            else
            {
                _local1 = __cFirst;
                _local1.active = true;
            };
            return (_local1);
        }

        function putToFront(p_node:FNode):void
        {
            if (p_node == __cFirst)
            {
                return;
            };
            if (p_node.cPoolNext)
            {
                p_node.cPoolNext.cPoolPrevious = p_node.cPoolPrevious;
            };
            if (p_node.cPoolPrevious)
            {
                p_node.cPoolPrevious.cPoolNext = p_node.cPoolNext;
            };
            if (p_node == __cLast)
            {
                __cLast = __cLast.cPoolPrevious;
            };
            if (__cFirst != null)
            {
                __cFirst.cPoolPrevious = p_node;
            };
            p_node.cPoolPrevious = null;
            p_node.cPoolNext = __cFirst;
            __cFirst = p_node;
        }

        function putToBack(p_node:FNode):void
        {
            if (p_node == __cLast)
            {
                return;
            };
            if (p_node.cPoolNext)
            {
                p_node.cPoolNext.cPoolPrevious = p_node.cPoolPrevious;
            };
            if (p_node.cPoolPrevious)
            {
                p_node.cPoolPrevious.cPoolNext = p_node.cPoolNext;
            };
            if (p_node == __cFirst)
            {
                __cFirst = __cFirst.cPoolNext;
            };
            if (__cLast != null)
            {
                __cLast.cPoolNext = p_node;
            };
            p_node.cPoolPrevious = __cLast;
            p_node.cPoolNext = null;
            __cLast = p_node;
        }

        private function createNew(p_precache:Boolean=false):FNode
        {
            var _local2:FNode;
            if ((((__iMaxCount == 0)) || ((__iCachedCount < __iMaxCount))))
            {
                __iCachedCount++;
                _local2 = FNodeFactory.createFromPrototype(__xPrototype);
                _local2.active = !(p_precache);
                _local2.cPool = this;
                if (__cFirst == null)
                {
                    __cFirst = _local2;
                    __cLast = _local2;
                }
                else
                {
                    _local2.cPoolPrevious = __cLast;
                    __cLast.cPoolNext = _local2;
                    __cLast = _local2;
                };
            };
            return (_local2);
        }

        private function createNode():FNode
        {
            return (FNodeFactory.createFromPrototype(__xPrototype));
        }

        public function dispose():void
        {
            var _local1:FNode;
            while (__cFirst)
            {
                _local1 = __cFirst.cPoolNext;
                __cFirst.dispose();
                __cFirst = _local1;
            };
        }

        public function deactivate():void
        {
            if (__cLast == null)
            {
                return;
            };
            while (__cLast.active)
            {
                __cLast.active = false;
            };
        }


    }
}//package com.flengine.core

