package com.lessrain.project.view.utils {
	/**
	 * @author denise
	 */
	public class ObjectPrinter {
		public static function print (obj:*, level:int = 0, output:String = ""):* {
		    var tabs:String = " ";
		    for(var i:int = 0; i < level; i++, tabs += "");
		    
		    for(var child:* in obj) {
		        output += tabs +"["+ child +"] => "+ obj[child];
		        
		        var childOutput:String = print(obj[child], level+1);
		        if(childOutput != '') output += '{'+ childOutput + tabs +'}';
		        
		        output += ',';
		    }
			output = output.slice( 0, -1 );
		    
		    return output;
  
		}
	}
}
