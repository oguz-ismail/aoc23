BEGIN {
	FS = "#"
}

NR == 1 {
	for (x = 1; x <= length; x++)
		empty_cols[x]
}

NF == 1 {
	empty_rows[NR]
}

{
	x = 1
	for (i = 1; i < NF; i++) {
		x += length($i)
		galaxies[x, NR]
		delete empty_cols[x]
		x++
	}
}

END {
	for (a in galaxies) {
		delete galaxies[a]
		for (b in galaxies) {
			sum1 += distance(a, b, 2)
			sum2 += distance(a, b, 1000000)
		}
	}

	print sum1
	print sum2
}

function distance(xy1, xy2, factor,
		x1, y1, x2, y2, ret, col, row) {
	split(xy1, tmp, SUBSEP)
	x1 = tmp[1]
	y1 = tmp[2]

	split(xy2, tmp, SUBSEP)
	x2 = tmp[1]
	y2 = tmp[2]

	ret = abs(x1-x2) + abs(y1-y2)

	for (col in empty_cols) {
		col += 0
		if ((col < x1) != (col < x2))
			ret += factor-1
	}

	for (row in empty_rows) {
		row += 0
		if ((row < y1) != (row < y2))
			ret += factor-1
	}

	return ret
}

function abs(x) {
	if (x < 0)
		return -x
	else
		return x
}
