{
	gsub(/./, "& ")
	for (x = 1; x <= NF; x++)
		if ($x != "#")
			maze[x, NR] = $x
}

END {
	for (x = 1; x <= NF; x++) {
		if ((x, 1) in maze)
			start = x SUBSEP 1

		if ((x, NR) in maze)
			end = x SUBSEP NR
	}

	for (p in maze)
		if (get_nbrs(p, nbrs1) != 2)
			for (nbr in nbrs1)
				condense(nbr, p)

	print max_weight(start)

	delete avoid
	print max_weight(start)
}

function max_weight(n, w0,  i, w, max) {
	if (n == end)
		return w0

	seen[n]
	for (i = 1; i <= nedges[n]; i++) {
		if (edge[n, i] in seen || (n, i) in avoid)
			continue

		w = max_weight(edge[n, i], w0+weight[n, i])
		if (w > max)
			max = w
	}

	delete seen[n]
	return max
}

function condense(e, n,  prev, w, nbr, uphill) {
	prev = n
	for (w = 1; ; w++) {
		if (get_nbrs(e, nbrs2) != 2)
			break

		for (nbr in nbrs2)
		 if (nbr != prev) {
			prev = e
			if (maze[prev] != "." && nbrs2[nbr] != maze[prev])
				uphill = 1

			e = nbr
			break
		 }
	}

	nedges[n]++
	edge[n, nedges[n]] = e
	weight[n, nedges[n]] = w

	if (uphill)
		avoid[n, nedges[n]]
}

function get_nbrs(p, dst,  x, y, nbr) {
	split(p, tmp, SUBSEP)
	x = tmp[1]
	y = tmp[2]

	delete dst
	dst[x-1, y] = "<"
	dst[x+1, y] = ">"
	dst[x, y-1] = "^"
	dst[x, y+1] = "v"

	for (nbr in dst)
		if (!(nbr in maze))
			delete dst[nbr]

	return length(dst)
}
