package elementalair.mobile.events {
	
	import flash.events.Event;
	
	public class MobileVideoEvent extends Event {
		
		public static const ACTIVATE:String 	= 'activate';
		
		public static const DEACTIVATE:String 	= 'deactivate';
		
		public static const	COMPLETE:String 	= 'complete';
		
		public static const ERROR:String		= 'error';
		
		public static const DISPOSED:String		= 'removed';
		
		public function MobileVideoEvent(type:String, text:String = '', bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}
}