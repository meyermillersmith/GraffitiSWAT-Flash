package com.lessrain.project.view.components.palette {
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.ColorData;
	import com.lessrain.project.model.vo.PaletteData;
	import com.lessrain.project.view.components.toolpalette.PaletteItemArrowButton;
	import com.lessrain.project.view.utils.AssetButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;

	/**
	 * @author lessintern
	 */
	public class PaletteView extends Sprite {

		private var _data : Vector.<PaletteData>;
		private var _colorsContainer : Sprite;
		private var _activeColor : ColorData;
		private var _palettes : Vector.<Palette>;
		private var _currentPalette : Palette;
		private var _paletteIndex : int;
		private var _w : Number;
		private var _paletteButton : PaletteButton;
		private var _paletteChooser : PaletteChooseScreen;
		private var _paletteButtonContainer : Sprite;
		private var _usedColorsPalette : Palette;
		private var colorsClosed : Boolean;
		private var _colorContainerMask : Sprite;
		private var _closeBlur : BlurFilter;
		private var _paletteButtonToggler : PaletteItemArrowButton;

		public function PaletteView() {
			_palettes = new Vector.<Palette>();
			_paletteIndex = 0;

			_paletteButtonContainer = addChild(new Sprite()) as Sprite;

			var chooserMask : Sprite = addChild(new Sprite()) as Sprite;
			var chooserHitAreaMask : Sprite = addChild(new Sprite()) as Sprite;
			var choosetHitArea : Sprite = _paletteButtonContainer.addChild(new Sprite()) as Sprite;

			_paletteChooser = _paletteButtonContainer.addChild(new PaletteChooseScreen(chooserMask, choosetHitArea,chooserHitAreaMask)) as PaletteChooseScreen;
			_paletteChooser.addEventListener(PaletteEvent.CLICK, onPaletteChosen);

			_colorsContainer = addChild(new Sprite()) as Sprite;
			_colorsContainer.x = Palette.LEFT_MARGIN;

			_colorContainerMask = addChild(new Sprite()) as Sprite;
			_colorContainerMask.x = _colorsContainer.x;
			_colorsContainer.mask = _colorContainerMask;

			_paletteButton = _paletteButtonContainer.addChild(new PaletteButton()) as PaletteButton;
			_paletteButton.addEventListener(PaletteEvent.CLICK, toggleClosePalette);

			_paletteButtonToggler = _paletteButtonContainer.addChild(new PaletteItemArrowButton(.7, 7)) as PaletteItemArrowButton;
			_paletteButtonToggler.x = _paletteButton.width - _paletteButtonToggler.width;
			_paletteButtonToggler.y = _paletteButton.height - _paletteButtonToggler.height;
			_paletteButtonToggler.addEventListener(AssetButton.CLICK, toggleClosePalette);
			_paletteButton.toggled = true;

			_paletteButtonContainer.addEventListener(MouseEvent.MOUSE_OVER, _paletteChooser.open);
			_paletteButtonContainer.addEventListener(MouseEvent.MOUSE_OUT, _paletteChooser.close);
			_paletteButtonContainer.mask = chooserHitAreaMask;
			// choosetHitArea.addEventListener(MouseEvent.MOUSE_OVER, _paletteChooser.open);
			// choosetHitArea.addEventListener(MouseEvent.MOUSE_OUT, _paletteChooser.close);

			var seperator : Sprite = addChild(ApplicationFacade.getSWFAssetInstance('PaletteSeperator')) as Sprite;
			seperator.alpha = .2;
			seperator.x = _paletteButton.width + 5;

			_closeBlur = new BlurFilter(10, 0, BitmapFilterQuality.MEDIUM);
		}

		private function toggleClosePalette(event : Event = null) : void {
			TweenLite.killTweensOf(_colorsContainer);
			_paletteButton.toggled = colorsClosed;
			_colorsContainer.filters = [_closeBlur];
			colorsClosed = !colorsClosed;
			TweenLite.to(_colorsContainer, .4, {x : (colorsClosed ? Palette.LEFT_MARGIN - _w : Palette.LEFT_MARGIN), ease : Sine.easeOut, onComplete : onToggleClosePaletteComplete});
		}

		private function onToggleClosePaletteComplete() : void {
			_colorsContainer.filters = [];
			_colorsContainer.mask = _colorContainerMask;
		}

		public function init(data : Vector.<PaletteData>) : void {
			_data = data;
			for (var i : int = 0; i < _data.length; i++) {
				var paletteData : PaletteData = _data[i];
				if (paletteData.isDefault) {
					_paletteIndex = i;
					drawColors(paletteData);
					var defaultColorBox : ColorBox = _currentPalette.defaultColorBox;
					if (defaultColorBox) {
						defaultColorBox.selected = true;
						_activeColor = defaultColorBox.color;
						_currentPalette.jumpToDefault();
					}
					_paletteButton.paletteData = paletteData;
				}
				_paletteChooser.push(paletteData);
			}
			_paletteChooser.activePalette = _data[_paletteIndex];
		}

		private function onPaletteChosen(event : PaletteEvent) : void {
			clearPalette();
			drawColors(event.palette);
			_paletteButton.paletteData = event.palette;
			if (colorsClosed) toggleClosePalette();
		}

		private function clearPalette() : void {
			while (_colorsContainer.numChildren > 0 ) {
				_colorsContainer.removeChildAt(0);
			}
		}

		private function drawColors(paletteData : PaletteData) : void {
			_colorsContainer.addChild(makePalette(paletteData));
		}

		private function makePalette(paletteData : PaletteData) : Palette {
			var displayPalette : Palette;
			for each (var savedPalette : Palette in _palettes) {
				if (savedPalette.paletteData == paletteData) {
					displayPalette = savedPalette;
				}
			}
			if (!displayPalette) {
				displayPalette = new Palette(paletteData, _w - _colorsContainer.x);
				_currentPalette = displayPalette;
				displayPalette.addEventListener(ColorEvent.CLICK, onColorClicked);
				_palettes.push(displayPalette);
			}
			return displayPalette;
		}

		private function onColorClicked(event : ColorEvent) : void {
			_activeColor = event.color;
			dispatchEvent(event.clone());
			for each (var palette : Palette in _palettes) {
				if (palette != event.target) palette.markColorClicked(_activeColor);
			}
		}

		public function get activeColor() : ColorData {
			return _activeColor;
		}

		public function markCurrentColorUsed() : void {
			if (!_usedColorsPalette) {
				var usedColorsPaletteData : PaletteData = new PaletteData();
				usedColorsPaletteData.id = 'used.colors';
				usedColorsPaletteData.name = ApplicationFacade.getCopy('palette.usedColors');
				_usedColorsPalette = makePalette(usedColorsPaletteData);
				_palettes.push(_usedColorsPalette);
				_paletteChooser.addUsedColors(_usedColorsPalette.paletteData);
				_paletteChooser.reposition();
			}
			if (!_usedColorsPalette.hasColor(_activeColor)) {
				_usedColorsPalette.addColor(_activeColor);
				_usedColorsPalette.markColorClicked(_activeColor)
				_paletteChooser.usedColorsButton.paletteData = _usedColorsPalette.paletteData;
			}
			for each (var palette : Palette in _palettes) {
				palette.markCurrentColorUsed(_activeColor);
			}
		}

		public function set w(w : Number) : void {
			_w = w;
			rearrange();
		}

		private function rearrange() : void {
			for each (var palette : Palette in _palettes) {
				palette.rearrange(_w - _colorsContainer.x);
			}
			_colorContainerMask.graphics.clear();
			_colorContainerMask.graphics.beginFill(0xFFFF00, .5);
			_colorContainerMask.graphics.drawRect(0, -15, _w - _colorsContainer.x, _colorsContainer.height + 15);
			_colorContainerMask.graphics.endFill();
		}
	}
}
