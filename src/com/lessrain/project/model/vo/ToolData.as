package com.lessrain.project.model.vo {
	/**
	 * @author lessintern
	 */
	public class ToolData extends BuyableData {
		
		public static const TYPE:String = 'tool';
		private var _subtools:Vector.<ToolData>;
		private var _level:int;
		private var _parent : ToolData;
		private var _position : Number;
		
		public function ToolData() {
			_type = TYPE;
			_subtools = new Vector.<ToolData>();
		}

		public function get subtools() : Vector.<ToolData> {
			return _subtools;
		}

		public function get level() : int {
			return _level;
		}

		public function set level(level : int) : void {
			_level = level;
		}
		
		public function get hasSubTools() : Boolean {
			return _subtools.length > 0;
		}

		public function get parent() : ToolData {
			return _parent;
		}

		public function set parent(parent : ToolData) : void {
			_parent = parent;
		}

		public function contains(child : ToolData) : Boolean {
			if (child == this) return true;
			var currentChild:ToolData = child;
			var currentParent:ToolData = currentChild.parent;
			while (currentParent){
				if (currentParent == this){
					return true;
				} else {
					currentChild = currentParent;
					currentParent = currentChild.parent;
				}
			}
			return false;
		}

		public function set position(position : Number) : void {
			_position = position;
		}

		public function get position() : Number {
			return _position;
		}
	}
}
