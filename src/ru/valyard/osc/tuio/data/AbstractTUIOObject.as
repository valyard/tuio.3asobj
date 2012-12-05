////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.data
{
	import flash.errors.IllegalOperationError;
	
	/**
	 * @author					valyard
	 */
	public class AbstractTUIOObject {
		
		public function AbstractTUIOObject(type:String, sessionID:Number, x:Number, y:Number, z:Number, X:Number, Y:Number, Z:Number, m:Number, frameID:uint)	{
			this.type = type;
			this.sessionID = sessionID;
			this.x = x;
			this.y = y;
			this.z = z;
			this.X = X;
			this.Y = Y;
			this.Z = Z;
			this.m = m;
			this.frameID = frameID;
		}
		
		//--------------------------------------------------------------------------
		//
		// Private variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Object id
		 */
		public var sessionID:uint;
		
		/**
		 * Object x coordinate
		 */
		public var x:Number;
		
		/**
		 * Object y coordinate
		 */
		public var y:Number;
		
		/**
		 * Object z coordinate
		 */
		public var z:Number;
		
		/**
		 * Object X speed
		 */
		public var X:Number;
		
		/**
		 * Object Y speed
		 */
		public var Y:Number;
		
		/**
		 * Object Z speed
		 */
		public var Z:Number;
		
		/**
		 * Motion acceleration
		 */
		public var m:Number;
		
		/**
		 * Object type: 2D, 25D, 3D
		 */
		public var type:String;
		
		/**
		 * Object frame id
		 */
		public var frameID:uint;
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
	}
}