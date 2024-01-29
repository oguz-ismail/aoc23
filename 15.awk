BEGIN {
	for (i = 1; i < 256; i++)
		ascii[sprintf("%c", i)] = i

	FS = ","
}

{
	for (i = 1; i <= NF; i++) {
		sum1 += hash($i)

		lens = $i
		sub(/[=-].*/, "", lens)
		box = hash(lens)

		if ($i ~ /-/) {
			if (lens in id) {
				sub(" " id[lens] " ", "", ids[box])
				delete id[lens]
			}
		}
		else {
			if (!(lens in id)) {
				id[lens] = ++seen[box]
				ids[box] = ids[box] " " id[lens] " "
			}

			n = $i
			sub(/.*=/, "", n)
			value[box, id[lens]] = n
		}
	}

	for (box in ids) {
		split(ids[box], slots, " ")
		for (i in slots)
			sum2 += (box+1)*i*value[box, slots[i]]
	}

	print sum1
	print sum2
}

function hash(s,  n, i, ret) {
	gsub(/./, "& ", s)
	n = split(s, tmp, " ")
	for (i = 1; i <= n; i++) {
		ret += ascii[tmp[i]]
		ret *= 17
		ret %= 256
	}

	return ret
}
