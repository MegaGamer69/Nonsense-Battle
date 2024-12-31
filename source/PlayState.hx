package;

import flixel.FlxState;
import flixel.FlxSprite;
import haxe.Json;
import haxe.ds.Vector;
import sys.io.File;

class PlayState extends FlxState
{
	private var characters:Array<FlxCharacter> = [
		new FlxCharacter("Arthur.json", 1),
		new FlxCharacter("Ass.json", 1),
		new FlxCharacter("Ednaldo.json", 1),
		new FlxCharacter("Eduardo.json", 1),
		new FlxCharacter("Elon.json", 1),
		new FlxCharacter("Granny.json", 1),
		new FlxCharacter("Hitler.json", 1),
		new FlxCharacter("Marco.json", 1),
		new FlxCharacter("Thais.json", 1),
		new FlxCharacter("Witch71.json", 1),
		new FlxCharacter("Psychoduck.json", 1),
		new FlxCharacter("CreoleBart.json", 1),
		new FlxCharacter("MatheusGirl.json", 1),
		new FlxCharacter("Protozoario.json", 1)
	];
	
	private var deck:Vector<FlxCharacter> = new Vector(8);
	
	override public function create()
	{
		super.create();
		
		// Testes
		
		for(i in 0...deck.length)
		{
			deck[i] = characters[i];
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

class FlxCharacter extends FlxSprite
{
	private var json:Dynamic = {};
	
	private var hitpoints:Int;
	private var damage:Int;
	
	private var attackDelay:Float;
	private var metersPerSecond:Float;
	
	private var attackRange:Float;
	
	private var currentLvl:Int;
	
	private var hasEvolution:Bool;
	
	public function new(name:String, level:Int)
	{
		super();
		
		json = Json.parse(File.getContent("assets/data/characters/" + name));
		
		loadGraphic("assets/images/characters/" + name);
		
		currentLvl = level;
		
		hitpoints = json.statusPerLvl[level].hp;
		damage = json.statusPerLvl[level].dmg;
		
		attackDelay = json.status.atkSpeed;
		metersPerSecond = json.status.movSpeed;
		
		hasEvolution = json.hasEvolution;
		
		Sys.println(attributeToString("Name: " + json.name));
		Sys.println(attributeToString("Description: " + json.description));
		Sys.println("Levels and upgrades:");
		
		// Informação importante: Os níveis vão de 1 à 9 por padrão
		
		for(i in 1...10)
		{
			Sys.println(i + " HP: " + attributeToString(json.statusPerLvl[i - 1].hp));
			Sys.println(i + " DMG: " + attributeToString(json.statusPerLvl[i - 1].dmg));
		}
		
		Sys.println("Has evolution: " + attributeToString(hasEvolution));
		
		if(hasEvolution)
		{
			Sys.println("Evolution: " + attributeToString(json.evolutionExtras));
		}
		
		Sys.println("Attack delay: " + attributeToString(json.status.atkSpeed));
		Sys.println("Meters/s: " + attributeToString(json.status.movSpeed));
		Sys.println("Atk. range: " + attributeToString(json.status.atkRange));
	}
	
	public function attributeToString(selected:Dynamic):String
	{
		return Std.string(selected);
	}
	
	public function applyDamage(amount:Int):Void
	{
		if(amount > 0)
		{
			hitpoints -= amount;
		}
	}
	
	public function attack(target:FlxCharacter, amount:Int):Void
	{
		if(amount > 0)
		{
			target.applyDamage(amount);
		}
	}
}
