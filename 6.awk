{
	if (NR == 1)
		field = "time"
	else
		field = "distance"

	for (i = 2; i <= NF; i++) {
		races[1, field] = (races[1, field] $i)
		races[i, field] = $i
	}
}

END {
	for (i = 1; i <= NF; i++)
		count[i] = num_strategies(races[i, "time"],
				races[i, "distance"])

	product = 1
	for (i = 2; i <= NF; i++)
		product *= count[i]

	print product
	print count[1]
}

function num_strategies(time, dist,  min, max, i) {
	min = 0
	max = int(time/2)

	while (max-min > 1) {
		i = int(min + (max-min)/2)
		if (i*(time-i) > dist)
			max = i
		else
			min = i
	}

	return time-2*max+1
}
