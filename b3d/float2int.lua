-- function encodes 32-bit floating point number into 32-bit
-- integer with same binary representation.

local i
local big = 2
local small = 0.5
local mask = 1
local powers = {[7] = {big = big, small = small, mask = mask}}

for i = 6, 1, -1 do
	big = big * big
	small = small * small
	mask = mask + mask
	powers[i] = {big = big, small = small, mask = mask}
end

local smallNumMultiplier = 0.5 * big * big
local tinyNum = 8 * small * small

return function (number)
	local negative = number < 0
	local exponent

	if negative then
		negative = -2147483648
		number = -number
	else
		negative = 0
	end

	if number < 8 * small * small then
		return math.floor(number * big * big * 2097152 + 0.5) + negative
	elseif number < 1 then
		number = number * smallNumMultiplier
		exponent = 0
	else
		exponent = 127
	end

	for k, v in ipairs(powers) do
		if number >= v.big then
			number = number * v.small
			exponent = exponent + v.mask
		end
	end

	if number < 2 then
		return math.floor((number - 1) * 8388608 + 0.5)
				 + bit.lshift(exponent, 23) + negative
	else
		return nil, "Number is out of range"
	end
end
