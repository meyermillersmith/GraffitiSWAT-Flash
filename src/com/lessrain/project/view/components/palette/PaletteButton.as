package com.lessrain.project.view.components.palette {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.model.vo.PaletteData;
	import com.lessrain.project.view.utils.AssetButton;
	import com.lessrain.project.view.utils.SimpleTextfield;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * @author lessintern
	 */
	public class PaletteButton extends AssetButton {

		private var _mainAsset : Sprite;
		private var _paletteData : PaletteData;
		private var _overAsset : Sprite;
		private var _rainbow : Sprite;
		private var _paletteTitle : SimpleTextfield;

		public function PaletteButton() {
			_mainAsset = addChild(new Sprite()) as Sprite;
			_rainbow = _mainAsset.addChild(new Sprite()) as Sprite;
			drawMask();
			// _rainbow.addChild(ApplicationFacade.getSWFAssetInstance('ColorRainbow'));
			_mainAsset.addChild(ApplicationFacade.getSWFAssetInstance('ColorGlass'));
			_mainAsset.addChild(ApplicationFacade.getSWFAssetInstance('ColorGlassReflection'));

			_overAsset = addChild(new Sprite()) as Sprite;
			super(_mainAsset, _overAsset);
		}

		private function drawColors() : void {
			var numColors : int = _paletteData.colors.length > 5 ? 6 : _paletteData.colors.length;
			var increment : int = 1;
			// ;_paletteData.colors.length < 6? 1 : Math.floor(_paletteData.colors.length/numColors);
			var singleColorHeight : Number = ColorBox.WIDTH / numColors;
			_rainbow.graphics.clear();
			for (var i : int = 0; i < numColors; i += increment) {
				_rainbow.graphics.beginFill(_paletteData.colors[i].color, 1);
				_rainbow.graphics.drawRect(0, (i / increment) * singleColorHeight, ColorBox.WIDTH, singleColorHeight);
				_rainbow.graphics.endFill();
			}
		}

		private function drawMask() : void {
			var rainbowMask : Sprite = _mainAsset.addChild(new Sprite()) as Sprite;
			rainbowMask.graphics.beginFill(0xFF0000, 1);
			rainbowMask.graphics.drawCircle(ColorBox.WIDTH / 2, ColorBox.WIDTH / 2, ColorBox.WIDTH / 2);
			rainbowMask.graphics.endFill();
			_rainbow.mask = rainbowMask;
		}

		override protected function onClick(event : MouseEvent) : void {
			dispatchEvent(new PaletteEvent(PaletteEvent.CLICK, _paletteData));
		}

		public function get paletteData() : PaletteData {
			return _paletteData;
		}

		public function set paletteData(paletteData : PaletteData) : void {
			_paletteData = paletteData;
			drawColors();
		}

		public function setTitle() : void {
			_paletteTitle = asset.addChild(new SimpleTextfield(paletteData.name, '.toolPaletteTitle'))as SimpleTextfield;
			_paletteTitle.y = height + 2;
			_paletteTitle.x = (ColorBox.WIDTH - _paletteTitle.width) / 2;
			_paletteTitle.filters = [new DropShadowFilter(2, 45, 0, 1, 2, 2)];
			
//			asset.graphics.beginFill(0xFF0000,.5);
//			asset.graphics.drawRect(0, 0, asset.width, asset.height);
//			asset.graphics.endFill();
		}
	}
}
