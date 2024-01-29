BEGIN {
	RS = ""
}

NR == 1 {
	for (i = 2; i < NF; i += 2) {
		ranges1[$i] = $i
		ranges1[$(i+1)] = $(i+1)
		ranges2[$i] = $i+$(i+1) - 1
	}

	next
}

{
	convert(ranges1, tmp)
	move(tmp, ranges1)

	do
		convert(ranges2, tmp)
	while (length(ranges2) > 0)

	move(tmp, ranges2)
}

END {
	print min(ranges1)
	print min(ranges2)
}

function convert(src, dst,  i, start2, end2, incr) {
	for (i = 3; i < NF; i += 3) {
		start2 = $(i+1)
		end2 = start2+$(i+2) - 1
		incr = $i-start2
		for (start1 in src)
			if (convert_range(start1+0, src[start1], start2, end2,
					dst, incr, leftovers))
				delete src[start1]
	}

	move(src, dst)
	move(leftovers, src)
}

function convert_range(start1, end1, start2, end2,
		dst, incr, diff) {
	if (end1 < start2 || start1 > end2)
		return 0

	if (start1 < start2 && end1 >= start2)
		diff[start1] = start2-1

	if (end1 > end2 && start1 <= end2)
		diff[end2+1] = end1

	if (start2 > start1)
		start1 = start2

	if (end2 < end1)
		end1 = end2

	dst[start1+incr] = end1+incr
	return 1
}

function move(src, dst) {
	for (i in src)
		dst[i] = src[i]

	delete src
}

function min(src,  ret, i) {
	for (i in src) {
		i += 0
		if (ret == "" || i < ret)
			ret = i
	}

	return ret
}
