BEGIN {
	split("1 2 3 4 5 6 7 8 9", tr)
	tr["one"]   = 1
	tr["two"]   = 2
	tr["three"] = 3
	tr["four"]  = 4
	tr["five"]  = 5
	tr["six"]   = 6
	tr["seven"] = 7
	tr["eight"] = 8
	tr["nine"]  = 9

	for (i in tr) {
		digit = digit sep i
		sep = "|"
	}

	digit = "(" digit ")"
}

{
	match($0, /[1-9]/)
	sum1 += substr($0, RSTART, 1)*10
	match($0, /.*[1-9]/)
	sum1 += substr($0, RLENGTH, 1)

	match($0, digit)
	sum2 += tr[substr($0, RSTART, RLENGTH)]*10
	match($0, ".*" digit)
	match(substr($0, 1, RLENGTH), digit "$")
	sum2 += tr[substr($0, RSTART, RLENGTH)]
}

END {
	print sum1
	print sum2
}
