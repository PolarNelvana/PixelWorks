; Color library for conversion of colors
; This library converts hex color codes to many other formats
; It also converts the formats back to hex
; Each function will return an array of value(s)
; The name of each function should be sufficient to know what it does

; Hexadecimal input is designed to be with the prefix "0x" and followed by 6 hexadecimal digits
; Hexadecimal input example: 0x926DF1

; Some functions have an additional flag for output format
; outputFormat: an integer that specifies which type of values to return
; Different functions have different possible formats which will be specified near the header
; If outputFormat is blank or invalid, the function will assume the default value (the first format)

; Some functions have an additional flag for precision
; precisionFlag: any integer specifies the number of digits to round
; If precisionFlag is the character 'x', it means that we don't want to round
; If precisionFlag is blank, it is treated as 0

; Other functions have unique flags which will be specified near the headers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; outputFormat: 1 for RGB, 2 for BGR, 3 for RYB, 4 for AndroidRGB
; Prefix can be any string such as "0x" or "#" or "$"
; If prefix is blank, then the output will have no prefix
hex2HexOtherFormat(hexadecimal, outputFormat, prefix)
{
    array := []

    if (outputFormat = 4) ; AndroidRGB
        array[1] := prefix . "FF" . substr(hexadecimal, 3, 6)
    else if (outputFormat = 3) ; RYB
    {
        tempArray := hex2RYB(hexadecimal, 1, "x")

        array[1] := prefix . format("{1:02X}{2:02X}{3:02X}", tempArray*)
    }
    else if (outputFormat = 2) ; BGR
    {
        firstPosition := substr(hexadecimal, 3, 2) ; Red
        secondPosition := substr(hexadecimal, 5, 2) ; Green
        thirdPosition := substr(hexadecimal, 7, 2) ; Blue

        array[1] := prefix . thirdPosition . secondPosition . firstPosition
    }
    else ; RGB
        array[1] := prefix . substr(hexadecimal, 3, 6)

    return array
}

; outputFormat: 1 for RGB, 2 for BGR, 3 for RYB, 4 for AndroidRGB
hex2Integer(hexadecimal, outputFormat)
{
    array := hex2HexOtherFormat(hexadecimal, outputFormat, "0x")
    
    array[1] := format("{:d}", array[1])

    return array
}

; outputFormat: 1, 2, 3
; For 1 format: R/G/B all go to 255 (default)
; For 2 format: R/G/B all go to 100
; For 3 format: R/G/B all go to 1
hex2RGB(hexadecimal, outputFormat, precisionFlag)
{
    array := []

    array[1] := hexadecimal >> 16 & 0xFF ; Red
    array[2] := hexadecimal >> 8 & 0xFF ; Green
    array[3] := hexadecimal & 0xFF ; Blue
    
    if (outputFormat = 3) ; Range [0, 1]
    {
        array[1] := precisionHandler((array[1] / 255), precisionFlag)
        array[2] := precisionHandler((array[2] / 255), precisionFlag)
        array[3] := precisionHandler((array[3] / 255), precisionFlag)
    }
    else if (outputFormat = 2) ; Range [0, 100]
    {
        array[1] := precisionHandler((100 * (array[1] / 255)), precisionFlag)
        array[2] := precisionHandler((100 * (array[2] / 255)), precisionFlag)
        array[3] := precisionHandler((100 * (array[3] / 255)), precisionFlag)
    }

    return array
}

; outputFormat: 1, 2, 3
; For 1 format: B/G/R all go to 255 (default)
; For 2 format: B/G/R all go to 100
; For 3 format: B/G/R all go to 1
hex2BGR(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, outputFormat, precisionFlag)

    array := []

    array[1] := tempArray[3]
    array[2] := tempArray[2]
    array[3] := tempArray[1]
    
    return array
}

; outputFormat: 1, 2, 3
; For 1 format: R/Y/B all go to 255 (default)
; For 2 format: R/Y/B all go to 100
; For 3 format: R/Y/B all go to 1
hex2RYB(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 1, "x")
    
    array := []

    r := tempArray[1]
    g := tempArray[2]
    b := tempArray[3]

    w := min(r, g, b)

    ; Remove whiteness from colors
	r -= w
	g -= w	 
	b -= w

	mg := max(r, g, b)
	y := min(r, g)

    ; Get yellow out of the red+green
	r -= y	
	g -= y

    ; If the conversion combines blue and green, cut in half to preserve value's maximum range
	if ((b && g) != 0)
	{
		b := b / 2
		g := g / 2
	}

    ; Redistribute remaining green
	y += g
	b += g

    ; Normalize to values
	my := max(r, y, b)

	if (my != 0)
	{
		n := mg / my
		r *= n
		y *= n
		b *= n
	}

    ; Add white back in
	array[1] := r + w ; Red
	array[2] := y + w ; Yellow
	array[3] := b + w ; Blue

    if (outputFormat = 3) ; Range [0, 1]
    {
        array[1] := precisionHandler((array[1] / 255), precisionFlag)
        array[2] := precisionHandler((array[2] / 255), precisionFlag)
        array[3] := precisionHandler((array[3] / 255), precisionFlag)
    }
    else if (outputFormat = 2) ; Range [0, 100]
    {
        array[1] := precisionHandler((100 * (array[1] / 255)), precisionFlag)
        array[2] := precisionHandler((100 * (array[2] / 255)), precisionFlag)
        array[3] := precisionHandler((100 * (array[3] / 255)), precisionFlag)
    }
    else ; Range [0, 255]
    {
        ; We don't need to use the precisionHandler because 255 mode doesn't use decimals
        array[1] := round(array[1])
        array[2] := round(array[2])
        array[3] := round(array[3])
    }

    return array
}

; outputFormat: 1, 2, 3, 4, 5
; For 1 format: H goes to 360, but S/L go to 100 (default)
; For 2 format, H goes to 360, but S/L go to 1
; For 3 format: H/S/L all go to 255
; For 4 format: H/S/L all go to 240
; For 5 format: H/S/L all go to 1
hex2HSL(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 3, "x")

	redPrime := tempArray[1]
	greenPrime := tempArray[2]
	bluePrime := tempArray[3]
	
	max := max(redPrime, greenPrime, bluePrime)
	min := min(redPrime, greenPrime, bluePrime)
	
	deltaColor := max - min
	
    lightness := (max + min) / 2

    if (deltaColor = 0)
    {
        hue = 0
        saturation = 0
    }
    else
    {
        if (lightness < 0.5)
            saturation := deltaColor / (max + min)
        else
            saturation := deltaColor / (2 - max - min)

        deltaR := (((max - redPrime) / 6) + (deltaColor / 2)) / deltaColor
        deltaG := (((max - greenPrime) / 6) + (deltaColor / 2)) / deltaColor
        deltaB := (((max - bluePrime) / 6) + (deltaColor / 2)) / deltaColor

        if (redPrime = max)
            hue := deltaB - deltaG
        else if (greenPrime = max)
            hue := (1 / 3) + deltaR - deltaB
        else if (bluePrime = max)
            hue := (2 / 3) + deltaG - deltaR

        if (hue < 0)
            hue += 1
        if (hue > 1)
            hue -= 1
    }

    array := []

    array[1] := hue
    array[2] := saturation
    array[3] := lightness

    if (outputFormat = 5)
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler(array[3], precisionFlag)
    }
    else if (outputFormat = 4)
    {
        array[1] := precisionHandler((array[1] * 240), precisionFlag)
        array[2] := precisionHandler((array[2] * 240), precisionFlag)
        array[3] := precisionHandler((array[3] * 240), precisionFlag)
    }
    else if (outputFormat = 3)
    {
        array[1] := precisionHandler((array[1] * 255), precisionFlag)
        array[2] := precisionHandler((array[2] * 255), precisionFlag)
        array[3] := precisionHandler((array[3] * 255), precisionFlag)
    }
    else if (outputFormat = 2)
    {
        array[1] := precisionHandler((array[1] * 360), precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler(array[3], precisionFlag)
    }
    else
    {
        array[1] := precisionHandler((array[1] * 360), precisionFlag)
        array[2] := precisionHandler((array[2] * 100), precisionFlag)
        array[3] := precisionHandler((array[3] * 100), precisionFlag)
    }

    return array
}

