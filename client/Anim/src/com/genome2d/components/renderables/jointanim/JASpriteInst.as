package com.genome2d.components.renderables.jointanim
{	
	public class JASpriteInst
	{
		public var parent:JASpriteInst;
		public var delayFrames:int;
		public var frameNum:Number;
		public var lastFrameNum:Number;
		public var frameRepeats:int;
		public var onNewFrame:Boolean;
		public var lastUpdated:int;
		public var curTransform:JATransform;
		public var curColor:JAColor;
		public var children:Vector.<JAObjectInst>;
		public var spriteDef:JASpriteDef;
		
		public function JASpriteInst()
		{
			children = new Vector.<JAObjectInst>();
			curTransform = new JATransform();
			spriteDef = null;
		}
		
		public function Dispose():void
		{
			var i:int = 0;
			while (i < children.length)
			{
				children[i].Dispose();
				i++;
			}
			
			children.splice(0, children.length);
			children = null;
			curTransform = null;
			spriteDef = null;
			curColor = null;
		}
		
		public function Reset():void
		{
			var i:int = 0;
			while (i < children.length)
			{
				children[i].Dispose();
				i++;
			}
			
			children.splice(0, children.length);
		}
	
	}
}