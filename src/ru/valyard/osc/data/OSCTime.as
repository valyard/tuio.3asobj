////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.data
{
	/**
	 * @author					valyard
	 */
	public class OSCTime {
		
		public function OSCTime(seconds:uint, picoseconds:uint) {
			this.seconds = seconds;
			this.picoseconds = picoseconds;
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
		
		public var seconds:uint;
		
		public var picoseconds:uint;
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Overriden methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Private functions
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
}