; outputFormat: 1, 2, 3
; For 1 format: H goes to 360, but S/VB go to 100 (default)
; For 2 format: H goes to 360, but S/VB go to 1
; For 3 format: H/S/VB all go to 1
hex2HSVB(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2HSL(hexadecimal, 5, "x")
    tempArray[1] *= 360

    array := []

    array[1] := tempArray[1]
    array[3] := tempArray[3] + tempArray[2] * min(tempArray[3], (1 - tempArray[3]))
    if (array[3] = 0)
        array[2] = 0
    else
        array[2] := 2 * (1 - (tempArray[3] / array[3]))

    if (outputFormat = 3)
    {
        array[1] := precisionHandler((array[1] / 360), precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler(array[3], precisionFlag)
    }
    else if (outputFormat = 2)
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler(array[3], precisionFlag)
    }
    else
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler((array[2] * 100), precisionFlag)
        array[3] := precisionHandler((array[3] * 100), precisionFlag)
    }
    
	return array
}

; outputFormat: 1, 2, 3
; For 1 format: H goes to 360, but W/B go to 100 (default)
; For 2 format: H goes to 360, but W/B go to 1
; For 3 format: H/W/B all go to 1
hex2HWB(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2HSVB(hexadecimal, 1, "x")

    array := []

    array[1] := tempArray[1]
    array[2] := (100 - tempArray[2]) * (tempArray[3] / 100)
    array[3] := 100 - tempArray[3]

    if (outputFormat = 3)
    {
        array[1] := precisionHandler((array[1] / 360), precisionFlag)
        array[2] := precisionHandler((array[2] / 100), precisionFlag)
        array[3] := precisionHandler((array[3] / 100), precisionFlag)
    }
    else if (outputFormat = 2)
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler((array[2] / 100), precisionFlag)
        array[3] := precisionHandler((array[3] / 100), precisionFlag)
    }
    else
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler(array[3], precisionFlag)
    }

    return array
}

; outputFormat: 1, 2, 3, 4
; For 1 format: H goes to 360, S goes to 100, and I goes to 255 (default)
; For 2 format: H goes to 360, S goes to 1, and I goes to 255
; For 3 format: H goes to 360, S goes to 1, and I goes to 1
; For 4 format: H/S/I all go to 1
hex2HSI(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 1, "x")

    sum := tempArray[1] + tempArray[2] + tempArray[3]

    red := tempArray[1] / sum
    green := tempArray[2] / sum
    blue := tempArray[3] / sum

    numerator := 0.5 * ((red - green) + (red - blue))
    denominator := sqrt(((red - green) ** 2) + ((red - blue) * (green - blue)))
    theta := acos(numerator / denominator)

    array := []

    ; Hue
    if (blue <= green)
        array[1] := theta * (180 / pi)
    else ; blue > green
        array[1] := ((2 * pi) - theta) * (180 / pi)

    ; Saturation
    array[2] := 1 - (3 * min(red, green, blue))

    ; Intensity
    array[3] := sum / (3 * 255)

    if (outputFormat = 4)
    {
        array[1] := precisionHandler((array[1] / 360), precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler(array[3], precisionFlag)
    }
    else if (outputFormat = 3)
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler(array[3], precisionFlag)
    }
    else if (outputFormat = 2)
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler(array[2], precisionFlag)
        array[3] := precisionHandler((array[3] * 255), precisionFlag)
    }
    else
    {
        array[1] := precisionHandler(array[1], precisionFlag)
        array[2] := precisionHandler((array[2] * 100), precisionFlag)
        array[3] := precisionHandler((array[3] * 255), precisionFlag)
    }

    return array
}

; outputFormat: 1, 2
; For 1 format: C/M/Y/K all go to 100
; For 2 format: C/M/Y/K all go to 1
hex2CMYK(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 3, "x")

    array := []

    array[4] := 1 - max(tempArray[1], tempArray[2], tempArray[3]) ; Black
    array[3] := ((1 - tempArray[3] - array[4]) / (1 - array[4])) ; Yellow
    array[2] := ((1 - tempArray[2] - array[4]) / (1 - array[4])) ; Magenta
    array[1] := ((1 - tempArray[1] - array[4]) / (1 - array[4])) ; Cyan

    if (outputFormat != 2)
    {
        array[1] *= 100
        array[2] *= 100
        array[3] *= 100
        array[4] *= 100
    }

    array[1] := precisionHandler(array[1], precisionFlag)
    array[2] := precisionHandler(array[2], precisionFlag)
    array[3] := precisionHandler(array[3], precisionFlag)
    array[4] := precisionHandler(array[4], precisionFlag)

    return array
}

; outputFormat: 1, 2
; For 1 format: C/M/Y/K all go to 100
; For 2 format: C/M/Y/K all go to 1
hex2CMY(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2CMYK(hexadecimal, 2, "x")

    array := []

    array[1] := tempArray[1] * (1 - tempArray[4]) + tempArray[4] ; Cyan
    array[2] := tempArray[2] * (1 - tempArray[4]) + tempArray[4] ; Magenta
    array[3] := tempArray[3] * (1 - tempArray[4]) + tempArray[4] ; Yellow

    if (outputFormat != 2)
    {
        array[1] *= 100
        array[2] *= 100
        array[3] *= 100
    }

    array[1] := precisionHandler(array[1], precisionFlag)
    array[2] := precisionHandler(array[2], precisionFlag)
    array[3] := precisionHandler(array[3], precisionFlag)

    return array
}

hex2XYZ(hexadecimal, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 3, "x")

    red := tempArray[1]
    green := tempArray[2]
    blue := tempArray[3]

    if (red > 0.04045)
        red := ((red + 0.055) / 1.055) ** 2.4
    else
        red := red / 12.92

    if (green > 0.04045)
        green := ((green + 0.055) / 1.055) ** 2.4
    else
        green := green / 12.92

    if (blue > 0.04045)
        blue := ((blue + 0.055) / 1.055) ** 2.4
    else
        blue := blue / 12.92

    red := red * 100
    green := green * 100
    blue := blue * 100

    array := []

    array[1] := precisionHandler((red * 0.4124 + green * 0.3576 + blue * 0.1805), precisionFlag)
    array[2] := precisionHandler((red * 0.2126 + green * 0.7152 + blue * 0.0722), precisionFlag)
    array[3] := precisionHandler((red * 0.0193 + green * 0.1192 + blue * 0.9505), precisionFlag)

    return array
}

hex2Yxy(hexadecimal, precisionFlag)
{
    tempArray := hex2XYZ(hexadecimal, "x")

    array := []

    array[1] := precisionHandler(tempArray[2], precisionFlag)
    array[2] := precisionHandler((tempArray[1] / (tempArray[1] + tempArray[2] + tempArray[3])), precisionFlag)
    array[3] := precisionHandler((tempArray[2] / (tempArray[1] + tempArray[2] + tempArray[3])), precisionFlag)

    return array
}

; outputFormat: 1, 2, 3
; For 1 format: R/G/B all go to 255 (default)
; For 2 format: R/G/B all go to 100
; For 3 format: R/G/B all go to 1
hex2AdobeRGB(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2XYZ(hexadecimal, "x")

    x := tempArray[1] / 100
    y := tempArray[2] / 100
    z := tempArray[3] / 100

    adobeR := x * 2.04137 + y * -0.56495 + z * -0.34469
    adobeG := x * -0.96927 + y * 1.87601 + z * 0.04156
    adobeB := x * 0.01345 + y * -0.11839 + z * 1.01541

    adobeR := adobeR ** (1 / 2.19921875)
    adobeG := adobeG ** (1 / 2.19921875)
    adobeB := adobeB ** (1 / 2.19921875)

    array := []

    if (outputFormat = 3) ; Range [0, 1]
    {
        array[1] := precisionHandler(adobeR, precisionFlag)
        array[2] := precisionHandler(adobeG, precisionFlag)
        array[3] := precisionHandler(adobeB, precisionFlag)
    }
    else if (outputFormat = 2) ; Range [0, 100]
    {
        array[1] := precisionHandler((100 * adobeR), precisionFlag)
        array[2] := precisionHandler((100 * adobeG), precisionFlag)
        array[3] := precisionHandler((100 * adobeB), precisionFlag)
    }
    else ; Range [0, 255]
    {
        array[1] := precisionHandler((255 * adobeR), precisionFlag)
        array[2] := precisionHandler((255 * adobeG), precisionFlag)
        array[3] := precisionHandler((255 * adobeB), precisionFlag)
    }

    return array
}

