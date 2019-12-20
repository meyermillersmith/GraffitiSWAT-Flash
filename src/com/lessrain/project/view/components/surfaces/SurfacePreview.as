package com.lessrain.project.view.components.surfaces {
	import flash.display.BlendMode;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.lessrain.project.ApplicationFacade;
	import com.lessrain.project.view.utils.Fader;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author lessintern
	 */
	public class SurfacePreview extends Sprite {

		private static const SIZE : Number = 250;
//		private static const ICON_SIZE : Number = 180;

		private var _circle : Sprite;
		private var _cache : Dictionary;
		private var _container : Sprite;
		private var _markedThumb : Sprite;

		public function SurfacePreview() {
			_cache = new Dictionary();
			
			_circle = addChild(new Sprite()) as Sprite;
			_circle.graphics.beginFill(0x000000,.8);
			_circle.graphics.drawCircle(0, 0, SIZE/2);
			_circle.graphics.endFill();
			_circle.x = _circle.y = SIZE/2;
			_circle.blendMode = BlendMode.MULTIPLY;
			
			_container = addChild(new Sprite()) as Sprite;
			_container.alpha = 0;
		}
		
		public function showThumb(event:SurfaceEvent) : void {
			clear();
			if (_cache[event.surface.key]){
				_container.addChild(_cache[event.surface.key]);
				Fader.fadeIn(_container);
			} else {
				loadThumb(event.surface.key);
			}
		}

		private function clear() : void {
			while(_container.numChildren > 0){
				_container.removeChildAt(0);
			}
		}
		
		public function hideThumb(event:Event = null) : void {
			if (_container.numChildren > 0) _markedThumb = _container.getChildAt(_container.numChildren - 1) as Sprite;
			Fader.fadeOut(_container,removeMarkedThumb);
		}

		private function removeMarkedThumb() : void {
			if (_markedThumb && _container.contains(_markedThumb)) _container.removeChild(_markedThumb);
		}

		private function loadThumb(surfaceKey : String) : void {
			var url:String = ApplicationFacade.getProperty('surfacesPath') + surfaceKey + '/thumbnail_250.png';
			var thumbnailLoader : ImageLoader = new ImageLoader(url, {name:surfaceKey, onComplete : onImageLoaded});
			var thumbnail:Sprite = thumbnailLoader.content;
			_cache[surfaceKey] = thumbnail;
			_container.addChild(thumbnail);
			thumbnailLoader.load();
		}

		private function onImageLoaded(event : LoaderEvent) : void {
			var thumbnail:Sprite = event.target.content as Sprite;
//			var scale : Number = Math.min(ICON_SIZE / thumbnail.width , ICON_SIZE / thumbnail.height);
//			thumbnail.scaleX = thumbnail.scaleY  = scale;
			thumbnail.x = (SIZE - thumbnail.width)/2;
			thumbnail.y = (SIZE - thumbnail.height)/2;
			if (_container.contains(thumbnail)) Fader.fadeIn(_container);
		}
		
		
	}
}
