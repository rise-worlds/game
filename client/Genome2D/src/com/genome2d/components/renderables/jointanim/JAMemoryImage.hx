package com.genome2d.components.renderables.jointanim;
import com.genome2d.textures.GTexture;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Rectangle;

/**
 * ...
 * @author Rise
 */
class JAMemoryImage {
	public static inline var Image_Uninitialized:Int = 0;
	public static inline var Image_Loading:Int = 1;
	public static inline var Image_Loaded:Int = 2;

	public var width:Int;
	public var height:Int;
	public var numRows:Int;
	public var numCols:Int;
	public var bd:BitmapData;
	public var loadFlag:Int;
	public var name:String;
	public var texture:GTexture;
	public var imageExist:Bool;
	private var onImgLoadCompleted:Dynamic;

	public function new(onLoadCompleted:Dynamic) {
		width = 0;
		height = 0;
		numRows = 1;
		numCols = 1;
		imageExist = true;
		loadFlag = Image_Uninitialized;
		onImgLoadCompleted = onLoadCompleted;
	}

	public function GetCelRect(theCel:Int, out:Rectangle):Void {
		out.height = GetCelHeight();
		out.width = GetCelWidth();
		out.x = ((theCel % numCols) * out.width);
		out.y = ((theCel / numCols) * out.height);
	}

	public function GetCelHeight():Float {
		return ((height / numRows));
	}

	public function GetCelWidth():Float {
		return ((width / numCols));
	}

	public function OnLoadedCompleted(event:Event):Void {
		event.target.removeEventListener("complete", OnLoadedCompleted);
		bd = cast(event.target.content.bitmapData, BitmapData);
		width = bd.width;
		height = bd.height;
		loadFlag = Image_Loaded;
		if (onImgLoadCompleted != null) {
			(onImgLoadCompleted(this));
			onImgLoadCompleted = null;
		};
	}

	public function onBeChanged():Void {
		if (bd != null) {
			width = bd.width;
			height = bd.height;
			loadFlag = Image_Loaded;
		};
	}

	public function Dispose():Void {
		if (texture != null) {
			texture.dispose();
		};
		texture = null;
		if (bd != null) {
			bd.dispose();
		};
	}
}