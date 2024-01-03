module alarmClock_top(
	input        clk,
	input  [9:0] switches,
	input        pause,
	input        reset,
	output [7:0] segs [0:5],
	output       buzzerEnable
);
	
	wire divClk;
	wire flashClk;

	clockDivider clockCD(clk, switches[0] ? 100 : 200, ~reset, divClk);
	clockDivider buzzerCD(clk, 420, ~reset, buzzerClk);
	clockDivider flashCD(clk, 1, ~reset, flashClk);
	
	wire [15:0] timeRemaining;
	wire beepState;
	
	assign buzzerEnable = beepState & buzzerClk;
    assign displayEnable = !beepState | flashClk;
	
	alarmClockController ac(
        clk,
		divClk,
	    switches[9:1],
		~pause,
        ~reset,
		timeRemaining,
		beepState
    );
	
	sevenSegDisp disp(timeRemaining, displayEnable, segs);
endmodule
