`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// National University of Singapore
// Department of Electrical and Computer Engineering
// EE2026 Digital Design
// AY1819 Semester 1
// Project: Voice Scope
//////////////////////////////////////////////////////////////////////////////////

module Voice_Scope_TOP(
    input CLK,
    
    input  J_MIC3_Pin3,   // PmodMIC3 audio input data (serial)
    output J_MIC3_Pin1,   // PmodMIC3 chip select, 20kHz sampling clock
    output J_MIC3_Pin4,   // PmodMIC3 serial clock (generated by module VoiceCapturer.v)
    
    //output J_DA2_Pin1,    // PmodDA2 sampling clock (generated by module DA2RefComp.vhd)
    //output J_DA2_Pin2,    // PmodDA2 Data_A, 12-bit speaker output (generated by module DA2RefComp.vhd)
    //output J_DA2_Pin3,    // PmodDA2 Data_B, not used (generated by module DA2RefComp.vhd)
    //output J_DA2_Pin4,    // PmodDA2 serial clock, 50MHz clock
    
    output [3:0] VGA_RED,    // RGB outputs to VGA connector (4 bits per channel gives 4096 possible colors)
    output [3:0] VGA_GREEN,
    output [3:0] VGA_BLUE,
    
    output VGA_VS,          // horizontal & vertical sync outputs to VGA connector
    output VGA_HS,
    
    output [11:0] MIC_IN_LEDS,
    input SW
    );
    
    
// Please create a clock divider module to generate 20kHz and 10Hz clock signals. 
// Instantiate it below
    wire clk_20k;
    wire clk_10;
    
    clk_div clk_div_01(.CLK(CLK), .CLK_DIVIDER(2499), .SLOW_CLK(clk_20k));
    clk_div clk_div_02(.CLK(CLK), .CLK_DIVIDER(9999999), .SLOW_CLK(clk_10));
    
// Instantiate test wave generator
    wire [9:0] Test_Wave;
    
    TestWave_Gen testwave_gen_01(.CLK_20K(clk_20k), .RAMP_WAVE(Test_Wave));
    
    
// Please instantiate the voice capturer module below
    wire [11:0] MIC_in;
    
    VOICE_CAPTURER voice_capturer_01(.CLK(CLK), .cs(clk_20k), .MISO(J_MIC3_Pin3),
        .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(MIC_in));
    assign MIC_IN_LEDS = MIC_in;
     
 // Instantiate multiplexer to select waveform
    wire [11:0] wave_sample;
 
    Select_Waveform waveform_mux_01(.SW(SW), .Test_Wave(Test_Wave), .MIC_in(MIC_in),
        .wave_sample(wave_sample));
    
    
// Please instantiate the waveform drawer module below
    wire [11:0] VGA_HORZ_COORD;
    wire [11:0] VGA_VERT_COORD; 
    
    wire [3:0] R_wave;
    wire [3:0] G_wave;
    wire [3:0] B_wave;
    
    wire clk_sample;
    wire clk_display;
    
    
    //instantiate TestWave_Gen
    TestWave_Gen generate_wave(clk_20k,Test_Wave);
    
    
    //instantiate Draw_Waveform
    Draw_Waveform waveform(clk_20k, wave_sample, VGA_HORZ_COORD, VGA_VERT_COORD, R_wave, G_wave, B_wave);
    
    
    
    
// Please instantiate the background drawing module below   
    wire [3:0] R_grid;
    wire [3:0] G_grid;
    wire [3:0] B_grid;
    
    //instantiate Draw_Background
    Draw_Background background(VGA_HORZ_COORD, VGA_VERT_COORD, R_grid, G_grid, B_grid);
    
    
// Please instantiate the VGA display module below

    VGA_DISPLAY VGA_DISPLAY(CLK,R_wave,G_wave,B_wave, R_grid, G_grid, B_grid, VGA_HORZ_COORD, VGA_VERT_COORD, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_VS, VGA_HS);
                    
                    
endmodule
