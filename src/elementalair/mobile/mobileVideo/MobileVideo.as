package elementalair.mobile.mobileVideo {
	
	import flash.media.StageWebView;
	import flash.system.Capabilities;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import elementalair.mobile.events.MobileVideoEvent;
	
	/**
	 * MobileVideo uses the StageWebView class to display the video in a native webview overlay.
	 * The video initially is not set to the full-height of the display as to make room for an underlying
	 * close button so the webview window can be closed from within the air application.
	 * Not having this close button displayed requires the video to be closed in IOS and thus, leaving the 
	 * app.
	 */
	public class MobileVideo extends Sprite {
		
		[Embed(source="../assets/close-button.png", mimeType="image/png")]
		private var CloseVideoButton:Class;
		
		private var _stageVideoView:StageWebView;
		
		private var _stageVideoBlocker:Sprite;
		
		private var _videoUrl:String;
		
		private var _closeVideoButton:Sprite;
		
		private var _parentSprite:Sprite;
		
		public function MobileVideo() {
			this.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private function init(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			this._parentSprite = Sprite(this.parent);
			
			this._closeVideoButton = new Sprite();
			this._closeVideoButton.addChild(new CloseVideoButton() as Bitmap);
			
			var videoWidth:int 	= this._parentSprite.stage.stageWidth;
			var videoHeight:int = this._parentSprite.stage.stageHeight;

			var videoY:int = this._closeVideoButton.height;
			if (Capabilities.screenDPI == 264) {
				videoWidth *= 2;
				videoHeight *= 2;
				videoY *= 2;
			}
			
			this._stageVideoBlocker = new Sprite();
			this._stageVideoBlocker.graphics.beginFill(0x000000);
			this._stageVideoBlocker.graphics.drawRect(0, 0, videoWidth, videoHeight);
			//this._stageVideoBlocker.mouseChildren = false;
			this.addChild(this._stageVideoBlocker);
			
			this._closeVideoButton.x = this._parentSprite.stage.stageWidth - this._closeVideoButton.width - 10;
			this._closeVideoButton.y = 0;
			this._closeVideoButton.addEventListener(MouseEvent.MOUSE_UP, this.closeVideoHandler);
			this._stageVideoBlocker.addChild(this._closeVideoButton);
			
			// Construct new StageWebView
			this._stageVideoView 			= new StageWebView();
			this._stageVideoView.stage 		= this._parentSprite.stage;
			this._stageVideoView.viewPort 	= new Rectangle(0, videoY, videoWidth, (videoHeight - this._closeVideoButton.height));
			
			this._stageVideoView.addEventListener(Event.ACTIVATE, this.stageVideoViewEventHandler);
			this._stageVideoView.addEventListener(Event.DEACTIVATE, this.stageVideoViewEventHandler);
			this._stageVideoView.addEventListener(Event.COMPLETE, this.stageVideoViewEventHandler);
			this._stageVideoView.addEventListener(ErrorEvent.ERROR, this.stageVideoViewErrorEventHandler);
			
			this._stageVideoView.loadURL(this._videoUrl);
		}
		
		private function closeVideoHandler(evt:MouseEvent):void {
			this.dispose();
		}
		
		private function stageVideoViewEventHandler(evt:Event):void {
			switch (evt.type) {
				case Event.ACTIVATE:
					trace(this + ' ACTIVATED');
					this.dispatchEvent(new MobileVideoEvent(MobileVideoEvent.ACTIVATE));
					break;
				case Event.DEACTIVATE:
					trace(this + ' DEACTIVATED');
					this.dispatchEvent(new MobileVideoEvent(MobileVideoEvent.DEACTIVATE));
					break;
				case Event.COMPLETE:
					trace(this + ' COMPLETE');
					this.dispatchEvent(new MobileVideoEvent(MobileVideoEvent.COMPLETE));
					break;
			}
		}
		
		private function stageVideoViewErrorEventHandler(evt:ErrorEvent):void {
			trace(this + ' StageWebView error: ' + evt.text);
			this.dispatchEvent(new MobileVideoEvent(MobileVideoEvent.ERROR));
		}
		
		/**
		 * Absolute path to video file.
		 * var path:String = new File(new File("app:/path_to_video.mp4").nativePath).url;
		 */
		public function get videoUrl():String {
			return this._videoUrl;
		}
		
		public function set videoUrl(p_videoUrl:String):void {
			this._videoUrl = p_videoUrl;
		}
		
		/**
		 * Remove and clean-up MobileVideo object.
		 */
		public function dispose():void {
			try {	
				this._closeVideoButton.removeEventListener(MouseEvent.MOUSE_UP, this.dispose);
				this.removeChild(this._stageVideoBlocker);
				this._stageVideoBlocker = null;
				
				this._stageVideoView.stage = null;
				this._stageVideoView.dispose();
				this._stageVideoView = null;
			} catch(e:Error) { }
			
			this.dispatchEvent(new MobileVideoEvent(MobileVideoEvent.DISPOSED));
		}
		
	}
}