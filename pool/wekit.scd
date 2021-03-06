SynthDef("werkit", {
	arg out = 0, pan = 0.0, freq = 440, amp = 0.1, gate = 1, cutoff = 100, rq = 0.1, att = 0.01, dec = 0, sus = 1, rel = 1, delay = 0.3;

	var source, filter, env, snd, delayEnv;
	source = WhiteNoise.ar;
	filter = BLowPass4.ar(source, freq, rq) * 0.3;
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	snd = (0.7 * filter + (0.3 * filter.distort)) * env;
	Out.ar(out, Pan2.ar(snd, pan));
})