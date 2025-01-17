package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.custom.FlxCharacter;
import flixel.group.FlxSpriteGroup;

class PlayState extends FlxState
{
	private var mainHand:Array<FlxCharacter>;
	private var avaliable:Array<FlxCharacter>;
	
	private var characters:Array<FlxCharacter> = [
		new FlxCharacter("Arthur",       1), // Arthur Femboy
		new FlxCharacter("Ass",          1), // O Comedor De Cu
		new FlxCharacter("Ednaldo",      1), // Ednaldo Pereira
		new FlxCharacter("Eduardo",      1), // Eduardo Fazballs
		new FlxCharacter("Elon",         1), // Elon Musk
		new FlxCharacter("Granny",       1), // Granny
		new FlxCharacter("BadHairDict",  1), // Mal-Penteado Alemão
		new FlxCharacter("Marco",        1), // Marco
		new FlxCharacter("Thais",        1), // Thaís Carla
		new FlxCharacter("Witch71",      1), // Bruxa Do 71
		new FlxCharacter("Psychoduck",   1), // Psicopato
		new FlxCharacter("CreoleBart",   1), // Bart Crioulo
		new FlxCharacter("MatheusGirl",  1), // Matheus Do 4
		new FlxCharacter("Protozoario",  1), // Dr. Protozoário
		new FlxCharacter("IdiotThief",   1), // Ladrão Idiota
		new FlxCharacter("SandroSouza",  1), // Sandro Souza
		new FlxCharacter("SigmaCar",     1), // Carro Sigma
		new FlxCharacter("Garibaldo",    1), // Gari Fumante
		new FlxCharacter("PhantomBitch", 1), // Demônio Maconheiro
		new FlxCharacter("GhostCLT",     1)  // Fantasma CLT
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
