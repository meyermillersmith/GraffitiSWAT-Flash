package com.lessrain.project.view.components {
	import se.cambiata.utils.crypt.Simplecrypt;

	import com.greensock.TweenLite;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.Encrypt;
	import com.lessrain.project.view.utils.LessMath;
	import com.lessrain.project.view.utils.RoundAssetButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	/**
	 * @author lessintern
	 */
	public class Banner extends AssetButton {

		private var _closeBtn : RoundAssetButton;
		private var _userId : String;

		public function Banner(userId_ : String, key : String, oyerKey : String, buttonOffset : int = 30) {
			_userId = userId_;
			var sprite : Sprite = ApplicationFacade.getSWFAssetInstance(key) as Sprite;
			var overSprite:Sprite = ApplicationFacade.getSWFAssetInstance(oyerKey) as Sprite;
			super(sprite,overSprite);
			
			_closeBtn = addChild(new RoundAssetButton('PaletteClose')) as RoundAssetButton;
			_closeBtn.addEventListener(AssetButton.CLICK, close);
			_closeBtn.y = 5;
			_closeBtn.x = _asset.width - _closeBtn.width - 5 - buttonOffset;
			
			visible = false;
			y = -height;
			mouseChildren = true;
		}

		private function close(event : Event = null) : void {
			animate(false);
		}
		
		public function show():void{
			visible = true;
			animate(true);
		}

		private function animate(open : Boolean) : void {
			TweenLite.killTweensOf(this);
			TweenLite.to(this, .6, {y:open? 0 : -height, onComplete : open ? onOpened : onClosed});
		}
		
		
		private function onClosed() : void {
			visible = false;
		}
		private function onOpened() : void {
			sendBannerSeen();
		}

		private function sendBannerSeen() : void {
			
			var variables : URLVariables = new URLVariables();
			var key:String = Encrypt.createRandomKey(LessMath.rand(5, 10));
			
			variables.chunks = Simplecrypt.encrypt(_userId,key);
			variables.gid = key;
			
			var request : URLRequest = new URLRequest("php/action/bannerSeen.php");
		    request.method = URLRequestMethod.POST;
		    request.data = variables;

			var loader : URLLoader = new URLLoader(request);
			loader.load(request);
			
		}
		
		override protected function onRoll(event : MouseEvent) : void {
			var bRoll : Boolean = event.type == MouseEvent.ROLL_OVER;
			_overSprite.alpha = bRoll? 1 : 0;
			_sprite.alpha = bRoll? 0 : 1;
			dispatchEvent(new Event(bRoll?ROLL_OVER:ROLL_OUT));
		}

		override protected function onClick(event : MouseEvent) : void {
			if (event.target != _closeBtn){
				super.onClick(event);
				mouseChildren = true;
				try {
					navigateToURL(new URLRequest(ApplicationFacade.getProperty('meemailUrl')),'_blank');
				} catch(e:Error){
					Debug.trace('Banner::onClick:navigateToURL:'+e.getStackTrace(),Debug.ERROR);
				}
				close();
			}
		}

		public function get banner() : Sprite {
			return _asset;
		}
	}
}
