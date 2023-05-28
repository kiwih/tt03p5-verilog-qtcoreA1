`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: New York University
// Engineer: Hammond Pearce
// 
// Last Edited Date: 04/19/2023
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none
module tt_um_kiwih_tt_top(
    input  wire [7:0] ui_in,   // Dedicated inputs
    output wire [7:0] uo_out,  // Dedicated outputs
    input  wire [7:0] uio_in,  // IOs: Input path
    output wire [7:0] uio_out, // IOs: Output path
    output wire [7:0] uio_oe,  // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
    );
    
//wire clk = io_in[0];
wire rst = !rst_n;

wire scan_enable_in = !ui_in[2]; //SPI uses active low
wire proc_enable_in = !ui_in[3]; //SPI uses active low
wire scan_in = ui_in[4];
wire btn_in = ui_in[5];
wire scan_out, halt_out;

wire miso = scan_enable_in ? scan_out :
            proc_enable_in ? halt_out :
            0;

wire [6:0] led_out;

assign uo_out[7] = miso;
assign uo_out[6:0] = led_out;

assign uio_out[7] = scan_out;
assign uio_out[6] = halt_out;
assign uio_out[5:0] = 0; //unused

assign uio_oe[7] = scan_enable_in;
assign uio_oe[6] = proc_enable_in;
assign uio_oe[5:0] = 6'b111111; //set rest to high impedance input (unused)

accumulator_microcontroller #(
    .MEM_SIZE(19)
) 
qtcore
(
    .clk(clk),
    .rst(rst),
    .scan_enable(scan_enable_in),
    .scan_in(scan_in),
    .scan_out(scan_out),
    .proc_en(proc_enable_in),
    .halt(halt_out),
    .btn_in(btn_in),
    .led_out(led_out)
);
endmodule
