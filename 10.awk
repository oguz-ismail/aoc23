{
	gsub(/./, "& ")
	for (x = 1; x <= NF; x++) {
		maze[x, NR] = $x
		if ($x == "S") {
			x0 = x
			y0 = NR
		}
	}
}

END {
	neighbors = sprintf("%1s%1s%1s%1s",
			maze[x0, y0-1], maze[x0, y0+1],
			maze[x0-1, y0], maze[x0+1, y0])
	if (neighbors ~ /^[7F|][LJ|]/)
		maze[x0, y0] = "|"
	else if (neighbors ~ /[LF-][J7-]$/)
		maze[x0, y0] = "-"
	else if (neighbors ~ /[7F|]..[J7-]/)
		maze[x0, y0] = "L"
	else if (neighbors ~ /[7F|].[LF-]./)
		maze[x0, y0] = "J"
	else if (neighbors ~ /.[LJ|][LF-]./)
		maze[x0, y0] = "7"
	else if (neighbors ~ /.[LJ|].[J7-]/)
		maze[x0, y0] = "F"

	x = x0
	y = y0

	if (maze[x, y] ~ /[7F|]/)
		direction = "N"
	else if (maze[x, y] ~ /[LJ]/)
		direction = "S"
	else
		direction = "E"

	do {
		if (maze[x, y] ~ /[LJ7F]/) {
			ncorners++
			cornerx[ncorners] = x
			cornery[ncorners] = y
		}

		state = maze[x, y] direction
		if (state ~ /-E|LS|FN/) {
			x++
			direction = "E"
		}
		else if (state ~ /-W|JS|7N/) {
			x--
			direction = "W"
		}
		else if (state ~ /\|S|7E|FW/) {
			y++
			direction = "S"
		}
		else if (state ~ /\|N|LW|JE/) {
			y--
			direction = "N"
		}

		perimeter++
	} \
	while (x != x0 || y != y0)
	
	# Shoelace formula
	j = ncorners
	for (i = 1; i <= ncorners; i++) {
		area += cornerx[i]*cornery[j]
		area -= cornery[i]*cornerx[j]
		j = i
	}

	area /= 2
	if (area < 0)
		area = -area

	print perimeter/2
	# Pick's theorem
	print area - (perimeter/2)+1
}
