////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.connection
{
	import ru.valyard.osc.connection.IOSCConnection;
	import ru.valyard.osc.tuio.data.TUIOBlob;
	import ru.valyard.osc.tuio.data.TUIOCursor;
	import ru.valyard.osc.tuio.data.TUIOObject;

	/**
	 * @author					valyard
	 */
	public interface ITUIOConnection {
		
		/**
		 * current TUIO frame number
		 */
		function get currentFrame():uint;
		
		/**
		 * true if connection is ready
		 */
		function get active():Boolean;
		
		/**
		 * OSC connection used
		 */
		function get connection():IOSCConnection;
		
		/**
		 * Closes connection
		 */
		function close():void;
		
		/**
		 * Returns Cursor by id
		 * @param id	Cursor id.
		 * @return		Cursor with specified id.
		 */
		function getCursor(id:Number):TUIOCursor;
		
		/**
		 * Returns Object by id
		 * @param id	Object id.
		 * @return		Object with specified id.
		 */
		function getObject(id:Number):TUIOObject;
		
		/**
		 * Returns Blob by id
		 * @param id	Blob id.
		 * @return		Blob with specified id.
		 */
		function getBlob(id:Number):TUIOBlob;
		
		/**
		 * Adds a listener
		 */
		function addListener(listener:ITUIOConnectionListener):void;
		
		/**
		 * Removes a listener
		 */
		function removeListener(listener:ITUIOConnectionListener):void;
	}
}