hex2CIELab(hexadecimal, precisionFlag)
{
    tempArray := hex2XYZ(hexadecimal, "x")

    x := tempArray[1] / 95.047
    y := tempArray[2] / 100
    z := tempArray[3] / 108.883

    if (x > 0.008856) 
        x := x ** (1 / 3)
    else
        x := (7.787 * x) + (16 / 116)

    if (y > 0.008856)
        y := y ** (1 / 3)
    else
        y := (7.787 * y) + (16 / 116)

    if (z > 0.008856)
        z := z ** (1 / 3)
    else
        z := (7.787 * z) + (16 / 116)

    array := []

    array[1] := precisionHandler(((116 * y) - 16), precisionFlag) ; L
    array[2] := precisionHandler((500 * (x - y)), precisionFlag) ; A
    array[3] := precisionHandler((200 * (y - z)), precisionFlag) ; B

    return array		
}

hex2CIELChab(hexadecimal, precisionFlag)
{
    tempArray := hex2CIELab(hexadecimal, "x")

    array := []

    array[1] := precisionHandler(tempArray[1], precisionFlag) ; L
    array[2] := precisionHandler(sqrt((tempArray[2]**2) + (tempArray[3]**2)), precisionFlag) ; C
    array[3] := precisionHandler(quadrantConfig(tempArray[2], tempArray[3]), precisionFlag) ; H

    return array
}

hex2CIELShab(hexadecimal, precisionFlag)
{
    tempArray := hex2CIELChab(hexadecimal, "x")

    array := []

    array[1] := precisionHandler(tempArray[1], precisionFlag) ; L
    array[2] := precisionHandler((tempArray[2] / tempArray[1]), precisionFlag) ; S
    array[3] := precisionHandler(tempArray[3], precisionFlag) ; H

    return array
}

hex2CIELuv(hexadecimal, precisionFlag)
{
    tempArray := hex2XYZ(hexadecimal, "x")
    
    u := (4 * tempArray[1]) / (tempArray[1] + (15 * tempArray[2]) + (3 * tempArray[3]))
    v := (9 * tempArray[2]) / (tempArray[1] + (15 * tempArray[2]) + (3 * tempArray[3]))
    y := tempArray[2] / 100

    if (y > 0.008856)
        y := y ** (1 / 3)
    else
        y := (7.787 * y) + (16 / 116)

    refU := (4 * 95.047) / (95.047 + (15 * 100) + (3 * 108.883))
    refV := (9 * 100) / (95.047 + (15 * 100) + (3 * 108.883))

    array := []
    
    array[1] := precisionHandler(((116 * y) - 16), precisionFlag) ; L
    array[2] := precisionHandler((13 * array[1] * (u - refU)), precisionFlag) ; U
    array[3] := precisionHandler((13 * array[1] * (v - refV)), precisionFlag) ; V

    return array
}

hex2CIELChuv(hexadecimal, precisionFlag)
{
    tempArray := hex2CIELuv(hexadecimal, "x")

    array := []

    array[1] := precisionHandler(tempArray[1], precisionFlag) ; L
    array[2] := precisionHandler(sqrt((tempArray[2]**2) + (tempArray[3]**2)), precisionFlag) ; C
    array[3] := precisionHandler(quadrantConfig(tempArray[2], tempArray[3]), precisionFlag) ; H

    return array
}

hex2CIELShuv(hexadecimal, precisionFlag)
{
    tempArray := hex2CIELChuv(hexadecimal, "x")

    array := []

    array[1] := precisionHandler(tempArray[1], precisionFlag) ; L
    array[2] := precisionHandler((tempArray[2] / tempArray[1]), precisionFlag) ; S
    array[3] := precisionHandler(tempArray[3], precisionFlag) ; H

    return array
}

hex2HunterLab(hexadecimal, precisionFlag)
{
    tempArray := hex2XYZ(hexadecimal, "x")

	a := (175 / 198.04) * (100 + 95.047)
    b := (70 / 218.11) * (100 + 108.883)

    array := []

    array[1] := precisionHandler((100 * sqrt(tempArray[2] / 100)), precisionFlag)
    array[2] := precisionHandler((a * (((tempArray[1] / 95.047) - (tempArray[2] / 100)) / sqrt(tempArray[2] / 100))), precisionFlag)
    array[3] := precisionHandler((b * (((tempArray[2] / 100) - (tempArray[3] / 108.883)) / sqrt(tempArray[2] / 100))), precisionFlag)
    
    return array
}

; outputFormat: 1, 2
; For 1 format: Y/U/V all go to 255 (default)
; For 2 format: Y/U/V all go to 1
hex2YUV(hexadecimal, outputFormat, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 3, "x")

    matrix1 := (0.299 * tempArray[1]) + (0.587 * tempArray[2]) + (0.114 * tempArray[3])
    matrix2 := (-0.147 * tempArray[1]) + (-0.289 * tempArray[2]) + (0.436 * tempArray[3])
    matrix3 := (0.615 * tempArray[1]) + (-0.515 * tempArray[2]) + (-0.100 * tempArray[3])

    if (outputFormat != 2)
    {
        matrix1 *= 255
        matrix2 *= 255
        matrix3 *= 255
    }

    array := []

    array[1] := precisionHandler(matrix1, precisionFlag)
    array[2] := precisionHandler(matrix2, precisionFlag)
    array[3] := precisionHandler(matrix3, precisionFlag)

    return array
}

; definition: 1 = high definition, 2 = full range, 3 = standard definition
hex2YCbCr(hexadecimal, definition, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 1, "x")

    if (definition = 3) ; Standard definition TV
    {
        matrix1 := ((0.257 * tempArray[1]) + (0.504 * tempArray[2]) + (0.098 * tempArray[3])) + 16
        matrix2 := ((-0.148 * tempArray[1]) + (-0.291 * tempArray[2]) + (0.439 * tempArray[3])) + 128
        matrix3 := ((0.439 * tempArray[1]) + (-0.368 * tempArray[2]) + (-0.071 * tempArray[3])) + 128
    }
    else if (definition = 2) ; Full range definition
    {
        matrix1 := (0.299 * tempArray[1]) + (0.587 * tempArray[2]) + (0.114 * tempArray[3])
        matrix2 := ((-0.169 * tempArray[1]) + (-0.331 * tempArray[2]) + (0.500 * tempArray[3])) + 128
        matrix3 := ((0.500 * tempArray[1]) + (-0.419 * tempArray[2]) + (-0.081 * tempArray[3])) + 128
    }
    else ; High definition TV
    {
        matrix1 := ((0.183 * tempArray[1]) + (0.614 * tempArray[2]) + (0.062 * tempArray[3])) + 16
        matrix2 := ((-0.101 * tempArray[1]) + (-0.339 * tempArray[2]) + (0.439 * tempArray[3])) + 128
        matrix3 := ((0.439 * tempArray[1]) + (-0.399 * tempArray[2]) + (-0.040 * tempArray[3])) + 128
    }

    array := []

    array[1] := precisionHandler(matrix1, precisionFlag)
    array[2] := precisionHandler(matrix2, precisionFlag)
    array[3] := precisionHandler(matrix3, precisionFlag)

    return array
}

