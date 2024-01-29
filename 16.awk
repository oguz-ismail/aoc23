BEGIN {
	tr["U\\"] = tr["D/"]  = "L"
	tr["U/"]  = tr["D\\"] = "R"
	tr["L\\"] = tr["R/"]  = "U"
	tr["L/"]  = tr["R\\"] = "D"
}

{
	gsub(/./, "& ")
	for (x = 1; x <= NF; x++)
		grid[x, NR] = $x
}

END {
	start(1, 1, "R")
	print max

	for (x = 1; x <= NF; x++) {
		start(x, 1, "D")
		start(x, NR, "U")
	}

	for (y = 1; y <= NR; y++) {
		start(1, y, "R")
		start(NF, y, "L")
	}

	print max
}

function start(x, y, dir,  i, n) {
	delete visited

	nbeams = 0
	follow(x, y, dir)
	for (i = 1; i <= nbeams; i++) {
		split(beams[i], params)
		follow(params[1], params[2], params[3])
	}

	n = length(visited)
	if (n > max)
		max = n
}

function follow(x, y, dir,  state) {
	while ((x, y) in grid) {
		state = dir grid[x, y]

		if ((x, y) in visited &&
	(state ~ /[UD]-|[LR]\|/ || dir == visited[x, y]))
			break

		visited[x, y] = dir
	
		if (state ~ /[UD]-/) {
			beams[++nbeams] = x-1 " " y " L"
			dir = "R"
		}
		else if (state ~ /[RL]\|/) {
			beams[++nbeams] = x " " y-1 " U"
			dir = "D"
		}
		else if (state in tr) {
			dir = tr[state]
		}

		x += (dir == "R")-(dir == "L")
		y += (dir == "D")-(dir == "U")
	}
}
