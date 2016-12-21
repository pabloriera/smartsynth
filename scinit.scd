MIDIIn.connect;

s.waitForBoot{ 


		{SinOsc.ar(440,0,Line.kr(0.1,0,1,doneAction:2))}.play;

		~pool = "pool/*.scd".loadPaths;
		~synth_name = "cheappiano";
		
		~pool.do({ arg item, i; item.add; [i, item.name].postln; });

		// var keys;
		~keys = Array.newClear(128);

		~noteOnFunc = {arg src, chan, num, vel;
			var node;
			node = ~keys.at(num);
			if (node.notNil, {
				node.release;
				~keys.put(num, nil);
			});
			node = Synth.tail(nil, ~synth_name, [\freq, num.midicps, \amp, 0.2*vel/127]);
			~keys.put(num, node);
			// [chan,num,vel/127].postln;
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
		    )

}