; definition: 1 = high definition (default), 2 = standard definition
hex2YPbPr(hexadecimal, definition, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 1, "x")

    if (definition = 2) ; Standard definition TV
    {
        matrix1 := (0.299 * tempArray[1]) + (0.587 * tempArray[2]) + (0.114 * tempArray[3])
        matrix2 := (-0.169 * tempArray[1]) + (-0.331 * tempArray[2]) + (0.500 * tempArray[3])
        matrix3 := (0.500 * tempArray[1]) + (-0.419 * tempArray[2]) + (-0.081 * tempArray[3])
    }
    else ; High definition TV
    {
        matrix1 := (0.213 * tempArray[1]) + (0.715 * tempArray[2]) + (0.072 * tempArray[3])
        matrix2 := (-0.115 * tempArray[1]) + (-0.385 * tempArray[2]) + (0.500 * tempArray[3])
        matrix3 := (0.500 * tempArray[1]) + (-0.454 * tempArray[2]) + (-0.046 * tempArray[3])
    }

    array := []

    array[1] := precisionHandler(matrix1, precisionFlag)
    array[2] := precisionHandler(matrix2, precisionFlag)
    array[3] := precisionHandler(matrix3, precisionFlag)

    return array
}

hex2YCxCz(hexadecimal, precisionFlag)
{
    tempArray := hex2XYZ(hexadecimal, "x")

    array := []

    array[1] := precisionHandler((116 * (tempArray[2] / 100)), precisionFlag)
    array[2] := precisionHandler((500 * ((tempArray[1] / 95.047) - (tempArray[2] / 100))), precisionFlag)
    array[3] := precisionHandler((200 * ((tempArray[2] / 100) - (tempArray[3] / 108.883))), precisionFlag)

    return array
}

