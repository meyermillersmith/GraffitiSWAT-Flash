package com.lessrain.project.view.components.facebook {
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.AssetButton;

	import flash.display.Sprite;

	/**
	 * @author lessintern
	 */
	public class ClearTextButton extends AssetButton {

		public function ClearTextButton(height_ : Number) {
			super(new Sprite(), getOverBG(height_));
			var cross : Sprite =  addChild(ApplicationFacade.getSWFAssetInstance('PaletteClose') as Sprite) as Sprite;
			cross.x = cross.y = height_ / 2;
			_asset.addChild(cross);
		}

		private function getOverBG(height_ : Number) : Sprite {
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xFFFFFF,.1);
			sprite.graphics.drawRect(0, 0, height_, height_);
			sprite.graphics.endFill();
			return sprite;
		}
	}
}
