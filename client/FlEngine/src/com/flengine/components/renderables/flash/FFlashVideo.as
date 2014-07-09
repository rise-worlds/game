// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.flash.FFlashVideo

package com.flengine.components.renderables.flash
{
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.media.Video;
    import com.flengine.core.FNode;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;

    public class FFlashVideo extends FFlashObject 
    {

        private static var __iCount:int = 0;

        private var __ncConnection:NetConnection;
        private var __nsStream:NetStream;
        private var __vNativeVideo:Video;
        private var __nAccumulatedTime:int;
        private var __bPlaying:Boolean = false;
        private var __sTextureId:String;

        public function FFlashVideo(p_node:FNode)
        {
            super(p_node);
            _iResampleType = 1;
            __sTextureId = ("G2DVideo#" + __iCount++);
            __ncConnection = new NetConnection();
            __ncConnection.addEventListener("ioError", onIOError);
            __ncConnection.addEventListener("netStatus", onNetStatus);
            __ncConnection.connect(null);
            __nsStream = new NetStream(__ncConnection);
            __nsStream.addEventListener("ioError", onIOError);
            __nsStream.addEventListener("netStatus", onNetStatus);
            __nsStream.client = this;
            __vNativeVideo = new Video();
            __vNativeVideo.attachNetStream(__nsStream);
            _doNative = __vNativeVideo;
        }

        public function get netStream():NetStream
        {
            return (__nsStream);
        }

        public function get nativeVideo():Video
        {
            return (__vNativeVideo);
        }

        public function onMetaData(p_data:Object, ... _args):void
        {
            __vNativeVideo.width = (((p_data.width)!=undefined) ? p_data.width : 320);
            __vNativeVideo.height = (((p_data.height)!=undefined) ? p_data.height : 240);
            if (((!((updateFrameRate == 0))) && (!((p_data.framerate == undefined)))))
            {
                updateFrameRate = p_data.framerate;
            };
        }

        public function onPlayStatus(p_data:Object):void
        {
            if (p_data.code == "Netstream.Play.Complete")
            {
                __bPlaying = false;
            };
        }

        public function onTransition(... _args):void
        {
        }

        public function playVideo(p_url:String):void
        {
            __nsStream.play(p_url);
        }

        private function onIOError(event:IOErrorEvent):void
        {
        }

        private function onNetStatus(event:NetStatusEvent):void
        {
            switch (event.info.code)
            {
                case "NetStream.Play.Stop":
                    __nsStream.seek(0);
                    return;
            };
        }

        override public function dispose():void
        {
            __vNativeVideo = null;
            __nsStream.close();
            __nsStream = null;
            __ncConnection.close();
            __ncConnection = null;
        }


    }
}//package com.flengine.components.renderables.flash