hex2YCoCg(hexadecimal, precisionFlag)
{
    tempArray := hex2RGB(hexadecimal, 1, "x")

    matrix1 := (0.25 * tempArray[1]) + (0.5 * tempArray[2]) + (0.25 * tempArray[3])
    matrix2 := (0.5 * tempArray[1]) + (-0.5 * tempArray[3])
    matrix3 := (-0.25 * tempArray[1]) + (0.5 * tempArray[2]) + (-0.25 * tempArray[3])

    array := []

    array[1] := precisionHandler(matrix1, precisionFlag)
    array[2] := precisionHandler(matrix2, precisionFlag)
    array[3] := precisionHandler(matrix3, precisionFlag)

    return array
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; REVERSE

; This portion of the code contains functions that convert all of the above codes ** back to hex
; Each of these functions returns a single hexadecimal value
; The functions will return nothing if given invalid inputFormat flag

; inputFormat: 1 for RGB, 2 for BGR, 3 for RYB, 4 for AndroidRGB
; Prefix can be whatever string
hexOtherFormat2Hex(hexFormat, inputFormat, inputPrefix)
{
    hexadecimal := substr(hexFormat, (strlen(inputPrefix) + 1), strlen(hexFormat))

    if (inputFormat = 1)
        return "0x" . hexadecimal
    else if (inputFormat = 2)
    {
        firstPosition := substr(hexadecimal, 1, 2) ; Blue
        secondPosition := substr(hexadecimal, 3, 2) ; Green
        thirdPosition := substr(hexadecimal, 5, 2) ; Red

        return "0x" . thirdPosition . secondPosition . firstPosition
    }
    else if (inputFormat = 3)
    {
        hexadecimal := "0x" . hexadecimal

        red := hexadecimal >> 16 & 0xFF
        yellow := hexadecimal >> 8 & 0xFF
        blue := hexadecimal & 0xFF

        return RYB2Hex(red, yellow, blue, 1)
    }
    else if (inputFormat = 4)
        return "0x" . substr(hexadecimal, 3, strlen(hexadecimal))

    return
}

; inputFormat: 1 for RGB, 2 for BGR, 3 for RYB, 4 for AndroidRGB
integer2Hex(int, inputFormat)
{
    if (inputFormat = 1)
        return format("0x{:X}", int)
    else if (inputFormat = 2)
        return hexOtherFormat2Hex(format("0x{:X}", int), 2, "0x")
    else if (inputFormat = 3)
        return hexOtherFormat2Hex(format("0x{:X}", int), 3, "0x")
    else if (inputFormat = 4)
        return hexOtherFormat2Hex(format("0x{:X}", int), 4, "0x")

    return
}

; inputFormat: 1, 2, 3
; For 1 format: R/G/B all go to 255
; For 2 format: R/G/B all go to 100
; For 3 format: R/G/B all go to 1
RGB2Hex(red, green, blue, inputFormat)
{
    if (inputFormat = 3)
    {
        red := round(red * 255)
        green := round(green * 255)
        blue := round(blue * 255)
    }
    else if (inputFormat = 2)
    {
        red := round(red * 2.55)
        green := round(green * 2.55)
        blue := round(blue * 2.55)
    }
    else if (inputFormat != 1)
        return

    return format("0x{1:02X}{2:02X}{3:02X}", red, green, blue)
}

; inputFormat: 1, 2, 3
; For 1 format: B/G/R all go to 255
; For 2 format: B/G/R all go to 100
; For 3 format: B/G/R all go to 1
BGR2Hex(blue, green, red, inputFormat)
{
    return RGB2Hex(red, green, blue, inputFormat)
}

; inputFormat: 1, 2, 3
; For 1 format: R/Y/B all go to 255
; For 2 format: R/Y/B all go to 100
; For 3 format: R/Y/B all go to 1
RYB2Hex(red, yellow, blue, inputFormat)
{
    if (inputFormat = 3)
    {
        red := round(red * 255)
        yellow := round(yellow * 255)
        blue := round(blue * 255)
    }
    else if (inputFormat = 2)
    {
        red := round(red * 2.55)
        yellow := round(yellow * 2.55)
        blue := round(blue * 2.55)
    }
    else if (inputFormat != 1)
        return

    ; Remove the whiteness from the color
    white := min(red, yellow, blue)
    
    red -= white
    yellow -= white
    blue -= white

    maxYellow := max(red, yellow, blue)

    ; Get the green out of the yellow and blue
    green := min(yellow, blue)
    
    yellow -= green
    blue -= green

    if ((blue && green) != 0)
    {
        blue *= 2
        green *= 2
    }
    
    ; Redistribute the remaining yellow
    red += yellow
    green += yellow

    ; Normalize to values
    maxGreen := max(red, green, blue)
    
    if (maxGreen > 0)
    {
        div := maxYellow / maxGreen
        
        red *= div
        green *= div
        blue *= div
    }
    
    ; Add the white back in
    red := round(red + white)
    green := round(green + white)
    blue := round(blue + white)

    return RGB2Hex(red, green, blue, 1)
}

; inputFormat: 1, 2, 3, 4, 5
; For 1 format: H goes to 360, but S/L go to 100
; For 2 format, H goes to 360, but S/L go to 1
; For 3 format: H/S/L all go to 255
; For 4 format: H/S/L all go to 240
; For 5 format: H/S/L all go to 1
HSL2Hex(hue, saturation, lightness, inputFormat)
{
    if (inputFormat = 1)
    {
        hue := hue / 360
        saturation := saturation / 100
        lightness := lightness / 100
    }
    else if (inputFormat = 2)
        hue := hue / 360
    else if (inputFormat = 3)
    {
        hue := hue / 255
        saturation := saturation / 255
        lightness := lightness / 255
    }
    else if (inputFormat = 4)
    {
        hue := hue / 240
        saturation := saturation / 240
        lightness := lightness / 240
    }
    else if (inputFormat != 5)
        return

    if (saturation = 0)
    {
        red := lightness * 255
        green := lightness * 255
        blue := lightness * 255
    }
    else
    {
        if (lightness < 0.5)
            var2 := lightness * (1 + saturation)
        else
            var2 := (lightness + saturation) - (saturation * lightness)

        var1 := (2 * lightness) - var2

        red := 255 * hue2RGB(var1, var2, hue + (1 / 3))
        green := 255 * hue2RGB(var1, var2, hue)
        blue := 255 * hue2RGB(var1, var2, hue - (1 / 3))
    }

    red := round(red)
    green := round(green)
    blue := round(blue)

    return RGB2Hex(red, green, blue, 1)
}

; inputFormat: 1, 2, 3
; For 1 format: H goes to 360, but S/VB go to 100
; For 2 format: H goes to 360, but S/VB go to 1
; For 3 format: H/S/VB all go to 1
HSVB2Hex(hue, saturation, value, inputFormat)
{
    if (inputFormat = 1)
    {
        hue := hue / 360
        saturation := saturation / 100
        value := value / 100
    }
    else if (inputFormat = 2)
        hue := hue / 360
    else if (inputFormat != 3)
        return
    
    if (saturation = 0)
    {
        red := round(value * 255)
        green := round(value * 255)
        blue := round(value * 255)
    }
    else
    {
        h := hue * 6

        if (h = 6)
            h := 0
        
        i := floor(h)

        var1 := value * (1 - saturation)
        var2 := value * (1 - saturation * (h - i))
        var3 := value * (1 - saturation * (1 - (h - i)))

        if (i = 0)
        {
            red := value
            green := var3
            blue := var1
        }
        else if (i = 1)
        {
            red := var2
            green := value
            blue := var1
        }
        else if (i = 2)
        {
            red := var1
            green := value
            blue := var3
        }
        else if (i = 3)
        {
            red := var1
            green := var2
            blue := value
        }
        else if (i = 4)
        {
            red := var3
            green := var1
            blue := value
        }
        else
        {
            red := value
            green := var1
            blue := var2
        }

        red := round(red * 255)
        green := round(green * 255)
        blue := round(blue * 255)
    }

    return RGB2Hex(red, green, blue, 1)
}

; inputFormat: 1, 2, 3
; For 1 format: H goes to 360, but W/B go to 100
; For 2 format: H goes to 360, but W/B go to 1
; For 3 format: H/W/B all go to 1
HWB2Hex(hue, whiteness, blackness, inputFormat)
{
    if (inputFormat = 1)
    {
        hue := hue / 360
        whiteness := whiteness / 100
        blackness := blackness / 100
    }
    else if (inputFormat = 2)
    {
        hue := hue / 360
    }
    else if (inputFormat != 3)
        return

    return HSVB2Hex(hue, (1 - (whiteness / (1 - blackness))), (1 - blackness), 3)
}

; inputFormat: 1, 2, 3, 4
; For 1 format: H goes to 360, S goes to 100, and I goes to 255
; For 2 format: H goes to 360, S goes to 1, and I goes to 255
; For 3 format: H goes to 360, S goes to 1, and I goes to 1
; For 4 format: H/S/I all go to 1
HSI2Hex(hue, saturation, intensity, inputFormat)
{
    if (inputFormat = 1)
    {
        saturation := saturation / 100
        intensity := intensity / 255
    }
    else if (inputFormat = 2)
        intensity := intensity / 255
    else if (inputFormat = 4)
        hue *= 360
    else if (inputFormat != 3)
        return

    if ((0 <= hue) && (hue < 120))
    {
        blue := intensity * (1 - saturation)
        red := intensity * (1 + ((saturation * cosDegree(hue)) / (cosDegree(60 - hue))))
        green := 3 * intensity - (red + blue)
    }
    else if ((120 <= hue) && (hue < 240))
    {
        hue -= 120
        red := intensity * (1 - saturation)
        green :=  intensity * (1 + ((saturation * cosDegree(hue)) / (cosDegree(60 - hue))))
        blue := 3 * intensity - (red + green)
    }
    else if ((240 <= hue) && (hue <= 360))
    {
        hue -= 240
        green := intensity * (1 - saturation)
        blue :=  intensity * (1 + ((saturation * cosDegree(hue)) / (cosDegree(60 - hue))))
        red := 3 * intensity - (green + blue)
    }

    return RGB2Hex(red, green, blue, 3)
}

; inputFormat: 1, 2
; For 1 format: C/M/Y/K all go to 100
; For 2 format: C/M/Y/K all go to 1
CMYK2Hex(cyan, magenta, yellow, black, inputFormat)
{
    if (inputFormat = 1)
    {
        cyan := cyan / 100
        magenta := magenta / 100
        yellow := yellow / 100
        black := black / 100
    }
    else if (inputFormat != 2)
        return

    red := round(255 * (1 - cyan) * (1 - black))
    green := round(255 * (1 - magenta) * (1 - black))
    blue := round(255 * (1 - yellow) * (1 - black))

    return RGB2Hex(red, green, blue, 1)
}

; inputFormat: 1, 2
; For 1 format: C/M/Y/K all go to 100
; For 2 format: C/M/Y/K all go to 1
CMY2Hex(cyan, magenta, yellow, inputFormat)
{
    if (inputFormat = 1)
    {
        cyan := cyan / 100
        magenta := magenta / 100
        yellow := yellow / 100
    }
    else if (inputFormat != 2)
        return

    red := round((1 - cyan) * 255)
    green := round((1 - magenta) * 255)
    blue := round((1 - yellow) * 255)

    return RGB2Hex(red, green, blue, 1)
}

XYZ2Hex(x, y, z)
{
    x := x / 100
    y := y / 100
    z := z / 100

    red := x * 3.2406 + y * -1.5372 + z * -0.4986
    green := x * -0.9689 + y *  1.8758 + z * 0.0415
    blue := x * 0.0557 + y * -0.2040 + z * 1.0570

    if (abs(red) > 0.0031308)
        red := 1.055 * (red ** (1 / 2.4)) - 0.055
    else
        red := 12.92 * red

    if (abs(green) > 0.0031308)
        green := 1.055 * (green ** (1 / 2.4)) - 0.055
    else
        green := 12.92 * green

    if (abs(blue) > 0.0031308)
        blue := 1.055 * (blue ** (1 / 2.4)) - 0.055
    else
        blue := 12.92 * blue

    red := round(red *255)
    green := round(green * 255)
    blue := round(blue * 255)

    return RGB2Hex(red, green, blue, 1)
}

Yxy2Hex(y1, x, y2)
{
    varX := x * (y1 / y2)
    varY := y1
    varZ := (1 - x - y2) * (y1 / y2)

    return XYZ2Hex(varX, varY, varZ)
}

; inputFormat: 1, 2, 3
; For 1 format: R/G/B all go to 255
; For 2 format: R/G/B all go to 100
; For 3 format: R/G/B all go to 1
AdobeRGB2Hex(red, green, blue, inputFormat)
{
    if (inputFormat = 1)
    {
        red := red / 255
        green := green / 255
        blue := blue / 255
    }
    else if (inputFormat = 2)
    {
        red := red / 100
        green := green / 100
        blue := blue / 100
    }
    else if (inputFormat != 3)
        return

    red := (red ** 2.19921875) * 100
    green := (green ** 2.19921875) * 100
    blue := (blue ** 2.19921875) * 100

    x := red * 0.57667 + green * 0.18555 + blue * 0.18819
    y := red * 0.29738 + green * 0.62735 + blue * 0.07527
    z := red * 0.02703 + green * 0.07069 + blue * 0.99110

    return XYZ2Hex(x, y, z)
}

CIELab2Hex(L, a, b)
{
    y := (L + 16) / 116
    x := a / 500 + y
    z := y - b / 200

    if (y**3 > 0.008856)
        y := y**3
    else
        y := (y - 16 / 116) / 7.787

    if (x**3 > 0.008856)
        x := x**3
    else
        x := (x - 16 / 116) / 7.787

    if (z**3 > 0.008856)
        z := z**3
    else
        z := (z - 16 / 116) / 7.787

    x *= 95.047
    y *= 100
    z *= 108.883

    return XYZ2Hex(x, y, z)
}

CIELChab2Hex(L, C, h)
{
    a := cos(degree2Radian(h)) * C
    b := sin(degree2Radian(h)) * C

    return CIELab2Hex(L, a, b)
}

CIELShab2Hex(L, S, h)
{
    C := L * S

    a := cos(degree2Radian(h)) * C
    b := sin(degree2Radian(h)) * C

    return CIELab2Hex(L, a, b)
}

CIELuv2Hex(L, u, v)
{
    y := (L + 16) / 116

    if (y**3 > 0.008856)
        y := y**3
    else
        y := (y - 16 / 116) / 7.787

    refU := (4 * 95.047) / (95.047 + (15 * 100) + (3 * 108.883))
    refV := (9 * 100) / (95.047 + (15 * 100) + (3 * 108.883))

    u := u / (13 * L) + refU
    v := v / (13 * L) + refV

    y *= 100
    x := - (9 * y * u) / ((u - 4) * v - u * v)
    z := (9 * y - (15 * v * y) - (v * X)) / (3 * v)

    return XYZ2Hex(x, y, z)
}

CIELChuv2Hex(L, C, h)
{
    u := cos(degree2Radian(h)) * C
    v := sin(degree2Radian(h)) * C

    return CIELuv2Hex(L, u, v)
}

CIELShuv2Hex(L, S, h)
{
    C := L * S

    u := cos(degree2Radian(h)) * C
    v := sin(degree2Radian(h)) * C

    return CIELuv2Hex(L, u, v)
}

HunterLab2Hex(L, a, b)
{
    varA := (175 / 198.04) * (100 + 95.047)
    varB := (70 / 218.11) * (100 + 108.883)

    y := ((L / 100) ** 2) * 100
    x := (a / varA * sqrt(y / 100) + (y / 100)) * 95.047
    z := - (b / varB * sqrt(y / 100) - (y / 100)) * 108.883

    return XYZ2Hex(x, y, z)
}

; inputFormat: 1, 2
; For 1 format: Y/U/V all go to 255
; For 2 format: Y/U/V all go to 1
YUV2Hex(y, u, v, inputFormat)
{
    if (inputFormat = 1)
    {
        y := y / 255
        u := u / 255
        v := v / 255
    }
    else if (inputFormat != 2)
        return

    red := y + (1.14 * v)
    green := y - (0.395 * u) - (0.581 * v)
    blue := y + (2.032 * u)

    return RGB2Hex(red, green, blue, 3)
}

; inputFormat: 1 = high definition, 2 = full range, 3 = standard definition
YCbCr2Hex(y, Cb, Cr, inputFormat)
{
    Cb -= 128
    Cr -= 128

    if (inputFormat = 1)
    {
        y -= 16
        red := (1.164 * y) + (1.793 * Cr)
        green := (1.164 * y) - (0.213 * Cb) - (0.533 * Cr)
        blue := (1.164 * y) + (2.112 * Cb)
    }
    else if (inputFormat = 2)
    {
        red := y + (1.4 * Cr)
        green := y - (0.343 * Cb) - (0.711 * Cr)
        blue := y + (1.765 * Cb)
    }
    else if (inputFormat = 3)
    {
        y -= 16
        red := (1.164 * y) + (1.596 * Cr)
        green := (1.164 * y) - (0.392 * Cb) - (0.813 * Cr)
        blue := (1.164 * y) + (2.017 * Cb)
    }
    else
        return

    red := round(red)
    green := round(green)
    blue := round(blue)

    return RGB2Hex(red, green, blue, 1)
}

; inputFormat: 1 = high definition, 2 = standard definition
YPbPr2Hex(y, Pb, Pr, inputFormat)
{
    if (inputFormat = 1)
    {
        red := y + (1.575 * Pr)
        green := y - (0.187 * Pb) - (0.468 * Pr)
        blue := y + (1.856 * Pb)
    }
    else if (inputFormat = 2)
    {
        red := y + (1.402 * Pr)
        green := y - (0.344 * Pb) - (0.714 * Pr)
        blue := y + (1.772 * Pb)

    }
    else
        return

    red := round(red)
    green := round(green)
    blue := round(blue)

    return RGB2Hex(red, green, blue, 1)
}

YCxCz2Hex(Y, Cx, Cz)
{
    ; This formula I came up with by using algebra and solving the YCxCz forumula for the original XYZ variables
    varY := (100 * Y) / 116
    varX := ((Cx * 95.047) / 500) + ((varY * 95.047) / 100)
    varZ := -(((Cz * 108.883) - (2 * varY * 108.883)) / 200)
    
    return XYZ2Hex(varX, varY, varZ)
}

YCoCg2Hex(Y, Co, Cg)
{
    red := Y + Co - Cg
    green := Y + Cg
    blue := Y - Co - Cg

    return RGB2Hex(red, green, blue, 1)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UTILITIES

global pi := 3.1415926535897932384626433832795

degree2Radian(degree)
{
    return degree * (pi / 180)
}

radian2Degree(radian)
{
    return radian * (180 / pi)
}

; AutoHotkey docs specify that the cos function must have input values of radians and it outputs radians as well
; Therefore convert degrees to radians before doing cos and then convert output back to degrees
cosDegree(expression)
{
    return radian2Degree(cos(degree2Radian(expression)))
}

hue2RGB(v1, v2, vH)
{
    if (vH < 0)
        vH += 1
    if (vH > 1)
        vH -= 1
    if ((6 * vH) < 1)
        return (v1 + (v2 - v1) * 6 * vH)
    if ((2 * vH) < 1)
        return v2
    if ((3 * vH) < 2)
        return (v1 + (v2 - v1) * ((2 / 3) - vH) * 6)
    return v1
}

precisionHandler(expression, precisionFlag)
{
    if (precisionFlag != "x")
        return round(expression, precisionFlag)
    else
        return expression
}

quadrantConfig(a, b)
{
    	if ((a >= 0) && (b = 0))
			h := 0
		else if ((a < 0) && (b = 0))
			h := 180
		else if ((a = 0) && (b > 0))
			h := 90
		else if ((a = 0) && (b < 0))
			h := 270
        else
        {
            if ((a > 0) && (b > 0))
                xBias := 0
            else if (a < 0)
                xBias := 180
            else if ((a > 0) && (b < 0))
                xBias := 360

            h := atan((b / a))
            h := (h * 57.29578) + xBias

            if (h < 0)
			    h := 360 + h
        }

    return h
}

cubicInt(t, a, b)
{
	weight := t * t * (3 - (2 * t))
	weight := a + weight * (b - a)
	return weight
}

; Input and output: 0 <= RGB <= 1
ryb2RGB(ir, iy, ib)
{
	; red
	x0 := cubicInt(iB, 1.0, 0.163)
	x1 := cubicInt(iB, 1.0, 0.0)
	x2 := cubicInt(iB, 1.0, 0.5)
	x3 := cubicInt(iB, 1.0, 0.2)
	y0 := cubicInt(iY, x0, x1)
	y1 := cubicInt(iY, x2, x3)
	oRr := cubicInt(iR, y0, y1)

	; green
	x0 := cubicInt(iB, 1.0, 0.373)
	x1 := cubicInt(iB, 1.0, 0.66)
	x2 := cubicInt(iB, 0.0, 0.0)
	x3 := cubicInt(iB, 0.5, 0.094)
	y0 := cubicInt(iY, x0, x1)
	y1 := cubicInt(iY, x2, x3)
	oG := cubicInt(iR, y0, y1)

	; blue
	x0 := cubicInt(iB, 1.0, 0.6)
	x1 := cubicInt(iB, 0.0, 0.2)
	x2 := cubicInt(iB, 0.0, 0.5)
	x3 := cubicInt(iB, 0.0, 0.0)
	y0 := cubicInt(iY, x0, x1)
	y1 := cubicInt(iY, x2, x3)
	oB := cubicInt(iR, y0, y1)

	rgbArray := []

	rgbArray[1] := oRr
	rgbArray[2] := oG
	rgbArray[3] := oB

	return rgbArray
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MISCELLANEOUS

; This function below allows us to call any of the conversion functions above using a number instead of the function name
; First argument is our hexadecimal value
; Second argument is the number of the color format
; To get the number of the color format, look at the comments throughout the function below
; The precision flag indicates how many decimals we want
hex2Number(hexadecimal, typeNumber, precisionFlag)
{
	if (typeNumber = 1) ; HTML
		array := hex2HexOtherFormat(hexadecimal, 1, "#")
	else if (typeNumber = 2) ; Hex (RGB)
		array := hex2HexOtherFormat(hexadecimal, 1, "0x")
	else if (typeNumber = 3) ; RGB (255)
		array := hex2RGB(hexadecimal, 1, precisionFlag)
	else if (typeNumber = 4) ; RGB (100)
		array := hex2RGB(hexadecimal, 2, precisionFlag)
	else if (typeNumber = 5) ; RGB (1)
		array := hex2RGB(hexadecimal, 3, precisionFlag)
	else if (typeNumber = 6) ; Integer (RGB)
		array := hex2Integer(hexadecimal, 1)
	else if (typeNumber = 7) ; Hex (BGR)
		array := hex2HexOtherFormat(hexadecimal, 2, "0x")
	else if (typeNumber = 8) ; BGR (255)
		array := hex2BGR(hexadecimal, 1, precisionFlag)
	else if (typeNumber = 9) ; BGR (100)
		array := hex2BGR(hexadecimal, 2, precisionFlag)
	else if (typeNumber = 10) ; BGR (1)
		array := hex2BGR(hexadecimal, 3, precisionFlag)
	else if (typeNumber = 11) ; Integer (BGR)
		array := hex2Integer(hexadecimal, 2)
	else if (typeNumber = 12) ; Hex (RYB)
		array := hex2HexOtherFormat(hexadecimal, 3, "0x")
	else if (typeNumber = 13) ; RYB (255)
		array := hex2RYB(hexadecimal, 1, precisionFlag)
	else if (typeNumber = 14) ; RYB (100)
		array := hex2RYB(hexadecimal, 2, precisionFlag)
	else if (typeNumber = 15) ; RYB (1)
		array := hex2RYB(hexadecimal, 3, precisionFlag)
	else if (typeNumber = 16) ; Integer (RYB)
		array := hex2Integer(hexadecimal, 3)
	else if (typeNumber = 17) ; Hex (Android RGB)
		array := hex2HexOtherFormat(hexadecimal, 4, "0x")
	else if (typeNumber = 18) ; Integer (Android RGB)
		array := hex2Integer(hexadecimal, 4)
    else if (typeNumber = 19) ; Adobe RGB (255)
        array := hex2AdobeRGB(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 20) ; Adobe RGB (100)
        array := hex2AdobeRGB(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 21) ; Adobe RGB (1)
        array := hex2AdobeRGB(hexadecimal, 3, precisionFlag)
    else if (typeNumber = 22) ; HSL (360, 100, 100)
        array := hex2HSL(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 23) ; HSL (360, 1, 1)
        array := hex2HSL(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 24) ; HSL (255)
        array := hex2HSL(hexadecimal, 3, precisionFlag)
    else if (typeNumber = 25) ; HSL (240)
        array := hex2HSL(hexadecimal, 4, precisionFlag)
    else if (typeNumber = 26) ; HSL (1)
        array := hex2HSL(hexadecimal, 5, precisionFlag)
    else if (typeNumber = 27) ; HSV/B (360, 100, 100)
        array := hex2HSVB(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 28) ; HSV/B (360, 1, 1)
        array := hex2HSVB(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 29) ; HSV/B (1)
        array := hex2HSVB(hexadecimal, 3, precisionFlag)
    else if (typeNumber = 30) ; HWB (360, 100, 100)
        array := hex2HWB(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 31) ; HWB (360, 1, 1)
        array := hex2HWB(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 32) ; HWB (1)
        array := hex2HWB(hexadecimal, 3, precisionFlag)
    else if (typeNumber = 33) ; HSI (360, 100, 255)
        array := hex2HSI(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 34) ; HSI (360, 1, 255)
        array := hex2HSI(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 35) ; HSI (360, 1, 1)
        array := hex2HSI(hexadecimal, 3, precisionFlag)
    else if (typeNumber = 36) ; HSI (1)
        array := hex2HSI(hexadecimal, 4, precisionFlag)
    else if (typeNumber = 37) ; CMYK (100)
        array := hex2CMYK(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 38) ; CMYK (1)
        array := hex2CMYK(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 39) ; CMY (100)
        array := hex2CMY(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 40) ; CMY (1)
        array := hex2CMY(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 41) ; Delphi
        array := hex2HexOtherFormat(hexadecimal, 2, "$")
    else if (typeNumber = 42) ; XYZ
        array := hex2XYZ(hexadecimal, precisionFlag)
    else if (typeNumber = 43) ; Yxy
        array := hex2Yxy(hexadecimal, precisionFlag)
    else if (typeNumber = 44) ; CIELab
        array := hex2CIELab(hexadecimal, precisionFlag)
    else if (typeNumber = 45) ; CIELChab
        array := hex2CIELChab(hexadecimal, precisionFlag)
    else if (typeNumber = 46) ; CIELShab
        array := hex2CIELShab(hexadecimal, precisionFlag)
    else if (typeNumber = 47) ; CIELuv
        array := hex2CIELuv(hexadecimal, precisionFlag)
    else if (typeNumber = 48) ; CIELChuv
        array := hex2CIELChuv(hexadecimal, precisionFlag)
    else if (typeNumber = 49) ; CIELShuv
        array := hex2CIELShuv(hexadecimal, precisionFlag)
    else if (typeNumber = 50) ; Hunter Lab
        array := hex2HunterLab(hexadecimal, precisionFlag)
    else if (typeNumber = 51) ; YUV (255)
        array := hex2YUV(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 52) ; YUV (1)
        array := hex2YUV(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 53) ; YCbCr (HD)
        array := hex2YCbCr(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 54) ; YCbCr (FD)
        array := hex2YCbCr(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 55) ; YCbCr (SD)
        array := hex2YCbCr(hexadecimal, 3, precisionFlag)
    else if (typeNumber = 56) ; YPbPr (HD)
        array := hex2YPbPr(hexadecimal, 1, precisionFlag)
    else if (typeNumber = 57) ; YPbPr (SD)
        array := hex2YPbPr(hexadecimal, 2, precisionFlag)
    else if (typeNumber = 58) ; YCxCz
        array := hex2YCxCz(hexadecimal, precisionFlag)
    else if (typeNumber = 59) ; YCoCg
        array := hex2YCoCg(hexadecimal, precisionFlag)

    return array
}

; This function below allows us to convert any value to hexadecimal using a number instead of the function name
; First argument is a variable of whatever type of value you have -- it can be a normal variable or an array
; Second argument is the number of the color format of the variable you are sending in to the function
; To get the number of the color format, look at the comments throughout the function below
number2Hex(variable, typeNumber)
{
	if (typeNumber = 1) ; HTML
		array := hexOtherFormat2Hex(variable, 1, "#")
	else if (typeNumber = 2) ; Hex (RGB)
		array := hexOtherFormat2Hex(variable, 1, "0x")
	else if (typeNumber = 3) ; RGB (255)
		array := RGB2Hex(variable[1], variable[2], variable[3], 1)
	else if (typeNumber = 4) ; RGB (100)
		array := RGB2Hex(variable[1], variable[2], variable[3], 2)
	else if (typeNumber = 5) ; RGB (1)
		array := RGB2Hex(variable[1], variable[2], variable[3], 3)
	else if (typeNumber = 6) ; Integer (RGB)
		array := integer2Hex(variable, 1)
	else if (typeNumber = 7) ; Hex (BGR)
		array := hexOtherFormat2Hex(variable, 2, "0x")
	else if (typeNumber = 8) ; BGR (255)
		array := BGR2Hex(variable[1], variable[2], variable[3], 1)
	else if (typeNumber = 9) ; BGR (100)
		array := BGR2Hex(variable[1], variable[2], variable[3], 2)
	else if (typeNumber = 10) ; BGR (1)
		array := BGR2Hex(variable[1], variable[2], variable[3], 3)
	else if (typeNumber = 11) ; Integer (BGR)
		array := integer2Hex(variable, 2)
	else if (typeNumber = 12) ; Hex (RYB)
		array := hexOtherFormat2Hex(variable, 3, "0x")
	else if (typeNumber = 13) ; RYB (255)
		array := RYB2Hex(variable[1], variable[2], variable[3], 1)
	else if (typeNumber = 14) ; RYB (100)
		array := RYB2Hex(variable[1], variable[2], variable[3], 2)
	else if (typeNumber = 15) ; RYB (1)
		array := RYB2Hex(variable[1], variable[2], variable[3], 3)
	else if (typeNumber = 16) ; Integer (RYB)
		array := integer2Hex(variable, 3)
	else if (typeNumber = 17) ; Hex (Android RGB)
		array := hexOtherFormat2Hex(variable, 4, "0x")
	else if (typeNumber = 18) ; Integer (Android RGB)
		array := integer2Hex(variable, 4)
    else if (typeNumber = 19) ; Adobe RGB (255)
        array := AdobeRGB2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 20) ; Adobe RGB (100)
        array := AdobeRGB2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 21) ; Adobe RGB (1)
        array := AdobeRGB2Hex(variable[1], variable[2], variable[3], 3)
    else if (typeNumber = 22) ; HSL (360, 100, 100)
        array := HSL2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 23) ; HSL (360, 1, 1)
        array := HSL2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 24) ; HSL (255)
        array := HSL2Hex(variable[1], variable[2], variable[3], 3)
    else if (typeNumber = 25) ; HSL (240)
        array := HSL2Hex(variable[1], variable[2], variable[3], 4)
    else if (typeNumber = 26) ; HSL (1)
        array := HSL2Hex(variable[1], variable[2], variable[3], 5)
    else if (typeNumber = 27) ; HSV/B (360, 100, 100)
        array := HSVB2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 28) ; HSV/B (360, 1, 1)
        array := HSVB2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 29) ; HSV/B (1)
        array := HSVB2Hex(variable[1], variable[2], variable[3], 3)
    else if (typeNumber = 30) ; HWB (360, 100, 100)
        array := HWB2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 31) ; HWB (360, 1, 1)
        array := HWB2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 32) ; HWB (1)
        array := HWB2Hex(variable[1], variable[2], variable[3], 3)
    else if (typeNumber = 33) ; HSI (360, 100, 255)
        array := HSI2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 34) ; HSI (360, 1, 255)
        array := HSI2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 35) ; HSI (360, 1, 1)
        array := HSI2Hex(variable[1], variable[2], variable[3], 3)
    else if (typeNumber = 36) ; HSI (1)
        array := HSI2Hex(variable[1], variable[2], variable[3], 4)
    else if (typeNumber = 37) ; CMYK (100)
        array := CMYK2Hex(variable[1], variable[2], variable[3], variable[4], 1)
    else if (typeNumber = 38) ; CMYK (1)
        array := CMYK2Hex(variable[1], variable[2], variable[3], variable[4], 2)
    else if (typeNumber = 39) ; CMY (100)
        array := CMY2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 40) ; CMY (1)
        array := CMY2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 41) ; Delphi
        array := hexOtherFormat2Hex(variable, 2, "$")
    else if (typeNumber = 42) ; XYZ
        array := XYZ2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 43) ; Yxy
        array := Yxy2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 44) ; CIELab
        array := CIELab2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 45) ; CIELChab
        array := CIELChab2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 46) ; CIELShab
        array := CIELShab2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 47) ; CIELuv
        array := CIELuv2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 48) ; CIELChuv
        array := CIELChuv2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 49) ; CIELShuv
        array := CIELShuv2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 50) ; Hunter Lab
        array := HunterLab2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 51) ; YUV (255)
        array := YUV2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 52) ; YUV (1)
        array := YUV2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 53) ; YCbCr (HD)
        array := YCbCr2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 54) ; YCbCr (FD)
        array := YCbCr2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 55) ; YCbCr (SD)
        array := YCbCr2Hex(variable[1], variable[2], variable[3], 3)
    else if (typeNumber = 56) ; YPbPr (HD)
        array := YPbPr2Hex(variable[1], variable[2], variable[3], 1)
    else if (typeNumber = 57) ; YPbPr (SD)
        array := YPbPr2Hex(variable[1], variable[2], variable[3], 2)
    else if (typeNumber = 58) ; YCxCz
        array := YCxCz2Hex(variable[1], variable[2], variable[3])
    else if (typeNumber = 59) ; YCoCg
        array := YCoCg2Hex(variable[1], variable[2], variable[3])

    return array
}

