package com.lessrain.project.view.utils {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * @author Luis Martinez (luis.martinezriancho@gmail.com)
	 */
	public final class URLoaderWrapper {
		private var _loader : URLLoader;
		private var _callback : Function;
		public static const SUCCESS : String = "Success";
		public static const ERROR : String = "Error";
		public static var idleTimeout : Number = 120000;

		public function URLoaderWrapper() {
		}

		public function load(callback_ : Function, url_ : String, params_ : Object = null, method_ : String = "GET", dataFormat_ : String = "text") : void {
			if (_loader) {
				removeLoader();
			}
			_callback = callback_;
			_loader = new URLLoader();
			_loader.addEventListener(flash.events.Event.COMPLETE, onSendDataResponse);
			_loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			var request : URLRequest = new URLRequest(url_);

			
			request.method = method_;

			if (params_ != null) {
				var vars : URLVariables = new URLVariables();
				for (var p:String in params_) {
					vars[p] = params_[p];
				}
				request.data = vars;
			}

			try {
				_loader.dataFormat = dataFormat_;

				_loader.load(request);
			} catch (error : Error) {
				trace("try: " + error);
				executeCallback(ERROR);
			}
		}

		public function loadRequest(callback_ : Function, request_ : URLRequest, dataFormat_ : String = "text") : void {
			if (_loader) {
				removeLoader();
			}
			_callback = callback_;
			_loader = new URLLoader();
			_loader.addEventListener(flash.events.Event.COMPLETE, onSendDataResponse);
			_loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			

			try {
				_loader.dataFormat = dataFormat_;
				_loader.load(request_);
			} catch (error : Error) {
				trace(error);
				executeCallback(ERROR);
			}
		}

		private function removeLoader() : void {
			if (!_loader) return;

			if (_loader.hasEventListener(flash.events.Event.COMPLETE)) _loader.removeEventListener(flash.events.Event.COMPLETE, onSendDataResponse);
			if (_loader.hasEventListener(flash.events.IOErrorEvent.IO_ERROR)) _loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onIOError);
			if (_loader.hasEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR)) _loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			try {
				_loader.close();
			} catch (error : Error) {
			}
			if (_loader.data) _loader.data = null;
			_loader = null;
			if (_callback != null) _callback = null;
		}

		public function abort() : void {
			removeLoader();
			if (_callback != null) _callback = null;
		}

		private function onIOError(event_ : flash.events.IOErrorEvent) : void {
			trace('onIOError: ' + event_);
			executeCallback(ERROR);
		}

		private function onSecurityError(event_ : flash.events.SecurityErrorEvent) : void {
			trace('onSecurityError: ' + event_);
			executeCallback(ERROR);
		}

		private  function onSendDataResponse(event_ : flash.events.Event) : void {
			if (event_.target["data"]) {
				executeCallback(SUCCESS, {data:(event_.target["data"])});
			} else {
				executeCallback(ERROR);
			}
		}

		private function executeCallback(type_ : String, data_ : Object = null) : void {
			var callback : Function = _callback;
			if (callback != null) {
				callback(type_, data_);
			}
		}

		public function dispose() : void {
			removeLoader();
			if (_callback != null) _callback = null;
		}
	}
}
