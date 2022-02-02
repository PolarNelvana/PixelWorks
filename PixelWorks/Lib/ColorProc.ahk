gradientMachine(hue, satu, lightBright, steps, mode, toColorH, toColorS, toColorL, forwardBackH, forwardBackS, forwardBackL, splitVarsMode)
{
	gradientArray := []

	if mode in 3,8,11 ; If we are dealing with brightness instead of lightness
		hsl2hsb(satu, lightBright)

	if mode in 3,2,4,7,8
	{
		satuCrement := (100 - satu) / (steps - 1)
		lightCrement := (100 - lightBright) / (steps - 1)
	}
	else if mode in 1,5,9
	{
		; DECREASE
		satuCrement := -1 * satu / (steps - 1)
		lightCrement := -1 * lightBright / (steps - 1)
	}
	else if (mode = 6)
	{
		satuCrement := (100 - satu) / (steps - 1)
		lightCrement := -1 * lightBright / (steps - 1) ; DECREASE
	}
	else if mode in 10,11
	{
		satuCrement := -1 * satu / (steps - 1) ; DECREASE
		lightCrement := (100 - lightBright) / (steps - 1)
	}
	else if (mode = 12) ; Cooler
	{
		if ((hue <= 90) || (hue > 270))
			hueCrement := 180 / (steps - 1)
		else
			hueCrement := (270 - hue) / (steps - 1)
	}
	else if (mode = 13) ; Warmer
	{
		/*
		if (hue <= 90)
			hueCrement := -1 * hue / (steps - 1)
		else if (hue >= 270)
			hueCrement := (360 - hue) / (steps - 1)
		else
			hueCrement := 180 / (steps - 1)
		*/
		if (hue <= 180)
			hueCrement := -1 * hue / (steps - 1)
		else
			hueCrement := (360 - hue) / (steps - 1)
	}
	else ; TO ANOTHER COLOR
	{
		if (forwardBackH = 0) ; FORWARD
		{
			if (hue > toColorH)
				hueCrement := (toColorH + (360 - hue)) / (steps - 1)
			else
				hueCrement := (toColorH - hue) / (steps - 1)
		}
		else if (forwardBackH = 1) ; REVERSE
		{
			if (hue > toColorH)
				hueCrement := -1 * (hue - toColorH) / (steps - 1)
			else
				hueCrement := -1 * (hue + (360 - toColorH)) / (steps - 1)
		}
		else ; AUTO
		{
			if (hue > toColorH)
				hueCrement := -1 * (hue - toColorH) / (steps - 1) ; DECREASE
			else
				hueCrement := (toColorH - hue) / (steps - 1)
		}

		if (forwardBackS = 0) ; FORWARD
		{
			if (satu > toColorS)
				satuCrement := (toColorS + (100 - satu)) / (steps - 1)
			else
				satuCrement := (toColorS - satu) / (steps - 1)
		}
		else if (forwardBackS = 1) ; REVERSE
		{
			if (satu > toColorS)
				satuCrement := -1 * (satu - toColorS) / (steps - 1)
			else
				satuCrement := -1 * (satu + (100 - toColorS)) / (steps - 1)
		}
		else ; AUTO
		{
			if (satu > toColorS)
				satuCrement := -1 * (satu - toColorS) / (steps - 1) ; DECREASE
			else
				satuCrement := (toColorS - satu) / (steps - 1)
		}

		if (forwardBackL = 0) ; FORWARD
		{
			if (lightBright > toColorL)
				lightCrement := (toColorL + (100 - lightBright)) / (steps - 1)
			else
				lightCrement := (toColorL - lightBright) / (steps - 1)
		}
		else if (forwardBackL = 1)
		{
			if (lightBright > toColorL)
				lightCrement := -1 * (lighBright - toColorL) / (steps - 1)
			else
				lightCrement := -1 * (lightBright + (100 - toColorL)) / (steps - 1)
		}
		else ; AUTO
		{
			if (lightBright > toColorL)
				lightCrement := -1 * (lightBright - toColorL) / (steps - 1) ; DECREASE
			else
				lightCrement := (toColorL - lightBright) / (steps - 1)
		}
	}

	loop, %steps%
	{
		if (a_index != 1)
		{
			if mode in 1,2,3
				lightBright += lightCrement
			else if mode in 4,5
				satu += satuCrement
			else if mode in 6,7,8,9,10,11
			{
				lightBright += lightCrement
				satu += satuCrement
			}
			else if mode in 12,13
				hue += hueCrement
			else
			{
				hue += hueCrement
				satu += satuCrement
				lightBright += lightCrement

				if (satu > 100)
					satu := satu - 100
				else if (satu < 0)
					satu := satu + 100

				if (lightBright > 100)
					lightBright := lightBright - 100
				else if (lightBright < 0)
					lightBright := lightBright + 100
			}

			if mode in 12,13,14
			{
				if (hue > 360)
					hue := hue - 360
				else if (hue < 0)
					hue := hue + 360
			}
		}

		if mode in 3,8,11 ; Convert HSB back to HSL
		{
			satuTemp := satu
			lightBrightTemp := lightBright
			hsb2hsl(satuTemp, lightBrightTemp)
			roundFunc(hue, satuTemp, lightBrightTemp)
			currColor = hsl(%hue%, %satuTemp%`%, %lightBrightTemp%`%)
		}
		else
		{
			roundFunc(hue, satu, lightBright)
			if (splitVarsMode != 1)
				currColor = hsl(%hue%, %satu%`%, %lightBright%`%)
			else
				currColor = %hue%|%satu%|%lightBright%
		}
		gradientArray.Push(currColor)
	}

	return gradientArray
}

hsl2hsb(byref satura, byref light)
{
	satura := satura / 100
	light := light / 100

	lightTemp := light + (satura * min(light, (1 - light)))
	if (lightTemp = 0)
		satura = 0
	else
		satura := 2 - (2 * light / lightTemp)
	light := lightTemp

	satura := satura * 100
	light := light * 100
	return
}

hsb2hsl(byref satura, byref bright)
{
	satura := satura / 100
	bright := bright / 100

	brightTemp := bright - (bright * satura / 2)
	if (brightTemp = 0)
		satura = 0
	else
		satura := (bright - brightTemp) / min(brightTemp, (1 - brightTemp))
	bright := brightTemp

	satura := satura * 100
	bright := bright * 100
	return
}

roundFunc(byref first, byref second, byref third)
{
	first := round(first, 10)
	second := round(second, 10)
	third := round(third, 10)
	return
}