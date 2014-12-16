package ;

import com.genome2d.assets.GAssetManager;
import com.genome2d.assets.GXmlAsset;
import com.genome2d.components.renderables.GMovieClip;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.filters.GHDRPassFilter;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;

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
		genome.onInvalidated.add(genomeInvalidated);
        genome.init(config);
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
		GStats.visible = true;
        initAssets();
    }
	
	private function genomeInvalidated()
	{
		if (sprite != null) sprite.texture.invalidateNativeTexture(false);
	}

    /**
        Initialize assets
     **/
    private function initAssets():Void {
        assetManager = new GAssetManager();
        assetManager.addUrl("atlas_gfx", "fx19_fx01.png");
        assetManager.addUrl("atlas_xml", "fx19_fx01.xml");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

	private var clip:GMovieClip;
    private var sprite:GSprite;

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():Void {
		var textureAltas:GTextureAtlas = GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));
		
		sprite = createSprite(100, 100, "atlas");
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