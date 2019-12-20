package com.lessrain.project.view.components.palette {
	import com.greensock.TweenLite;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.ColorData;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author lessintern
	 */
	public class ColorBox extends Sprite {

		public static const WIDTH : int = 25;
		public static const MARGIN : int = 5;
		public static const MARGIN_WIDTH : int = WIDTH + MARGIN;
		private static const BUBBLE_RADIUS : int = WIDTH / 8;
		
		private var _selected : Boolean;
		private var _color : ColorData;
		private var _foreground : Sprite;
		private var _usedMark : Sprite;
		private var _used : Boolean;
		private var _overShape : Sprite;
		private var _mask : Sprite;
		private var _glass : Sprite;
		private var _reflection : Sprite;
		private var _mainAsset : Sprite;
		private var _title : SimpleTextfield;

		public function ColorBox(color_ : ColorData, paletteId:String) {
			_color = color_;
			
			var isTamiya:Boolean = paletteId == 'tamiya';
			
			_mainAsset = addChild(new Sprite()) as Sprite;

			_foreground = _mainAsset.addChild(new Sprite()) as Sprite;
			_foreground.graphics.beginFill(_color.color);
			_foreground.graphics.drawRect(0, 0, WIDTH, WIDTH);
			_foreground.graphics.endFill();
//			_foreground.x = _foreground.y = _foreground.width / 2;

			_overShape = _mainAsset.addChild(drawBubble(0xFF0000)) as Sprite;
			_overShape.alpha = 0;
			_overShape.x +=_foreground.width / 2;
			_overShape.y +=_foreground.width / 2;

			_glass = _mainAsset.addChild(ApplicationFacade.getSWFAssetInstance(isTamiya?'ColorTamiyaGlass': 'ColorGlass')) as Sprite;
//			if (!isTamiya) _glass.blendMode = BlendMode.MULTIPLY;
			_reflection = addChild(ApplicationFacade.getSWFAssetInstance(isTamiya?'ColorTamiyaGlassReflection': 'ColorGlassReflection')) as Sprite;

			
			_title = addChild(new SimpleTextfield(_color.name,'.toolPaletteTitle')) as SimpleTextfield;
			_title.y = -15;
			_title.x = (WIDTH - _title.width) / 2; 
			_title.alpha = 0;
			
			_mask = addChild(ApplicationFacade.getSWFAssetInstance(isTamiya?'ColorTamiyaGlass': 'ColorGlass')) as Sprite;
			_mainAsset.mask = _mask;

			addEventListener(MouseEvent.MOUSE_OVER, onRoll);
			addEventListener(MouseEvent.MOUSE_OUT, onRoll);
			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function drawBubble(color:uint) : Sprite {
			var bubble:Sprite = new Sprite();
			bubble.graphics.lineStyle(1, 0xFFFFFF, .5);
			bubble.graphics.beginFill(color, 1);
			bubble.graphics.drawCircle(0, 0, BUBBLE_RADIUS);
			bubble.graphics.endFill();
			var margin:Number =  2.5 * BUBBLE_RADIUS;
			bubble.x = WIDTH/2 - margin;
			bubble.y = -WIDTH/2 + margin;
			return bubble;
		}


		private function onClick(event : MouseEvent) : void {
			dispatchEvent(new ColorEvent(ColorEvent.CLICK, _color));
			selected = true;
		}

		protected function onRoll(event : MouseEvent) : void {
			if (!_selected) {
				var bRoll : Boolean = event.type == MouseEvent.MOUSE_OVER;
				TweenLite.to(_overShape, .2, {alpha : (bRoll ? 1 : 0)});
				TweenLite.to(_title, .2, {alpha : (bRoll ? 1 : 0)});
			}
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set selected(selected_ : Boolean) : void {
			_selected = selected_;
			TweenLite.killTweensOf(_overShape);
			_overShape.alpha = _title.alpha = _selected ? 1 : 0;
		}

		public function set used(used_ : Boolean) : void {
			if (_used != used_) {
				_used = used_;
				if (_used && !_usedMark) {
					_usedMark = _foreground.addChild(drawBubble(0x000000)) as Sprite;
					_usedMark.x +=_foreground.width / 2;
					_usedMark.y +=_foreground.width / 2;
				}
				if (_usedMark) _usedMark.visible = used_;
			}
		}

		public function finalize() : void {
			removeEventListener(MouseEvent.MOUSE_OVER, onRoll);
			removeEventListener(MouseEvent.MOUSE_OUT, onRoll);
			removeEventListener(MouseEvent.CLICK, onClick);
			TweenLite.killTweensOf(_overShape);
			if (parent) parent.removeChild(this);
		}

		public function get color() : ColorData {
			return _color;
		}
	}
}
