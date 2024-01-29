{
	chart("[0-9]+", numbers)
	chart("[^0-9.]", symbols)
}

END {
	for (i in numbers) {
		number = numbers[i]

		split(i, xy, SUBSEP)
		x1 = xy[1]
		x2 = x1+length(number)
		y = xy[2]

		delete neighbors
		neighbors[x1-1, y]
		neighbors[x2, y]
		for (x = x1-1; x <= x2; x++) {
			neighbors[x, y-1]
			neighbors[x, y+1]
		}

		is_part = 0
		for (neighbor in neighbors) {
			if (!(neighbor in symbols))
				continue

			is_part = 1
			if (symbols[neighbor] == "*")
				parts[neighbor, ++nparts[neighbor]] = number
		}

		if (is_part)
			sum1 += number
	}

	for (gear in nparts)
		if (nparts[gear] == 2)
			sum2 += parts[gear, 1]*parts[gear, 2]

	print sum1
	print sum2
}

function chart(re, dst,  offset, start) {
	while (match(substr($0, 1+offset), re)) {
		start = RSTART+offset
		dst[start, NR] = substr($0, start, RLENGTH)
		offset += RSTART+RLENGTH
	}
}
