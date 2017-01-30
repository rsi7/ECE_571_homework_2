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

	input	logic			clk,			// clock signal to the circuit
	input 	logic			reset,			// assert high to reset the circuit
	input	logic			start,			// assert high to start data input

	input	logic	[7:0]	inputA,			// data bytes to be considered

	output	logic	[7:0]	maxValue,		// current max value of the sequence
	output					done			// goes high when final value determined

	);

	/*************************************************************************/
	/* Local parameters and variables										 */
	/*************************************************************************/

	localparam	S0	=	4'b0000;
	localparam	S1	=	4'b0001;
	localparam	S2	=	4'b0010;
	localparam	S3	=	4'b0100;
	localparam	S4	=	4'b1000;

	reg		[3:0]		state,
	reg		[3:0]		next;

	/*************************************************************************/
	/* Global Assignments													 */
	/*************************************************************************/


	/*************************************************************************/
	/* FSM Block 1: reset & state advancement								 */
	/*************************************************************************/

	always@(posedge clk or posedge reset) begin

		if (reset) begin
			state <= S0;
		end

		else begin
			state <= next;
		end

	end

	/*************************************************************************/
	/* FSM Block 2: state transistions								 		 */
	/*************************************************************************/

	always@(state or go or jmp) begin

		next 		= 4'bx;

		case (state)
			IDLE : begin
				if (sdfsd) begin
					sdfsd
				end
				else begin
					sdfsd
				end
		endcase
	end



	/*************************************************************************/
	/* FSM Block 3: assigning outputs										 */
	/*************************************************************************/

	always@(posedge clk or negedge reset) begin

		if (reset) begin
			maxValue	<= 8'b0;
			done		<= 1'b1;
		end

		else begin

			case(next)
				S0, S1 :
				S2, S3 :

			endcase
			done	<= 1'b1;
		end
endmodule