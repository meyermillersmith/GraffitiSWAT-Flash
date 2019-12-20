package com.lessrain.project.model {	import com.lessrain.debug.Debug;	import com.lessrain.project.ApplicationFacade;	import com.lessrain.project.model.vo.ColorData;	import com.lessrain.project.model.vo.PaletteData;	import com.lessrain.puremvc.shared.model.delegates.ILoadDelegate;	import com.lessrain.puremvc.shared.model.delegates.URLLoaderDelegate;	import org.puremvc.as3.multicore.patterns.proxy.Proxy;	import flash.utils.getQualifiedClassName;	/**	 * @author torstenhartel	 */	public class ColorsProxy extends Proxy {		public static const NAME : String = getQualifiedClassName(ColorsProxy);		public static const COLORS_LOAD : String = "colorsLoad";		public static const COLORS_LOADED : String = "colorsLoaded";		public static const TYPE_SUCCESS : String = "typeSuccess";		public static const TYPE_FAILURE : String = "typeFailure";		private var _src : String;		public function ColorsProxy() {			super(NAME);		}		public function load() : void {			if (!_src) {				throw new ArgumentError("No source declared in" + getQualifiedClassName(this));			} else {				var loadDelegate : ILoadDelegate = new URLLoaderDelegate(_src);				var failHandler : Function = function(msg_ : String) : void {					Debug.trace('TutorialProxy::failHandler: Loading has failed: ' + _src + ' ' + msg_, Debug.ERROR);					checkComplete();				};				loadDelegate.completeCallback = handleLoadComplete;				loadDelegate.failCallback = failHandler;				loadDelegate.load();			}		}		private function handleLoadComplete(data_ : *) : void {			data = new Vector.<PaletteData>();			var xml : XML = new XML(data_);			var i : int = 0;			var foundDefault : Boolean;			for each (var itemNode : XML in xml.palette) {				var item : PaletteData = new PaletteData();				item.id = String(itemNode.@id) != '' ? String(itemNode.@id) : '' + i;				item.name = ApplicationFacade.getCopy('palette.' + item.id);				item.isDefault = String(itemNode.@isDefault) == 'true';				item.index = i;				item.defaultColorIndex = 0;							var defaultColor:String = String(itemNode.@defaultColor);				foundDefault ||= item.isDefault;				var children : XMLList = itemNode.children();				for each (var childNode:XML in children ) {					if (childNode.name() == 'color') {						if (defaultColor == String(childNode.@hex)){							item.defaultColorIndex = item.colors.length;						}						item.colors.push(new ColorData(uint('0x' + childNode.@hex),String(childNode.@name)));					}				}				cleanColors(item.colors);				if (item.isDefault) data.unshift(item);				else data.push(item);				i++;			}			if (data.length > 0 && !foundDefault) data[0].isDefault = true;			checkComplete();		}		private function cleanColors(colors : Vector.<ColorData>) : void {			for (var i : int = 0; i < colors.length; i++) {				for (var j : int = i + 1; j < colors.length; j++) {					if (colors[i].color == colors[j].color){						colors.splice(j, 1);						Debug.trace('ColorsProxy::cleanColors: removed color '+colors[i].color+' '+colors[i].name);						j--;
					} else {					}				}			}//			Debug.trace('ColorsProxy::cleanColors: colors '+colors);		}		private function checkComplete() : void {			if (data) {				sendNotification(COLORS_LOADED, data, TYPE_SUCCESS);			} else {				sendNotification(COLORS_LOADED, null, TYPE_FAILURE);			}		}		override public function onRegister() : void {		}		override public function onRemove() : void {		}		protected function get datas() : Vector.<PaletteData> {			return data as Vector.<PaletteData>;		}		public function set src(src : String) : void {			_src = src;		}	}}