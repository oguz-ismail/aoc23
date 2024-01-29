BEGIN {
	split("R D L U", xdir)
	split("0 1 2 3 4 5 6 7 8 9 a b c d e f", tmp)
	for (i in tmp)
		xdigit[tmp[i]] = i-1
}

{
	update(state1, $1, $2)
	update(state2, xdir[1+substr($3, 8, 1)], xnum(substr($3, 3, 5)))
}

END {
	print volume(state1)
	print volume(state2)
}

function update(state, dir, num,  x, y) {
	state["P"] += num
	x = state["x"] + ((dir == "R")-(dir == "L"))*num
	y = state["y"] + ((dir == "D")-(dir == "U"))*num
	state["2A"] += state["x"]*y - state["y"]*x
	state["x"] = x
	state["y"] = y
}

function volume(state,  area) {
	area = state["2A"]/2
	if (area < 0)
		area = -area

	return area + state["P"]/2 + 1
}

function xnum(s,  ret, i) {
	for (i = 1; i <= length(s); i++)
		ret = ret*16 + xdigit[substr(s, i, 1)]

	return ret
}
