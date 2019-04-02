//output vending is state TOT

module vendingmachine(clock,reset,inpco,vending,state);

//input n output
input clock;
input reset;
input [3:0] inpco;

output [2:0] vending;
output [1:0] state;

reg [2:0] vending;

//inpco
parameter [3:0] IN050=4'b0001;
parameter [3:0] IN100=4'b0010;
parameter [3:0] COFFEE=4'b0100;
parameter [3:0] RETBUT=4'b1000;

//output vending
parameter [2:0] IDLE=3'b000;
parameter [2:0] PASS=3'b001;
parameter [2:0] VENCOF=3'b010;
parameter [2:0] RETWON=3'b100;

//state
parameter [1:0] HAV000=2'b00;
parameter [1:0] HAV050=2'b01;
parameter [1:0] HAV100=2'b10;
parameter [1:0] HAV150=2'b11;

reg [1:0] state, next_state;
//reg PASS, IDLE, VENCOF, RETWON;

//machine state
always @(state or inpco)
  begin
    next_state=HAV000;
      case(state)
        HAV000: case(inpco)
                  IN050: next_state=HAV050;
                  IN100: next_state=HAV100;
                  COFFEE: next_state=HAV000;
                  RETBUT: next_state=HAV000;
                  //default: next_state=HAV000;
                endcase
        HAV050: case(inpco) 
                  IN050: next_state=HAV100;
                  IN100: next_state=HAV150;
                  COFFEE: next_state=HAV050;
                  RETBUT: next_state=HAV000;
                  //default: next_state=HAV000;
                endcase
        HAV100: case(inpco) 
                  IN050: next_state=HAV100;
                  IN100: next_state=HAV100;
                  COFFEE: next_state=HAV000;
                  RETBUT: next_state=HAV000;
                  //default: next_state=HAV000;
                endcase
        HAV150: case(inpco) 
                  IN050: next_state=HAV150;
                  IN100: next_state=HAV150;
                  COFFEE: next_state=HAV000;
                  RETBUT: next_state=HAV000;
                  //default: next_state=HAV000;
                endcase
        //default: next_state=HAV000;
      endcase
  end

//machine clock
always @(posedge clock or negedge reset)
    if(!reset) begin
      state <= HAV000;
      vending <= IDLE;
      end
      else state <= next_state;

//machine output
always @(posedge clock)//state or inpco)
      case (state)
          HAV000: vending <= IDLE;
          HAV050: case(inpco)
                    IN050:
                        vending <= IDLE;
                    IN100:
                        vending <= IDLE;
                    COFFEE:
                        vending <= IDLE;
                    RETBUT:
                        vending <= RETWON;
                  endcase
          HAV100: case(inpco)
                    IN050:
                        vending <= PASS;
                    IN100:
                        vending <= PASS;
                    COFFEE:
                        vending <= VENCOF;
                    RETBUT:
                        vending <= RETWON;
                  endcase
          HAV150: case(inpco)
                    IN050:
                        vending <= PASS;
                    IN100:
                        vending <= PASS;
                    COFFEE:
                        vending <= VENCOF;
                    RETBUT:
                        vending <= RETWON;
                  endcase
        endcase

endmodule
