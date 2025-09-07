grep -A 10000 "[ ]*for(fu" ../core.v >core_forq.v
grep -B 10000 -A 0 "[ ]*for(fu" ../core.v >core_nofor.v
grep -A 10000 "[ ]*for(way" core_forq.v >core_forway.v
grep -B 10000 -A 0 "[ ]*for(way" core_forq.v >core_forfu.v
rm core_forq.v

