package com.lessrain.project.view.utils {
	import flash.display.Sprite;
	
	/**
	 * @author Torsten Haertel, torsten at lessrain.com
	 */
	public class SimpleTextButton extends AssetButton {
		
		public static const CLICK:String = 'SimpleButtonClick';
		
		protected var _field:SimpleTextfield;

		public function SimpleTextButton(text_ : String, styleClass_:String = '.button', bgalpha_:Number = 0, w_:int = -1, h_:int = 21, r_:int = -1, isRound_:Boolean = true, color_:uint = 0x000000, overColor_:uint=0x444444, marginLeft_:int = 5, marginTop_:int = 0) {
			super(new Sprite(),new Sprite());
			_field = new SimpleTextfield(text_, styleClass_);
			_field.x = marginLeft_;
			_field.y = marginTop_ > 0?marginTop_ : (h_ - _field.field.textHeight) / 2;
			asset.addChild(_field);
			
			var w:int = w_>0?w_:_field.field.textWidth+marginLeft_*2;
			var h:int = h_;
			var r:int = r_>0?r_:h;
			_sprite.graphics.beginFill(color_, bgalpha_);
			if(isRound_){
				_sprite.graphics.drawRoundRectComplex(0, 0, w+marginLeft_, h, r, r, r, r);
			} else {
				_sprite.graphics.drawRect(0, 0, w+marginLeft_, h);
			}
			_sprite.graphics.endFill();
			
			_overSprite.graphics.beginFill(overColor_, bgalpha_);
			if(isRound_){
				_overSprite.graphics.drawRoundRectComplex(0, 0, w+marginLeft_, h, r, r, r, r);
			} else {
				_overSprite.graphics.drawRect(0, 0, w+marginLeft_, h);
			}
			_overSprite.graphics.endFill();
			
		}
		
		override public function set enabled(enabled_:Boolean):void{
			super.enabled = enabled_;
			alpha = _enabled?1:.3;
		}
		
		public function set text(text_:String):void{
			_field.text = text_;
		}

		public function get field() : SimpleTextfield {
			return _field;
		}
		
		override public function get width():Number{
			return _sprite.width;
		}
		
		public function centerText():void{
			field.x = (_sprite.width - (field.field.textWidth + 5) )/ 2;
			field.y = (_sprite.height - field.field.textHeight )/ 2;
		}
	}
}
