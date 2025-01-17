package flixel.custom;

import flixel.FlxSprite;
import haxe.Json;
import sys.io.File;

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
	
	public function new(name:String, level:Int)
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
		
		json = Json.parse(File.getContent("assets/data/characters/" + name + ".json"));
		
		evolution = json.evolutionExtras[level - 1];
		
		loadGraphic("assets/images/characters/" + name + ".jpg");
		
		currentLvl = level;
		
		hitpoints = json.statusPerLvl[level - 1].hp;
		damage = json.statusPerLvl[level - 1].dmg;
		
		attackDelay = json.status.atkSpeed;
		metersPerSecond = json.status.movSpeed;
		
		hasEvolution = json.hasEvolution;
		
		Sys.println(attributeToString("Nome: " + json.name));
		Sys.println(attributeToString("Descrição: " + json.description));
		Sys.println("Níveis e melhorias:");
		
		// Informação importante: Os níveis vão de 1 à 9 por padrão
		
		for(i in 1...9)
		{
			Sys.println("Nivel " + i + " Vida: " + attributeToString(json.statusPerLvl[i - 1].hp));
			Sys.println("Nivel " + i + " Dano: " + attributeToString(json.statusPerLvl[i - 1].dmg));
		}
		
		Sys.println("Tem evolução? " + (hasEvolution ? "Sim" : "Não"));
		
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
		if(currentLvl >= 1 && currentLvl <= 9)
		{
			currentLvl++;
			
			hitpoints = json.statusPerLvl[currentLvl - 1].hp;
			damage = json.statusPerLvl[currentLvl - 1].dmg;
			
			if(hasEvolution)
			{
				evolution = json.evolutionExtras[currentLvl - 1];
			}
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
		if(amount > 0 && hitpoints > 0)
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
