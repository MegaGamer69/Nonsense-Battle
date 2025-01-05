package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import sys.io.File;

class PlayState extends FlxState
{
	private var mainHand:Array<FlxCharacter>;
	private var avaliable:Array<FlxCharacter>;
	
	private var characters:Array<FlxCharacter> = [
		new FlxCharacter("Arthur",       1, 0 ), // Arthur Femboy
		new FlxCharacter("Ass",          1, 1 ), // O Comedor De Cu
		new FlxCharacter("Ednaldo",      1, 2 ), // Ednaldo Pereira
		new FlxCharacter("Eduardo",      1, 3 ), // Eduardo Fazballs
		new FlxCharacter("Elon",         1, 4 ), // Elon Musk
		new FlxCharacter("Granny",       1, 5 ), // Granny
		new FlxCharacter("Hitler",       1, 6 ), // Hitler
		new FlxCharacter("Marco",        1, 7 ), // Marco
		new FlxCharacter("Thais",        1, 8 ), // Thaís Carla
		new FlxCharacter("Witch71",      1, 9 ), // Bruxa Do 71
		new FlxCharacter("Psychoduck",   1, 10), // Psicopato
		new FlxCharacter("CreoleBart",   1, 11), // Bart Crioulo
		new FlxCharacter("MatheusGirl",  1, 12), // Matheus Do 4
		new FlxCharacter("Protozoario",  1, 13), // Dr. Protozoário
		new FlxCharacter("IdiotThief",   1, 14), // Ladrão Idiota
		new FlxCharacter("SandroSouza",  1, 15), // Sandro Souza
		new FlxCharacter("SigmaCar",     1, 16), // Carro Sigma
		new FlxCharacter("Garibaldo",    1, 17), // Gari Fumante
		new FlxCharacter("PhantomBitch", 1, 18), // Demônio Maconheiro
		new FlxCharacter("GhostCLT",     1, 19)  // Fantasma CLT
	];
	
	private var deck:Array<FlxCharacter>;
	
	override public function create():Void
	{
		super.create();
		
		deck = new Array<FlxCharacter>();
		
		avaliable = deck.copy();
		
		mainHand = [];
		
		for(i in 0 ... Std.int(Math.min(8, characters.length)))
		{
			deck.push(characters[i]);
		}
		
		for(i in 0 ... Std.int(Math.min(4, deck.length)))
		{
			mainHand.push(deck[i]);
		}
		
		while(mainHand.length < 4 && avaliable.length > 0)
		{
			var index:Int = FlxG.random.int(avaliable.length - 1);
			
			mainHand.push(avaliable[index]);
			avaliable.splice(index, 1);
		}
	}

	override public function update(elapsed:Float):Void
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
	
	private var evolution:Dynamic = {};
	
	public function new(name:String, level:Int, id:Int)
	{
		super();
		
		if(level < 1)
		{
			level = 1;
		}
		
		if(level > 9)
		{
			level = 9;
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
		
		for(i in 0...9)
		{
			Sys.println("Nivel " + i + " HP: " + json.statusPerLvl[i - 1].hp);
			Sys.println("Nivel " + i + " DMG: " + json.statusPerLvl[i - 1].dmg);
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
		
		if(hasEvolution)
		{
			evolution = json.evolutionExtras[currentLvl - 1];
		}
	}
	
	public function evolve():Void
	{
		if(hasEvolution)
		{
			evolution = json.evolutionExtras[currentLvl - 1];
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
