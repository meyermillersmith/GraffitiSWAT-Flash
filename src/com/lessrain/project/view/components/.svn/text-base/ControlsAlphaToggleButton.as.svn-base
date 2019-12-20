package com.lessrain.project.view.components {
	import com.lessrain.debug.Debug;
	import com.lessrain.project.view.utils.RoundToggleButton;
	import flash.display.Sprite;

	/**
	 * @author lessintern
	 */
	public class ControlsAlphaToggleButton extends RoundToggleButton {

		private var _toggledSprite : Sprite;

		public function ControlsAlphaToggleButton(assetKey : String, toggledAssetKey : String, radius_ : int = 10, color : uint = 0x000000, overColor : uint = 0xFFC020, overAlpha : Number = 1) {
			super(assetKey, toggledAssetKey, radius_, color, overColor, overAlpha);
			_toggledSprite = _asset.addChild(drawCircle(overColor)) as Sprite;
			_asset.setChildIndex(_toggledSprite, 0);
			alpha = .5;
		}
		
		override public function set toggled(toggled_ : Boolean) : void {
			Debug.trace('ControlsAlphaToggleButton::toggled:'+toggled_);
			if (_toggled != toggled_){
				super.toggled = toggled_;
				alpha = getAlpha();
				Debug.trace('ControlsAlphaToggleButton::toggled:swap kids');
				_asset.setChildIndex(_toggledSprite, _toggled? 1 : 0);
				_asset.setChildIndex(_sprite, _toggled? 0 : 1);
			}
		}
		
		override public function set enabled(enabled_ : Boolean) : void {
			super.enabled = enabled_;
			alpha = enabled? getAlpha() : 0;
		}
		
		private function getAlpha():Number{
			return toggled? 1 : .5;
		}
	}
}
