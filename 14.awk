{
	gsub(/./, "& ")
	for (i = 1; i <= NF; i++)
		rows[i] = $i rows[i]
}

END {
	yn = length(rows)+1
	xn = length(rows[1])+1

	for (y in rows) {
		x = 0
		buf1[x, y] = 0

		ngaps = split(rows[y], gaps, "#")
		for (i = 1; i <= ngaps; i++) {
			x += length(gaps[i])+1
			rocks = gsub(/O/, "&", gaps[i])
			sum1 += (-rocks^2 + 2*rocks*x - rocks)/2
			buf1[x, y] = rocks
		}
	}

	for (x = 1; x < xn; x++) {
		buf1[x, 0] = 0
		buf1[x, yn] = 0
	}

	tilt(buf1, buf2, xn, yn)
	tilt(buf2, buf1, yn, xn)
	tilt(buf1, buf2, xn, yn)
	for (n = 999999999; n > 0; n--) {
		state = ""
		for (y = 0; y <= yn; y++)
		 for (x = 0; x <= xn; x++)
		  if ((x, y) in buf2)
			state = state buf2[x, y] ","

		if (state in seen)
			break

		seen[state] = n
		cycle()
	}

	n %= seen[state]-n
	for (; n > 0; n--)
		cycle()

	for (p in buf2) {
		split(p, tmp, SUBSEP)
		y = tmp[2]
		sum2 += (yn-y)*buf2[p]
	}

	print sum1
	print sum2
}

function cycle() {
	tilt(buf2, buf1, yn, xn)
	tilt(buf1, buf2, xn, yn)
	tilt(buf2, buf1, yn, xn)
	tilt(buf1, buf2, xn, yn)
}

function tilt(src, dst, xn, yn,
		p1, p2, x, y, xi, yi) {
	delete dst
	for (p1 in src) {
		split(p1, tmp, SUBSEP)
		x = tmp[1]
		y = tmp[2]

		p2 = yn-y SUBSEP x
		dst[p2] = 0
		for (yi = y+1; yi < yn; yi++) {
		 if ((x, yi) in src)
			break

		 for (xi = x+1; xi <= xn; xi++)
		  if ((xi, yi) in src) {
			if (xi-src[xi, yi] <= x)
				dst[p2]++

			break
		  }
		}
	}
}
