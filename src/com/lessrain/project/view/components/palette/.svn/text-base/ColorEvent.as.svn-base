package com.lessrain.project.view.components.palette {
	import com.lessrain.project.model.vo.ColorData;

	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class ColorEvent extends Event {

		public static const CLICK : String = 'colorClick';
		private var _color : ColorData;

		public function ColorEvent(type:String, color_ : ColorData, bubbles : Boolean = false, cancelable : Boolean = false) {
			_color = color_;
			super(type, bubbles, cancelable);
		}

		public function get color() : ColorData {
			return _color;
		}
		
		override public function clone():Event{
			return new ColorEvent(type,_color);
		}
	}
}
