package com.lessrain.project.view.components.surfaces {
	import flash.filters.DropShadowFilter;
	import flash.display.BlendMode;

	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.SurfaceData;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class SurfaceButton extends AssetButton {

		public static const ROLL_OVER : String = 'SurfaceButtonRollOver';
		public static const ROLL_OUT : String = 'SurfaceButtonRollOut';
		public static const SIZE : int = 90;
		public static const CIRCLEPOS : int = SIZE / 2;
		public static const INNER_SIZE : int = 60;
		public static const THUMBNAIL_LOADED : String = "thumbnailLoaded";
		private var _surfaceData : SurfaceData;
		private var _thumbnail : Sprite;
		private var _title : SimpleTextfield;
		private var _buyButton : SimpleTextButton;
		private var _price : SimpleTextfield;
		private var _yPos : Number;

		public function SurfaceButton(surfaceData_ : SurfaceData) {
			_surfaceData = surfaceData_;
			
			super(drawBGCircle(0x000000, .5), new Sprite());
			
			if (_surfaceData) {
				var thumbnailUrl : String = ApplicationFacade.getProperty('surfacesPath') + _surfaceData.key + '/thumbnail_90.png';

				var thumbnailLoader : ImageLoader = new ImageLoader(thumbnailUrl, {onComplete : onImageLoaded, onError : onError});
				thumbnailLoader.load();
				_thumbnail = thumbnailLoader.content;

				_asset.addChild(_thumbnail);

				setTitle(_surfaceData.title);

				_price = addChild(new SimpleTextfield('', '.price', SIZE)) as SimpleTextfield;
				_price.y = _title.y + _title.height - 5;

				bought = _surfaceData.bought;
			} else {
				var lock : Sprite = addChild(ApplicationFacade.getSWFAssetInstance('SurfaceFiller')) as Sprite;
				lock.x = lock.y = (SIZE - lock.width)/2;
				lock.filters = [new DropShadowFilter(5,45,0,1,7,7)];
				setTitle(ApplicationFacade.getCopy('surface.filler'));
				enabled = false;
			}
		}

		private function setTitle(titleTxt : String) : void {
			_title = addChild(new SimpleTextfield(titleTxt, '.surfaceTitle', SIZE)) as SimpleTextfield;
			_title.y = SIZE;
			_title.x = (SIZE - _title.width) / 2;
			_title.alpha = .8;
		}

		override protected function onRoll(event : MouseEvent) : void {
			var bRoll : Boolean = event.type == MouseEvent.ROLL_OVER;
			TweenLite.to(_asset, .4, {y : bRoll ? - 5 : 0});
			TweenLite.to(_title, .4, {alpha : bRoll ? 1 : .6});
			super.onRoll(event);
			dispatchEvent(new SurfaceEvent(bRoll ? ROLL_OVER : ROLL_OUT, _surfaceData));
		}

		private function drawBGCircle(color_ : uint, alpha_ : Number) : Sprite {
			var circle : Sprite = new Sprite();
			circle.graphics.beginFill(color_, alpha_);
			circle.graphics.drawCircle(0, 0, SIZE / 2);
			circle.graphics.endFill();
			circle.x = circle.y = SIZE / 2;
			if (color_ == 0) circle.blendMode = BlendMode.MULTIPLY;
			return circle;
		}

		public function set bought(wasBought : Boolean) : void {
			if (_surfaceData.price == 0) {
				_price.text = ApplicationFacade.getCopy('surface.free');
			} else if (wasBought) {
				_price.text = ApplicationFacade.getCopy('surface.unlocked');
				if (_buyButton && contains(_buyButton)) {
					removeChild(_buyButton);
					_buyButton.finalize();

					addEventListener(MouseEvent.CLICK, onClick);
					removeEventListener(MouseEvent.CLICK, onBuyClick);
				}
			} else {
				_price.text = _surfaceData.price + ' ' + ApplicationFacade.getCopy('surface.currency');

				_buyButton = addChild(new SimpleTextButton(ApplicationFacade.getCopy('surface.buy'), '.sample', 1, INNER_SIZE - 10, 21, -1, true, 0xFD0035, 0xEF8F00)) as SimpleTextButton;
				_buyButton.addEventListener(SimpleTextButton.CLICK, onBuyClick);
				_buyButton.centerText();
				_buyButton.y = _price.y + _price.height - 3;
				_buyButton.x = (SIZE - _buyButton.width) / 2;

				addEventListener(MouseEvent.CLICK, onBuyClick);
				removeEventListener(MouseEvent.CLICK, onClick);
			}
		}

		private function onImageLoaded(event : LoaderEvent) : void {
//			var scale : Number = Math.min(ICON_SIZE / _thumbnail.width, ICON_SIZE / _thumbnail.height);
//			_thumbnail.scaleX = _thumbnail.scaleY = scale;
			_thumbnail.x = (SIZE - _thumbnail.width) / 2;
			_yPos = (SIZE - _thumbnail.height) / 2;
			_thumbnail.y = _yPos;
			dispatchLoaded();
		}

		private function onError(event : LoaderEvent) : void {
			dispatchEvent(new Event(THUMBNAIL_LOADED));
		}

		private function dispatchLoaded() : void {
			dispatchEvent(new Event(THUMBNAIL_LOADED));
		}

		override protected function onClick(event : MouseEvent) : void {
			Debug.trace('SurfaceButton::onClick:' + _surfaceData.key);
			dispatchEvent(new SurfaceEvent(SurfaceEvent.CLICK, _surfaceData));
		}

		private function onBuyClick(event : Event) : void {
			dispatchEvent(new SurfaceEvent(SurfaceEvent.BUY, _surfaceData));
		}

		public function get key() : String {
			return _surfaceData.key;
		}

		public function get surfaceData() : SurfaceData {
			return _surfaceData;
		}
	}
}
