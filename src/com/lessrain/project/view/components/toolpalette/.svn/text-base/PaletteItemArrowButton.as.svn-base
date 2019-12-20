package com.lessrain.project.view.components.toolpalette {
	import com.greensock.TweenLite;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.RoundToggleButton;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class PaletteItemArrowButton extends RoundToggleButton {

		private var _target : ToolButton;
		private var _assetKey : String;
		private var _locked : Boolean;

		public function PaletteItemArrowButton(iconScaleFactor : Number = 1, radius_ : int = 10, color:uint = 0x000000,target_:ToolButton = null) {
			_locked = target_ && target_.locked;
			_assetKey = _locked? 'Lock' : 'PaletteArrow';
			super(_assetKey, _assetKey, radius_,color);
			if (target_) target = target_;
//			_toggledIcon.rotation = -90;
			if (iconScaleFactor!= 1){
//				_toggledIcon.scaleX = _toggledIcon.scaleY = iconScaleFactor;
				_icon.scaleX = _icon.scaleY = iconScaleFactor;
			}
		}

		override protected function onRoll(event : MouseEvent) : void {
			var bRoll : Boolean = event.type == MouseEvent.ROLL_OVER;
			if (!_locked) {
				TweenLite.to(_icon, .2, {rotation:bRoll == toggled?0:-90});
			}
			if (toggled) {
				super.onRoll(event);
			}
		}

		public function set target(target : ToolButton) : void {
			_target = target;
			toggledToTarget();
			_target.addEventListener(AssetButton.TOGGLED_CHANGED, toggledToTarget);
			_target.addEventListener(ToolButton.LOCKED_CHANGED, lockedToTarget);
		}

		private function toggledToTarget(event : Event = null) : void {
//			enabled = !_target.toggled;
			toggled = !_target.toggled;
			_overSprite.alpha = toggled? 0 : 1;
		}

		private function lockedToTarget(event : Event = null) : void {
			_locked = _target && _target.locked;
			_assetKey = _locked? 'Lock' : 'PaletteArrow';
			setToggledIcon(_assetKey);
			setIcon(_assetKey);
		}
		
		override public function set toggled(toggled_ : Boolean) : void {
			_toggled = toggled_;
			if (!_locked) {
				_icon.rotation = toggled_?-90:0;
			}
		}
		
		override protected function onClick(event : MouseEvent) : void {
			if (_target) _target.dispatchClick();
			else super.onClick(event);
		}
	}
}
