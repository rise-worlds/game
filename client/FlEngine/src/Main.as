package 
{
	import com.flengine.fl2d;
	import com.flengine.components.FCamera;
	import com.flengine.components.renderables.FSprite;
	import com.flengine.core.FConfig;
	import com.flengine.core.FNode;
	import com.flengine.core.FlEngine;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	use namespace fl2d;
	/**
	 * ...
	 * @author Rise
	 */
	public class Main extends Sprite 
	{
		private var genome:FlEngine;
		private var container:FNode;
        private var camera:FCamera;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var config:FConfig = new FConfig(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			//config.enableStats = true;
			// Initialize Genome2D
			genome = FlEngine.getInstance();
			genome.onInitialized.addOnce(initialized);
			genome.init(stage, config);
		}
		
		private function initialized(parm:Object):void {
			container = new FNode("container");
            container.transform.x = stage.stageWidth/2;
            container.transform.y = stage.stageHeight/2;
            genome.root.addChild(container);
            camera = FCamera(container.addComponent(FCamera));
            var back:FNode = new FNode("back");
            back.transform.setScale(800 / 600, 400 / 300);
			var sprite:FSprite = FSprite(back.addComponent(FSprite));
			container.addChild(back);
		 }
	}
	
}