; This function formats all of the conversion arrays into formatted text
; The function also adds parenthesis and commas to arrays greater than length 1
arrayToText(array)
{
    if (array.Length() = 1)
        return array[1]

    expression := "("
    loop, % array.Length() - 1
        expression .= array[a_index] . ", "
    expression .= array[array.Length()] . ")"
    return expression
}

; This function determines the appropriate contrasting color
; Input: Hexadecimal value
; Output: Black or white contrasting color
; typeNumber refers to the desired output format (see the conversionNumber() function above)
contrastFinder(hexadecimal, typeNumber)
{
    rgbArray := hex2RGB(hexadecimal, 3, "x")

	red := rgbArray[1]
	if (red <= 0.03928)
		red := red / 12.92
	else
		red := ((red + 0.055) / 1.055) ** 2.4

	green := rgbArray[2]
	if (green <= 0.03928)
		green := green / 12.92
	else
		green := ((green + 0.055) / 1.055) ** 2.4

	blue := rgbArray[3]
	if (blue <= 0.03928)
		blue := blue / 12.92
	else
		blue := ((blue + 0.055) / 1.055) ** 2.4

	luminance := 0.2126 * red + 0.7152 * green + 0.0722 * blue

	if (luminance > 0.179)
		return hex2Number(0x000000, typeNumber, "x")
	else
		return hex2Number(0xFFFFFF, typeNumber, "x")
}

