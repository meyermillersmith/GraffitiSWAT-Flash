package com.lessrain.project.view.components.canvas {
	import flash.geom.Point;
	/**
	 * @author lessintern
	 */
	public class CurveBezier {
		private var _points : Vector.<Point>;
		private var _distance_tolerance : Number = 5;
		private var _approximation_scale : Number = 1;
		private var _angle_tolerance : Number = 0.05 * Math.PI;
		private var _curve_recursion_limit : Number = 17;
		private var _curve_collinearity_epsilon : Number = 0;
		private var _curve_angle_tolerance_epsilon : Number = 0;
		private var _count : int;
		
		
//		public static function curveThrough3Points(g:Graphics, points:Array/*of Points*/):void{
//			if (points.length != 3){
//				CubicBezier.curveThroughPoints(g, points);
//			} else {
//				var p0:Point = points[0];
//				var p1:Point = points[1];
//				var p2:Point = points[1];
//				var useQuadratic:Boolean;
//				if (Math.abs(p2.x -p0.x) > Math.abs(p2.y - p0.y)){
//					var m:Number = (p2.x -p0.x) / (p2.y - p0.y);
//					var b:Number = p0.y - m*p0.x;
//					var projectedP1Y:Number = m*p1.x + b;
//					useQuadratic
//				}
//			}
//		}
		
		    //------------------------------------------------------------------------
    public function calc(x1:Number, y1:Number, 
                          x2:Number, y2:Number, 
                          x3:Number, y3:Number):Vector.<Point>
    {
        _points = new Vector.<Point>;
        _distance_tolerance = 0.5 / _approximation_scale;
       	_distance_tolerance *= _distance_tolerance;
        bezier(x1, y1, x2, y2, x3, y3);
       	_count = 0;
       	return _points;
    }
    
    function bezier(x1:Number, y1:Number, 
                          x2:Number, y2:Number, 
                          x3:Number, y3:Number):void
    {
        _points.push(new Point(x1, y1));
        recursive_bezier(x1, y1, x2, y2, x3, y3, 0);
        _points.push(new Point(x3, y3));
    }


    //------------------------------------------------------------------------
    function recursive_bezier(x1:Number, y1:Number, 
                          x2:Number, y2:Number, 
                          x3:Number, y3:Number,
                          level:Number):void
    {
        if(level > _curve_recursion_limit) 
        {
            return;
        }

        // Calculate all the mid-points of the line segments
        //----------------------
        var x12:Number   = (x1 + x2) / 2;                
        var y12:Number   = (y1 + y2) / 2;
        var x23:Number   = (x2 + x3) / 2;
        var y23:Number   = (y2 + y3) / 2;
        var x123:Number  = (x12 + x23) / 2;
        var y123:Number  = (y12 + y23) / 2;

        var dx:Number = x3-x1;
        var dy:Number = y3-y1;
        var d:Number = Math.abs(((x2 - x3) * dy - (y2 - y3) * dx));

        if(d > _curve_collinearity_epsilon)
        { 
            // Regular care
            //-----------------
            if(d * d <= _distance_tolerance * (dx*dx + dy*dy))
            {
                // If the curvature doesn't exceed the distance_tolerance value
                // we tend to finish subdivisions.
                //----------------------
                if(_angle_tolerance < _curve_angle_tolerance_epsilon)
                {
                    _points.push(new Point(x123, y123));
                    return;
                }

                // Angle & Cusp Condition
                //----------------------
               	var da:Number = Math.abs(Math.atan2(y3 - y2, x3 - x2) - Math.atan2(y2 - y1, x2 - x1));
                if(da >= Math.PI) da = 2*Math.PI - da;

                if(da < _angle_tolerance)
                {
                    // Finally we can stop the recursion
                    //----------------------
                    _points.push(new Point(x123, y123));
                    return;                 
                }
            }
        }
        else
        {
            // Collinear case
            //-----------------
            dx = x123 - (x1 + x3) / 2;
            dy = y123 - (y1 + y3) / 2;
            if(dx*dx + dy*dy <= _distance_tolerance)
            {
                _points.push(new Point(x123, y123));
                return;
            }
        }

        // Continue subdivision
        //----------------------
        recursive_bezier(x1, y1, x12, y12, x123, y123, level + 1); 
			recursive_bezier(x123, y123, x23, y23, x3, y3, level + 1);
		}

		public function get points() : Vector.<Point> {
			return _points;
		}
    
	}
}
