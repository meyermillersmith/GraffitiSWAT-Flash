package com.lessrain.project.view.components {
	import com.lessrain.project.model.vo.BuyableData;
	import flash.events.Event;

	/**
	 * @author lessintern
	 */
	public class ItemBuyEvent extends Event {
		
		public static const BUY:String = 'buyItem';
		public static const BOUGHT:String = 'itemBought';
		private var _itemData : BuyableData;

		public function ItemBuyEvent(type : String, itemData_ : BuyableData, bubbles : Boolean = false, cancelable : Boolean = false) {
			_itemData = itemData_;
			super(type, bubbles, cancelable);
		}

		public function get itemData() : BuyableData {
			return _itemData;
		}
		
		override public function clone():Event{
			return new ItemBuyEvent(type, _itemData);
		}
	}
}
