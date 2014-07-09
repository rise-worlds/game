package ;
import flash.geom.Matrix;
import com.genome2d.components.renderables.jointanim.JAMemoryImage;
import com.genome2d.components.renderables.jointanim.JAColor;
import com.genome2d.components.renderables.jointanim.JATransform;
import com.genome2d.components.renderables.jointanim.JAObjectInst;
import com.genome2d.components.renderables.jointanim.JASpriteInst;
import com.genome2d.context.IContext;

import com.genome2d.components.renderables.jointanim.JAnim;
import com.genome2d.components.renderables.jointanim.JAnimListener;

/**
 * ...
 * @author Rise
 */
class AnimCallback implements JAnimListener
{

	public function new() 
	{
		
	}
	
	/* INTERFACE com.genome2d.components.renderables.jointanim.JAnimListener */
	
	public function JAnimPLaySample(_arg1:String, _arg2:Int, _arg3:Float, _arg4:Float):Void 
	{
		
	}
	
	public function JAnimObjectPredraw(_arg1:Int, _arg2:JAnim, _arg3:IContext, _arg4:JASpriteInst, _arg5:JAObjectInst, _arg6:JATransform, _arg7:JAColor):Bool 
	{
		return false;
	}
	
	public function JAnimObjectPostdraw(_arg1:Int, _arg2:JAnim, _arg3:IContext, _arg4:JASpriteInst, _arg5:JAObjectInst, _arg6:JATransform, _arg7:JAColor):Bool 
	{
		return false;
	}
	
	public function JAnimImagePredraw(_arg1:JASpriteInst, _arg2:JAObjectInst, _arg3:JATransform, _arg4:JAMemoryImage, _arg5:IContext, _arg6:Int):Int 
	{
		return 0;
	}
	
	public function JAnimStopped(_arg1:Int, _arg2:JAnim):Void 
	{
		_arg2.Play(_arg2.lastPlayedLabel);
	}
	
	public function JAnimCommand(_arg1:Int, _arg2:JAnim, _arg3:JASpriteInst, _arg4:String, _arg5:String):Bool 
	{
		return false;
	}
	
	public function JAnimImageNotExistDraw(_arg1:String, _arg2:IContext, _arg3:Matrix, _arg4:Float, _arg5:Float, _arg6:Float, _arg7:Float, _arg8:Int):Void 
	{
		
	}
	
}