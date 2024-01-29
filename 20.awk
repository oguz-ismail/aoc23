BEGIN {
	FS = " -> |, "
}

{
	module = $1
	sub(/[%&]/, "", module)

	if ($1 ~ /^%/) {
		flip[module]
		state[module] = "off"
	}
	else if ($1 ~ /^&/) {
		conj[module]
	}

	for (i = 2; i <= NF; i++)
		dests[module, ++ndests[module]] = $i
}

END {
	conj["rx"]
	for (source in ndests)
		for (i = 1; i <= ndests[source]; i++) {
			dest = dests[source, i]
			if (dest in conj) {
				inputs[dest, ++ninputs[dest]] = source
				memory[dest, source] = "low"
			}
		}
	
	parent = inputs["rx", 1]
	for (i = 1; i <= ninputs[parent]; i++)
		watch[inputs[parent, i]]
	
	for (i = 0; i < 1000 || length(watch) > 0; i++)
		button_press(i)

	presses = 1
	for (i in cyclelen)
		presses = lcm(presses, cyclelen[i])

	print (count["low"]+1000)*count["high"]
	print presses
}

function send_pulse(sender, pulse,  i) {
	for (i = 1; i <= ndests[sender]; i++) {
		npulses++
		recips[npulses] = dests[sender, i]
		pulses[npulses] = pulse
		senders[npulses] = sender
	}
}

function button_press(time,  i, recip, pulse, sender, j) {
	npulses = 0
	delete pulses
	send_pulse("broadcaster", "low")
	for (i = 1; i <= npulses; i++) {
		recip = recips[i]
		pulse = pulses[i]
		sender = senders[i]

		if (time < 1000)
			count[pulse]++

		if (pulse == "low" && recip in watch) {
			if (recip in seen) {
				cyclelen[recip] = time-seen[recip]
				delete watch[recip]
			}
			else {
				seen[recip] = time
			}
		}

		if (recip in flip) {
			if (pulse == "high")
				continue

			if (state[recip] == "off") {
				state[recip] = "on"
				pulse = "high"
			}
			else {
				state[recip] = "off"
				pulse = "low"
			}
		}
		else {
			memory[recip, sender] = pulse
			
			pulse = "low"
			for (j = 1; j <= ninputs[recip]; j++)
			 if (memory[recip, inputs[recip, j]] != "high") {
				pulse = "high"
				break
			 }
		}

		send_pulse(recip, pulse)
	}
}

function lcm(x, y) {
	return x*y / gcd(x,y)
}

function gcd(x, y) {
	if (y == 0)
		return x

	return gcd(y, x%y)
}
