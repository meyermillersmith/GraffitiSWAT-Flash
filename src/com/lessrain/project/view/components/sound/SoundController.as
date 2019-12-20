package com.lessrain.project.view.components.sound {	import com.lessrain.logger.LogManager;	import com.lessrain.util.CallDelay;	import flash.display.Sprite;	import flash.utils.Dictionary;	/**	 * Offers high-level access to common builder sounds	 * @author Torsten Haertel, Less Rain (torsten_at_lessrain.com)	 */	public class SoundController extends Sprite {				public static const SOUND_UPDATE : String = 'SoundControllerSoundUpdate';				protected static var _instance:SoundController = null;		protected var _soundGroup:SoundGroup;				public static const Spray : String = 'Spray';		public static const SprayCanShake : String = 'SprayCanShake';		public static const ChooseColor : String = 'ChooseColor';		public static const RollerDrawing : String = 'RollerDrawing';		public static const PenDrawing : String = 'PenDrawing';				/**		 * Sounds		 */		protected static const SOUNDS	: Array  = [Spray, SprayCanShake, ChooseColor, RollerDrawing, PenDrawing];								private var _sounds 			: Array;
		private var _id 				: String;
		private var _soundOn : Boolean;		private var _streamingSound : StreamingSound;		private var _dStreamingSounds : Dictionary;		private var _currentSound : AssetSound;				public function SoundController(forceSingleton:SingletonEnforcer) {						if (forceSingleton is SingletonEnforcer == false) {				throw new Error('SoundController is a singleton, please use getInstance()');			}						_soundGroup = new SoundGroup();
			initializeSounds();
			soundOn = true;
		}
		
		public static function getInstance():SoundController {
			if (_instance == null) _instance = new SoundController( new SingletonEnforcer() );
			return _instance;	
		}
		
		// Initialize used sounds		protected function initializeSounds():void {			
			_dStreamingSounds = new Dictionary();			_sounds = new Array();			for each (var linkageID : String in SOUNDS) {				var assetSound : AssetSound = new AssetSound(linkageID, _soundGroup);//				assetSound.forceSingleChannel = true;				_sounds.push(assetSound);			}		}		public function dispose():void {			_soundGroup.dispose(true);			_soundGroup = null;			_instance = null;		}				/**		 * playEventSoundByID		 */		public function playEventSoundByID(id:String, volume:Number = 1, pan_:Number = 0, loops_:int = 0):void {			if (!_soundOn) return;
			
			var vol:Number = volume;
			if (volume == 1) {
				if (id.indexOf('Interface')>=0) vol = .25;
			}						_currentSound = _soundGroup.getSound(id) as AssetSound;			if (_currentSound) {				_currentSound.volume = vol;
				_currentSound.pan = pan_;				_currentSound.play(0,loops_);			}			else LogManager.error('SoundController.playEventSoundByID :: '+id);		}		public function playEventSoundDelayed(id_:String, delay_:Number):void {			if (!_soundOn) return;
			_id = id_;			CallDelay.call(playStoredSound, delay_);		}		private function playStoredSound() : void {			playEventSoundByID(_id, .25);
		}				public function stop() : void {			if (_currentSound){				_currentSound.stop();				_currentSound = null;			}		}				public function get soundOn() : Boolean {
			return _soundOn;
		}

		public function set soundOn(soundOn : Boolean) : void {
			_soundOn = soundOn;			if (soundOn){				resumeStream();
			}else stopStream();		}
				public function stream(src_ : String) : void {			if (soundOn){				if (!_streamingSound) {					_streamingSound = new StreamingSound();
					_dStreamingSounds[src_] = _streamingSound;					_streamingSound.src = src_;
					_streamingSound.start();				}				else _streamingSound.resume();			}		}				public function setStreamVolume(vol_:Number) :void {			if (_streamingSound){				if (soundOn) _streamingSound.volume = vol_;				else _streamingSound.passiveVolume = vol_;
			}		}		public function stopStream() : void {			if (_streamingSound) {				_streamingSound.pause();			}		}		public function resumeStream() : void {			if (_streamingSound) {				_streamingSound.resume();			}		}				public function get isPlaying():Boolean{			return _currentSound != null && _currentSound.isPlaying;		}	}}internal class SingletonEnforcer{}