BEGIN {
	FS = " |: |, |; "
	cubes["red"]   = 12
	cubes["green"] = 13
	cubes["blue"]  = 14
}

{
	possible = 1
	delete max

	for (i = 3; i < NF; i += 2) {
		if (possible && $i > cubes[$(i+1)])
			possible = 0

		if ($i > max[$(i+1)])
			max[$(i+1)] = $i
	}

	if (possible)
		sum1 += $2

	sum2 += max["red"]*max["green"]*max["blue"]
}

END {
	print sum1
	print sum2
}
