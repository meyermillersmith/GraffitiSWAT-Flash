package com.lessrain.project.view.utils {
	import com.greensock.TweenLite;
	import com.lessrain.debug.Debug;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author Torsten Haertel, torsten at lessrain.com
	 */
	public class AssetButton extends Sprite {
		
		public static const CLICK : String = 'SimpleButtonClick';
		public static const ROLL_OVER : String = 'SimpleButtonRollOver';
		public static const ROLL_OUT : String = 'SimpleButtonRollOut';
		public static const TOGGLED_CHANGED : String = "SimpleButtonToggleChanged";
		
		protected var _asset : Sprite;
		protected var _enabled : Boolean;
		protected var _sprite : Sprite;
		protected var _overSprite : Sprite;
		protected var _toggled : Boolean;

		public function AssetButton(sprite_:Sprite, overSprite_:Sprite = null) {
			_asset = new Sprite();
			
			_sprite = _asset.addChild(sprite_) as Sprite;
			if (overSprite_){
				_overSprite = _asset.addChild(overSprite_) as Sprite;
				_overSprite.alpha = 0;
			}
			
			addChild(_asset);
			enabled = true;
		}

		public function get enabled() : Boolean {
			return _enabled;
		}

		public function set enabled(enabled_ : Boolean) : void {
			
			if (_enabled != enabled_) {
				_enabled = enabled_;

				buttonMode = _enabled;
				mouseEnabled = _enabled;
				mouseChildren = false;

				if (_enabled && !hasEventListener(MouseEvent.CLICK)) {
					addEventListener(MouseEvent.CLICK, onClick);
					if (_overSprite){
						addEventListener(MouseEvent.ROLL_OVER, onRoll);
						addEventListener(MouseEvent.ROLL_OUT, onRoll);
					}
				}
				else if (!_enabled && hasEventListener(MouseEvent.CLICK)) {
					removeEventListener(MouseEvent.CLICK, onClick);
					removeEventListener(MouseEvent.ROLL_OVER, onRoll);
					removeEventListener(MouseEvent.ROLL_OUT, onRoll);
				}
			}
		}
		
		public function set toggled(toggled_ : Boolean) : void {
			_toggled = toggled_;
			enabled = !toggled_;
			TweenLite.killTweensOf(_overSprite);
			_overSprite.alpha = toggled_? 1 : 0;
			dispatchEvent(new Event(TOGGLED_CHANGED));
		}

		protected function onRoll(event : MouseEvent) : void {
			var bRoll : Boolean = event.type == MouseEvent.ROLL_OVER;
			doRoll(bRoll);
		}
		
		public function doRoll(bRoll : Boolean ) : void {
			TweenLite.to(_overSprite, .2, {alpha:bRoll?1:0});
			dispatchEvent(new Event(bRoll?ROLL_OVER:ROLL_OUT));
		}
		
		protected function onClick(event : MouseEvent) : void {
			dispatchEvent(new Event(CLICK));
		}

		public function finalize() : void {
			enabled = false;
		}

		public function get asset() : Sprite {
			return _asset;
		}

		public function get sprite() : Sprite {
			return _sprite;
		}

		public function get toggled() : Boolean {
			return _toggled;
		}
	}
}
