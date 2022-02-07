Engine_filtSaw : CroneEngine {
    
  var params;
  alloc{
  
    
    SynthDef(\filtSaw, {
		arg		freq, detune, atk, sus, rel, curve1, curve2,
				minCf, maxCf, minRq, maxRq,
				minBpfHz, maxBpfHz,
				lowShelf, rs, db,
				gate, amp, spread, out;
		var sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[curve1,0,curve2]), gate, levelScale:amp, doneAction:2);
		sig = Saw.ar(
			freq +
			LFNoise1.kr({LFNoise1.kr(0.5).range(0.15,0.4)}!8).range(detune.neg,detune));
		sig = BPF.ar(
			sig,
			LFNoise1.kr({LFNoise1.kr(0.13).exprange(minBpfHz,maxBpfHz)}!8).exprange(minCf, maxCf),
			LFNoise1.kr({LFNoise1.kr(0.08).exprange(0.08,0.35)}!8).range(minRq, maxRq));
		sig = BLowShelf.ar(sig, lowShelf, rs, db);
		sig = SplayAz.ar(4, sig, spread);
		sig = sig * env * 2;
		Out.ar(out, sig);
	}).add;

params = Dictionary.newFrom([

			\detune, 3.0,
			\atk, 6,
			\sus, 4,
			\rel, 6,
			\curve1, 1,
	    \curve2, (-1),
			\minCf, 30,
	    \maxCf, 6000,
	    \minRq, 0.005,
	    \maxRq, 0.04,
	    \minBpfHz, 0.02,
	    \maxBpfHz, 0.25,
	    \lowShelf, 220,
	    \rs, 0.85,
	    \db, 6,
	    \gate, 1,
	    \amp, 1,
	    \spread, 1,
	  
		]);

params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

this.addCommand("hz", "f", { arg msg;
			Synth.new("filtSaw", [\freq, msg[1]] ++ params.getPairs)
		});
  }  

}	
