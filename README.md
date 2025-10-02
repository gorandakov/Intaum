currently the cpu can so far be implemented on 7 phase dynamic depleting cmos, but if you change the fpu to ieee std accurate it will not fit in 7 phases so the 54 bit precision and 10 bit exponent is not an error.
the 7 phase assumes cell complexity of e.g. aoi4321 or aoi3333.
power use at 12GHz 3nm:
10^7×10×3×1.6×10^-19x10^10=0.5 watts per core
in addition, if using write though rdram with many port and banks, additional 0.5-0.6 watts per core tile.
50% estimated speed with 25 5×5 matrix for total of 12.5× performance.
increase of tile size beyond 25 rapidly reduces performance in my estimated metrics.
8 gb per core feasible for max 200gb and desktop package sized die.
as of msi algorithm choice the core would not run at 50% with 25 tiles but at 45%. note that this is metric for running with significant cache miss rate.
as for 2nm I can't promise it is possible to beat or match this 3nm cpu
note: with 5 gold layer matter rather than 4 the frequency can be 22GHz on 3nm depletion mode 7 phase dynamic logic.
note 2: with 6 gold layer matter rather than 5 or 4, in addition to 22GHz operation,
one conditional branch disambiguiation should be possible such as executing a loop
in parallel with a return based on condition and cancelling computing one of the 
branches earlier than the other completes.


