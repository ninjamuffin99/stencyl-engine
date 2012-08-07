package com.stencyl.graphics.transitions;

import nme.display.BlendMode;
import nme.display.Sprite;
import nme.display.Graphics;
import nme.display.BitmapData;
import nme.display.Shape;

import com.stencyl.Engine;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

class RectangleTransition extends Transition
{
	private var rectangleImg:BitmapData;
	private var graphics:Graphics;
	
	public var color:Int;
		
	//needs to be public so that it can be tweened
	public var width:Int;
	public var height:Int;
		
	private var beginWidth:Int;
	private var endWidth:Int;
	private var beginHeight:Int;
	private var endHeight:Int;
	
	public var rect:Shape;
	
	public function new(direction:String, duration:Float, color:Int) 
	{
		super(duration);
			
		this.color = color;
		this.direction = direction;
		
		if(direction == Transition.IN)
		{
			beginWidth = 0;
			beginHeight = 0;
			endWidth = Engine.screenWidth;
			endHeight = Engine.screenHeight;
		}
		else if(direction == Transition.OUT)
		{
			beginWidth = Engine.screenWidth;
			beginHeight = Engine.screenHeight;
			endWidth = 0;
			endHeight = 0;
		}
		else
		{
			trace("Invalid transition direction: " + direction);
			complete = true;
		}
	}
	
	override public function start()
	{
		active = true;		
		width = beginWidth;
		height = beginHeight;
			
		rectangleImg = new BitmapData(Engine.screenWidth, Engine.screenHeight);
		
		rect = new Shape();
		graphics = rect.graphics;
		
		if (direction == Transition.IN)
		{
			graphics.beginFill(color);
			graphics.drawRect(0, 0, Engine.screenWidth, Engine.screenHeight);
			graphics.endFill();
		}		
		
		Engine.engine.transitionLayer.addChild(rect);
		
		Actuate.tween(this, duration, { width:endWidth, height:endHeight } ).ease(Linear.easeNone).onComplete(stop);
	}
	
	override public function draw(g:Graphics)	
	{
		graphics.clear();
		
		graphics.beginFill(color);
		graphics.drawRect(0, 0, Engine.screenWidth, Engine.screenHeight);
		graphics.endFill();
		
		rectangleImg.draw(Engine.engine.master);
		graphics.beginBitmapFill(rectangleImg);
		graphics.drawRect((Engine.screenWidth - width) / 2, (Engine.screenHeight - height) / 2, width, height);
		graphics.endFill();		
	}
	
	override public function cleanup()
	{		
		if(rect != null)
		{
			Engine.engine.transitionLayer.removeChild(rect);
			rect = null;
		}
	}
	
}