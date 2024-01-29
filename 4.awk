{
	copies[NR]++

	delete winning
	for (i = 3; i <= NF; i++) {
		if ($i == "|")
			break

		winning[$i]
	}

	wins = 0
	for (i++; i <= NF; i++)
		if ($i in winning)
			wins++

	sum1 += int(2^(wins-1))

	for(i = 1; i <= wins; i++)
		copies[NR+i] += copies[NR]
}
END{
	for(card in copies)
		sum2 += copies[card]

	print sum1
	print sum2
}
