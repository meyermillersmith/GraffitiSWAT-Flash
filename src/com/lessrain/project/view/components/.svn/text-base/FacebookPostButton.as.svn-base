package com.lessrain.project.view.components {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Sprite;
	
	/**
	 * @author Torsten Haertel, torsten at lessrain.com
	 */
	public class FacebookPostButton extends AssetButton {
		
		public static const CLICK:String = 'SimpleButtonClick';
		
		protected var _titleField:SimpleTextfield;
		protected var _subTitleField : SimpleTextfield;
		private var _titleFieldOver : SimpleTextfield;
		private var _subTitleFieldOver : SimpleTextfield;

		public function FacebookPostButton(title_ : String, subTitle_ : String) {
			super(ApplicationFacade.getSWFAssetInstance('PostFacebookButtonBG'),new Sprite());
			
			var marginTop:int = 2;
			
			_titleField = new SimpleTextfield(title_, '.postButton');
			_titleField.y = marginTop;
			sprite.addChild(_titleField);
			
			
			_titleFieldOver = new SimpleTextfield(title_, '.postButtonOver');
			_titleFieldOver.y = marginTop;
			_overSprite.addChild(_titleFieldOver);
			
			_subTitleField = new SimpleTextfield(subTitle_, '.postButtonSub');
			_subTitleField.y = marginTop + _titleField.height - 7;
			_subTitleField.alpha = .5;
			sprite.addChild(_subTitleField);
			
			_subTitleFieldOver = new SimpleTextfield(subTitle_, '.postButtonSubOver');
			_subTitleFieldOver.y = marginTop + _titleFieldOver.height - 7;
			_subTitleFieldOver.alpha = .5;
			_overSprite.addChild(_subTitleFieldOver);
			
//			var maxLineLength:Number = Math.max(_titleField.field.textWidth, _subTitleField.field.textWidth) + 10;
//			Debug.trace('FacebookPostButton::FacebookPostButton:maxLineLength '+maxLineLength+ ' width '+width);
			
			_titleField.field.width = _sprite.width;
			_titleFieldOver.field.width = _sprite.width;
			_subTitleField.field.width = _sprite.width;
			_subTitleFieldOver.field.width = _sprite.width;
			
//			_sprite.width = maxLineLength + 5;
			
			var r:int = 5;
			_overSprite.graphics.beginFill(0x284488, 1);
			_overSprite.graphics.drawRoundRectComplex(-1, -1, _sprite.width, _sprite.height + 1, r, r, r, r);
			_overSprite.graphics.endFill();
			
		}
		
		override public function set enabled(enabled_ : Boolean) : void {
			alpha = enabled_? 1 : .7;
			super.enabled = enabled_;
		}
	}
}
