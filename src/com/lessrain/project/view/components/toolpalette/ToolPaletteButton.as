package com.lessrain.project.view.components.toolpalette {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.AssetButton;

	import flash.display.Sprite;

	/**
	 * @author lessintern
	 */
	public class ToolPaletteButton extends AssetButton {
		
		private var _radius : int;
		protected var _icon : Sprite;

		public function ToolPaletteButton(assetKey:String, radius_:int = 10, color:uint = 0x000000, overColor:uint = 0xFFC020, overAlpha:Number = 1) {
			_radius = radius_;
			super(drawCircle(color), drawCircle(overColor, overAlpha));
			_icon = addChild(ApplicationFacade.getSWFAssetInstance(assetKey) as Sprite) as Sprite;
			_icon.x = _icon.y = _radius;
		}

		private function drawCircle(color_ : uint, alpha_:Number = 1) : Sprite {
			var bg : Sprite = new Sprite();
			bg.graphics.beginFill(color_, alpha_);
			bg.graphics.drawCircle(0, 0, _radius);
			bg.graphics.endFill();
			bg.x = bg.y = _radius;
			return bg;
		}
	}
}
