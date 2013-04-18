package elementalair.mobile.mobileText {
	
	import flash.text.StageText;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.SoftKeyboardEvent;
	import flash.system.Capabilities;
	
	import elementalair.mobile.events.MobileTextEvent;
	
	public class MobileTextObject extends MobileTextObjectModel {

		private var _bitmapCopy:Bitmap;
		
		public function MobileTextObject() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		protected override function init(evt:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			// Invoke garbage collection when object is removed from stage
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.dispose);
			
			// Check for retina display on IOS
			if (Capabilities.screenDPI == 264) super.compensateForRetina = true;
			
			if (super.hasBackground) this.drawBackground();
			else this.drawStageText();
		}
		
		/**
		 * Draw StageText background and border as Sprite.
		 */
		private function drawBackground():void {
			// add super.useLocalToGlobal dhrck here for forms in nested DisplayObjects
			
			super.backgroundSprite = new Sprite();
			
			// Draw background Sprite if border and background colors are set.
			if (super.borderColor is uint) 
				super.backgroundSprite.graphics.lineStyle(super.borderThickness, super.borderColor);
			if (super.backgroundColor is uint)
				super.backgroundSprite.graphics.beginFill(super.backgroundColor);
			
			super.backgroundSprite.graphics.drawRect(0, 0, super.textFieldWidth, super.textFieldHeight);
			
			this.addChild(super.backgroundSprite);
			
			this.drawStageText();
		}
		
		/**
		 * Create StageText object.
		 */
		private function drawStageText():void {
			// Convert local x and y of textObject to global x and y for native os screen poisition
			var localPoint:Point = new Point(this.x, this.y);
			
			var globalPoint:Point;
			if (super.useLocalToGlobal) globalPoint = this.localToGlobal(localPoint);
			else globalPoint = localPoint;
			
			var stWidth:Number = super.textFieldWidth;
			var stHeight:Number = super.textFieldHeight;
			
			// Multiply width, height, x and y properties of StageText if retina display
			if (super.compensateForRetina) {
				stWidth  *= 2;
				stHeight *= 2;
				globalPoint.x *= 2;
				globalPoint.y *= 2;
			}
			
			super.stageText 			= new StageText();
			super.stageText.stage 		= this.parent.stage;
			super.stageText.viewPort 	= new Rectangle(globalPoint.x, globalPoint.y, stWidth, stHeight);
			
			super.stageText.addEventListener(FocusEvent.FOCUS_IN,	this.stageTextFocusHandler);
			super.stageText.addEventListener(FocusEvent.FOCUS_OUT, 	this.stageTextFocusHandler);
			super.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, this.softKeyboardEventHandler);
			super.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, this.softKeyboardEventHandler);
			super.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, this.softKeyboardEventHandler);
		}
		
		/** StageText event handlers. **/
		
		/**
		 * StageText focus event handlers.
		 * @param evt
		 */
		private function stageTextFocusHandler(evt:FocusEvent):void {
			super.textValue = super.stageText.text;
			
			if (evt.type == FocusEvent.FOCUS_IN) this.stageTextFocusInHandler();
			if (evt.type == FocusEvent.FOCUS_OUT) this.displayAsBitmapCopy();
		}
		
		/**
		 * Highlight all text when StageText object gains focus.
		 */
		private function stageTextFocusInHandler():void {
			super.stageText.selectRange(0, super.stageText.text.length);
		}
		
		private function softKeyboardEventHandler(evt:SoftKeyboardEvent):void {
			trace(this + ' SoftKeyboardEvent: ' + evt.type);
			// Dispatch copy of SoftKeyboardEvent
			this.dispatchEvent(new MobileTextEvent(MobileTextEvent.KEYBOARD_ACTIVATE));
		}
		
		/**
		 * Hide bitmap copy and set StageText to visible and assign focus.
		 */
		private function displayAsStageText(evt:MouseEvent = null):void {
			this.removeEventListener(MouseEvent.MOUSE_UP, this.displayAsStageText);
			
			if (this._bitmapCopy) {
				if (this.contains(this._bitmapCopy)) {
					this.removeChild(this._bitmapCopy);
				}
				// Remove bitmapdata from memory instead of waiting for garbage collection
				this._bitmapCopy.bitmapData.dispose();
				this._bitmapCopy = null;
			}
			
			super.stageText.visible = true;
			super.stageText.assignFocus();
		}
		
		/**
		 * Get Bitmap copy of StageText object is text property has a value.
		 */
		private function displayAsBitmapCopy():void {
			// Set stage display quality to HIGH temporarily for good Bitmap copy
			super.stageText.stage.quality = StageQuality.HIGH;
			var area:Rectangle = super.stageText.viewPort;
			var bitmap:BitmapData = new BitmapData(area.width, area.height , true , 0x00000000);
			
			super.stageText.drawViewPortToBitmapData(bitmap);
			
			this._bitmapCopy = new Bitmap(bitmap);
			this._bitmapCopy.x = 0;
			this._bitmapCopy.y = 0;
			this.addChild(this._bitmapCopy);
			
			super.stageText.visible = false;
			super.stageText.stage.quality = StageQuality.LOW;
			
			this.addEventListener(MouseEvent.MOUSE_UP, this.displayAsStageText);
		}
		
		/**
		 * Display StageText as local display object.
		 */
		public function displayLocal():void {
			this.displayAsBitmapCopy();
		}
		
		/**
		 * Display as StageText.
		 */
		public function displayNative():void {
			this.displayAsStageText();
		}
		
		/**
		 * Remove StageText and display objects.
		 */
		public function dispose(evt:Event = null):void {
			if (super.stageText) {
				super.stageText.stage = null;
				super.stageText.dispose();
			}
			
			if (this._bitmapCopy) {
				if (this.contains(this._bitmapCopy)) {
					this.removeChild(this._bitmapCopy);
				}
				// Remove bitmapdata from memory instead of waiting for garbage collection
				this._bitmapCopy.bitmapData.dispose();
				this._bitmapCopy = null;
			}
			
			if (super.backgroundSprite) {
				this.removeChild(super.backgroundSprite);
				super.backgroundSprite = null;
			}
		}
		
	}
}