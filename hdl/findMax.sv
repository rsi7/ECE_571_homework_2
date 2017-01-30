// Module: findMax.sv
// Author: Rehan Iqbal
// Date: January 30, 2017
// Company: Portland State University
//
// Description:
// ------------
// Takes in a sequence of unsigned bytes and determines the largest & smallest
// values that were sent. Implemented with a three-block finite state machine.
//
///////////////////////////////////////////////////////////////////////////////

module findMax (

	/*************************************************************************/
	/* Top-level port declarations											 */
	/*************************************************************************/

	input	logic						clk,		// clock signal to the circuit
	input 	logic						reset,		// assert high to reset the circuit
	input	logic						start,		// assert high to start data input

	input	logic	unsigned	[7:0]	inputA,		// data bytes to be considered

	output	logic	unsigned	[7:0]	maxValue,	// current max value of the sequence
	output	logic						done		// goes high when final value determined

	);

	/*************************************************************************/
	/* Local parameters and variables										 */
	/*************************************************************************/

	localparam	IDLE		=	2'b00;		// state: FSM is waiting for start signal
	localparam	RECEIVING	=	2'b01;		// state: FSM is receing data
	localparam	DONE		=	2'b10;		// state: FSM has finished processing data

	logic		[1:0]		state;			// register to hold current FSM state
	logic		[1:0]		next;			// register to hold pending FSM state

	/*************************************************************************/
	/* FSM Block 1: reset & state advancement								 */
	/*************************************************************************/

	always@(posedge clk or posedge reset) begin

		// reset the FSM to idle state
		if (reset) begin
			state <= IDLE;
		end

		// otherwise, advance the state
		else begin
			state <= next;
		end

	end

	/*************************************************************************/
	/* FSM Block 2: state transistions								 		 */
	/*************************************************************************/

	always@(posedge clk or posedge reset) begin

		// default state assignment
		// if case statement fails

		next = 4'bx;

		case (state)

			// check if start was asserted
			// if so, FSM is receiving data
			// otherwise, keep idle

			IDLE : begin
				if (start) next = RECEIVING;
				else next = IDLE;
			end

			// check if start was de-asserted
			// if so, move to DONE state
			// otherwise, still receiving data

			RECEIVING : begin
				if (!start) next = DONE;
				else next = RECEIVING;
			end

			// final results only last 1 cycle
			DONE : next = IDLE;

		endcase
	end

	/*************************************************************************/
	/* FSM Block 3: assigning outputs										 */
	/*************************************************************************/

	always@(posedge clk or negedge reset) begin

		// if reset was asserted, set outputs to zero
		if (reset) begin
			maxValue	<= 8'b0;
			done		<= 1'b0;
		end

		else begin

			case(next)

				// check if starting to receive data
				// if so, update maxValue - otherwise, keep at zero

				IDLE : begin

					if (start) maxValue <= inputA;
					else maxValue <= 8'b0;

					done <= 1'b0;
				end

				// compare current maxValue against new data input
				// update if needed - retain previous value otherwise

				RECEIVING : begin

					if (inputA > maxValue) begin
						maxValue <= inputA;
					end

					else begin
						maxValue <= maxValue;
					end

					done <= 1'b0;
				end

				// set done flag high to indicate processing finished
				DONE : begin
					maxValue <= maxValue;
					done <= 1'b1;
				end

			endcase	
		end
	end

endmodule