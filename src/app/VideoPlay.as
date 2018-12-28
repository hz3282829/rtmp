package app {
import flash.display.Sprite;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.media.Camera;

import flash.media.Microphone;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
	public class VideoPlay extends Sprite {

        private var _rtmpURL:String             = "rtmp://play.fdtz8.com/iev";
        private var _sid:String = "";
		private var w:int =100;
		private var h:int = 100;
		private var video_mc:Video;
        private var nc:NetConnection               = null;
        private var ns:NetStream                   = null;
		private var _nsClient:Object;
		public function VideoPlay(w:int =100,h:int =100) {
            w =w;
            h =h;
			// constructor code
            init();
		}

		private function init():void
		{

            video_mc           = new Video(w, h);
            video_mc.smoothing = true;
            this.addChild(video_mc);
		}
		public function  play(rtmp:String,sid:String,w:int =100,h:int =100):void
		{
            _rtmpURL = rtmp;
			_sid = sid;
			
			w =w;
			h = h;
			trace("play:"," _rtmpURL:",_rtmpURL," _sid:",_sid, "W:",w," H:",h);
            video_mc.width =w;
            video_mc.height =h;
            initNet(_rtmpURL);
			
		}
        // 重置播放 如果是用户则播放
        private function rePlay():void {
            if (!this.ns) {
                return;
            }

            this.video_mc.attachNetStream(this.ns);
            ns.play(_sid);
            trace("开始播放:"+_sid);
        }
        private function connectRTMPServer(src:String):void {
            nc.connect(src);
            trace("链接："+src);
        }
        private function initNet(_rtmp:String):void
        {
            if (nc == null) {
                nc        = new NetConnection();
                nc.client = this;
                nc.addEventListener(NetStatusEvent.NET_STATUS, _netStatusEvent);
                nc.addEventListener(IOErrorEvent.IO_ERROR, _errorEvent);
            }
            if (_rtmpURL != _rtmp || !this.nc.connected) {
                nc.close();
                if (_rtmp != "") {
                    connectRTMPServer(_rtmp);

                }
                _rtmpURL = _rtmp;
            } else {
                dispatchEvent(new Event("connectSuccessEvent"));//流连接成功
                initStream();
            }
        }

        private function _netStatusEvent(e:NetStatusEvent):void {
            trace(e.info.code);
            switch (e.info.code) {
                case "NetConnection.Connect.Success":
                    trace("链接成功");
                    //startRtmpValid();
                    initStream();
                    rePlay();
                    break;
                case "NetConnection.Connect.Closed"://关闭
                case "NetConnection.Connect.Failed"://Error 失败
                case "NetConnection.Connect.Rejected"://Error 没有权限
                    trace("1111111");
				this.dispatchEvent(new Event("playFaild"));
                    break;
                case "NetStream.Publish.Start":
                    trace(22222);
                    break;
                case "NetStream.Publish.BadName"://Error
                    trace(33);
                    break;
                case "NetStream.Record.NoAccess"://Error
                case "NetStream.Record.Failed"://Error
                    trace(4444);
                    break;
                case "NetStream.Play.Start":
                    break;
                case "NetStream.Buffer.Full":
                    break;
                case "NetStream.Video.DimensionChange"://防止播放假死
                    if (this.ns) {
                        this.ns.resume();
                    }
                    break;
                case "NetStream.Play.Stop":
                case "NetStream.Play.UnpublishNotify":
                    break;
                case "NetStream.Play.InsufficientBW"://Error
                    //this.infoText = "带宽不足,请关闭其它应用,确保视频正常播放.";
                    break;
                case "NetStream.Play.Failed"://Error
                case "NetStream.Play.FileStructureInvalid"://Error
                case "NetStream.Play.NoSupportedTrackFound"://Error
                case "NetStream.Play.StreamNotFound"://Error
                    break;
                case "NetStream.Failed":

                    break;
                case "NetConnection.Connect.NetworkChange":
                    break;
                default:
            }
        }

        //*连接出错
        private function _errorEvent(e:*):void {

        }


        private function initStream():void {

            try {
                ns        = new NetStream(
                        nc);
				_nsClient = new Object();
				_nsClient.onMetaData = onMetaDataHandle;
						//ns.audioCodec =
                ns.client = _nsClient;
				ns.bufferTime = 3;
                ns.addEventListener(NetStatusEvent.NET_STATUS, _netStatusEvent);

            } catch (e:*) {

            }
        }

		//
		private function onMetaDataHandle(infoObject:Object):void
		{
			trace("onMetaDataHandle:"+infoObject);
			for each(var i:*  in infoObject)
			{
				trace(" i:",+i,"  content:",infoObject[i]);
			}
		}
        private function startRtmpValid():void {
            trace("验证..");
            nc.call("netping", null);
        }

        private function netping(...args):void {
            //只有参数有3个时才开启验证流程
            trace("111:"+args);
            var arglenth:int = args.length;
            if (arglenth == 3) {
                var result:int = int(args[2]);
                if (result > 1) {
                    result = encrypt(result)
                    nc.call("netping", null, result);
                }

                else if (result == 1) //验证通过
                {
                    initStream();
                    rePlay();

                }
                else if (result == 0) {

                }
            }
        }

        private function encrypt(plainText:int):int
        {
            var KEY:int = 413256489;

            return plainText ^ KEY;
        }
		//
		private function onMetaData(...rest):void
		{
			
		}

	}
	
}
