(
MIDIIn.connect;

s.waitForBoot{

	~length = 4;
	~dur = 0.5;
	~split = 0;

	{SinOsc.ar(440,0,Line.kr(0.1,0,1,doneAction:2))}.play;

	~pool = "pool/*.scd".loadPaths;
	~synth_name = "cheappiano";

	~pool.do({ arg item, i; item.add; [i, item.name].postln; });

	// var keys;
	~keys = Array.newClear(128);

	~noteOnFunc = {arg src, chan, num, vel;
		var node, boolsplit;
		node = ~keys.at(num);
		if (node.notNil, {
			node.release;
			~keys.put(num, nil);
		});

		if(num<~split,{boolsplit=127-~mode},{boolsplit=~mode});

		if(boolsplit==127,{
			node = Synth.tail(nil, ~synth_name, [\freq, num.midicps, \amp, 0.5*vel/127]);},
		{var le, stream, dur;
			dur = ~dur;
			if(~length*num.midicps>20000,{le=20000/num.midicps},{le=~length});

			stream = Pseries(num.midicps, num.midicps,  le).asStream;

			Routine({
				le.do({
					Synth(~synth_name, [ \freq, stream.next ] );
					dur.wait; // synonym for yield, used by .play to schedule next occurence
				})
			}).play

			/*Pbind(
				\instrument, ~synth_name,
				\freq, Pseries(num.midicps, num.midicps, ~length/127*20),
				\dur, ~dur/127;
			).play;*/

		});

		~keys.put(num, node);
		//[chan,num,vel/127].postln;
	};
	MIDIIn.addFuncTo(\noteOn, ~noteOnFunc);

	~noteOffFunc = {arg src, chan, num, vel;
		var node;
		node = ~keys.at(num);
		if (node.notNil, {
			node.release;
			~keys.put(num, nil);
		});
	};

	MIDIIn.addFuncTo(\noteOff, ~noteOffFunc);

	~mf1 = MIDIFunc.cc({ |value, num, chan, src|
		 ~dur = value/127.0;
		//value.postln;
	}, 16);    

	~mf2 = MIDIFunc.cc({ |value, num, chan, src|
		~length = value/127.0*20;
		//value.postln;
	}, 17);    


	~mf4 = MIDIFunc.cc({ |value, num, chan, src|
		~mode = value;
		//value.postln;
	}, 24);


	~mf3 = MIDIFunc.cc({ |value, num, chan, src|
		~split = value;
		//value.postln;
	}, 70);
    
    ~mf5 = MIDIFunc.cc({ |value, num, chan, src|
		//CmdPeriod.run;
        s.freeAll;
	}, 31);
    
    
    

	c = ProgramChangeResponder({ |src,chan,val|
		// [src,chan,val].postln;

		if(val < ~pool.size,
			{
				~synth_name  = ~pool[val].name;
				~pool[val].name.postln;
			}
	)},
	nil, // any source
	nil, // any channel
	nil // any value
	);

    s.statusWatcher.stopAliveThread;

};



)

// Pbind(
// 	\instrument, "cheappiano",
// 	\degree, Pwhite(0, 10),
// 	\dur, 0.2,
// 	\amp, Pwhite(0.01, 0.05),
// 	\numharm, Pwhite(10, 20),
// 	\att, 0.01,
// 	\rel, Pwhite(0.5, 0.8),
// 	\pan, Pwhite(-1, 1.0)
// ).play;
//
// (
// Pbind(
// 	\instrument, ~synth_name,
// 	\freq, Pseries(440, 440, 4),
// 	\dur, ~dur/127;
// ).play;
// )
//
// Pseries(0, 2, ~note_num)
//
// Synth
//
// (
// var a, b;
// a = Pseries(440, 440, 4);
// b = a.asStream;            // make a stream from the pattern
// 5.do({ b.next.postln; });    // print 5 values from the stream
// )
//
// (
// // streams as a sequence of pitches
// var stream, dur;
// dur = 1/8;
//
// stream = Pseries(440, 440, 4).asStream;
//
// Routine({
// 	4.do({
// 		Synth("cheappiano", [ \freq, stream.next ] );
// 		dur.wait; // synonym for yield, used by .play to schedule next occurence
// 	})
// }).play
//
// )