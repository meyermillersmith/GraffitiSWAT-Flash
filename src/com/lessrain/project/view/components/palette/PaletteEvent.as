package com.lessrain.project.view.components.palette {
	import com.lessrain.project.model.vo.PaletteData;

	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class PaletteEvent extends Event {

		public static const CLICK : String = 'paletteButtonClick';
		private var _palette : PaletteData;

		public function PaletteEvent(type : String, surface_ : PaletteData, bubbles : Boolean = false, cancelable : Boolean = false) {
			_palette = surface_;
			super(type, bubbles, cancelable);
		}

		public function get palette() : PaletteData {
			return _palette;
		}
		
		override public function clone():Event{
			return new PaletteEvent(type, _palette);
		}
	}
}
