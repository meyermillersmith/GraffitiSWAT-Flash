package com.lessrain.project.view.components.toolpalette {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.ToolData;
	import com.lessrain.project.view.components.ItemBuyEvent;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class ToolButton extends AssetButton {

		public static const LOCKED_CHANGED : String = "locked_changed";
		public static const CIRCLE_WIDTH : int = 50;
		private var _toolData : ToolData;
		private var _buyButton : SimpleTextButton;
		private var _lock : Sprite;
		private var _field : SimpleTextfield;
		private var _arrowButton : PaletteItemArrowButton;
		private var _locked : Boolean;

		public function ToolButton(toolData_ : ToolData) {
			_toolData = toolData_;
			super(drawCircle(0x99918f), drawCircle(0xFFC020));
			drawTool();
		}

		private function drawCircle(color : uint) : Sprite {
			var bg : Sprite = new Sprite();
			bg.graphics.beginFill(color, 1);
			bg.graphics.drawCircle(0, 0, CIRCLE_WIDTH / 2);
			bg.graphics.endFill();
			bg.x = bg.y = CIRCLE_WIDTH / 2;
			return bg;
		}

		private function drawTool() : void {
			var icon : Sprite = asset.addChild(new Sprite()) as Sprite;
			drawIcon(icon,_toolData.key);
			_field = icon.addChild(new SimpleTextfield(_toolData.title, '.toolTitle')) as SimpleTextfield;
			_field.y = CIRCLE_WIDTH;
			_field.x = CIRCLE_WIDTH / 2 - _field.width / 2;
			update();
		}

		private function onBuyClick(event : Event) : void {
			dispatchEvent(new ItemBuyEvent(ItemBuyEvent.BUY, _toolData));
		}

		private function drawIcon(asset : Sprite, assetKey : String) : void {
			var _imageLoader : ImageLoader = new ImageLoader(ApplicationFacade.getProperty('toolsPath')+assetKey+'.png', {onComplete : onIconLoaded, onError : onError});
			// TODO on error!
			asset.addChild(_imageLoader.content);
			_imageLoader.load();
		}

		public function get toolData() : ToolData {
			return _toolData;
		}
		
		override public function set enabled(enabled_ : Boolean) : void {
			super.enabled = enabled_;
			alpha = 1;
		}
		

		private function onError(event : LoaderEvent = null) : void {
		}

		private function onIconLoaded(event : LoaderEvent = null) : void {
			
		}

		public function update() : void {
			locked = _toolData.locked;
		}
		
		public function set locked(locked_ : Boolean) : void {
			if (_locked != locked_){
				_locked = locked_;
				trace('ToolButton::locked:' + locked_);
				
	//			enabled = !locked_;
//				_field.alpha = locked_? .5 : 1;
				alpha = locked_? .5 : 1;
				if (_lock) _lock.visible = locked_;
	//			if (_buyButton) _buyButton.visible = locked_;
				if (_arrowButton) _arrowButton.visible = !locked_;
				
				if (locked_) {
					if (!_lock){
//						_lock  = asset.addChild(ApplicationFacade.getSWFAssetInstance('Lock')) as Sprite;
//						_lock.y =  CIRCLE_WIDTH - 20;
//						_lock.x = CIRCLE_WIDTH - 20;
					}
					
					if (false){
						_buyButton = addChild(new SimpleTextButton(ApplicationFacade.getCopy('surface.buy'), '.sample', 1, CIRCLE_WIDTH, 21, -1, true, 0xEF8F00, 0xFD0035)) as SimpleTextButton;
						_buyButton.addEventListener(SimpleTextButton.CLICK, onBuyClick);
						_buyButton.centerText();
						_buyButton.y =  (CIRCLE_WIDTH - _buyButton.height) / 2;
						_buyButton.x = (CIRCLE_WIDTH - _buyButton.width) / 2;
					}
				}
				dispatchEvent(new Event(LOCKED_CHANGED));
			}
		}
		
		override protected function onClick(event : MouseEvent) : void {
			if (_locked){
				onBuyClick(event);
			} else {
				super.onClick(event);
			}
		}

		public function dispatchClick() : void {
			onClick(new MouseEvent(MouseEvent.CLICK));
		}

		public function set arrowButton(arrowButton : PaletteItemArrowButton) : void {
			_arrowButton = arrowButton;
//			_arrowButton.visible = !_toolData.locked;
		}

		public function get locked() : Boolean {
			return _locked;
		}
	}
}
