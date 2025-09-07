grep -A 10000 "[ ]*for(fu" ../core.v >core_for.v
grep -B 10000 -A 0 "[ ]*for(fu" ../core.v >core_nofor.v

