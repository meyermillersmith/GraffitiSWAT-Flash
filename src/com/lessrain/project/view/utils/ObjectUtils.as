package com.lessrain.project.view.utils {
	import flash.utils.describeType;

	/**
	 * @author Luis Martinez (luis.martinezriancho@gmail.com)
	 */
	public class ObjectUtils {
		public static function inspect(obj_ : Object, depth_ : int = 10, prefix_ : String = "\t", filterProps_ : Array = null) : String {
			var scan : Function = function(obj_ : Object, depth_ : int, prefix_ : String,filterProps_ : Array = null) : String {
				var out : String;

				if (depth_ < 1) {
					out = obj_ is String ? "\"" + obj_ + "\"" : String(obj_);
				} else {
					const classDef : XML = describeType(obj_);
					var str : String = "";

					if (filterProps_) {
						for each (var variableFilter:XML in classDef.variable) {
							if( filterProps_.indexOf(String(variableFilter.@name))>-1)
							{
								str += prefix_ + variableFilter.@name + " = " + scan(obj_[variableFilter.@name], depth_ - 1, prefix_ + '\t',filterProps_) + '\n';
							}
						}
					} else {
						for each (var variable:XML in classDef.variable) {
							str += prefix_ + variable.@name + " = " + scan(obj_[variable.@name], depth_ - 1, prefix_ + '\t') + '\n';
						}
					}

					for (var s:String in obj_) {
						str += prefix_ + s + "=" + scan(obj_[s], depth_ - 1, prefix_ + '\t',filterProps_) + '\n';
					}

					// noinspection NestedConditionalExpressionJS,NegatedConditionalExpressionJS
					out = str == "" ? ((obj_ != null) ? (obj_ is String ? "\"" + obj_ + "\"" : obj_ + "") : "null") : ("[" + classDef.@name + "] {\n" + str + (prefix_.substr(0, prefix_.length - 1)) + "}");
				}

				return out;
			};

			return prefix_ + scan(obj_, depth_, prefix_ + '\t',filterProps_);
		}
	}
}
