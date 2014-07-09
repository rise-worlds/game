package com.genome2d.components.renderables.jointanim;
import com.genome2d.context.IContext;
import flash.geom.Matrix;

/**
 * ...
 * @author Rise
 */
interface JAnimListener {
	function JAnimPLaySample(_arg1:String, _arg2:Int, _arg3:Float, _arg4:Float):Void;
	function JAnimObjectPredraw(_arg1:Int, _arg2:JAnim, _arg3:IContext, _arg4:JASpriteInst, _arg5:JAObjectInst, _arg6:JATransform, _arg7:JAColor):Bool;
	function JAnimObjectPostdraw(_arg1:Int, _arg2:JAnim, _arg3:IContext, _arg4:JASpriteInst, _arg5:JAObjectInst, _arg6:JATransform, _arg7:JAColor):Bool;
	function JAnimImagePredraw(_arg1:JASpriteInst, _arg2:JAObjectInst, _arg3:JATransform, _arg4:JAMemoryImage, _arg5:IContext, _arg6:Int):Int;
	function JAnimStopped(_arg1:Int, _arg2:JAnim):Void;
	function JAnimCommand(_arg1:Int, _arg2:JAnim, _arg3:JASpriteInst, _arg4:String, _arg5:String):Bool;
	function JAnimImageNotExistDraw(_arg1:String, _arg2:IContext, _arg3:Matrix, _arg4:Float, _arg5:Float, _arg6:Float, _arg7:Float, _arg8:Int):Void;

}