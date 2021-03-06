package com.lessrain.project.view.components.facebook {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.lessrain.project.view.utils.CustomImageLoader;
	import com.greensock.loading.ImageLoader;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class FriendsSelectorItem extends AssetButton {

		public static const HEIGHT : Number = 56;

		private var _friend : FacebookFriend;
		private var _width : Number;
		private var _image : Bitmap;
		private var _name : SimpleTextfield;
		private var _index : int;

		public function FriendsSelectorItem(friend_ : FacebookFriend, width_:Number) {
			
			_friend = friend_;
			_width = width_;
			
			super(getBackground(0xFFFFFF),getBackground(0x3B5998));
			
			loadImage();
			_name = addChild(new SimpleTextfield(_friend.name,'.fbFriend',_width,true,true)) as SimpleTextfield;
			_name.x = 66;
			_name.y = (HEIGHT - _name.height) /2;
			
			drawContainerBorders();
		}
		
		private function getBackground(color:uint):Sprite{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(color,1);
			sprite.graphics.drawRect(0, 0, _width, HEIGHT);
			sprite.graphics.endFill();
			return sprite;
		}

		private function drawContainerBorders() : void {
			var borders:Shape = addChild(new Shape()) as Shape;
			borders.graphics.lineStyle(1,0x888888);
			borders.graphics.lineTo(0, HEIGHT-1);
			borders.graphics.lineTo(_width-1, HEIGHT-1);
			borders.graphics.lineTo(_width-1, 1);
		}

		/*private function loadImage(event : Event = null) : void {
			var loader:ImageLoader = new ImageLoader(_friend.picture);
			_image = _asset.addChild(loader.content) as Sprite;
			_image.x = 8;
			_image.y = 3;
			loader.load();
		}*/
		
		private function loadImage(event : Event = null) : void {
			var loader:CustomImageLoader = new CustomImageLoader(friendImageLoaded);
			loader.load(_friend.picture);
			
		}
		
		private function friendImageLoaded(type_:String,bitmapData_:BitmapData,id_:String=null):void
		{
			if(type_==CustomImageLoader.ERROR || !bitmapData_)
			{
				return;
			}
			
			_image = new Bitmap(bitmapData_);
			_image.x = 8;
			_image.y = 3;
			
			_asset.addChild(_image);
		}

		public function activate() : void {
			onRoll(new MouseEvent(MouseEvent.ROLL_OVER));
		}

		public function deactivate() : void {
			onRoll(new MouseEvent(MouseEvent.ROLL_OUT));
		}

		public function select() : void {
			onClick(new MouseEvent(MouseEvent.CLICK));
		}

		public function get friend() : FacebookFriend {
			return _friend;
		}

		public function set index(index : int) : void {
			_index = index;
		}

		public function get index() : int {
			return _index;
		}
		
		override public function toString() : String {
			return _friend.toString();
		}
	}
}
