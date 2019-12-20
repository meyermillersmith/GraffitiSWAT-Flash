package com.lessrain.project.view.components.surfaces {
	import com.lessrain.project.model.vo.SurfaceData;

	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class SurfaceEvent extends Event {

		public static const CLICK : String = 'surfaceButtonClick';
		public static const BUY : String = 'surfaceButtonBuyClick';
		public static const BOUGHT : String = 'surfaceBought';
		private var _surface : SurfaceData;

		public function SurfaceEvent(type : String, surface_ : SurfaceData, bubbles : Boolean = false, cancelable : Boolean = false) {
			_surface = surface_;
			super(type, bubbles, cancelable);
		}

		public function get surface() : SurfaceData {
			return _surface;
		}
		
		override public function clone():Event{
			return new SurfaceEvent(type, _surface);
		}
	}
}
