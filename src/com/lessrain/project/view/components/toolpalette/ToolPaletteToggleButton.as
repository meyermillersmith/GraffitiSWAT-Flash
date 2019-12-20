package com.lessrain.project.view.components.toolpalette {
	import com.lessrain.project.ApplicationFacade;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class ToolPaletteToggleButton extends ToolPaletteButton {

		protected var _toggledIcon : Sprite;

		public function ToolPaletteToggleButton(assetKey : String, toggledAssetKey : String, radius_ : int = 10, color:uint = 0x000000, overColor:uint = 0xFFC020, overAlpha:Number = 1) {
			super(assetKey, radius_, color, overColor, overAlpha);
			_toggledIcon = ApplicationFacade.getSWFAssetInstance(toggledAssetKey) as Sprite;
			_toggledIcon.x = _toggledIcon.y = radius_;
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
	}
}
