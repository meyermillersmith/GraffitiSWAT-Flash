package com.lessrain.project.view.utils {
	import com.lessrain.project.ApplicationFacade;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	
	/**
	 * @author Torsten Haertel, torsten at lessrain.com
	 */
	public class SimpleTextfield extends Sprite {
		
		private var _field : TextField;
		private var _bitmap : Bitmap;
		private var _shape : Shape;
		private var _fixedWidth : Boolean;

		public function SimpleTextfield(text_:String, styleClass_:String = '.button', width_:Number = 2048, bMultiline_ : Boolean = false, bWordwrap_ : Boolean = false) {
			
			_shape = addChild( new Shape()) as Shape;
			_shape.visible = false;
			
			_field = new TextField();
			_field.embedFonts = true;
			_field.selectable = false;
			_field.multiline = bMultiline_;
			_field.wordWrap = bWordwrap_;
			_field.defaultTextFormat = ApplicationFacade.getTextFormat('css', styleClass_);
			_field.antiAliasType = AntiAliasType.ADVANCED;
			_field.htmlText = text_;
			addChild(_field);
			
			_fixedWidth = width_ != 2048;
			
			if (bMultiline_){
				_field.width = width_;
				_field.height = _field.textHeight+10;
			} else {
				_field.width = _fixedWidth ? width_  :_field.textWidth+15;
				_field.height = _field.textHeight+3;
			}
			
		}
		
		public function set text (text_:String) :void {
			_field.htmlText = text_;
			_field.height = _field.textHeight+10;
			if (!_field.multiline){
				if (!_fixedWidth) _field.width = _field.textWidth+15;;
				_field.height = _field.textHeight+3;
			}
		}
		
		public function get text():String{
			return field.text;
		}

		public function get field() : TextField {
			return _field;
		}

		public function drawBackground() : void {
			_shape.visible = true;
			
			var w:int = width + 18;
			var h:int = 21;
			var r:int = h/2;
			_shape.graphics.beginFill(0, .5);
			_shape.graphics.drawRoundRectComplex(0, 0, w, h, r, r, r, r);
			_shape.graphics.endFill();
			
			if (_bitmap) {
				_bitmap.x = 10;
				_bitmap.y = (21 - _field.textHeight) / 2;
			}
			else {
				_field.x = 10;
				_field.y = (21 - _field.textHeight) / 2;
				
			}
		}
	}
}
