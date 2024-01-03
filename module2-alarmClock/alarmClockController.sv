module alarmClockController(
	input             mainClk,
	input             timeClk,
	input      [8:0]  switches,
	input             pauseResume,
	input             reset,
	output reg [15:0] timeRemaining,
	output            shouldBeep
);

	
	localparam SET = 2'b00;
	localparam RUN = 2'b01;
	localparam PAUSE = 2'b10;
	localparam BEEP = 2'b11;
	
	reg [1:0] state = SET;
	reg [1:0] next_state;
	
	assign shouldBeep = state == BEEP;
	
	reg [21:0] timeRemaining_d;
	
	reg [1:0] timeClk_sr;
	reg [1:0] pauseResume_sr;
	reg [1:0] reset_sr;
	
	always @(posedge mainClk) begin
		timeClk_sr <= {timeClk_sr[0], timeClk};
		pauseResume_sr <= {pauseResume_sr[0], pauseResume};
		reset_sr <= {reset_sr[0], reset};
		
		state <= next_state;
		timeRemaining <= timeRemaining_d;
	end
	
	always_comb begin
		case (state)
			SET: begin
				if (pauseResume_sr == 2'b01) next_state = RUN;
				else next_state = SET;
				
				timeRemaining_d = switches * 100;
			end
			RUN: begin
				if (pauseResume_sr == 2'b01) next_state = PAUSE;
				else if (reset_sr == 2'b01) next_state = SET;
				else if (timeRemaining == 0) next_state = BEEP;
				else next_state = RUN;
				
				if (timeClk_sr == 2'b01) timeRemaining_d = timeRemaining - 1;
				else timeRemaining_d = timeRemaining;
			end
			PAUSE: begin
				if (pauseResume_sr == 2'b01) next_state = RUN;
				else if (reset_sr == 2'b01) next_state = SET;
				else next_state = PAUSE;
				
				timeRemaining_d = timeRemaining;
			end
			BEEP: begin
				if (reset_sr == 2'b01) next_state = SET;
				else next_state = BEEP;
				
				timeRemaining_d = 0;
			end
		endcase
	end
endmodule
