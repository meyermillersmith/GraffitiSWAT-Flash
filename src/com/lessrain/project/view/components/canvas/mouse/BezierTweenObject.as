package com.lessrain.project.view.components.canvas.mouse {
	/**
	 * @author Torsten Haertel, torsten at lessrain.com
	 */
	public class BezierTweenObject {
		
		private var _y : Number = 0;
		private var _x : Number = 0;
		private var _rotation : Number = 0;
		
		public function BezierTweenObject() {
		}

		public function get y() : Number {
			return _y;
		}

		public function set y(y : Number) : void {
			_y = y;
		}
		
		public function set x(x : Number) : void {
			_x = x;
		}

		public function get x() : Number {
			return _x;
		}

		public function get rotation() : Number {
			return _rotation;
		}

		public function set rotation(rotation : Number) : void {
			_rotation = rotation;
		}
	}
}
