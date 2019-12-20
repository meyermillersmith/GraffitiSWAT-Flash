package com.lessrain.project.model.vo {
	/**
	 * @author lessintern
	 */
	public class SurfaceData extends BuyableData {

		private var _dbid:int;
		public static const TYPE:String = 'surface';
		
		public function SurfaceData() {
			_type = TYPE;
		}

		public function get dbid() : int {
			return _dbid;
		}

		public function set dbid(dbid : int) : void {
			_dbid = dbid;
		}
	}
}
