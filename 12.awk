{
	sum1 += num_arrgmts($1, $2)
	sum2 += num_arrgmts(repeat($1, 5, "?"), repeat($2, 5, ","))
}

END {
	print sum1
	print sum2
}

function num_arrgmts(springs, sizes,  room, group) {
	ngroups = split(sizes, size, ",")

	room = length(springs)-(ngroups-1)
	for (group in size)
		room -= size[group]

	delete cache
	return count_arrgmts(springs, 1, room, 0)
}


function count_arrgmts(springs, group, avail, sep,
		count, head, tail, body, used) {
	if (group > ngroups)
		return springs !~ /#/

	if ((group, avail) in cache)
		return cache[group, avail]

	head = "^[.?]{" sep "}[.?]{0,"
	tail = "}[#?]{" size[group] "}"
	body = avail
	while (body >= 0 && match(springs, head body tail)) {
		used = RLENGTH-sep-size[group]
		count += count_arrgmts(substr(springs, RLENGTH+1),
				group+1, avail-used, 1)
		body = used-1
	}

	cache[group, avail] = count
	return count
}

function repeat(s, n, _sep,  ret, sep, i) {
	for (i = 0; i < n; i++) {
		ret = ret sep s
		sep = _sep
	}

	return ret
}
