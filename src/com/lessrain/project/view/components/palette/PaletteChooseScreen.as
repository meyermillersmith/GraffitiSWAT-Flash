package com.lessrain.project.view.components.palette {
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.lessrain.project.model.vo.PaletteData;
	import com.lessrain.project.view.components.MenuBar;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	/**
	 * @author lessintern
	 */
	public class PaletteChooseScreen extends Sprite {
		
		private static const MARGIN:int = 25;

		private var _paletteButtons : Vector.<PaletteButton>;
		private var _visiblePaletteButtons : Vector.<PaletteButton>;
//		private var _textContainer : Bitmap;
		private var _activePalette : PaletteData;
		private var _viewMask : Sprite;
		private var _buttonContainer : Sprite;
		private var _hitArea : Sprite;
		private var _isClosing : Boolean;
		private var _usedColorsButton : PaletteButton;
		private var _hitAreaMask : Sprite;

		public function PaletteChooseScreen(viewMask_ : Sprite, hitArea_ : Sprite, hitAreaMask_ : Sprite) {
			_paletteButtons = new Vector.<PaletteButton>();
			
			_buttonContainer = addChild(new Sprite()) as Sprite;
			
//			_textContainer = addChild(new Bitmap()) as Bitmap;
//			_textContainer.x = -MenuBar.MARGIN;
//			_textContainer.alpha = 0;
			
			_viewMask = viewMask_;
			mask = _viewMask;
			
			_hitAreaMask = hitAreaMask_;
//			hitArea_.mask = _hitAreaMask;
			
			_hitArea = hitArea_;
			
			visible = false;
		}

		public function push(palette : PaletteData) : PaletteButton {
			var paletteBtn : PaletteButton = _buttonContainer.addChild(new PaletteButton()) as PaletteButton;
			paletteBtn.paletteData = palette;
			paletteBtn.setTitle();
			paletteBtn.addEventListener(PaletteEvent.CLICK, onPaletteClick);
			_paletteButtons.push(paletteBtn);
			drawMask();
			return paletteBtn;
		}

		public function addUsedColors(palette : PaletteData) : void {
			_usedColorsButton = push(palette);
		}


		public function reposition() : void {
			_visiblePaletteButtons = new Vector.<PaletteButton>();
			for each (var btn : PaletteButton in _paletteButtons) {
				if (btn.visible){
					_visiblePaletteButtons.push(btn);
				}
			}
			for (var i : int = 0; i < _visiblePaletteButtons.length; i++) {
				var paletteBtn : PaletteButton = _visiblePaletteButtons[i];
				paletteBtn.y = i * paletteBtn.height + (i == 0 ? 0 : 5);
			}
			var trans:Matrix = new Matrix();
			trans.translate(MenuBar.MARGIN, 0);
			
			drawMask();
		}

		private function drawMask() : void {
			_viewMask.graphics.clear();
			_viewMask.graphics.beginFill(0xFF0000,.2);
			_viewMask.graphics.drawRect(-MenuBar.MARGIN, -height - MARGIN, width , height + MARGIN + ColorBox.WIDTH/2);
			_viewMask.graphics.endFill();

			_hitAreaMask.graphics.clear();
			_hitAreaMask.graphics.beginFill(0xFF0000,.2);
			_hitAreaMask.graphics.drawRect(-MenuBar.MARGIN, -height - MARGIN, width , height + MARGIN + ColorBox.WIDTH);
			_hitAreaMask.graphics.endFill();
			
			drawHitArea();
		}
		
		private function drawHitArea() : void {
			
			_hitArea.graphics.clear();
			_hitArea.graphics.beginFill(0xFFF00F,0);
			_hitArea.graphics.drawRect(-MenuBar.MARGIN, y, width, y < 0? -y : 0);
			_hitArea.graphics.drawRect(-MenuBar.MARGIN, 0, ColorBox.WIDTH + MenuBar.MARGIN, ColorBox.WIDTH);
			_hitArea.graphics.endFill();
		}

		private function onPaletteClick(event : PaletteEvent) : void {
			//(event.target as PaletteButton).paletteData = _activePalette;
			close();
			dispatchEvent(event);
			activePalette = event.palette;
		}

		public function open(event : MouseEvent) : void {
//			if (!_isClosing){
				visible = true;
				TweenLite.killTweensOf(this);
//				_textContainer.visible = true;
				TweenLite.to(this, .4, {y : -height - 25, ease : Expo.easeOut});
//				TweenLite.killTweensOf(_textContainer);
//				TweenLite.to(_textContainer, .2, {alpha : 1, ease : Expo.easeOut});
//			}
		}

		public function close(event : MouseEvent = null) : void {
			_isClosing = true;
			TweenLite.killTweensOf(this);
			TweenLite.to(this, .4, {y : 0, ease : Expo.easeOut, onComplete : onClose});
//			_textContainer.visible = false;
//			TweenLite.killTweensOf(_textContainer);
//			TweenLite.to(_textContainer, .1, {alpha : 0, ease : Expo.easeOut, onComplete : onTextTransparent});
		}

//		private function onTextTransparent() : void {
//			Debug.trace('PaletteChooseScreen::onTextTransparent:');
//			_textContainer.visible = false;
//		}


		override public function set y(y_ : Number) : void {
			super.y = y_;
			var mommy : Sprite = parent as Sprite;
			mommy.graphics.clear();
			mommy.graphics.beginFill(0xFF0000, 0);
			mommy.graphics.drawRect(- MenuBar.MARGIN, y_, ColorBox.WIDTH, mommy.height);
			mommy.graphics.endFill();
			
			drawHitArea();
		}

		private function onClose() : void {
			visible = false;
			_isClosing = false;
		}

		public function set activePalette(activePalette : PaletteData) : void {
			_activePalette = activePalette;
			for each (var button : PaletteButton in _paletteButtons) {
				button.visible = button.paletteData != _activePalette;
			}
			reposition();
		}

		public function get buttonContainer() : Sprite {
			return _buttonContainer;
		}

		public function get usedColorsButton() : PaletteButton {
			return _usedColorsButton;
		}
	}
}
