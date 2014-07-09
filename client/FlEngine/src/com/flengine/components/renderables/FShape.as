// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FShape

package com.flengine.components.renderables
{
    import __AS3__.vec.Vector;
    import com.flengine.context.materials.FCameraTexturedPolygonMaterial;
    import com.flengine.textures.FTexture;
    import com.flengine.core.FNode;
    import com.flengine.components.FTransform;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FShape extends FRenderable 
    {

        private static var cTransformVector:Vector.<Number> = new <Number>[0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1];

        protected var _cMaterial:FCameraTexturedPolygonMaterial;
        var cTexture:FTexture;
        protected var _iMaxVertices:int = 0;
        protected var _iCurrentVertices:int = 0;
        protected var _aVertices:Vector.<Number>;
        protected var _aUVs:Vector.<Number>;
        protected var _bDirty:Boolean = false;

        public function FShape(p_node:FNode)
        {
            super(p_node);
            _cMaterial = new FCameraTexturedPolygonMaterial();
        }

        public function setTexture(p_texture:FTexture):void
        {
            cTexture = p_texture;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            if ((((cTexture == null)) || ((_iMaxVertices == 0))))
            {
                return;
            };
            p_context.checkAndSetupRender(_cMaterial, iBlendMode, cTexture.premultiplied, p_maskRect);
            _cMaterial.bind(p_context.cContext, p_context.bReinitialize, p_camera, _iMaxVertices);
            var _local4:FTransform = cNode.cTransform;
            cTransformVector[0] = _local4.nWorldX;
            cTransformVector[1] = _local4.nWorldY;
            cTransformVector[2] = _local4.nWorldScaleX;
            cTransformVector[3] = _local4.nWorldScaleY;
            cTransformVector[4] = cTexture.nUvX;
            cTransformVector[5] = cTexture.nUvY;
            cTransformVector[6] = cTexture.nUvScaleX;
            cTransformVector[7] = cTexture.nUvScaleY;
            cTransformVector[8] = _local4.nWorldRotation;
            cTransformVector[10] = (cTexture.nPivotX * _local4.nWorldScaleX);
            cTransformVector[11] = (cTexture.nPivotY * _local4.nWorldScaleY);
            cTransformVector[12] = (_local4.nWorldRed * _local4.nWorldAlpha);
            cTransformVector[13] = (_local4.nWorldGreen * _local4.nWorldAlpha);
            cTransformVector[14] = (_local4.nWorldBlue * _local4.nWorldAlpha);
            cTransformVector[15] = _local4.nWorldAlpha;
            _cMaterial.draw(cTransformVector, cTexture.cContextTexture.tTexture, cTexture.iFilteringType, _aVertices, _aUVs, _iCurrentVertices, _bDirty);
            _bDirty = false;
        }

        public function init(p_vertices:Vector.<Number>, p_uvs:Vector.<Number>):void
        {
            var _local3:int;
            _bDirty = true;
            _iCurrentVertices = (p_vertices.length / 2);
            if ((p_vertices.length / 2) > _iMaxVertices)
            {
                _iMaxVertices = (p_vertices.length / 2);
                _aVertices = p_vertices;
                _aUVs = p_uvs;
            }
            else
            {
                _local3 = 0;
                while (_local3 < (_iCurrentVertices * 2))
                {
                    _aVertices[_local3] = p_vertices[_local3];
                    _aUVs[_local3] = p_uvs[_local3];
                    _local3++;
                };
            };
        }


    }
}//package com.flengine.components.renderables

