BEGIN {
	sum_fmt = "LC_ALL=C sort -k1,1 | " \
		"awk '{s += NR*$2} END{print \"%s: \" s}'"
	sum1 = sprintf(sum_fmt, 1)
	sum2 = sprintf(sum_fmt, 2)
}

{
	hand1 = $1
	gsub("A", "E", hand1)
	gsub("K", "D", hand1)
	gsub("Q", "C", hand1)
	gsub("T", "A", hand1)

	hand2 = hand1
	gsub("J", "1", hand2)
	gsub("J", "B", hand1)

	bid = $2

	gsub(/./, "& ", $1)
	$0 = $0

	delete freq
	for (i = 1; i <= 5; i++)
		freq[$i]++
	
	delete same
	for (i in freq)
		same[freq[i]]++

	if (5 in same)
		type1 = 6
	else if (4 in same)
		type1 = 5
	else if (3 in same && 2 in same)
		type1 = 4
	else if (3 in same)
		type1 = 3
	else if (2 in same && same[2] == 2)
		type1 = 2
	else if (2 in same)
		type1 = 1
	else
		type1 = 0

	type2 = type1
	if (freq["J"]) {
		if (type1 == 5 || type1 == 4)
			type2 = 6
		else if (type1 == 3)
			type2 = 5
		else if (type1 == 2)
			type2 = freq["J"] == 2 ? 5 : 4
		else if (type1 == 1)
			type2 = 3
		else if (type1 == 0)
			type2 = 1
	}

	print type1 hand1, bid | sum1
	print type2 hand2, bid | sum2
}
