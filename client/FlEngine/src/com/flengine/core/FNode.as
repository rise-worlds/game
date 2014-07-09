// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.core.FNode

package com.flengine.core
{
    import __AS3__.vec.Vector;
    import com.flengine.signals.HelpSignal;
    import com.flengine.components.FTransform;
    import com.flengine.components.physics.FBody;
    import com.flengine.context.postprocesses.FPostProcess;
    import flash.utils.Dictionary;
    import com.flengine.components.FComponent;
    import com.flengine.error.FError;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import com.flengine.signals.FMouseSignal;
    import flash.utils.getDefinitionByName;
    import com.flengine.components.renderables.FRenderable;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FNode 
    {

        private static var __iCount:int = 0;
        private static var __aActiveMasks:Vector.<FNode> = new Vector.<FNode>();

        private var __eOnAddedToStage:HelpSignal;
        private var __eOnRemovedFromStage:HelpSignal;
        private var __eOnComponentAdded:HelpSignal;
        private var __eOnComponentRemoved:HelpSignal;
        fl2d var cPool:FNodePool;
        fl2d var cPoolPrevious:FNode;
        fl2d var cPoolNext:FNode;
        fl2d var cPrevious:FNode;
        fl2d var cNext:FNode;
        private var __bChangedParent:Boolean = false;
        public var cameraGroup:int = 0;
        private var __bParentActive:Boolean = true;
        fl2d var iUsedAsMask:int = 0;
        private var __bActive:Boolean = true;
        private var __aTags:Vector.<String>;
        private var __oUserData:Object;
        fl2d var cCore:FlEngine;
        protected var _iId:uint;
        protected var _sName:String;
        fl2d var cTransform:FTransform;
        fl2d var cBody:FBody;
        fl2d var cParent:FNode;
        private var __bUpdating:Boolean = false;
        private var __bDisposeAfterUpdate:Boolean = false;
        private var __bRemoveAfterUpdate:Boolean = false;
        private var __bDisposed:Boolean = false;
        private var __bRendering:Boolean = false;
        public var postProcess:FPostProcess;
        private var __eOnMouseDown:HelpSignal;
        private var __eOnMouseMove:HelpSignal;
        private var __eOnMouseUp:HelpSignal;
        private var __eOnMouseOver:HelpSignal;
        private var __eOnMouseClick:HelpSignal;
        private var __eOnMouseOut:HelpSignal;
        public var mouseEnabled:Boolean = false;
        public var mouseChildren:Boolean = true;
        fl2d var cMouseOver:FNode;
        fl2d var cMouseDown:FNode;
        fl2d var cRightMouseDown:FNode;
        private var __dComponentsLookupTable:Dictionary;
        private var __cFirstComponent:FComponent;
        private var __cLastComponent:FComponent;
        private var _iChildCount:int = 0;
        private var _cFirstChild:FNode;
        private var _cLastChild:FNode;
        fl2d var iUsedAsPPMask:int;

        public function FNode(p_name:String="")
        {
            __aTags = new Vector.<String>();
            __iCount++;
            _iId = __iCount;
            _sName = (((p_name)=="") ? ("FNode#" + __iCount) : p_name);
            cCore = FlEngine.getInstance();
            __dComponentsLookupTable = new Dictionary();
            cTransform = new FTransform(this);
            __dComponentsLookupTable[FTransform] = cTransform;
        }

        public function getPrototype():XML
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            var _local3:XML = <node/>
            ;
            _local3.@name = _sName;
            _local3.@mouseEnabled = mouseEnabled;
            _local3.@mouseChildren = mouseChildren;
            _local3.@tags = __aTags.join(",");
            _local3.components = <components/>
            ;
            _local3.components.appendChild(cTransform.getPrototype());
            if (cBody)
            {
                _local3.components.appendChild(cBody.getPrototype());
            };
            var _local2:FComponent = __cFirstComponent;
            while (_local2)
            {
                _local3.components.appendChild(_local2.getPrototype());
                _local2 = _local2.cNext;
            };
            _local3.children = <children/>
            ;
            var _local1:FNode = _cFirstChild;
            while (_local1)
            {
                _local3.children.appendChild(_local1.getPrototype());
                _local1 = _local1.cNext;
            };
            return (_local3);
        }

        public function get onAddedToStage():HelpSignal
        {
            if (__eOnAddedToStage == null)
            {
                __eOnAddedToStage = new HelpSignal();
            };
            return (__eOnAddedToStage);
        }

        public function get onRemovedFromStage():HelpSignal
        {
            if (__eOnRemovedFromStage == null)
            {
                __eOnRemovedFromStage = new HelpSignal();
            };
            return (__eOnRemovedFromStage);
        }

        public function get onComponentAdded():HelpSignal
        {
            if (__eOnComponentAdded == null)
            {
                __eOnComponentAdded = new HelpSignal();
            };
            return (__eOnComponentAdded);
        }

        public function get onComponentRemoved():HelpSignal
        {
            if (__eOnComponentRemoved == null)
            {
                __eOnComponentRemoved = new HelpSignal();
            };
            return (__eOnComponentRemoved);
        }

        public function get previous():FNode
        {
            return (cPrevious);
        }

        public function get next():FNode
        {
            return (cNext);
        }

        function set bParentActive(p_value:Boolean):void
        {
            var _local2:FNode = _cFirstChild;
            while (_local2)
            {
                _local2.bParentActive = p_value;
                _local2 = _local2.cNext;
            };
        }

        public function set active(p_value:Boolean):void
        {
            var _local3:FComponent;
            var _local2:FNode;
            if (p_value == __bActive)
            {
                return;
            };
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            __bActive = p_value;
            cTransform.active = __bActive;
            if (cPool)
            {
                if (p_value)
                {
                    cPool.putToBack(this);
                }
                else
                {
                    cPool.putToFront(this);
                };
            };
            if (cBody)
            {
                cBody.active = __bActive;
            };
            _local3 = __cFirstComponent;
            while (_local3)
            {
                _local3.active = __bActive;
                _local3 = _local3.cNext;
            };
            _local2 = _cFirstChild;
            while (_local2)
            {
                _local2.bParentActive = __bActive;
                _local2 = _local2.cNext;
            };
        }

        public function get active():Boolean
        {
            return (__bActive);
        }

        public function hasTag(p_tag:String):Boolean
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            if (__aTags.indexOf(p_tag) != -1)
            {
                return (true);
            };
            return (false);
        }

        public function addTag(p_tag:String):void
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            if (__aTags.indexOf(p_tag) != -1)
            {
                return;
            };
            __aTags.push(p_tag);
        }

        public function removeTag(p_tag:String):void
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            var _local2:int = __aTags.indexOf(p_tag);
            if (_local2 == -1)
            {
                return;
            };
            __aTags.splice(_local2, 1);
        }

        public function get userData():Object
        {
            if (__oUserData == null)
            {
                __oUserData = {};
            };
            return (__oUserData);
        }

        public function get core():FlEngine
        {
            return (cCore);
        }

        public function get name():String
        {
            return (_sName);
        }

        public function set name(p_value:String):void
        {
            _sName = p_value;
        }

        public function get transform():FTransform
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            return (cTransform);
        }

        public function get parent():FNode
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            return (cParent);
        }

        fl2d function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            var _local5 = null;
            if (((!(__bActive)) || (!(__bParentActive))))
            {
                return;
            };
            __bChangedParent = false;
            __bUpdating = true;
            var _local8:Boolean = ((p_parentTransformUpdate) || (cTransform.bTransformDirty));
            var _local7:Boolean = ((p_parentColorUpdate) || (cTransform.bColorDirty));
            if (((((_local8) || (_local7))) || (((!((cBody == null))) && (cBody.isDynamic())))))
            {
                cTransform.invalidate(_local8, _local7);
            };
            if (cBody != null)
            {
                cBody.update(p_deltaTime, _local8, _local7);
            };
            var _local6:FComponent = __cFirstComponent;
            while (_local6)
            {
                _local6.update(p_deltaTime, _local8, _local7);
                _local6 = _local6.cNext;
            };
            _local8 = ((_local8) || (cTransform.bTransformDirty));
            _local7 = ((_local7) || (cTransform.bColorDirty));
            if (((cTransform.bTransformDirty) || (cTransform.bColorDirty)))
            {
                cTransform.invalidate(cTransform.bTransformDirty, cTransform.bColorDirty);
            };
            var _local4:FNode = _cFirstChild;
            while (_local4)
            {
                _local4.update(p_deltaTime, _local8, _local7);
                _local5 = _local4.next;
                if (_local4.__bDisposeAfterUpdate)
                {
                    _local4.dispose();
                };
                if (_local4.__bRemoveAfterUpdate)
                {
                    removeChild(_local4);
                };
                _local4 = _local5;
            };
            __bUpdating = false;
        }

        fl2d function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle, p_renderAsMask:Boolean):void
        {
            if (((((((((((!(__bActive)) || (__bChangedParent))) || (!(__bParentActive)))) || (!(cTransform.visible)))) || (((((cameraGroup & p_camera.mask) == 0)) && (!((cameraGroup == 0))))))) || ((((iUsedAsMask > 0)) && (!(p_renderAsMask))))))
            {
                return;
            };
            if (!p_renderAsMask)
            {
                if (cTransform.cMask != null)
                {
                    p_context.renderAsStencilMask(__aActiveMasks.length);
                    cTransform.cMask.render(p_context, p_camera, p_maskRect, true);
                    __aActiveMasks.push(cTransform.cMask);
                    p_context.renderToColor(__aActiveMasks.length);
                };
            };
            __bRendering = true;
            if (cTransform.rAbsoluteMaskRect != null)
            {
                p_maskRect = p_maskRect.intersection(cTransform.rAbsoluteMaskRect);
            };
            var _local6:FComponent = __cFirstComponent;
            while (_local6)
            {
                _local6.render(p_context, p_camera, p_maskRect);
                _local6 = _local6.cNext;
            };
            var _local5:FNode = _cFirstChild;
            while (_local5)
            {
                if (_local5.postProcess)
                {
                    _local5.postProcess.render(p_context, p_camera, p_maskRect, _local5);
                }
                else
                {
                    _local5.render(p_context, p_camera, p_maskRect, p_renderAsMask);
                };
                _local5 = _local5.cNext;
            };
            if (((core.cConfig.enableStats) && (core.cConfig.showExtendedStats)))
            {
                p_camera.iRenderedNodesCount++;
            };
            if (!p_renderAsMask)
            {
                if (cTransform.cMask != null)
                {
                    __aActiveMasks.pop();
                    if (__aActiveMasks.length == 0)
                    {
                        p_context.clearStencil();
                    };
                    p_context.renderToColor(__aActiveMasks.length);
                };
            };
            __bRendering = false;
        }

        public function toString():String
        {
            return (("[G2DNode]" + _sName));
        }

        public function disposeChildren():void
        {
            if (__bRendering)
            {
                throw (new FError("FError: Cannot do this while rendering."));
            };
            if (_cFirstChild == null)
            {
                return;
            };
            var _local1:FNode = _cFirstChild.cNext;
            while (_local1)
            {
                _local1.cPrevious.dispose();
                _local1 = _local1.cNext;
            };
            _cFirstChild.dispose();
            _cFirstChild = null;
            _cLastChild = null;
        }

        public function dispose():void
        {
            var _local2 = null;
            if (__bRendering)
            {
                throw (new FError("FError: Cannot do this while rendering."));
            };
            if (__bUpdating)
            {
                __bDisposeAfterUpdate = true;
                return;
            };
            if (__bDisposed)
            {
                return;
            };
            __bActive = false;
            disposeChildren();
            for (var _local1:Object in __dComponentsLookupTable)
            {
                _local2 = __dComponentsLookupTable[_local1];
                delete __dComponentsLookupTable[_local1];
                _local2.dispose();
            };
            cBody = null;
            cTransform = null;
            __cFirstComponent = null;
            __cLastComponent = null;
            __dComponentsLookupTable = null;
            if (cParent != null)
            {
                cParent.removeChild(this);
            };
            cNext = null;
            cPrevious = null;
            if (cPoolNext)
            {
                cPoolNext.cPoolPrevious = cPoolPrevious;
            };
            if (cPoolPrevious)
            {
                cPoolPrevious.cPoolNext = cPoolNext;
            };
            cPoolNext = null;
            cPoolPrevious = null;
            cPool = null;
            if (__eOnMouseDown)
            {
                __eOnMouseDown.dispose();
                __eOnMouseDown = null;
            };
            if (__eOnMouseMove)
            {
                __eOnMouseMove.dispose();
                __eOnMouseMove = null;
            };
            if (__eOnMouseUp)
            {
                __eOnMouseUp.dispose();
                __eOnMouseUp = null;
            };
            if (__eOnMouseOver)
            {
                __eOnMouseOver.dispose();
                __eOnMouseOver = null;
            };
            if (__eOnMouseClick)
            {
                __eOnMouseClick.dispose();
                __eOnMouseClick = null;
            };
            if (__eOnMouseOut)
            {
                __eOnMouseOut.dispose();
                __eOnMouseOut = null;
            };
            if (__eOnRemovedFromStage)
            {
                __eOnRemovedFromStage.dispose();
                __eOnRemovedFromStage = null;
            };
            if (__eOnAddedToStage)
            {
                __eOnAddedToStage.dispose();
                __eOnAddedToStage = null;
            };
            __bDisposed = true;
        }

        public function get onMouseDown():HelpSignal
        {
            if (__eOnMouseDown == null)
            {
                __eOnMouseDown = new HelpSignal();
            };
            return (__eOnMouseDown);
        }

        public function get onMouseMove():HelpSignal
        {
            if (__eOnMouseMove == null)
            {
                __eOnMouseMove = new HelpSignal();
            };
            return (__eOnMouseMove);
        }

        public function get onMouseUp():HelpSignal
        {
            if (__eOnMouseUp == null)
            {
                __eOnMouseUp = new HelpSignal();
            };
            return (__eOnMouseUp);
        }

        public function get onMouseOver():HelpSignal
        {
            if (__eOnMouseOver == null)
            {
                __eOnMouseOver = new HelpSignal();
            };
            return (__eOnMouseOver);
        }

        public function get onMouseClick():HelpSignal
        {
            if (__eOnMouseClick == null)
            {
                __eOnMouseClick = new HelpSignal();
            };
            return (__eOnMouseClick);
        }

        public function get onMouseOut():HelpSignal
        {
            if (__eOnMouseOut == null)
            {
                __eOnMouseOut = new HelpSignal();
            };
            return (__eOnMouseOut);
        }

        fl2d function processMouseEvent(p_captured:Boolean, p_event:MouseEvent, p_position:Vector3D, p_camera:FCamera):Boolean
        {
            var _local5:FNode;
            var _local6:FComponent;
            if (((((!(active)) || (!(cTransform.visible)))) || (((((cameraGroup & p_camera.mask) == 0)) && (!((cameraGroup == 0)))))))
            {
                return (false);
            };
            if (mouseChildren)
            {
                _local5 = _cLastChild;
                while (_local5)
                {
                    p_captured = ((_local5.processMouseEvent(p_captured, p_event, p_position, p_camera)) || (p_captured));
                    _local5 = _local5.cPrevious;
                };
            };
            if (mouseEnabled)
            {
                _local6 = __cFirstComponent;
                while (_local6)
                {
                    p_captured = ((_local6.processMouseEvent(p_captured, p_event, p_position)) || (p_captured));
                    _local6 = _local6.cNext;
                };
            };
            return (p_captured);
        }

        fl2d function handleMouseEvent(p_object:FNode, p_type:String, p_x:int, p_y:int, p_buttonDown:Boolean, p_ctrlDown:Boolean):void
        {
            var _local7 = null;
            var _local8 = null;
            if (mouseEnabled)
            {
                _local7 = new FMouseSignal(this, p_object, p_x, p_y, p_buttonDown, p_ctrlDown, p_type);
                if (p_type == "mouseDown")
                {
                    cMouseDown = p_object;
                    if (__eOnMouseDown)
                    {
                        __eOnMouseDown.dispatch(_local7);
                    };
                }
                else
                {
                    if (p_type == "mouseMove")
                    {
                        if (__eOnMouseMove)
                        {
                            __eOnMouseMove.dispatch(_local7);
                        };
                    }
                    else
                    {
                        if (p_type == "mouseUp")
                        {
                            if ((((cMouseDown == p_object)) && (__eOnMouseClick)))
                            {
                                _local8 = new FMouseSignal(this, p_object, p_x, p_y, p_buttonDown, p_ctrlDown, "mouseUp");
                                __eOnMouseClick.dispatch(_local8);
                            };
                            cMouseDown = null;
                            if (__eOnMouseUp)
                            {
                                __eOnMouseUp.dispatch(_local8);
                            };
                        }
                        else
                        {
                            if (p_type == "mouseOver")
                            {
                                cMouseOver = p_object;
                                if (__eOnMouseOver)
                                {
                                    __eOnMouseOver.dispatch(_local8);
                                };
                            }
                            else
                            {
                                if (p_type == "mouseOut")
                                {
                                    cMouseOver = null;
                                    if (__eOnMouseOut)
                                    {
                                        __eOnMouseOut.dispatch(_local7);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (cParent)
            {
                cParent.handleMouseEvent(p_object, p_type, p_x, p_y, p_buttonDown, p_ctrlDown);
            };
        }

        public function getComponents():Dictionary
        {
            return (__dComponentsLookupTable);
        }

        public function getComponent(p_componentLookupClass:Class):FComponent
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            return (__dComponentsLookupTable[p_componentLookupClass]);
        }

        public function hasComponent(p_componentLookupClass:Class):Boolean
        {
            return (!((__dComponentsLookupTable[p_componentLookupClass] == null)));
        }

        public function addExistComponent(p_component:FComponent, p_componetClass:Class, p_componentLookupClass:Object=null):FComponent
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            if (p_componentLookupClass == null)
            {
                p_componentLookupClass = p_componetClass;
            };
            if (__dComponentsLookupTable[p_componentLookupClass] != null)
            {
                return (__dComponentsLookupTable[p_componentLookupClass]);
            };
            p_component.cLookupClass = p_componentLookupClass;
            __dComponentsLookupTable[p_componentLookupClass] = p_component;
            if ((p_component is FBody))
            {
                if (cBody)
                {
                    throw (new FError("FError: Node cannot have multiple body components."));
                };
                cBody = (p_component as FBody);
                return (p_component);
            };
            if (__cFirstComponent == null)
            {
                __cFirstComponent = p_component;
                __cLastComponent = p_component;
            }
            else
            {
                __cLastComponent.cNext = p_component;
                p_component.cPrevious = __cLastComponent;
                __cLastComponent = p_component;
            };
            if (__eOnComponentAdded)
            {
                __eOnComponentAdded.dispatch(p_componentLookupClass);
            };
            return (p_component);
        }

        public function addComponent(p_componentClass:Class, p_componentLookupClass:Class=null):FComponent
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            if (p_componentLookupClass == null)
            {
                p_componentLookupClass = p_componentClass;
            };
            if (__dComponentsLookupTable[p_componentLookupClass] != null)
            {
                return (__dComponentsLookupTable[p_componentLookupClass]);
            };
            var _local3:FComponent = new (p_componentClass)(this);
            if (_local3 == null)
            {
                throw (new FError("FError: Invalid component class."));
            };
            _local3.cLookupClass = p_componentLookupClass;
            __dComponentsLookupTable[p_componentLookupClass] = _local3;
            if ((_local3 is FBody))
            {
                if (cBody)
                {
                    throw (new FError("FError: Node cannot have multiple body components."));
                };
                cBody = (_local3 as FBody);
                return (_local3);
            };
            if (__cFirstComponent == null)
            {
                __cFirstComponent = _local3;
                __cLastComponent = _local3;
            }
            else
            {
                __cLastComponent.cNext = _local3;
                _local3.cPrevious = __cLastComponent;
                __cLastComponent = _local3;
            };
            if (__eOnComponentAdded)
            {
                __eOnComponentAdded.dispatch(p_componentLookupClass);
            };
            return (_local3);
        }

        public function addComponentFromPrototype(p_componentPrototype:XML):FComponent
        {
            var _local4:Object = getDefinitionByName(p_componentPrototype.@componentClass.split("-").join("::"));
            var _local2:Object = getDefinitionByName(p_componentPrototype.@componentLookupClass.split("-").join("::"));
            var _local3:FComponent = addComponent((_local4 as Class), (_local2 as Class));
            _local3.bindFromPrototype(p_componentPrototype);
            return (_local3);
        }

        public function removeComponent(p_componentLookupClass:Class):void
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            var _local2:FComponent = __dComponentsLookupTable[p_componentLookupClass];
            if ((((_local2 == null)) || ((_local2 == cTransform))))
            {
                return;
            };
            if (_local2.cPrevious != null)
            {
                _local2.cPrevious.cNext = _local2.cNext;
            };
            if (_local2.cNext != null)
            {
                _local2.cNext.cPrevious = _local2.cPrevious;
            };
            if (__cFirstComponent == _local2)
            {
                __cFirstComponent = __cFirstComponent.cNext;
            };
            if (__cLastComponent == _local2)
            {
                __cLastComponent = __cLastComponent.cPrevious;
            };
            delete __dComponentsLookupTable[p_componentLookupClass];
            if ((_local2 is FBody))
            {
                cBody = null;
            };
            _local2.dispose();
            if (__eOnComponentAdded)
            {
                __eOnComponentAdded.dispatch(p_componentLookupClass);
            };
        }

        public function get firstChild():FNode
        {
            return (_cFirstChild);
        }

        public function get lastChild():FNode
        {
            return (_cLastChild);
        }

        public function get numChildren():int
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            return (_iChildCount);
        }

        public function addChild(p_child:FNode):void
        {
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            if (p_child == this)
            {
                throw (new FError("FError: Node cannot be the child of itself."));
            };
            if (p_child.parent != null)
            {
                p_child.parent.removeChild(p_child);
            };
            p_child.__bChangedParent = true;
            p_child.cParent = this;
            if (_cFirstChild == null)
            {
                _cFirstChild = p_child;
                _cLastChild = p_child;
            }
            else
            {
                _cLastChild.cNext = p_child;
                p_child.cPrevious = _cLastChild;
                _cLastChild = p_child;
            };
            _iChildCount++;
            if (isOnStage())
            {
                p_child.addedToStage();
            };
        }

        public function removeChild(p_child:FNode):void
        {
            if (p_child.__bRendering)
            {
                throw (new FError("FError: Cannot do this while rendering."));
            };
            if (__bDisposed)
            {
                throw (new FError("FError: Node is already disposed."));
            };
            if (p_child.cParent != this)
            {
                return;
            };
            if (p_child.__bUpdating)
            {
                p_child.__bRemoveAfterUpdate = true;
                return;
            };
            if (p_child.cPrevious != null)
            {
                p_child.cPrevious.cNext = p_child.cNext;
            }
            else
            {
                _cFirstChild = _cFirstChild.cNext;
            };
            if (p_child.cNext)
            {
                p_child.cNext.cPrevious = p_child.cPrevious;
            }
            else
            {
                _cLastChild = _cLastChild.cPrevious;
            };
            p_child.cParent = null;
            p_child.cNext = null;
            p_child.cPrevious = null;
            _iChildCount--;
            p_child.__bRemoveAfterUpdate = false;
            if (isOnStage())
            {
                p_child.removedFromStage();
            };
        }

        public function swapChildren(p_child1:FNode, p_child2:FNode):void
        {
            if (((!((p_child1.parent == this))) || (!((p_child2.parent == this)))))
            {
                return;
            };
            var _local3:FNode = p_child1.cNext;
            if (p_child2.cNext == p_child1)
            {
                p_child1.cNext = p_child2;
            }
            else
            {
                p_child1.cNext = p_child2.cNext;
                if (p_child1.cNext)
                {
                    p_child1.cNext.cPrevious = p_child1;
                };
            };
            if (_local3 == p_child2)
            {
                p_child2.cNext = p_child1;
            }
            else
            {
                p_child2.cNext = _local3;
                if (p_child2.cNext)
                {
                    p_child2.cNext.cPrevious = p_child2;
                };
            };
            _local3 = p_child1.cPrevious;
            if (p_child2.cPrevious == p_child1)
            {
                p_child1.cPrevious = p_child2;
            }
            else
            {
                p_child1.cPrevious = p_child2.cPrevious;
                if (p_child1.cPrevious)
                {
                    p_child1.cPrevious.cNext = p_child1;
                };
            };
            if (_local3 == p_child2)
            {
                p_child2.cPrevious = p_child1;
            }
            else
            {
                p_child2.cPrevious = _local3;
                if (p_child2.cPrevious)
                {
                    p_child2.cPrevious.cNext = p_child2;
                };
            };
            if (p_child1 == _cFirstChild)
            {
                _cFirstChild = p_child2;
            }
            else
            {
                if (p_child2 == _cFirstChild)
                {
                    _cFirstChild = p_child1;
                };
            };
            if (p_child1 == _cLastChild)
            {
                _cLastChild = p_child2;
            }
            else
            {
                if (p_child2 == _cLastChild)
                {
                    _cLastChild = p_child1;
                };
            };
        }

        public function putChildToFront(p_child:FNode):void
        {
            if (p_child == _cLastChild)
            {
                return;
            };
            if (p_child.cNext)
            {
                p_child.cNext.cPrevious = p_child.cPrevious;
            };
            if (p_child.cPrevious)
            {
                p_child.cPrevious.cNext = p_child.cNext;
            };
            if (p_child == _cFirstChild)
            {
                _cFirstChild = _cFirstChild.cNext;
            };
            if (_cLastChild != null)
            {
                _cLastChild.cNext = p_child;
            };
            p_child.cPrevious = _cLastChild;
            p_child.cNext = null;
            _cLastChild = p_child;
        }

        public function putChildToBack(p_child:FNode):void
        {
            if (p_child == _cFirstChild)
            {
                return;
            };
            if (p_child.cNext)
            {
                p_child.cNext.cPrevious = p_child.cPrevious;
            };
            if (p_child.cPrevious)
            {
                p_child.cPrevious.cNext = p_child.cNext;
            };
            if (p_child == _cLastChild)
            {
                _cLastChild = _cLastChild.cPrevious;
            };
            if (_cFirstChild != null)
            {
                _cFirstChild.cPrevious = p_child;
            };
            p_child.cPrevious = null;
            p_child.cNext = _cFirstChild;
            _cFirstChild = p_child;
        }

        private function addedToStage():void
        {
            if (__eOnAddedToStage)
            {
                __eOnAddedToStage.dispatch(null);
            };
            if (cBody != null)
            {
                cBody.addToSpace();
            };
            var _local1:FNode = _cFirstChild;
            while (_local1)
            {
                _local1.addedToStage();
                _local1 = _local1.cNext;
            };
        }

        private function removedFromStage():void
        {
            if (__eOnRemovedFromStage)
            {
                __eOnRemovedFromStage.dispatch(null);
            };
            if (cBody != null)
            {
                cBody.removeFromSpace();
            };
            var _local1:FNode = _cFirstChild;
            while (_local1)
            {
                _local1.removedFromStage();
                _local1 = _local1.cNext;
            };
        }

        public function isOnStage():Boolean
        {
            if (this == cCore.root)
            {
                return (true);
            };
            if (cParent == null)
            {
                return (false);
            };
            return (cParent.isOnStage());
        }

        public function sortChildrenOnY(p_ascending:Boolean=true):void
        {
            var _local8:int;
            var _local2:int;
            var _local6:int;
            var _local9:int;
            var _local7:FNode;
            var _local5:FNode;
            var _local4:FNode;
            if (_cFirstChild == null)
            {
                return;
            };
            var _local3:int = 1;
            while (true)
            {
                _local7 = _cFirstChild;
                _cFirstChild = null;
                _cLastChild = null;
                _local6 = 0;
                while (_local7)
                {
                    _local6++;
                    _local5 = _local7;
                    _local8 = 0;
                    _local9 = 0;
                    while (_local9 < _local3)
                    {
                        _local8++;
                        _local5 = _local5.cNext;
                        if (!_local5) break;
                        _local9++;
                    };
                    _local2 = _local3;
                    while ((((_local8 > 0)) || ((((_local2 > 0)) && (_local5)))))
                    {
                        if (_local8 == 0)
                        {
                            _local4 = _local5;
                            _local5 = _local5.cNext;
                            _local2--;
                        }
                        else
                        {
                            if ((((_local2 == 0)) || (!(_local5))))
                            {
                                _local4 = _local7;
                                _local7 = _local7.cNext;
                                _local8--;
                            }
                            else
                            {
                                if (p_ascending)
                                {
                                    if (_local7.cTransform.nLocalY >= _local5.cTransform.nLocalY)
                                    {
                                        _local4 = _local7;
                                        _local7 = _local7.cNext;
                                        _local8--;
                                    }
                                    else
                                    {
                                        _local4 = _local5;
                                        _local5 = _local5.cNext;
                                        _local2--;
                                    };
                                }
                                else
                                {
                                    if (_local7.cTransform.nLocalY <= _local5.cTransform.nLocalY)
                                    {
                                        _local4 = _local7;
                                        _local7 = _local7.cNext;
                                        _local8--;
                                    }
                                    else
                                    {
                                        _local4 = _local5;
                                        _local5 = _local5.cNext;
                                        _local2--;
                                    };
                                };
                            };
                        };
                        if (_cLastChild)
                        {
                            _cLastChild.cNext = _local4;
                        }
                        else
                        {
                            _cFirstChild = _local4;
                        };
                        _local4.cPrevious = _cLastChild;
                        _cLastChild = _local4;
                    };
                    _local7 = _local5;
                };
                _cLastChild.cNext = null;
                if (_local6 <= 1)
                {
                    return;
                };
                _local3 = (_local3 * 2);
            };
        }

        public function sortChildrenOnX(p_ascending:Boolean=true):void
        {
            var _local8:int;
            var _local2:int;
            var _local6:int;
            var _local9:int;
            var _local7:FNode;
            var _local5:FNode;
            var _local4:FNode;
            if (_cFirstChild == null)
            {
                return;
            };
            var _local3:int = 1;
            while (true)
            {
                _local7 = _cFirstChild;
                _cFirstChild = null;
                _cLastChild = null;
                _local6 = 0;
                while (_local7)
                {
                    _local6++;
                    _local5 = _local7;
                    _local8 = 0;
                    _local9 = 0;
                    while (_local9 < _local3)
                    {
                        _local8++;
                        _local5 = _local5.cNext;
                        if (!_local5) break;
                        _local9++;
                    };
                    _local2 = _local3;
                    while ((((_local8 > 0)) || ((((_local2 > 0)) && (_local5)))))
                    {
                        if (_local8 == 0)
                        {
                            _local4 = _local5;
                            _local5 = _local5.cNext;
                            _local2--;
                        }
                        else
                        {
                            if ((((_local2 == 0)) || (!(_local5))))
                            {
                                _local4 = _local7;
                                _local7 = _local7.cNext;
                                _local8--;
                            }
                            else
                            {
                                if (p_ascending)
                                {
                                    if (_local7.cTransform.nLocalX >= _local5.cTransform.nLocalX)
                                    {
                                        _local4 = _local7;
                                        _local7 = _local7.cNext;
                                        _local8--;
                                    }
                                    else
                                    {
                                        _local4 = _local5;
                                        _local5 = _local5.cNext;
                                        _local2--;
                                    };
                                }
                                else
                                {
                                    if (_local7.cTransform.nLocalX <= _local5.cTransform.nLocalX)
                                    {
                                        _local4 = _local7;
                                        _local7 = _local7.cNext;
                                        _local8--;
                                    }
                                    else
                                    {
                                        _local4 = _local5;
                                        _local5 = _local5.cNext;
                                        _local2--;
                                    };
                                };
                            };
                        };
                        if (_cLastChild)
                        {
                            _cLastChild.cNext = _local4;
                        }
                        else
                        {
                            _cFirstChild = _local4;
                        };
                        _local4.cPrevious = _cLastChild;
                        _cLastChild = _local4;
                    };
                    _local7 = _local5;
                };
                _cLastChild.cNext = null;
                if (_local6 <= 1)
                {
                    return;
                };
                _local3 = (_local3 * 2);
            };
        }

        public function sortChildrenOnUserData(p_property:String, p_ascending:Boolean=true):void
        {
            var _local9:int;
            var _local3:int;
            var _local7:int;
            var _local10:int;
            var _local8:FNode;
            var _local6:FNode;
            var _local5:FNode;
            if (_cFirstChild == null)
            {
                return;
            };
            var _local4:int = 1;
            while (true)
            {
                _local8 = _cFirstChild;
                _cFirstChild = null;
                _cLastChild = null;
                _local7 = 0;
                while (_local8)
                {
                    _local7++;
                    _local6 = _local8;
                    _local9 = 0;
                    _local10 = 0;
                    while (_local10 < _local4)
                    {
                        _local9++;
                        _local6 = _local6.cNext;
                        if (!_local6) break;
                        _local10++;
                    };
                    _local3 = _local4;
                    while ((((_local9 > 0)) || ((((_local3 > 0)) && (_local6)))))
                    {
                        if (_local9 == 0)
                        {
                            _local5 = _local6;
                            _local6 = _local6.cNext;
                            _local3--;
                        }
                        else
                        {
                            if ((((_local3 == 0)) || (!(_local6))))
                            {
                                _local5 = _local8;
                                _local8 = _local8.cNext;
                                _local9--;
                            }
                            else
                            {
                                if (p_ascending)
                                {
                                    if (_local8.userData[p_property] >= _local6.userData[p_property])
                                    {
                                        _local5 = _local8;
                                        _local8 = _local8.cNext;
                                        _local9--;
                                    }
                                    else
                                    {
                                        _local5 = _local6;
                                        _local6 = _local6.cNext;
                                        _local3--;
                                    };
                                }
                                else
                                {
                                    if (_local8.userData[p_property] <= _local6.userData[p_property])
                                    {
                                        _local5 = _local8;
                                        _local8 = _local8.cNext;
                                        _local9--;
                                    }
                                    else
                                    {
                                        _local5 = _local6;
                                        _local6 = _local6.cNext;
                                        _local3--;
                                    };
                                };
                            };
                        };
                        if (_cLastChild)
                        {
                            _cLastChild.cNext = _local5;
                        }
                        else
                        {
                            _cFirstChild = _local5;
                        };
                        _local5.cPrevious = _cLastChild;
                        _cLastChild = _local5;
                    };
                    _local8 = _local6;
                };
                _cLastChild.cNext = null;
                if (_local7 <= 1)
                {
                    return;
                };
                _local4 = (_local4 * 2);
            };
        }

        public function getWorldBounds(p_target:Rectangle=null):Rectangle
        {
            var _local2 = null;
            if (p_target == null)
            {
                p_target = new Rectangle();
            };
            var _local8 = Infinity;
            var _local7 = Number.NEGATIVE_INFINITY;
            var _local9 = Infinity;
            var _local6 = Number.NEGATIVE_INFINITY;
            var _local5:Rectangle = new Rectangle();
            var _local4:FComponent = __cFirstComponent;
            while (_local4)
            {
                _local2 = (_local4 as FRenderable);
                if (_local2)
                {
                    _local2.getWorldBounds(_local5);
                    _local8 = (((_local8)<_local5.x) ? _local8 : _local5.x);
                    _local7 = (((_local7)>_local5.right) ? _local7 : _local5.right);
                    _local9 = (((_local9)<_local5.y) ? _local9 : _local5.y);
                    _local6 = (((_local6)>_local5.bottom) ? _local6 : _local5.bottom);
                };
                _local4 = _local4.cNext;
            };
            var _local3:FNode = _cFirstChild;
            while (_local3)
            {
                _local3.getWorldBounds(_local5);
                _local8 = (((_local8)<_local5.x) ? _local8 : _local5.x);
                _local7 = (((_local7)>_local5.right) ? _local7 : _local5.right);
                _local9 = (((_local9)<_local5.y) ? _local9 : _local5.y);
                _local6 = (((_local6)>_local5.bottom) ? _local6 : _local5.bottom);
                _local3 = _local3.cNext;
            };
            p_target.setTo(_local8, _local9, (_local7 - _local8), (_local6 - _local9));
            return (p_target);
        }


    }
}//package com.flengine.core

