package com.lessrain.project.view.utils {
	import flash.display.BlendMode;
	import com.lessrain.project.ApplicationFacade;
	import flash.display.Sprite;


	/**
	 * @author lessintern
	 */
	public class RoundAssetButton extends AssetButton {
		
		protected var _radius : int;
		protected var _icon : Sprite;

		public function RoundAssetButton(assetKey:String, radius_:int = 10, color:uint = 0x000000, overColor:uint = 0xFFC020, overAlpha:Number = 1) {
			_radius = radius_;
			super(drawCircle(color), drawCircle(overColor, overAlpha));
			setIcon(assetKey);
			blendMode = BlendMode.LAYER;
		}

		protected function drawCircle(color_ : uint, alpha_:Number = 1) : Sprite {
			var bg : Sprite = new Sprite();
			bg.graphics.beginFill(color_, alpha_);
			bg.graphics.drawCircle(0, 0, _radius);
			bg.graphics.endFill();
			bg.x = bg.y = _radius;
			return bg;
		}
		
		protected function setIcon(assetKey:String):void{
			if (_icon && _icon.parent) _icon.parent.removeChild(_icon);
			_icon = addChild(ApplicationFacade.getSWFAssetInstance(assetKey) as Sprite) as Sprite;
			_icon.x = _icon.y = _radius;
		}
	}
}
