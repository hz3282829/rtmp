package  {
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import app.VideoPlay;
	import flash.events.Event;

	public class Main extends MovieClip 
	{
		
		private var _videoPlay:VideoPlay;
		private var _rtmp:String = "rtmp://play.xyllf.com/iev";
		private var _sid:String = "78103772865616183|7828397E3B4ECD668849A720A86B08DE?k=d9b2cda1513dcb6d35cca1c3642eba93&t=5c1ca9c3";
		private var size:Array =[[840, 630],[510, 900]];
		private var  sizeID:int =0;
		public function Main() {
			
			// constructor code
			init();
		}
		
		//
		private function init():void
		{
			stop();
			_videoPlay = new VideoPlay(100,100);
			addChild(_videoPlay);
			_videoPlay.y = 70;
			_videoPlay.addEventListener("playFaild",playFaildHandle);
			//_videoPlay.play(_rtmp,_sid,size[sizeID][0],size[sizeID][1]);
			btn.addEventListener(MouseEvent.CLICK, playVideo);
			btn.txt.mouseEnabled = false;
			btn.buttonMode = true;
			btn.txt.text = "manual";
			btnb.txt.mouseEnabled = false;
			btnb.buttonMode = true;
			btnb.txt.text = "automatic";
			
			btnb.addEventListener(MouseEvent.CLICK,playVideoAuto);
			
		}
		//
		private function playFaildHandle(e:Event):void
		{
			trace("播放失败");
			msg.text = "播放失败";
		}
		//
		private function playVideoAuto(e:MouseEvent):void
		{
			_videoPlay.play(_rtmp,_sid,size[sizeID][0],size[sizeID][1]);
			trace("auto");
			
		}
		
		//
		private function playVideo(e:MouseEvent):void
		{
			_rtmp = String(atxt.text);
			_sid = String(btxt.text);
			sizeID = parseInt(wtxt.text);
			trace("_rtmp:"+_rtmp+"  _sid:"+_sid+"  sizeID:"+sizeID);
			_videoPlay.play(_rtmp,_sid,size[sizeID][0],size[sizeID][1]);
		}
		

	}
	
}
