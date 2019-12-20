package com.lessrain.project.view.components.toolpalette {
	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class ToolPaletteEvent extends Event {
		
		public static const CHANGED:String = 'toolSizeChanged';
		
		public static const SPRAY_MODE:String 	= 'sprayCap';
		public static const PEN_MODE:String 	= 'pen';
		public static const ROLLER_MODE:String 	= 'roller';

		private var _toolType : String;
		private var _toolSize : int;
		private var _toolBrushIndex : int;

		public function ToolPaletteEvent(type : String, toolType : String, toolSize : int = 0, toolBrushIndex : int = 0, bubbles : Boolean = false, cancelable : Boolean = false) {
			_toolSize = toolSize;
			_toolType = toolType;
			_toolBrushIndex = toolBrushIndex;
			super(type, bubbles, cancelable);
		}

		public function get toolType() : String {
			return _toolType;
		}

		public function get toolSize() : int {
			return _toolSize;
		}
		
		override public function clone():Event{
			return new ToolPaletteEvent(type, toolType, toolSize, toolBrushIndex);
		}

		public function get toolBrushIndex() : int {
			return _toolBrushIndex;
		}
	}
}
