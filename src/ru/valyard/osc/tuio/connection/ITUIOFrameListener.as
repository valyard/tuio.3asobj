////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.connection
{
	/**
	 * Something which is interested in new TUIO frames
	 * @author					valyard
	 */
	public interface ITUIOFrameListener extends ITUIOConnectionListener	{
		
		/**
		 * Callback for new TUIO frame
		 * @param id	frame id
		 */
		function newFrame(id:uint):void;
		
	}
}