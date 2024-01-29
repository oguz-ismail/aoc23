BEGIN {
	FS = "[{:=,}]"
}

parsing_parts {
	sum = 0
	delete part
	for (i = 2; i < NF; i += 2)
		sum += part[$i] = $(i+1)

	if (is_accepted(part))
		sum1 += sum

	next
}

!NF {
	parsing_parts = 1
	next
}

{
	j = 1
	for (i = 2; i < NF-1; i += 2) {
		op[$1, j] = substr($i, 2, 1)
		lhs[$1, j] = substr($i, 1, 1)
		rhs[$1, j] = substr($i, 3)
		rule[$1, j] = $(i+1)
		j++
	}

	rule[$1, j] = $(NF-1)
	nrules[$1] = j
}

END {
	FS = " "

	split("x m a s", tmp)
	for (i in tmp)
		cat[tmp[i]] = i

	range[1] = "in,1 1 1 1,4000 4000 4000 4000"
	nranges = 1
	for (i = 1; i <= nranges; i++) {
		split(range[i], p, ",")

		wf = p[1]
		if (wf == "R")
			continue

		split(p[2], min)
		split(p[3], max)

		if (wf == "A") {
			sum2 += num_combs()
			continue
		}

		for (j = 1; j < nrules[wf]; j++) {
			k = wf SUBSEP j
			if (op[k] == ">")
				split_range(k, min, max, 1)
			else
				split_range(k, max, min, -1)
		}

		enqueue(rule[wf, j])
		delete ranges[i]
	}

	print sum1
	print sum2
}

function split_range(rulei, lim1, lim2, dir,  c, tmp) {
	c = cat[lhs[rulei]]
	tmp = lim1[c]
	lim1[c] = rhs[rulei]+dir
	enqueue(rule[rulei])

	lim1[c] = tmp
	lim2[c] = rhs[rulei]
}

function is_accepted(part,  wf, i, l, r, o) {
	for (wf = "in"; wf !~ /A|R/; wf = rule[wf, i])
		for (i = 1; i < nrules[wf]; i++) {
			l = part[lhs[wf, i]]
			r = rhs[wf, i]+0
			o = op[wf, i]
			if ((o == "<" && l < r) || (o == ">" && l > r))
				break
		}

	return (wf == "A")
}

function num_combs( ret, i) {
	ret = 1
	for (i in min) {
		if (min[i] > max[i])
			return 0

		ret *= max[i]-min[i]+1
	}

	return ret
}

function join(a,  ret, i) {
	for (i = 1; i <= length(a); i++) {
		ret = ret sep a[i]
		sep = " "
	}

	return ret
}

function enqueue(wf) {
	nranges++
	range[nranges] = wf "," join(min) "," join(max)
}
