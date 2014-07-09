// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FColorQuad

package com.flengine.components.renderables
{
    import __AS3__.vec.Vector;
    import com.flengine.context.materials.FDrawColorCameraVertexShaderBatchMaterial;
    import com.flengine.core.FNode;
    import com.flengine.components.FTransform;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FColorQuad extends FRenderable 
    {

        private static var cMaterial:FDrawColorCameraVertexShaderBatchMaterial;
        private static var cTransformVector:Vector.<Number> = new <Number>[0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1];

        public function FColorQuad(p_node:FNode)
        {
            super(p_node);
            if (cMaterial == null)
            {
                cMaterial = new FDrawColorCameraVertexShaderBatchMaterial();
            };
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            if (p_context.checkAndSetupRender(cMaterial, iBlendMode, true, p_maskRect))
            {
                cMaterial.bind(p_context.cContext, p_context.bReinitialize, p_camera);
            };
            var _local4:FTransform = cNode.cTransform;
            cMaterial.draw(_local4.nWorldX, _local4.nWorldY, _local4.nWorldScaleX, _local4.nWorldScaleY, _local4.nWorldRotation, _local4.nWorldRed, _local4.nWorldGreen, _local4.nWorldBlue, _local4.nWorldAlpha);
        }


    }
}//package com.flengine.components.renderables

