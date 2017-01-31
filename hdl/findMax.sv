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

`include "definitions.pkg"

module findMax (

	/*************************************************************************/
	/* Top-level port declarations											 */
	/*************************************************************************/

	input	ulogic1			clk,		// clock signal to the circuit
	input 	ulogic1			reset,		// assert high to reset the circuit
	input	ulogic1			start,		// assert high to start data input

	input	ulogic8			inputA,		// data bytes to be considered

	output	ulogic8			maxValue,	// current max value of the sequence
	output	ulogic8			minValue,	// current min value of the sequence
	output	ulogic1			done		// goes high when final value determined

	);

	/*************************************************************************/
	/* Local parameters and variables										 */
	/*************************************************************************/

	ulogic2		[1:0]		state;		// register to hold current FSM state
	ulogic2		[1:0]		next;		// register to hold pending FSM state

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
	/* FSM Block 2: state transistions										 */
	/*************************************************************************/

	always@(posedge clk or posedge reset) begin

		case (state)

			// check if start was asserted
			// if so, FSM is receiving data
			// otherwise, keep idle

			IDLE : begin
				if (start) next <= RECEIVING;
				else next <= IDLE;
			end

			// check if start was de-asserted
			// if so, move to DONE state
			// otherwise, still receiving data

			RECEIVING : begin
				if (!start) next <= DONE;
				else next <= RECEIVING;
			end

			// final results only last 1 cycle
			DONE : next <= IDLE;

			// set next state to unknown if case statement fails
			default : next <= 2'bx;

		endcase
	end

	/*************************************************************************/
	/* FSM Block 3: assigning outputs										 */
	/*************************************************************************/

	always@(posedge clk or negedge reset) begin

		// if reset was asserted, clear the outputs
		if (reset) begin
			maxValue	<= 8'b0;
			minValue	<= 8'd255;
			done		<= 1'b0;
		end

		else begin

			case(next)

				// check if starting to receive data
				// if so, update maxValue & minValue

				IDLE : begin

					if (start) begin
						maxValue <= inputA;
						minValue <= inputA;
					end

					else begin
						maxValue <= 8'b0;
						minValue <= 8'd255;
					end

					done <= 1'b0;
				end

				// compare current maxValue against new data input
				// update if needed - retain previous value otherwise

				RECEIVING : begin

					if (inputA > maxValue) begin
						maxValue <= inputA;
					end

					else if (inputA < minValue) begin
						minValue <= inputA;
					end

					else begin
						maxValue <= maxValue;
						minValue <= minValue;
					end

					done <= 1'b0;
				end

				// set done flag high to indicate processing finished
				DONE : begin
					maxValue <= maxValue;
					minValue <= minValue;
					done <= 1'b1;
				end

				// set outputs to unknown if case statement fails
				default : begin
					maxValue <= 8'bx;
					minValue <= 8'bx;
					done <= 1'bx;
				end
			endcase	
		end
	end

endmodule