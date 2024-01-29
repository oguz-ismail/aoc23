NR == 1 {
	gsub(/./, "& ")
	split($0, lr)
}

NR >= 3 {
	gsub(/[=(,)]/, "")

	network[$1, "L"] = $2
	network[$1, "R"] = $3

	if ($1 ~ /A$/)
		starts[$1]
}

END {
	steps1 = count_steps("AAA", "^ZZZ$")

	for (start in starts)
		steps[count_steps(start, "Z$")]

	steps2 = 1
	for (stepsi in steps)
		steps2 = lcm(stepsi, steps2)

	print steps1
	print steps2
}

function count_steps(node, endpat,  i, count) {
	for (i = 1; node !~ endpat; i++) {
		if (i > length(lr))
			i = 1

		node = network[node, lr[i]]
		count++
	}

	return count
}

function lcm(x, y) {
	return x*y / gcd(x,y)
}

function gcd(x, y) {
	if (y == 0)
		return x

	return gcd(y, x%y)
}
