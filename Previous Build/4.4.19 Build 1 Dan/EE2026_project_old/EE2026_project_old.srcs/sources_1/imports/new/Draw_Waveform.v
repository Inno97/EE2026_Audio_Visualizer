`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// You may study and modify the code inside this module to imporve the display feature or introduce other features
//////////////////////////////////////////////////////////////////////////////////

module Draw_Waveform(
    input clk_sample, //20kHz clock
    input SW0,
    input [9:0] wave_sample,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    input [11:0] colour,
    output [3:0] VGA_Red_waveform,
    output [3:0] VGA_Green_waveform,
    output [3:0] VGA_Blue_waveform
    );
    
    //The Sample_Memory represents the memory array used to store the voice samples.
    //There are 1280 points and each point can range from 0 to 1023. 
    reg [9:0] Sample_Memory[1279:0];
    reg [10:0] i = 0;
    reg [9:0] ramp_count;
    
    //Each wave_sample is displayed on the screen from left to right. 
    always @ (posedge clk_sample) begin
        i = (i==1279) ? 0 : i + 1;
        ramp_count = (ramp_count >= 639) ? 0 : ramp_count + 1;
        Sample_Memory[i] <= (SW0 == 1) ? wave_sample : ramp_count;              
    end
     
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;
    
    assign red = colour >> 8;
    assign green = colour << 4 >> 8;
    assign blue = colour << 8 >> 8;
    
    assign VGA_Red_waveform =   ((VGA_HORZ_COORD < 1280) && (VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]))) ? red : 0;
    assign VGA_Green_waveform = ((VGA_HORZ_COORD < 1280) && (VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]))) ? green : 0;
    assign VGA_Blue_waveform =  ((VGA_HORZ_COORD < 1280) && (VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]))) ? blue : 0 ;

    
endmodule

