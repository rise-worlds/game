// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAnimListener

package com.genome2d.components.renderables.jointanim
{
    import com.genome2d.context.IContext;
    import com.genome2d.components.renderables.jointanim.JAMemoryImage;
    import flash.geom.Matrix;

    public /*dynamic*/ interface JAnimListener 
    {

        function JAnimPLaySample(_arg1:String, _arg2:int, _arg3:Number, _arg4:Number):void;
        function JAnimObjectPredraw(_arg1:int, _arg2:JAnim, _arg3:IContext, _arg4:JASpriteInst, _arg5:JAObjectInst, _arg6:JATransform, _arg7:JAColor):Boolean;
        function JAnimObjectPostdraw(_arg1:int, _arg2:JAnim, _arg3:IContext, _arg4:JASpriteInst, _arg5:JAObjectInst, _arg6:JATransform, _arg7:JAColor):Boolean;
        function JAnimImagePredraw(_arg1:JASpriteInst, _arg2:JAObjectInst, _arg3:JATransform, _arg4:JAMemoryImage, _arg5:IContext, _arg6:int):int;
        function JAnimStopped(_arg1:int, _arg2:JAnim):void;
        function JAnimCommand(_arg1:int, _arg2:JAnim, _arg3:JASpriteInst, _arg4:String, _arg5:String):Boolean;
        function JAnimImageNotExistDraw(_arg1:String, _arg2:IContext, _arg3:Matrix, _arg4:Number, _arg5:Number, _arg6:Number, _arg7:Number, _arg8:int):void;

    }
}//package com.flengine.components.renderables.jointanim

