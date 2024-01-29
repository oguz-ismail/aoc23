{
	gsub(/./, "& ")
	for (x = 1; x <= NF; x++) {
		if ($x == "S") {
			x0 = x
			y0 = NR
		}

		if ($x ~ /\.|S/)
			plots[x, NR]
	}
}

END {
	steps1 = 64
	steps2 = 26501365 

	whole  = (2*steps2 + 1)/NR - 2
	even   = (whole+1)/2
	odd    = whole-even
	middle = (NR+1)/2
	ear    = NR-middle-1

	even_tiles  = even^2 * count_reached(x0, y0, NR-1)
	odd_tiles   = odd^2 * count_reached(x0, y0, NR)
	even_edges  = count_reached( 1,  1, ear) \
	            + count_reached(NR,  1, ear) \
	            + count_reached(NR, NR, ear) \
	            + count_reached( 1, NR, ear)
	even_edges *= even
	odd_edges   = count_reached( 1,  1, NR+ear) \
	            + count_reached(NR,  1, NR+ear) \
	            + count_reached(NR, NR, NR+ear) \
	            + count_reached( 1, NR, NR+ear)
	odd_edges  *= odd
	corners     = count_reached(     1, middle, NR-1) \
	            + count_reached(    NR, middle, NR-1) \
	            + count_reached(middle,      1, NR-1) \
	            + count_reached(middle,     NR, NR-1)

	print count_reached(x0, y0, steps1)
	print odd_tiles+even_tiles+odd_edges+even_edges+corners
}

function count_reached(x, y, steps,  i) {
	delete buf1
	buf1[x, y]
	for (i = 0; i < steps; i++)
		if (i % 2)
			step(buf2, buf1)
		else
			step(buf1, buf2)

	if (steps % 2)
		return length(buf2)
	else
		return length(buf1)
}

function step(src, dst,  plot, x, y, nbr) {
	delete dst
	for (plot in src) {
		split(plot, tmp, SUBSEP)
		x = tmp[1]
		y = tmp[2]

		delete nbrs
		nbrs[x-1, y]
		nbrs[x+1, y]
		nbrs[x, y-1]
		nbrs[x, y+1]

		for (nbr in nbrs)
			if (nbr in plots)
				dst[nbr]
	}
}
