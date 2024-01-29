BEGIN {
	FS = ": | "
	srand()
}

{
	for (i = 1; i <= NF; i++)
		nodes0[$i] = 1

	for (i = 2; i <= NF; i++)
		edges0[$1, $i] = 1
}

END {
	for (;;) {
		dup(nodes0, nodes)
		dup(edges0, edges)

		while (length(edges) > 30)
			contract_random_edge()

		delete single
		for (e in edges)
		 if (edges[e] == 1)
			single[e]

		for (e in edges)
		 if (edges[e] == 3) {
			delete cut
			cut[e]
			try_cut()
		 }

		for (e1 in edges)
		 if (edges[e1] == 2)
		  for (e2 in single) {
			delete cut
			cut[e1]
			cut[e2]
			try_cut()
		  }

		for (e1 in single) {
		 delete single[e1]
		 delete skip
		 for (e2 in single) {
		  skip[e2]
		  for (e3 in single) {
			if (e3 in skip)
				continue

			delete cut
			cut[e1]
			cut[e2]
			cut[e3]
			try_cut()
		  }
		 }
		}
	}
}

function dup(src, dst,  i) {
	delete dst
	for (i in src)
		dst[i] = src[i]
}

function contract_random_edge( skip, r, u, v, w, e) {
	skip = int(rand()*length(edges))
	for (r in edges)
		if (!skip--)
			break

	delete edges[r]
	split(r, tmp, SUBSEP)
	v = tmp[1]
	u = tmp[2]
	nodes[v] += nodes[u]
	delete nodes[u]

	for (w in nodes) {
		if (w == v)
			continue
		else if ((u, w) in edges)
			e = u SUBSEP w
		else if ((w, u) in edges)
			e = w SUBSEP u
		else
			continue

		if ((v, w) in edges)
			edges[v, w] += edges[e]
		else
			edges[w, v] += edges[e]

		delete edges[e]
	}
}

function try_cut( e, n, m) {
	for (e in cut) {
		split(e, tmp, SUBSEP)
		break
	}

	n = part_size(tmp[1])
	m = part_size(tmp[2])
	if (n+m == length(nodes0)) {
		print n*m
		exit
	}
}

function part_size(v,  u, n) {
	delete part
	part[v]
	do {
		delete new
		for (v in part)
		 for (u in nodes)
			if (u in part)
				continue
			else if ((v, u) in cut || (u, v) in cut)
				continue
			else if ((v, u) in edges || (u, v) in edges)
				new[u]

		for (v in new)
			part[v]
	}
	while (length(new))

	for (v in part)
		n += nodes[v]

	return n
}
