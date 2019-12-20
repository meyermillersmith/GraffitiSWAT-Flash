package com.lessrain.project.model.vo {
	/**
	 * @author lessintern
	 */
	public class BuyableData {
		
		protected var _key:String;
		protected var _title:String;
		protected var _type:String;
		protected var _price : Number;
		protected var _bought : Boolean;
		protected var _tested : Boolean;
		
		public function BuyableData() {
		}

		public function get key() : String {
			return _key;
		}

		public function set key(key : String) : void {
			_key = key;
		}

		public function get title() : String {
			return _title;
		}

		public function set title(title : String) : void {
			_title = title;
		}

		public function get locked() : Boolean {
			return _price > 0 && !_bought;
		}

		public function get price() : Number {
			return _price;
		}

		public function set price(price : Number) : void {
			_price = price;
		}

		public function get bought() : Boolean {
			return _bought;
		}

		public function set bought(bought : Boolean) : void {
			_bought = bought;
		}

		public function get type() : String {
			return _type;
		}

		public function set type(type : String) : void {
			_type = type;
		}

		public function get isSurface() : Boolean {
			return _type == SurfaceData.TYPE;
		}
		public function get isTool() : Boolean {
			return _type == ToolData.TYPE;
		}
		
		public function toString() : String {
			return "BuyableData:{itemKey:'" + key + "',itemType:'" + type + "',itemName:'" + _title + "',itemPrice:'" + _price + "'}";
		}

		public function set tested(tested : Boolean) : void {
			_tested = tested;
		}

		public function get tested() : Boolean {
			return _tested;
		}
	}
}
