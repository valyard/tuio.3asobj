////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.connection {
	
	import ru.valyard.osc.tuio.data.TUIOCursor;
	
	/**
	 * @author					valyard
	 */
	public interface ITUIOCursorListener extends ITUIOConnectionListener {
		
		/**
		 * Callback for adding TUIO cursors
		 * @param object	TUIOCursor instance
		 */
		function addTUIOCursor(cursor:TUIOCursor):void;
		
		/**
		 * Callback for updating TUIO cursors
		 * @param object	TUIOCursor instance
		 */
		function updateTUIOCursor(cursor:TUIOCursor):void;
		
		/**
		 * Callback for removing TUIO cursors
		 * @param object	TUIOCursor instance
		 */
		function removeTUIOCursor(cursor:TUIOCursor):void;
		
	}
}