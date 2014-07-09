// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FSimpleShape

package com.flengine.components.renderables
{
    import com.flengine.textures.FTexture;
    import __AS3__.vec.Vector;
    import com.flengine.core.FNode;
    import com.flengine.components.FTransform;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FSimpleShape extends FRenderable 
    {

        var cTexture:FTexture;
        protected var _aVertices:Vector.<Number>;
        protected var _aUvs:Vector.<Number>;

        public function FSimpleShape(p_node:FNode)
        {
            super(p_node);
        }

        public function setTexture(p_texture:FTexture):void
        {
            cTexture = p_texture;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            if ((((((cTexture == null)) || ((_aVertices == null)))) || ((_aUvs == null))))
            {
                return;
            };
            var _local4:FTransform = cNode.cTransform;
            p_context.drawPoly(cTexture, _aVertices, _aUvs, _local4.nWorldX, _local4.nWorldY, _local4.nWorldScaleX, _local4.nWorldScaleY, _local4.nWorldRotation, _local4.nWorldRed, _local4.nWorldGreen, _local4.nWorldBlue, _local4.nWorldAlpha, iBlendMode, p_maskRect);
        }

        public function init(p_vertices:Vector.<Number>, p_uvs:Vector.<Number>):void
        {
            _aVertices = p_vertices;
            _aUvs = p_uvs;
        }


    }
}//package com.flengine.components.renderables