global listFormats := ["HTML", "Hex (RGB)", "RGB (255)", "RGB (100)", "RGB (1)", "Integer (RGB)", "Hex (BGR)", "BGR (255)", "BGR (100)", "BGR (1)", "Integer (BGR)", "Hex (RYB)", "RYB (255)", "RYB (100)", "RYB (1)", "Integer (RYB)", "Hex (Android RGB)", "Integer (Android RGB)", "Adobe RGB (255)", "Adobe RGB (100)", "Adobe RGB (1)", "HSL (360, 100, 100)", "HSL (360, 1, 1)", "HSL (255)", "HSL (240)", "HSL (1)", "HSV/B (360, 100, 100)", "HSV/B (360, 1, 1)", "HSV/B (1)", "HWB (360, 100, 100)", "HWB (360, 1, 1)", "HWB (1)", "HSI (360, 100, 255)", "HSI (360, 1, 255)", "HSI (360, 1, 1)", "HSI (1)", "CMYK (100)", "CMYK (1)", "CMY (100)", "CMY (1)", "Delphi", "XYZ", "Yxy", "CIELab", "CIELChab", "CIELShab", "CIELuv", "CIELChuv", "CIELShuv", "Hunter Lab", "YUV (255)", "YUV (1)", "YCbCr (HD)", "YCbCr (FD)", "YCbCr (SD)", "YPbPr (HD)", "YPbPr (SD)", "YCxCz", "YCoCg"]

; DEBUG
; loop, 59
;    OutputDebug, % listFormats[a_index] . ":   " . colorString("0xABCDEF", a_index, "x")

/* References:
RYB: https://web.archive.org/web/20130525061042/www.insanit.net/tag/rgb-to-ryb/
HWB: https://en.wikipedia.org/wiki/HWB_color_model
Hex2HSI: http://eng.usf.edu/~hady/courses/cap5400/rgb-to-hsi.pdf
HSI2Hex: https://www.youtube.com/watch?v=EsKEOhZs_GI
CIELShab/CIELShuv: https://en.wikipedia.org/wiki/Colorfulness
YUV: https://web.archive.org/web/20180421030430/http://www.equasys.de/colorconversion.html
YCxCz: https://engineering.purdue.edu/~bouman/software/YCxCz/pdf/ColorFidelityMetrics.pdf
YCoCg: https://en.wikipedia.org/wiki/
Many others: http://www.easyrgb.com/en/math.php and http://www.brucelindbloom.com/index.html?Equations.html
Contrasting: https://stackoverflow.com/questions/3942878/how-to-decide-font-color-in-white-or-black-depending-on-background-color
*/
