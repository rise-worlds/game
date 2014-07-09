// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.FComponent

package com.flengine.components
{
    import com.flengine.core.FNode;
    import flash.utils.getQualifiedClassName;
    import flash.utils.describeType;
    import com.flengine.context.FContext;
    import flash.geom.Rectangle;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.events.TouchEvent;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FComponent 
    {

        protected var _xPrototype:XML;
        protected var _bActive:Boolean = true;
        protected var _sId:String = "";
        fl2d var cLookupClass:Object;
        fl2d var cPrevious:FComponent;
        fl2d var cNext:FComponent;
        fl2d var cNode:FNode;
        fl2d var cRenderData:Object;

        public function FComponent(p_node:FNode)
        {
            cNode = p_node;
        }

        public function getPrototype():XML
        {
            var _local5:int;
            var _local4 = null;
            var _local1 = null;
            _xPrototype = <component/>
            ;
            _xPrototype.@id = _sId;
            _xPrototype.@componentClass = getQualifiedClassName(this).split("::").join("-");
            _xPrototype.@componentLookupClass = getQualifiedClassName(this.cLookupClass).split("::").join("-");
            _xPrototype.properties = <properties/>
            ;
            var _local2:XML = describeType(this);
            var _local6:XMLList = _local2.variable;
            _local5 = 0;
            while (_local5 < _local6.length())
            {
                _local4 = _local6[_local5];
                addPrototypeProperty(_local4.@name, this[_local4.@name], _local4.@type);
                _local5++;
            };
            var _local3:XMLList = _local2.accessor;
            _local5 = 0;
            while (_local5 < _local3.length())
            {
                _local1 = _local3[_local5];
                if (_local1.@access == "readwrite")
                {
                    addPrototypeProperty(_local1.@name, this[_local1.@name], _local1.@type);
                };
                _local5++;
            };
            return (_xPrototype);
        }

        protected function addPrototypeProperty(p_name:String, p_value:*, p_type:String, p_prototype:XML=null):void
        {
            var _local5 = null;
            p_type = p_type.toLowerCase();
            var _local7:String = typeof(p_value);
            if ((((_local7 == "object")) && (((!((p_type == "array"))) && (!((p_type == "object")))))))
            {
                return;
            };
            if (_local7 != "object")
            {
                _local5 = new (XML)((((((("<" + (p_name + " ")) + " value=") + (('"' + p_value) + '"')) + " type=") + (('"' + p_type) + '"')) + "/>"));
            }
            else
            {
                _local5 = new (XML)((((("<" + (p_name + " ")) + " type=") + (('"' + p_type) + '"')) + "/>"));
                for (var _local6:String in p_value)
                {
                    addPrototypeProperty(_local6, p_value[_local6], typeof(p_value[_local6]), _local5);
                };
            };
            if (p_prototype == null)
            {
                _xPrototype.properties.appendChild(_local5);
            }
            else
            {
                p_prototype.appendChild(_local5);
            };
        }

        public function bindFromPrototype(p_prototype:XML):void
        {
            var _local4:int;
            _sId = p_prototype.@id;
            var _local3:XMLList = p_prototype.properties;
            var _local2:int = _local3.children().length();
            _local4 = 0;
            while (_local4 < _local2)
            {
                bindPrototypeProperty(_local3.children()[_local4], this);
                _local4++;
            };
        }

        public function bindPrototypeProperty(p_property:XML, p_object:Object):void
        {
            var _local3:int;
            var _local5:int;
            var _local4 = null;
            if (p_property.@type == "object")
            {
            };
            if (p_property.@type == "array")
            {
                _local4 = [];
                _local3 = p_property.children().length();
                _local5 = 0;
                while (_local5 < _local3)
                {
                    bindPrototypeProperty(p_property.children()[_local5], _local4);
                    _local5++;
                };
            };
            if (p_property.@type == "boolean")
            {
                _local4 = (((p_property.@value)=="false") ? false : true);
            };
            try
            {
                p_object[p_property.name()] = (((_local4)==null) ? p_property.@value : _local4);
            }
            catch(e:Error)
            {
                (trace("bindPrototypeProperty", e, p_object, p_property.name(), _local4));
            };
        }

        public function set active(p_value:Boolean):void
        {
            _bActive = p_value;
        }

        public function get active():Boolean
        {
            return (_bActive);
        }

        public function get id():String
        {
            return (_sId);
        }

        public function get node():FNode
        {
            return (cNode);
        }

        public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
        }

        public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
        }

        public function processMouseEvent(p_captured:Boolean, p_event:MouseEvent, p_position:Vector3D):Boolean
        {
            return (false);
        }

        public function processTouchEvent(p_captured:Boolean, p_event:TouchEvent, p_position:Vector3D):Boolean
        {
            return (false);
        }

        private function internaldispose():void
        {
            _bActive = false;
            cNode = null;
            cNext = null;
            cPrevious = null;
            dispose();
        }

        public function dispose():void
        {
        }


    }
}//package com.flengine.components

