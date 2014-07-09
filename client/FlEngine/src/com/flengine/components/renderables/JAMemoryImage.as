// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.JAMemoryImage

package com.flengine.components.renderables
{
    import flash.display.BitmapData;
    import com.flengine.textures.FTexture;
    import flash.geom.Rectangle;
    import flash.events.Event;

    public class JAMemoryImage 
    {

        public static const Image_Uninitialized:int = 0;
        public static const Image_Loading:int = 1;
        public static const Image_Loaded:int = 2;

        public var width:int;
        public var height:int;
        public var numRows:int;
        public var numCols:int;
        public var bd:BitmapData;
        public var loadFlag:int;
        public var name:String;
        public var texture:FTexture;
        public var imageExist:Boolean;
        private var onImgLoadCompleted:Function;

        public function JAMemoryImage(onLoadCompleted:Function)
        {
            width = 0;
            height = 0;
            numRows = 1;
            numCols = 1;
            imageExist = true;
            loadFlag = 0;
            onImgLoadCompleted = onLoadCompleted;
        }

        public function GetCelRect(theCel:int, out:Rectangle):void
        {
            out.height = GetCelHeight();
            out.width = GetCelWidth();
            out.x = ((theCel % numCols) * out.width);
            out.y = ((theCel / numCols) * out.height);
        }

        public function GetCelHeight():Number
        {
            return ((height / numRows));
        }

        public function GetCelWidth():Number
        {
            return ((width / numCols));
        }

        public function OnLoadedCompleted(event:Event):void
        {
            event.target.removeEventListener("complete", OnLoadedCompleted);
            bd = BitmapData(event.target.content.bitmapData);
            width = bd.width;
            height = bd.height;
            loadFlag = 2;
            if (onImgLoadCompleted != null)
            {
                (onImgLoadCompleted(this));
                onImgLoadCompleted = null;
            };
        }

        public function onBeChanged():void
        {
            if (bd)
            {
                width = bd.width;
                height = bd.height;
                loadFlag = 2;
            };
        }

        public function Dispose():void
        {
            if (texture)
            {
                texture.dispose();
            };
            texture = null;
            if (bd)
            {
                bd.dispose();
            };
        }


    }
}//package com.flengine.components.renderables

