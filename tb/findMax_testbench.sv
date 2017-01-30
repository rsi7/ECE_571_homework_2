// Module: findMax_testbench.sv
// Author: Rehan Iqbal
// Date: January 30, 2017
// Company: Portland State University
//
// Description:
// ------------
// Instantiates the device-under-test (findMax) and runs through a series of
// byte sequences. These are randomly generated bytes which range in value from
// 0 to 255. The number of bytes sent varies between 1 & 16.
//
//
//The testbench will run for a user-specified number of trials before ending.
// It will write results to a local textfile specifying the data bytes sent out
// and the maxValue & minValue returned by the DUT.
// 
///////////////////////////////////////////////////////////////////////////////

module findMax_testbench;

	timeunit 1ns;

	/*************************************************************************/
	/* Local parameters and variables										 */
	/*************************************************************************/

	localparam					trials = 10;

	logic 						clk_tb		= 1'b0;		// clock signal to the DUT
	logic 						reset_tb	= 1'b0;		// active-high reset to the DUT
	logic 						start_tb	= 1'b0;		// active-high start signal to the DUT
	logic	unsigned	[7:0]	inputA_tb	= 1'b0;		// data byte inputs to the DUT

	logic	unsigned	[7:0]	maxValue_tb;			// maximum value returned by DUT
	logic 						done_tb;				// active-high completion signal from DUT

	int 						fhandle;				// integer to hold file location
	byte	unsigned			bytes;

	/*************************************************************************/
	/* Instantiating the DUT 												 */
	/*************************************************************************/

	findMax DUT (

		.clk			(clk_tb),			// I [0:0] clock signal to the circuit
		.reset			(reset_tb), 		// I [0:0] assert high to reset the circuit
		.start			(start_tb), 		// I [0:0] assert high to start data input
		.inputA			(inputA_tb),		// I [7:0] data byts to be considered

		.maxValue		(maxValue_tb),		// O [7:0] current max value of the sequence
		.done			(done_tb)			// O [0:0] goes high when final value determined

		);

	/*************************************************************************/
	/* Running the testbench simluation										 */
	/*************************************************************************/

	// keep the clock ticking
	always begin
		#1 clk <= !clk
	end

	// main simulation loop

	initial begin

		// format time units for printing later
		// also setup the output file location

		$timeformat(-9, 0, "ns", 8);
		fhandle = $fopen("C:/Users/riqbal/Desktop/findMax_results.txt");

		// toggle the resets to start the FSM
		#5 reset = 1'b1;
		#5 reset = 1'b0;
		#5

		for (int j = 1; j <= trials; j++) begin

			#5 bytes = $urandom_range(16,1);
			start = 1'b1;

			for (int i = 1; i <= bytes; i++) begin
				#1 inputA_tb = $urandom_range(8'b11111111,8'b0)
				fstrobe(fhandle,"Time:\t%t\t\tinputA: %d\t\tmaxValue: %d\t\t", $time, inputA_tb, maxValue_tb);
			end

			start = 1'b0;

		end

		// print results to file

		end

		// wrap up file writing & finish simulation
		$fwrite(fhandle, "\n\nEND OF FILE");
		$fclose(fhandle);
		$stop;

	end

endmodule