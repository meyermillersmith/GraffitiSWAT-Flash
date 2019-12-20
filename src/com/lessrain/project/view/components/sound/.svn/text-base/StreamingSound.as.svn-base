package com.lessrain.project.view.components.sound {
	import com.greensock.TweenLite;
	import com.lessrain.debug.Debug;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * @author Torsten Härtel, torsten@lessrain.com
	 */
	public class StreamingSound {
		
		public static const LOADING_COMPLETE : String = "LOADING_COMPLETE";
		
		private var _sound 			: Sound;
		private var _soundTransform : SoundTransform;
		private var _channel 		: SoundChannel;		private var _src 			: String;
		private var _isInitial 		: Boolean;
		private var _muted			: Boolean;
		private var _volume			: Number;
		private var _isFading 		: Boolean;
		private var _isPlaying 		: Boolean;
		private var _sprite 		: Sprite;
		private var _soundLoaderContext : SoundLoaderContext;
		private var _playEventDispatched : Boolean;
		private var _noID3InfoPlease : Boolean;
		private var _currentVolume : Number;

		
		public function StreamingSound()
		{
			_sprite = new Sprite();
			_isInitial = true;
			_volume = _currentVolume = 1;
		}
		
		public function set src(src : String) : void {
			_src = src;
		}
		
		/**
		 * Start
		 */
		public function start() :void {
			if (!_sound && _src)
			{
				_playEventDispatched = false;
				if (!_sprite.hasEventListener(Event.ENTER_FRAME)) {
					_sprite.addEventListener(Event.ENTER_FRAME, checkBuffering);
				}
				
				try {
					// Sound
					_sound = new Sound();
					_soundLoaderContext = new SoundLoaderContext(2000, false);
					_sound.addEventListener(Event.COMPLETE, onComplete);
					_sound.load(new URLRequest(_src), _soundLoaderContext);
					play();
					
					_isPlaying = true;
				}
				catch (e:Error) {
					_isPlaying = false;
					Debug.trace("StreamingSound::start ERROR e "+e.message);
				}
			}
		}		
		/**
		 * checkBuffering
		 */
		private function checkBuffering(event : Event) : void {
			if (!_playEventDispatched && _sound && !_sound.isBuffering) {
				_playEventDispatched = true;
				_sprite.dispatchEvent(new Event(LOADING_COMPLETE));
				_sprite.removeEventListener(Event.ENTER_FRAME, checkBuffering);
			}
		}
		
		/**
		 * onComplete
		 */
		private function onComplete(event : Event) : void {
		}

		/**
		 * Play
		 */
		private function play() : void {
			
			// SoundTransform
            _soundTransform = new SoundTransform(_muted ? .1 : _volume);
            _isInitial = false;
            
			// SoundChannel
			_channel = _sound.play(0, 1000);
			_channel.soundTransform = _soundTransform;
            _channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
		}
		
		/**
		 * onPlaybackComplete
		 */
		private function onPlaybackComplete(event:Event):void {
			
			if (_sound.hasEventListener(Event.COMPLETE)) {
				_sound.removeEventListener(Event.COMPLETE, onComplete);
			}

			_sound = null;
			
			_channel.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			
			volume = _volume;
			start();
		}
		
		/**
         * pause
         */
        public function pause() :void
        {
        	_isPlaying = false;
        	TweenLite.killTweensOf(this);
        	TweenLite.to(this, .5, {dimVolume:0});
        }
        
        /**
         * resume
         */
        public function resume() : void 
        {
			_isPlaying = true;
        	if (_sound==null) start();
        	
        	if (_soundTransform!=null) {
				_soundTransform.volume = 0;
			}
			
			TweenLite.killTweensOf(this);
        	TweenLite.to(this, .5, {dimVolume:_currentVolume});
		}
        
        /**
		 * Set volume
		 */
		public function set volume( vol_:Number ) :void {
			setVolume(vol_);
		}
		public function set passiveVolume( vol_:Number ) :void {
			_volume = vol_;
			_currentVolume = vol_;
		}
		public function set dimVolume( vol_:Number ) :void {
			setVolume(vol_,true);
		}
		
		private function setVolume( vol_:Number, dimming:Boolean = false) :void {
			_volume = vol_;
			if (!dimming) _currentVolume = vol_;
			if (_soundTransform && _channel && !_muted && !_isFading) {
				_soundTransform.volume = vol_;
				_channel.soundTransform = _soundTransform;
			}
		}
		
		public function setMuted(muted : Boolean, duration_:Number ) : void {
			if (_muted!=muted) {
				_muted = muted;
			}
		}
		
		/**
		 * setPan
		 */
		public function set pan( pan_:Number ) :void {
			if (_soundTransform && _channel && pan_!=_soundTransform.pan) {
				_soundTransform.pan = pan_;
				_channel.soundTransform = _soundTransform;
			}
		}
		
		public function get muted() : Boolean {
			return _muted;
		}				public function get volume() : Number {
			return _volume;		}
		
		public function get dimVolume() : Number {
			return _volume;
		}
		
		/**
		 * isPlaying
		 */
		public function isPlaying() :Boolean {
			return _isPlaying;
		}
		
		/**
		 * Dispose
		 */
		public function dispose() : void {
			
			if (_channel) {
				_channel.stop();
				_channel = null;
			}
			
			if (_sound) {
				if (_sound.hasEventListener(Event.COMPLETE)) {
					_sound.removeEventListener(Event.COMPLETE, onComplete);
				}
				try {
					_sound.close();
				} catch(e_:Error) {}
				_sound = null;
			}
		}
		
		public function get sprite() : Sprite {
			return _sprite;
		}
		
		public function set noID3InfoPlease(noID3InfoPlease : Boolean) : void {
			_noID3InfoPlease = noID3InfoPlease;
		}
	}
}
