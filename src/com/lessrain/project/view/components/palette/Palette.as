package com.lessrain.project.view.components.palette {
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.lessrain.debug.Debug;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.ColorData;
	import com.lessrain.project.model.vo.PaletteData;
	import com.lessrain.project.view.components.sound.SoundController;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * @author lessintern
	 */
	public class Palette extends Sprite {

		// public static const MAX_COLOR_PER_LINE : int = 40;
		// private static const MAX_LINES : int = 2;
		// private static const MAX_COLORS : int = MAX_COLOR_PER_LINE * MAX_LINES;
		public static const LEFT_MARGIN : int = ColorBox.WIDTH * 3 / 2 + 5;
		private static const MIN_SPEED : int = 3;
		private static const MAX_SPEED : int = 100;
		private static const SPEED_DIFF : int = MAX_SPEED - MIN_SPEED;
		private var _colorBoxes : Vector.<ColorBox>;
		private var _maxWidth : Number;
		private var _colorContainer : Sprite;
		private var _mask : Sprite;
		private var _increment : int;
		private var _speed : int = MIN_SPEED;
		private var _arrowLeft : Sprite;
		private var _arrowRight : Sprite;
		private var _paletteData : PaletteData;
		private var _lastXPos : Number = 0;
		private var _colorContainerDragRect : Rectangle;
		private var _lastDragPos : Number;
		private var _dragDirection : Number;

		public function Palette(paletteData : PaletteData, viewMaxWidth : Number) {
			_paletteData = paletteData;
			calculateMaxWidth(viewMaxWidth);
			_colorBoxes = new Vector.<ColorBox>();
			_colorContainer = addChild(new Sprite()) as Sprite;
			_mask = addChild(new Sprite()) as Sprite;
			drawMask();
			mask = _mask;
			draw(paletteData);
			drawArrows();
			makeDraggable();
		}

		private function draw(paletteData : PaletteData) : void {
			for each (var color : ColorData in paletteData.colors) {
				drawColor(color);
			}
		}
		
		public function addColor(color:ColorData):void{
				_paletteData.colors.push(color);
				drawColor(color);
		}
		
		private function drawColor(color:ColorData):void{
				var colorBox : ColorBox = _colorContainer.addChild(new ColorBox(color,_paletteData.id)) as ColorBox;
				colorBox.addEventListener(ColorEvent.CLICK, onColorClicked);
				colorBox.x = _lastXPos;
				_colorBoxes.push(colorBox);
				_lastXPos += ColorBox.WIDTH + ColorBox.MARGIN;
		}

		private function onColorClicked(event : ColorEvent) : void {
			for each (var colorBox : ColorBox in _colorBoxes) {
				if (colorBox.parent.parent) {
					if (colorBox != event.target) colorBox.selected = false; //TODO save current used and unchek it
				}
			}
			SoundController.getInstance().playEventSoundByID(SoundController.ChooseColor);
			Debug.trace('Palette::onColorClicked:');
			dispatchEvent(event.clone());
		}

		public function markCurrentColorUsed(colorUsed : ColorData) : void {
			for each (var colorBox : ColorBox in _colorBoxes) {
				if (colorBox.color.color == colorUsed.color) colorBox.used = true;
			}
			// _activeColorBox.used = true;
		}
		
		public function markColorClicked(colorUsed : ColorData) : void {
			for each (var colorBox : ColorBox in _colorBoxes) {
				colorBox.selected = colorBox.color.color == colorUsed.color;
			}
			// _activeColorBox.used = true;
		}

		public function get defaultColorBox() : ColorBox {
			return _colorBoxes.length > 0 ? _colorBoxes[_paletteData.defaultColorIndex] : null;
		}

		public function jumpToDefault() : void {
			var numBoxes:int = Math.ceil(_maxWidth/(ColorBox.MARGIN_WIDTH));
			var numBoxesHalf:int = Math.floor(numBoxes/2);
			_colorContainer.x = Math.max(_maxWidth - _colorContainer.width+ ColorBox.MARGIN,-defaultColorBox.x + numBoxesHalf * ColorBox.MARGIN_WIDTH);
			checkArrowVisibility();
		}


		public function rearrange(w : Number) : void {
			calculateMaxWidth(w);
			drawMask();
			
			positionRightArrow();
		}

		private function drawMask() : void {
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x0000FF, .2);
			_mask.graphics.drawRect(0, -15, _maxWidth + ColorBox.MARGIN, ColorBox.WIDTH + 15);
			_mask.graphics.endFill();
		}

		private function calculateMaxWidth(viewMaxWidth : Number) : void {
			_maxWidth = viewMaxWidth;
			var numBoxes:int = Math.floor(_maxWidth/(ColorBox.MARGIN_WIDTH));
			_maxWidth = numBoxes*(ColorBox.MARGIN_WIDTH) - ColorBox.MARGIN;
		}

		public function get maxWidth() : Number {
			return _maxWidth;
		}

		private function makeDraggable() : void {
			_colorContainerDragRect = new Rectangle(-_colorContainer.width + _maxWidth,0,_colorContainer.width - _maxWidth,0);
			_colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragColorContainer);
		}

		private function dragColorContainer(event : MouseEvent) : void {
			_lastDragPos = _colorContainer.x;
			_dragDirection = 0;
			TweenLite.killTweensOf(_colorContainer);
			Mouse.cursor = MouseCursor.HAND;
			_colorContainer.startDrag(false,_colorContainerDragRect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, getDragDirection);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragColorContainer);
		}

		private function getDragDirection(event : MouseEvent) : void {
			var movement:Number = _lastDragPos - _colorContainer.x;
			Debug.trace('Palette::getDragDirection:movement '+movement);
			_dragDirection = movement;// / Math.abs(movement);
			_lastDragPos = _colorContainer.x;
		}

		private function stopDragColorContainer(event : MouseEvent) : void {
			_colorContainer.stopDrag();
			Mouse.cursor = MouseCursor.AUTO;
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragColorContainer);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, getDragDirection);
			if (Math.abs(_dragDirection) > 1){
				var target:Number = _colorContainer.x-(_dragDirection) * 2;
				target = target > 0 ? 0 : target < _colorContainerDragRect.x ? _colorContainerDragRect.x : target;
				TweenLite.to(_colorContainer, .4, {x:target});
			}
		}

		private function drawArrows() : void {
			_arrowLeft = addChild(getArrowButton(true)) as Sprite;
			_arrowRight = addChild(getArrowButton(false)) as Sprite;
			
			positionRightArrow();
			
			_arrowLeft.alpha = _arrowRight.alpha = .8;

			_arrowLeft.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownArrow);
			_arrowRight.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownArrow);
			_arrowLeft.addEventListener(MouseEvent.MOUSE_UP, onMouseOutArrow);
			_arrowRight.addEventListener(MouseEvent.MOUSE_UP, onMouseOutArrow);
			_arrowLeft.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutArrow);
			_arrowRight.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutArrow);
			
			checkArrowVisibility();
		}

		private function getArrowButton(isLeft:Boolean) : Sprite {
			var arrowButton:Sprite = new Sprite();
			arrowButton.buttonMode = true;
			var hitarea:Sprite = arrowButton.addChild(new Sprite()) as Sprite;
			hitarea.name = 'hitarea';
			hitarea.graphics.beginFill(0x880099,0);
			hitarea.graphics.drawRect(0, 0, ColorBox.WIDTH, ColorBox.WIDTH);
			hitarea.graphics.endFill();
			var arrow:Sprite = arrowButton.addChild(ApplicationFacade.getSWFAssetInstance('Arrow')) as Sprite;
//			var scale:Number = (ColorBox.WIDTH / 2) / arrow.height;
//			arrow.scaleX = arrow.scaleY = scale;
			if (isLeft){
				arrow.rotation = 180;
				arrow.x = arrow.width;
				arrow.y += arrow.height;
			}else {
				arrow.x = hitarea.width - arrow.width;
				arrow.y = (ColorBox.WIDTH - arrow.height) / 2;
			}
			arrowButton.mouseChildren = false;
			return arrowButton;
		}


		private function positionRightArrow() : void {
			_arrowRight.x = _maxWidth - _arrowRight.width;
		}

		private function onMouseOverArrow(event : MouseEvent) : void {
			var increment : int =  event.target == _arrowLeft ? -1 : 1;
			slide(increment);
			Sprite(event.target).addEventListener(MouseEvent.MOUSE_MOVE, onMouseOverMove);
		}

		private function onMouseDownArrow(event : MouseEvent) : void {
			var increment : int =  event.target == _arrowLeft ? -1 : 1;
			_speed = MIN_SPEED;
			slide(increment);
//			Sprite(event.target).addEventListener(MouseEvent.MOUSE_MOVE, onMouseOverMove);
		}

		private function onMouseOverMove(event : MouseEvent) : void {
			var arrow:Sprite = event.target as Sprite;
			var arrowMouseX:Number = arrow == _arrowLeft ? arrow.width - arrow.mouseX : arrow.mouseX;
			_speed = MIN_SPEED + (arrowMouseX / arrow.width)*SPEED_DIFF;
			blurBoxes(new BlurFilter(_speed/10,0,BitmapFilterQuality.MEDIUM));
		}

		private function onMouseOutArrow(event : MouseEvent) : void {
			stopSliding();
		}

		private function checkArrowVisibility() : void {
			_arrowLeft.visible = _colorContainer.x < 0;
			_arrowRight.visible = _colorContainer.width + _colorContainer.x > _maxWidth + ColorBox.MARGIN ;
		}

		public function slide(increment : int) : void {
			TweenLite.killTweensOf(_colorContainer);
			_increment = -increment;
			addEventListener(Event.ENTER_FRAME, render);
//			_speedUpTimer.start();
		}

		private function render(event : Event) : void {
			_colorContainer.x += _increment * _speed;
			if (_colorContainer.x > 0){
				_colorContainer.x = 0;
			} else if(_colorContainer.width - ColorBox.MARGIN + _colorContainer.x < _maxWidth + ColorBox.MARGIN ){
				_colorContainer.x = _maxWidth - _colorContainer.width+ ColorBox.MARGIN;
			}
			checkArrowVisibility();
			speedup();
		}

		private function speedup() : void {
			_speed += 1;
			blurBoxes(new BlurFilter(_speed/10,0,BitmapFilterQuality.MEDIUM));
		}

		public function stopSliding() : void {
			removeEventListener(Event.ENTER_FRAME, render);
			_speed = MIN_SPEED;
			var factor:Number = Math.abs(_colorContainer.x / ColorBox.MARGIN_WIDTH);
			var numBoxes:int = _increment < 0 ? Math.ceil(factor):Math.floor(factor);
			var targetX:Number = -numBoxes*ColorBox.MARGIN_WIDTH;
			TweenLite.to(_colorContainer, .4, {x:targetX, ease:Sine.easeOut, onComplete:onStoppedSliding});
			var arrow:Sprite = _increment == 1 ? _arrowLeft : _arrowRight;
			arrow.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseOverMove);
			blurBoxes();
			var color:ColorBox;
		}

		private function onStoppedSliding() : void {
		}

		private function blurBoxes(blurFilter:BlurFilter = null) : void {
			for each (var colorBox : ColorBox in _colorBoxes) {
				colorBox.filters = blurFilter? [blurFilter] : [];
			}
		}



		public function get colorContainer() : Sprite {
			return _colorContainer;
		}

		public function get paletteData() : PaletteData {
			return _paletteData;
		}
		
		public function hasColor(color:ColorData):Boolean{
			var foundColor:Boolean;
			for each (var colorBox : ColorBox in _colorBoxes) {
				if (colorBox.color == color){
					foundColor = true;
					break;
				}
			}
			return foundColor;
		}
	}
}
