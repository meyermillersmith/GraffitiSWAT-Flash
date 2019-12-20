package com.lessrain.project.view.utils {
	import com.lessrain.project.ApplicationFacade;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class RoundToggleButton extends RoundAssetButton {

		protected var _toggledIcon : Sprite;

		public function RoundToggleButton(assetKey : String, toggledAssetKey : String, radius_ : int = 10, color:uint = 0x000000, overColor:uint = 0xFFC020, overAlpha:Number = 1) {
			super(assetKey, radius_, color, overColor, overAlpha);
			setToggledIcon(toggledAssetKey);
		}
		
		override public function set toggled(toggled_ : Boolean) : void {
			_toggled = toggled_;
			try {
				removeChild(toggled_?_icon : _toggledIcon);
			}catch(e:Error){
			}
			addChild(toggled_?_toggledIcon : _icon);
		}
		
		override protected function onClick(event : MouseEvent) : void {
			toggled = !_toggled;
			dispatchEvent(new Event(CLICK));
		}
		
		protected function setToggledIcon(assetKey:String):void{
			if (_toggledIcon && _toggledIcon.parent) _toggledIcon.parent.removeChild(_toggledIcon);
			_toggledIcon = ApplicationFacade.getSWFAssetInstance(assetKey) as Sprite;
			_toggledIcon.x = _toggledIcon.y = _radius;
		}
	}
}
