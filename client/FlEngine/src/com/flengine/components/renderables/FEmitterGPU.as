// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FEmitterGPU

package com.flengine.components.renderables
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import com.flengine.textures.FTexture;
    import com.flengine.context.materials.FCameraTexturedParticlesBatchMaterial;
    import com.flengine.core.FNode;
    import com.flengine.components.FTransform;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FEmitterGPU extends FRenderable 
    {

        private static var __aCached:Dictionary = new Dictionary();
        static var aTransformVector:Vector.<Number> = new <Number>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

        var aParticles:Vector.<Number>;
        var nCurrentTime:int = 0;
        var iMaxParticles:int;
        var iActiveParticles:int;
        var cTexture:FTexture;
        var sHash:String;
        protected var _cMaterial:FCameraTexturedParticlesBatchMaterial;

        public function FEmitterGPU(p_node:FNode)
        {
            super(p_node);
        }

        public function get activeParticles():int
        {
            return (iActiveParticles);
        }

        public function set activeParticles(p_particleCount:int):void
        {
            iActiveParticles = p_particleCount;
        }

        public function setTexture(p_texture:FTexture):void
        {
            cTexture = p_texture;
        }

        public function get textureId():String
        {
            if (cTexture)
            {
                return (cTexture.id);
            };
            return ("");
        }

        public function set textureId(p_value:String):void
        {
            cTexture = FTexture.getTextureById(p_value);
        }

        public function initialize(p_timeOffset:Number, p_offsetX:Number, p_offsetY:Number, p_emitAngle:Number, p_minVelocity:int, p_maxVelocity:int, p_minStartScale:Number, p_maxStartScale:Number, p_minEndScale:Number, p_maxEndScale:Number, p_sameScale:Boolean, p_startAlpha:Number, p_endAlpha:Number, p_minEnergy:int, p_maxEnergy:int, p_maxParticles:int, p_seed:int=0):void
        {
            var _local21:int;
            var _local20:Number;
            var _local22:Number;
            var _local19:Number;
            var _local23:Number;
            var _local18:Number;
            sHash = ((((((((((((((((((((((((((((((((p_timeOffset + "|") + p_offsetX) + "|") + p_offsetY) + "|") + p_emitAngle) + "|") + p_minVelocity) + "|") + p_maxVelocity) + "|") + p_minStartScale) + "|") + p_maxStartScale) + "|") + p_minEndScale) + "|") + p_maxEndScale) + "|") + p_sameScale) + "|") + p_startAlpha) + "|") + p_endAlpha) + "|") + p_minEnergy) + "|") + p_maxEnergy) + "|") + p_maxParticles) + "|") + p_seed);
            iMaxParticles = p_maxParticles;
            aParticles = __aCached[sHash];
            if (aParticles != null)
            {
                return;
            };
            aParticles = new Vector.<Number>();
            cRenderData = null;
            _local21 = 0;
            while (_local21 < iMaxParticles)
            {
                aParticles.push(((Math.random() * p_offsetX) - (p_offsetX * 0.5)), ((Math.random() * p_offsetY) - (p_offsetY * 0.5)));
                _local20 = ((Math.random() * p_emitAngle) - (p_emitAngle * 0.5));
                _local22 = Math.sin(_local20);
                _local19 = Math.cos(_local20);
                _local23 = ((Math.random() * (p_maxVelocity - p_minVelocity)) + p_minVelocity);
                aParticles.push((_local23 * _local19), (_local23 * _local22));
                if (!p_sameScale)
                {
                    aParticles.push(((Math.random() * (p_maxStartScale - p_minStartScale)) + p_minStartScale), ((Math.random() * (p_maxEndScale - p_minEndScale)) + p_minEndScale));
                }
                else
                {
                    _local18 = ((Math.random() * (p_maxStartScale - p_minStartScale)) + p_minStartScale);
                    aParticles.push(_local18, _local18);
                };
                aParticles.push(p_startAlpha, p_endAlpha);
                aParticles.push((_local21 * p_timeOffset), ((Math.random() * (p_maxEnergy - p_minEnergy)) + p_minEnergy));
                _local21++;
            };
            __aCached[sHash] = aParticles;
            iActiveParticles = iMaxParticles;
            _cMaterial = FCameraTexturedParticlesBatchMaterial.getByHash(sHash);
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            nCurrentTime = (nCurrentTime + p_deltaTime);
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            if ((((((cTexture == null)) || ((iMaxParticles == 0)))) || ((_cMaterial == null))))
            {
                return;
            };
            if (p_context.checkAndSetupRender(_cMaterial, iBlendMode, cTexture.premultiplied, p_maskRect))
            {
                _cMaterial.bind(p_context.cContext, p_context.bReinitialize, p_camera, aParticles);
            };
            var _local4:FTransform = cNode.cTransform;
            aTransformVector[0] = _local4.nWorldX;
            aTransformVector[1] = _local4.nWorldY;
            aTransformVector[2] = (cTexture.iWidth * _local4.nWorldScaleX);
            aTransformVector[3] = (cTexture.iHeight * _local4.nWorldScaleY);
            aTransformVector[4] = cTexture.nUvX;
            aTransformVector[5] = cTexture.nUvY;
            aTransformVector[6] = cTexture.nUvScaleX;
            aTransformVector[7] = cTexture.nUvScaleY;
            aTransformVector[8] = _local4.nWorldRotation;
            aTransformVector[9] = nCurrentTime;
            aTransformVector[10] = 2;
            aTransformVector[11] = 1;
            aTransformVector[12] = 1;
            aTransformVector[13] = 1;
            aTransformVector[14] = 1;
            aTransformVector[15] = 0.1;
            _cMaterial.draw(aTransformVector, cTexture.cContextTexture.tTexture, cTexture.iFilteringType, iActiveParticles);
        }


    }
}//package com.flengine.components.renderables

