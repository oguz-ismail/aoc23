{
	gsub(/./, "& ")
	for (x = 1; x <= NF; x++)
		heat_loss[x, NR] = $x
}

END {
	find_least_heat_loss(1, 3)
	find_least_heat_loss(4, 10)
}

function find_least_heat_loss(min_row, max_row,
		state0, x, y,     dir0, row0, loss0,
		state,  neighbor, dir,  row,  loss) {
	delete total_loss
	total_loss[1 SUBSEP 1 SUBSEP "E" SUBSEP 0] = 0
	total_loss[1 SUBSEP 1 SUBSEP "S" SUBSEP 0] = 0

	while (dequeue());
	for (state in total_loss)
		enqueue(total_loss[state], state)

	delete seen
	while ((state0 = dequeue())) {
		split(state0, params, SUBSEP)
		x     = params[1]
		y     = params[2]
		dir0  = params[3]
		row0  = params[4]
		loss0 = total_loss[state0]

		if (row0 >= min_row && x == NF && y == NR) {
			print loss0
			break
		}

		delete neighbors
		neighbors["W"] = x-1 SUBSEP y
		neighbors["E"] = x+1 SUBSEP y
		neighbors["N"] = x SUBSEP y-1
		neighbors["S"] = x SUBSEP y+1

		if (row0 < min_row) {
		 for (dir in neighbors)
		  if (dir != dir0)
			delete neighbors[dir]
		}
		else if (row0 >= max_row) {
			delete neighbors[dir0]
		}

		for (dir in neighbors) {
			if (dir0 dir ~ /EW|WE|NS|SN/)
				continue

			neighbor = neighbors[dir]
			if (!(neighbor in heat_loss))
				continue

			row = 1
			if (dir == dir0)
				row += row0

			state = neighbor SUBSEP dir SUBSEP row
			if (state in seen || state in total_loss)
				continue

			loss = loss0+heat_loss[neighbor]
			total_loss[state] = loss
			enqueue(loss, state)
		}

		seen[state0]
	}
}

function enqueue(loss, state,  prev) {
	states[loss, ++nstates[loss]] = state

	if (nstates[loss] > 1)
		return

	prev = ""
	while (queue[prev] != "" && loss > queue[prev])
		prev = queue[prev]

	queue[loss] = queue[prev]
	queue[prev] = loss
}

function dequeue( loss, ret) {
	loss = queue[""]
	if (loss == "")
		return ""

	ret = states[loss, nstates[loss]--]

	if (nstates[loss] == 0) {
		queue[""] = queue[loss]
		delete queue[loss]
	}

	return ret
}
