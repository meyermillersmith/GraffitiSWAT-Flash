package com.lessrain.project.view.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;

	/**
	 * @author Luis Martinez (luis.martinezriancho@gmail.com)
	 */
	public final class CustomImageLoader {
		private var _id : String;
		private var _callback : Function;
		private var _loader : Loader;
		private var _source : String;
		private static var context : LoaderContext;
		public static const SUCCESS : String = "Success";
		public static const ERROR : String = "Error";
		public var transparent : Boolean = true;

		public function CustomImageLoader(callback_ : Function, source_ : String = null, id_ : String = null) {
			construct(callback_, source_, id_);
		}

		private function construct(callback_ : Function, source_ : String = null, id_ : String = null) : void {
			if (!context) {
				context = new LoaderContext(true);
				context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			}

			_callback = callback_;
			if (source_) _source = source_;
			if (id_) _id = id_;
		}

		public function load(source_ : String = null, id_ : String = null) : void {
			removeLoader();
			if (source_) _source = source_;
			if (id_) _id = id_;

			if (!_source) {
				executeCallback(ERROR, null, _id);
				return;
			}

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			try {
				_loader.load(new URLRequest(_source), context);
			} catch (error : Error) {
				trace(error);
				executeCallback(ERROR, null, _id);
			}
		}

		private function onComplete(event_ : Event) : void {
			// var loadedBitmapData : BitmapData = Bitmap(_loader.content).bitmapData;
			// trace("LOAD COMPLETE ");
			var resultBitmapData : BitmapData = Bitmap(_loader.content).bitmapData.clone();
			/*var r : Rectangle = loadedBitmapData.rect;
			if (transparent) {
			resultBitmapData = new BitmapData(loadedBitmapData.width, loadedBitmapData.height, true);
			resultBitmapData.copyChannel(loadedBitmapData, r, ZERO_POINT, BitmapDataChannel.RED, BitmapDataChannel.RED);
			resultBitmapData.copyChannel(loadedBitmapData, r, ZERO_POINT, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
			resultBitmapData.copyChannel(loadedBitmapData, r, ZERO_POINT, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
			resultBitmapData.copyChannel(loadedBitmapData, r, ZERO_POINT, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			} else {
			resultBitmapData = new BitmapData(loadedBitmapData.width, loadedBitmapData.height, false,0x000000);
			resultBitmapData.copyChannel(loadedBitmapData, r, ZERO_POINT, BitmapDataChannel.RED, BitmapDataChannel.RED);
			resultBitmapData.copyChannel(loadedBitmapData, r, ZERO_POINT, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
			resultBitmapData.copyChannel(loadedBitmapData, r, ZERO_POINT, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
			}*/

			removeLoader();
			executeCallback(SUCCESS, resultBitmapData, _id);
		}

		private function onIOError(event_ : flash.events.IOErrorEvent) : void {
			trace('onIOError: ' + event_);
			removeLoader();
			executeCallback(ERROR, null, _id);
		}

		private function onSecurityError(event_ : flash.events.SecurityErrorEvent) : void {
			trace('onSecurityError: ' + event_);
			removeLoader();
			executeCallback(ERROR, null, _id);
		}

		private function removeLoader(close_ : Boolean = true) : void {
			if (_loader) {
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

				if (close_) {
					try {
						_loader.close();
					} catch(error : Error) {
						// no need to do anything in response
					}
				}

				if (_loader.content) {
					if (Bitmap(_loader.content).bitmapData) {
						Bitmap(_loader.content).bitmapData.dispose();
					}
				}

				_loader = null;
			}
		}

		public function abort() : void {
			removeLoader(true);
		}

		private function executeCallback(type_ : String, bitmapData_ : BitmapData = null, id_ : String = null) : void {
			var callback : Function = _callback;
			if (callback != null) {
				callback(type_, bitmapData_, id_);
			}
		}

		public function dispose() : void {
			removeLoader();
			if (_callback != null) _callback = null;
		}

		public function get source() : String {
			return _source;
		}
	}
}
