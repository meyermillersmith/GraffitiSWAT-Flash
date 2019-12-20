package com.lessrain.project.view.components.sound {
		private var _id 				: String;
		private var _soundOn : Boolean;
			initializeSounds();
			soundOn = true;
		}
		
		public static function getInstance():SoundController {
			if (_instance == null) _instance = new SoundController( new SingletonEnforcer() );
			return _instance;	
		}
		
		// Initialize used sounds
			_dStreamingSounds = new Dictionary();
			
			var vol:Number = volume;
			if (volume == 1) {
				if (id.indexOf('Interface')>=0) vol = .25;
			}
				_currentSound.pan = pan_;
			_id = id_;
		}
			return _soundOn;
		}

		public function set soundOn(soundOn : Boolean) : void {
			_soundOn = soundOn;
			}else stopStream();
		
					_dStreamingSounds[src_] = _streamingSound;
					_streamingSound.start();
			}