package ;

import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderables.GMovieClip;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.jointanim.JAnim;
import com.genome2d.components.renderables.jointanim.JointAnimate;
import com.genome2d.context.filters.GHDRPassFilter;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import flash.net.URLRequest;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.net.URLLoaderDataFormat;
import flash.net.URLLoader;
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * ...
 * @author Rise
 */

class Main 
{
	static public function main() {
        var inst = new Main();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
		var config = new GContextConfig();
        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
		genome.onUpdate.add(genomeUpdateHandler);
		genome.onPostRender.add(genomeRenderHandler);
        genome.init(config);
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
		GStats.visible = true;
        initAssets();
    }

    /**
        Initialize assets
     **/
    private function initAssets():Void {
        assetManager = new GAssetManager();
        //assetManager.addUrl("atlas_gfx", "building1.png");
        //assetManager.addUrl("atlas_xml", "building1.xml");
        //assetManager.addUrl("atlas_gfx", "cloud.png");
        //assetManager.addUrl("atlas_xml", "cloud.xml");
        assetManager.addUrl("atlas_gfx", "vs.png");
        assetManager.addUrl("atlas_xml", "vs.xml");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

	private var clip:GMovieClip;
    private var sprite:GSprite;
	private var anim:JAnim;

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():Void {
		var urlLoader:URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		urlLoader.addEventListener(Event.COMPLETE, g2d_completeHandler);
		//urlLoader.addEventListener(IOErrorEvent.IO_ERROR, g2d_ioErrorHandler);
		//urlLoader.load(new URLRequest("building1.pam"));
		//urlLoader.load(new URLRequest("cloud.pam"));
		urlLoader.load(new URLRequest("vs.pam"));
		JAnim.HelpCallInitialize();
    }
	
	private function g2d_completeHandler(p_event:Event):Void
	{
		var g2d_bytes:ByteArray = cast(p_event.target.data, ByteArray);
		g2d_bytes.endian = Endian.LITTLE_ENDIAN;
		g2d_bytes.position = 0;
		var callback:AnimCallback = new AnimCallback();
		var textureAltas:GTextureAtlas = GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));
		var joint:JointAnimate = new JointAnimate();
		joint.LoadPam(g2d_bytes, textureAltas);
		//var anim:JAnim = new JAnim(null, joint, 0);
		anim = cast GNodeFactory.createNodeWithComponent(JAnim);
		//anim = new JAnim();
		anim.setJointAnim(joint, 0, callback);
		anim.interpolate = false;
		//anim.Play("MOVE_F");
		anim.Play("VS");
		//anim.Play("ZC_HG");
		//anim.Play("CLOUD");
		anim.mirror = true;
		//anim.color = cast 0xAABBCCDDEE;
		//anim.filter = new GHDRPassFilter();
		anim.transform.LoadIdentity();
		//anim.transform.Translate(100, 100);
		genome.root.addChild(anim.node);
		
		//sprite = createSprite(100, 100, "atlas_GENERAL101B_MOVE_F0000");
		//var clip:GMovieClip;
        //clip = createMovieClip(500, 400, ["atlas_GENERAL101B_MOVE_F0000",
										  //"atlas_GENERAL101B_MOVE_F0001",
										  //"atlas_GENERAL101B_MOVE_F0002",
										  //"atlas_GENERAL101B_MOVE_F0003",
										  //"atlas_GENERAL101B_MOVE_F0004",
										  //"atlas_GENERAL101B_MOVE_F0005",
										  //"atlas_GENERAL101B_MOVE_F0006",
										  //"atlas_GENERAL101B_MOVE_F0007",
										  //"atlas_GENERAL101B_MOVE_F0008",
										  //"atlas_GENERAL101B_MOVE_F0009"]);
	}
	
	private var list:Array<String> = 
			["atlas_GENERAL101B_MOVE_F0000",
			 "atlas_GENERAL101B_MOVE_F0001",
			 "atlas_GENERAL101B_MOVE_F0002",
			 "atlas_GENERAL101B_MOVE_F0003",
			 "atlas_GENERAL101B_MOVE_F0004",
			 "atlas_GENERAL101B_MOVE_F0005",
			 "atlas_GENERAL101B_MOVE_F0006",
			 "atlas_GENERAL101B_MOVE_F0007",
			 "atlas_GENERAL101B_MOVE_F0008",
			 "atlas_GENERAL101B_MOVE_F0009"];
	private var g2d_accumulatedTime:Float = 0;
	private var g2d_currentFrame:Int = 0;
	
	private function genomeUpdateHandler(time:Float):Void
	{
		if (anim != null)
		{
			anim.Update(time * 0.1);
			//anim._update(time * 0.1);
		}
		if (sprite != null) 
		{
			g2d_accumulatedTime += genome.root.core.getCurrentFrameDeltaTime();
			if (g2d_accumulatedTime >= 100) {
				g2d_currentFrame += Std.int(g2d_accumulatedTime / 100);
				//if (g2d_currentFrame == list.length) 
				//{
				//	g2d_currentFrame = 1;
				//}
				//else 
				{
					g2d_currentFrame %= list.length;
				}
				//sprite.textureId = list[g2d_currentFrame];
				g2d_accumulatedTime %= 100;
				//Lib.trace(g2d_currentFrame);
				//Lib.trace(list[g2d_currentFrame]);
			}
		}
	}
	
	private function genomeRenderHandler():Void
	{
		if (anim != null)
		{
			anim.Draw(genome.getContext());
		}
	}

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.textureId = p_textureId;
        sprite.node.transform.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
	
	private function createMovieClip(p_x:Float, p_y:Float, p_frames:Array<String>):GMovieClip {
        var clip:GMovieClip = cast GNodeFactory.createNodeWithComponent(GMovieClip);
        clip.frameRate = 10;
        clip.frameTextureIds = p_frames;
		clip.repeatable = false;
        clip.node.transform.setPosition(p_x, p_y);
        genome.root.addChild(clip.node);
        return clip;
    }
	
	/**
        Mouse click handler
     **/
    private function mouseClickHandler(signal:GNodeMouseSignal):Void {
        trace("CLICK", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse over handler
     **/
    private function mouseOverHandler(signal:GNodeMouseSignal):Void {
        trace("OVER", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse out handler
     **/
    private function mouseOutHandler(signal:GNodeMouseSignal):Void {
        trace("OUT", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse down handler
     **/
    private function mouseDownHandler(signal:GNodeMouseSignal):Void {
        trace("DOWN", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse up handler
     **/
    private function mouseUpHandler(signal:GNodeMouseSignal):Void {
        trace("UP", signal.dispatcher.name, signal.target.name);
    }
}