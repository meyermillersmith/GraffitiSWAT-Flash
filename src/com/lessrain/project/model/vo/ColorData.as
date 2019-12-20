package com.lessrain.project.model.vo {
	/**
	 * @author lessintern
	 */
	public class ColorData {
		
		private var _color : uint;
		private var _name : String;
		
		public function ColorData(color_:uint, name_:String = '') {
			_color = color_;
			_name = name_;
		}

		public function get color() : uint {
			return _color;
		}

		public function set color(color : uint) : void {
			_color = color;
		}

		public function get name() : String {
			return _name;
		}

		public function set name(name : String) : void {
			_name = name;
		}
		
	}
}
