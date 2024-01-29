{
	split($0, buf)
	left = right = 0;
	extrapolate(1, NF, NF+1)
	sum1 += right
	sum2 += left
}

END {
	print sum1
	print sum2
}

function extrapolate(seq, len, diff,  nonzero, i) {
	for (i = 0; i < len-1; i++) {
		buf[diff+i] = buf[seq+i+1]-buf[seq+i]
		if (buf[diff+i] != 0)
			nonzero = 1
	}

	if (nonzero)
		extrapolate(diff, len-1, diff+len)

	left = buf[seq]-left
	right += buf[seq+len-1]
}
