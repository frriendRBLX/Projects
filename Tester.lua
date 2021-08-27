local Tester = {}

local function Test(NumTrials, Method)
	local Deltas = {}
	
	for i = 0, NumTrials do
		local InitTime = tick()
		Method()
		table.insert(Deltas, tick() - InitTime)
	end
	
	local Result = 0;
	if NumTrials > 0 then
		for _, Delta in ipairs(Deltas) do
			Result += Delta
		end

		Result /= #Deltas
	else
		Result = Deltas[1]
	end
	
	return Result
end

function Tester:RunTest(NumTrials, Method)	
	print(string.format("Running Test.. [%i Tries]", NumTrials))
	local Result = Test(NumTrials, Method)
	print(string.format("\n---------------------------\nTest Completed\n\nAverage Execution Time:\n	%.2f s\n	%i ms\n	%i µs\n---------------------------", Result, Result * 1000, Result * 1000000))
end

function Tester:RunABTest(NumTrials, AMethod, BMethod)
	print(string.format("Running AB Test.. [%i Tries]\n", NumTrials))
	
	print("Running A Test..")
	local AResult = Test(NumTrials, AMethod)
	print("Running B Test..")
	local BResult = Test(NumTrials, BMethod)
	
	print(string.format("\n---------------------------\nAB Test Completed\n\nAverage Execution Time:\n	A: %.2f s\n	| B: %.2f s\n	A: %i ms\n	| B: %i ms\n	A: %i µs\n	| B: %i µs\n---------------------------",
		AResult, BResult, AResult * 1000, BResult * 1000, AResult * 1000000, BResult * 1000000))
end

return Tester
