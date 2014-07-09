// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.core.FNodeFactory

package com.flengine.core
{
    import com.flengine.components.FComponent;
    import com.flengine.error.FError;
    import flash.utils.getDefinitionByName;
    import com.flengine.components.FTransform;

    public class FNodeFactory 
    {


        public static function createNode(p_name:String=""):FNode
        {
            return (new FNode(p_name));
        }

        public static function createNodeWithComponent(p_componentClass:Class, p_name:String="", p_lookupClass:Class=null):FComponent
        {
            var _local4:FNode = new FNode(p_name);
            return (_local4.addComponent(p_componentClass, p_lookupClass));
        }

        public static function createNodeWithComponentPrototype(p_componentPrototype:XML, p_name:String=""):FComponent
        {
            var _local3:FNode = new FNode(p_name);
            return (_local3.addComponentFromPrototype(p_componentPrototype));
        }

        public static function createFromPrototype(p_prototype:XML, p_name:String=""):FNode
        {
            var _local8:*;
            var _local6:*;
            var _local9:int;
            var _local4 = null;
            var _local7 = null;
            if (p_prototype == null)
            {
                throw (new FError("FError: Prototype cannot be null."));
            };
            var _local5:FNode = new FNode(p_name);
            _local5.mouseEnabled = (((p_prototype.@mouseEnabled)=="true") ? true : false);
            _local5.mouseChildren = (((p_prototype.@mouseChildren)=="true") ? true : false);
            var _local3:Array = p_prototype.@tags.split(",");
            _local9 = 0;
            while (_local9 < _local3.length)
            {
                _local5.addTag(_local3[_local9]);
                _local9++;
            };
            _local9 = 0;
            while (_local9 < p_prototype.components.children().length())
            {
                _local4 = p_prototype.components.children()[_local9];
                _local8 = getDefinitionByName(_local4.@componentClass.split("-").join("::"));
                if (_local8 == FTransform)
                {
                    _local5.transform.bindFromPrototype(_local4);
                }
                else
                {
                    _local6 = getDefinitionByName(_local4.@componentLookupClass.split("-").join("::"));
                    _local7 = _local5.addComponent(_local8, _local6);
                    _local7.bindFromPrototype(_local4);
                };
                _local9++;
            };
            _local9 = 0;
            while (_local9 < p_prototype.children.children().length())
            {
                _local4 = p_prototype.children.children()[_local9];
                _local5.addChild(FNodeFactory.createFromPrototype(_local4));
                _local9++;
            };
            return (_local5);
        }


    }
}//package com.flengine.core

