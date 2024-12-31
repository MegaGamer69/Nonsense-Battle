package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxTypedSpriteGroup;
import haxe.Json;
import sys.io.File;

class PlayState extends FlxState
{
	private var mainHand:Array<FlxCharacter>;
	private var avaliable:Array<FlxCharacter>;
		
	private var characters:Array<FlxCharacter> = [
		new FlxCharacter("Arthur",      1, 0 ),
		new FlxCharacter("Ass",         1, 1 ),
		new FlxCharacter("Ednaldo",     1, 2 ),
		new FlxCharacter("Eduardo",     1, 3 ),
		new FlxCharacter("Elon",        1, 4 ),
		new FlxCharacter("Granny",      1, 5 ),
		new FlxCharacter("Hitler",      1, 6 ),
		new FlxCharacter("Marco",       1, 7 ),
		new FlxCharacter("Thais",       1, 8 ),
		new FlxCharacter("Witch71",     1, 9 ),
		new FlxCharacter("Psychoduck",  1, 10),
		new FlxCharacter("CreoleBart",  1, 11),
		new FlxCharacter("MatheusGirl", 1, 12),
		new FlxCharacter("Protozoario", 1, 13),
		new FlxCharacter("IdiotThief",  1, 14)
	];
	
	private var deck:FlxTypedSpriteGroup<FlxCharacter>;
	
	override public function create()
	{
		super.create();
		
		deck = new FlxTypedSpriteGroup<FlxCharacter>();
		deck.maxSize = 8;
		
		avaliable = deck.members.copy();
		
		hand = [];
		
		for(i in 0 ... Std.int(Math.min(8, characters.length)))
		{
			deck.add(character[i]);
		}
		
		for(i in 0 ... Std.int(Math.min(4, deck.length)))
		{
			mainHand.add(deck[i]);
		}
		
		while(hand.length < 4 && avaliable.length - 1)
		{
			// Temporariamente vazio
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
	
	private var identifier:Int;
	
	private var hitpoints:Int;
	private var damage:Int;
	
	private var attackDelay:Float;
	private var metersPerSecond:Float;
	
	private var attackRange:Float;
	
	private var currentLvl:Int;
	
	private var hasEvolution:Bool;
	
	private var evoltion:Dynamic = {};
	
	public function new(name:String, level:Int, id:Int)
	{
		super();
		
		if(level < 1 || level > 9)
		{
			level = 1;
		}
		
		if(id > 0)
		{
			identifier = id;
		}
		
		json = Json.parse(File.getContent("assets/data/characters/" + name + ".json"));
		
		evolution = json.evolutionExtras[level - 1];
		
		loadGraphic("assets/images/characters/" + name + ".jpg");
		
		currentLvl = level;
		
		hitpoints = json.statusPerLvl[level].hp;
		damage = json.statusPerLvl[level].dmg;
		
		attackDelay = json.status.atkSpeed;
		metersPerSecond = json.status.movSpeed;
		
		hasEvolution = json.hasEvolution;
		
		Sys.println(attributeToString("Nome: " + json.name));
		Sys.println(attributeToString("Descrição: " + json.description));
		Sys.println("Níveis e melhorias:");
		
		// Informação importante: Os níveis vão de 1 à 9 por padrão
		
		for(i in 1...10)
		{
			Sys.println(i + " HP: " + attributeToString(evolution.hp));
			Sys.println(i + " DMG: " + attributeToString(evolution[i - 1].dmg));
		}
		
		Sys.println("Tem evolução: " + attributeToString(hasEvolution));
		
		if(hasEvolution)
		{
			Sys.println("Evolução: " + attributeToString(json.evolutionExtras));
		}
		
		Sys.println("Intervalo de ataque: " + attributeToString(json.status.atkSpeed));
		Sys.println("Metros por segundo: " + attributeToString(json.status.movSpeed));
		Sys.println("Alcance de ataque: " + attributeToString(json.status.atkRange));
		
		scale.set(0.165, 0.165);
		
		centerOrigin();
	}
	
	public function upgrade():Void
	{
		currentLvl++;
		
		hitpoints = json.statusPerLvl[currentLvl - 1].hp;
		damage = json.statusPerLvl[currentLvl - 1].dmg;
	}
	
	public function evolve():Void
	{
		if(hasEvolution)
		{
			evolution = json.evolutionExtras[currentLvl - 1]
		}
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
