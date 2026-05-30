module HazardUnit(
	input RegWriteE,
    input RegWriteM,
    input RegWriteW,
    input [1:0] ResultSrcE,
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input PCSrcE,
    output StallF, StallD, FlushD, FlushE,
    output [1:0] ForwardAE, ForwardBE
);
    wire lwStall; 
    assign ForwardAE = (Rs1E == RdM && RegWriteM && Rs1E != 0) ? 2'b10 : 
                       (Rs1E == RdW && RegWriteW && Rs1E != 0) ? 2'b01 : 2'b00;
    assign ForwardBE = (Rs2E == RdM && RegWriteM && Rs2E != 0) ? 2'b10 : 
                       (Rs2E == RdW && RegWriteW && Rs2E != 0) ? 2'b01 : 2'b00;                       
	assign lwStall = RegWriteE && (ResultSrcE == 2'b00) && (RdE != 5'b0) && (Rs1D == RdE || Rs2D == RdE);
    assign StallF = lwStall;
    assign StallD = lwStall;
    assign FlushD = PCSrcE; 
    assign FlushE = PCSrcE | lwStall;
endmodule