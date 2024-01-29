BEGIN {
	RS = ""
}

{
	delete rows
	delete cols
	for (i = 1; i <= NF; i++) {
		row = rows[i] = $i
		gsub(/./, "& ", row)
		ncells = split(row, cells)
		for (j = 1; j <= ncells; j++)
			cols[j] = cols[j] cells[j]
	}

	sum1 += find_mirror(rows)*100 + find_mirror(cols)
	sum2 += find_mirror(rows, 1)*100 + find_mirror(cols, 1)
}

END {
	print sum1
	print sum2
}

function find_mirror(lines, smudged,
		i, j, k, n, count, perfect) {
	n = length(lines)
	for (i = 1; i < n; i++) {
		count = count_matching(lines, i, i+1)

		perfect = (count == i || count == n-i)
		if (smudged == perfect)
			continue
		else if (perfect)
			return i

		j = i-count
		k = i+1+count
		if (!differ_by_one(lines[j], lines[k]))
			continue

		count = count_matching(lines, j-1, k+1)+1
		if (count == j || count == n-k+1)
			return i
	}

	return 0
}

function count_matching(lines, i, j,  ret, k) {
	for (k = 0; i-k in lines && j+k in lines; k++) {
		if (lines[i-k] != lines[j+k])
			break

		ret++
	}

	return ret
}

function differ_by_one(line1, line2,  i, yes) {
	for (i = 1; i <= length(line1); i++)
		if (substr(line1, i, 1) != substr(line2, i, 1)) {
			if (yes)
				return 0
			else
				yes = 1
		}

	return yes
}
