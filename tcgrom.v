// This module is just a big ROM which allows you to look up the bitmap
//  for a given character.

module tcgrom(
    input [8:0] addr,
    output reg [7:0] data
);
    // A memory is implemented using a case statement 
    always @(addr)
        case (addr)
            // PLAY
            9'h000: data = 8'b00010000; // %   *         %
            9'h001: data = 8'b00011000; // %   **        %
            9'h002: data = 8'b00011100; // %   ***       %
            9'h003: data = 8'b00011110; // %   ****      %
            9'h004: data = 8'b00011110; // %   ****      %
            9'h005: data = 8'b00011100; // %   ***       %
            9'h006: data = 8'b00011000; // %   **        %
            9'h007: data = 8'b00010000; // %   *         %
            
            // PAUSE
            9'h008: data = 8'b00000000; // %             %
            9'h009: data = 8'b11100111; // %   ***  ***  %
            9'h00a: data = 8'b11100111; // %   ***  ***  %
            9'h00b: data = 8'b11100111; // %   ***  ***  %
            9'h00c: data = 8'b11100111; // %   ***  ***  %
            9'h00d: data = 8'b11100111; // %   ***  ***  %
            9'h00e: data = 8'b11100111; // %   ***  ***  %
            9'h00f: data = 8'b11100111; // %   ***  ***  %

            // NEXT
            9'h010: data = 8'b00000000; // %             %
            9'h011: data = 8'b00000100; // %       *     %
            9'h012: data = 8'b00000110; // %       **    %
            9'h013: data = 8'b01111111; // %   *******   %
            9'h014: data = 8'b01111111; // %   *******   %
            9'h015: data = 8'b00000110; // %       **    %
            9'h016: data = 8'b00000100; // %       *     %
            9'h017: data = 8'b00000000; // %             %
            
            // FAST FORWARD
            9'h018: data = 8'b00000000; // %             %
            9'h019: data = 8'b10000000; // %   *         %
            9'h01a: data = 8'b11000100; // %   **   *    %
            9'h01b: data = 8'b11100110; // %   ***  **   %
            9'h01c: data = 8'b11111111; // %   **** ***  %
            9'h01d: data = 8'b11100110; // %   ***  **   %
            9'h01e: data = 8'b11000100; // %   **   *    %
            9'h01f: data = 8'b10000000; // %   *         %
  
            // REWIND
            9'h028: data = 8'b00000000; // %             %
            9'h029: data = 8'b00000001; // %          *  %
            9'h02a: data = 8'b00100011; // %     *   **  %
            9'h02b: data = 8'b01100111; // %    **  ***  %
            9'h02c: data = 8'b11111111; // %   *** ****  %
            9'h02d: data = 8'b01100111; // %    **  ***  %
            9'h02e: data = 8'b00100011; // %     *   **  %
            9'h02f: data = 8'b00000001; // %          *  %
  
            9'h030: data = 8'b01111110; // %   ******    %
            9'h031: data = 8'b01100000; // %   **        %
            9'h032: data = 8'b01100000; // %   **        %
            9'h033: data = 8'b01111000; // %   ****      %
            9'h034: data = 8'b01100000; // %   **        %
            9'h035: data = 8'b01100000; // %   **        %
            9'h036: data = 8'b01111110; // %   ******    %
            9'h037: data = 8'b00000000; // %             %
    
            9'h038: data = 8'b00111100; // %    ****     %
            9'h039: data = 8'b01100110; // %   **  **    %
            9'h03a: data = 8'b01100000; // %   **        %
            9'h03b: data = 8'b01101110; // %   ** ***    %
            9'h03c: data = 8'b01100110; // %   **  **    %
            9'h03d: data = 8'b01100110; // %   **  **    %
            9'h03e: data = 8'b00111100; // %    ****     %
            9'h03f: data = 8'b00000000; // %             %
  
            9'h040: data = 8'b01100110; // %   **  **    %
            9'h041: data = 8'b01100110; // %   **  **    %
            9'h042: data = 8'b01100110; // %   **  **    %
            9'h043: data = 8'b01111110; // %   ******    %
            9'h044: data = 8'b01100110; // %   **  **    %
            9'h045: data = 8'b01100110; // %   **  **    %
            9'h046: data = 8'b01100110; // %   **  **    %
            9'h047: data = 8'b00000000; // %             %
  
            9'h048: data = 8'b00111100; // %    ****     %
            9'h049: data = 8'b00011000; // %     **      %
            9'h04a: data = 8'b00011000; // %     **      %
            9'h04b: data = 8'b00011000; // %     **      %
            9'h04c: data = 8'b00011000; // %     **      %
            9'h04d: data = 8'b00011000; // %     **      %
            9'h04e: data = 8'b00111100; // %    ****     %
            9'h04f: data = 8'b00000000; // %             %
  
            9'h0a0: data = 8'b01111110; // %   ******    %
            9'h0a1: data = 8'b00011000; // %     **      %
            9'h0a2: data = 8'b00011000; // %     **      %
            9'h0a3: data = 8'b00011000; // %     **      %
            9'h0a4: data = 8'b00011000; // %     **      %
            9'h0a5: data = 8'b00011000; // %     **      %
            9'h0a6: data = 8'b00011000; // %     **      %
            9'h0a7: data = 8'b00000000; // %             %
    
            9'h0b8: data = 8'b01100011; // %   **   **   %
            9'h0b9: data = 8'b01100011; // %   **   **   %
            9'h0ba: data = 8'b01100011; // %   **   **   %
            9'h0bb: data = 8'b01101011; // %   ** * **   %
            9'h0bc: data = 8'b01111111; // %   *******   %
            9'h0bd: data = 8'b01110111; // %   *** ***   %
            9'h0be: data = 8'b01100011; // %   **   **   %
            9'h0bf: data = 8'b00000000; // %             %
  
  
            9'h100: data = 8'b00000000; // %             %
            9'h101: data = 8'b00000000; // %             %
            9'h102: data = 8'b00000000; // %             %
            9'h103: data = 8'b00000000; // %             %
            9'h104: data = 8'b00000000; // %             %
            9'h105: data = 8'b00000000; // %             %
            9'h106: data = 8'b00000000; // %             %
            9'h107: data = 8'b00000000; // %             %
  
            9'h108: data = 8'b00011000; // %     **      %
            9'h109: data = 8'b00011000; // %     **      %
            9'h10a: data = 8'b00011000; // %     **      %
            9'h10b: data = 8'b00011000; // %     **      %
            9'h10c: data = 8'b00000000; // %             %
            9'h10d: data = 8'b00000000; // %             %
            9'h10e: data = 8'b00011000; // %     **      %
            9'h10f: data = 8'b00000000; // %             %
  
            9'h110: data = 8'b01100110; // %   **  **    %
            9'h111: data = 8'b01100110; // %   **  **    %
            9'h112: data = 8'b01100110; // %   **  **    %
            9'h113: data = 8'b00000000; // %             %
            9'h114: data = 8'b00000000; // %             %
            9'h115: data = 8'b00000000; // %             %
            9'h116: data = 8'b00000000; // %             %
            9'h117: data = 8'b00000000; // %             %
  
            9'h118: data = 8'b01100110; // %   **  **    %
            9'h119: data = 8'b01100110; // %   **  **    %
            9'h11a: data = 8'b11111111; // %  ********   %
            9'h11b: data = 8'b01100110; // %   **  **    %
            9'h11c: data = 8'b11111111; // %  ********   %
            9'h11d: data = 8'b01100110; // %   **  **    %
            9'h11e: data = 8'b01100110; // %   **  **    %
            9'h11f: data = 8'b00000000; // %             %
  
            9'h120: data = 8'b00011000; // %     **      %
            9'h121: data = 8'b00111110; // %    *****    %
            9'h122: data = 8'b01100000; // %   **        %
            9'h123: data = 8'b00111100; // %    ****     %
            9'h124: data = 8'b00000110; // %       **    %
            9'h125: data = 8'b01111100; // %   *****     %
            9'h126: data = 8'b00011000; // %     **      %
            9'h127: data = 8'b00000000; // %             %
  
            9'h128: data = 8'b01100010; // %   **   *    %
            9'h129: data = 8'b01100110; // %   **  **    %
            9'h12a: data = 8'b00001100; // %      **     %
            9'h12b: data = 8'b00011000; // %     **      %
            9'h12c: data = 8'b00110000; // %    **       %
            9'h12d: data = 8'b01100110; // %   **  **    %
            9'h12e: data = 8'b01000110; // %   *   **    %
            9'h12f: data = 8'b00000000; // %             %
  
            9'h130: data = 8'b00111100; // %    ****     %
            9'h131: data = 8'b01100110; // %   **  **    %
            9'h132: data = 8'b00111100; // %    ****     %
            9'h133: data = 8'b00111000; // %    ***      %
            9'h134: data = 8'b01100111; // %   **  ***   %
            9'h135: data = 8'b01100110; // %   **  **    %
            9'h136: data = 8'b00111111; // %    ******   %
            9'h137: data = 8'b00000000; // %             %
  
            9'h138: data = 8'b00000110; // %       **    %
            9'h139: data = 8'b00001100; // %      **     %
            9'h13a: data = 8'b00011000; // %     **      %
            9'h13b: data = 8'b00000000; // %             %
            9'h13c: data = 8'b00000000; // %             %
            9'h13d: data = 8'b00000000; // %             %
            9'h13e: data = 8'b00000000; // %             %
            9'h13f: data = 8'b00000000; // %             %
  
            9'h140: data = 8'b00001100; // %      **     %
            9'h141: data = 8'b00011000; // %     **      %
            9'h142: data = 8'b00110000; // %    **       %
            9'h143: data = 8'b00110000; // %    **       %
            9'h144: data = 8'b00110000; // %    **       %
            9'h145: data = 8'b00011000; // %     **      %
            9'h146: data = 8'b00001100; // %      **     %
            9'h147: data = 8'b00000000; // %             %
  
            9'h148: data = 8'b00110000; // %    **       %
            9'h149: data = 8'b00011000; // %     **      %
            9'h14a: data = 8'b00001100; // %      **     %
            9'h14b: data = 8'b00001100; // %      **     %
            9'h14c: data = 8'b00001100; // %      **     %
            9'h14d: data = 8'b00011000; // %     **      %
            9'h14e: data = 8'b00110000; // %    **       %
            9'h14f: data = 8'b00000000; // %             %
  
            9'h150: data = 8'b00000000; // %             %
            9'h151: data = 8'b01100110; // %   **  **    %
            9'h152: data = 8'b00111100; // %    ****     %
            9'h153: data = 8'b11111111; // %  ********   %
            9'h154: data = 8'b00111100; // %    ****     %
            9'h155: data = 8'b01100110; // %   **  **    %
            9'h156: data = 8'b00000000; // %             %
            9'h157: data = 8'b00000000; // %             %
  
            9'h158: data = 8'b00000000; // %             %
            9'h159: data = 8'b00011000; // %     **      %
            9'h15a: data = 8'b00011000; // %     **      %
            9'h15b: data = 8'b01111110; // %   ******    %
            9'h15c: data = 8'b00011000; // %     **      %
            9'h15d: data = 8'b00011000; // %     **      %
            9'h15e: data = 8'b00000000; // %             %
            9'h15f: data = 8'b00000000; // %             %
  
            9'h160: data = 8'b00000000; // %             %
            9'h161: data = 8'b00000000; // %             %
            9'h162: data = 8'b00000000; // %             %
            9'h163: data = 8'b00000000; // %             %
            9'h164: data = 8'b00000000; // %             %
            9'h165: data = 8'b00011000; // %     **      %
            9'h166: data = 8'b00011000; // %     **      %
            9'h167: data = 8'b00110000; // %    **       %
  
            9'h168: data = 8'b00000000; // %             %
            9'h169: data = 8'b00000000; // %             %
            9'h16a: data = 8'b00000000; // %             %
            9'h16b: data = 8'b01111110; // %   ******    %
            9'h16c: data = 8'b00000000; // %             %
            9'h16d: data = 8'b00000000; // %             %
            9'h16e: data = 8'b00000000; // %             %
            9'h16f: data = 8'b00000000; // %             %
  
            9'h170: data = 8'b00000000; // %             %
            9'h171: data = 8'b00000000; // %             %
            9'h172: data = 8'b00000000; // %             %
            9'h173: data = 8'b00000000; // %             %
            9'h174: data = 8'b00000000; // %             %
            9'h175: data = 8'b00011000; // %     **      %
            9'h176: data = 8'b00011000; // %     **      %
            9'h177: data = 8'b00000000; // %             %
  
            9'h178: data = 8'b00000000; // %             %
            9'h179: data = 8'b00000011; // %        **   %
            9'h17a: data = 8'b00000110; // %       **    %
            9'h17b: data = 8'b00001100; // %      **     %
            9'h17c: data = 8'b00011000; // %     **      %
            9'h17d: data = 8'b00110000; // %    **       %
            9'h17e: data = 8'b01100000; // %   **        %
            9'h17f: data = 8'b00000000; // %             %
  
            9'h180: data = 8'b00111100; // %    ****     %
            9'h181: data = 8'b01100110; // %   **  **    %
            9'h182: data = 8'b01101110; // %   ** ***    %
            9'h183: data = 8'b01110110; // %   *** **    %
            9'h184: data = 8'b01100110; // %   **  **    %
            9'h185: data = 8'b01100110; // %   **  **    %
            9'h186: data = 8'b00111100; // %    ****     %
            9'h187: data = 8'b00000000; // %             %
  
            9'h188: data = 8'b00011000; // %     **      %
            9'h189: data = 8'b00011000; // %     **    . %
            9'h18a: data = 8'b00111000; // %    ***      %
            9'h18b: data = 8'b00011000; // %     **      %
            9'h18c: data = 8'b00011000; // %     **      %
            9'h18d: data = 8'b00011000; // %     **      %
            9'h18e: data = 8'b01111110; // %   ******    %
            9'h18f: data = 8'b00000000; // %             %
  
            9'h190: data = 8'b00111100; // %    ****     %
            9'h191: data = 8'b01100110; // %   **  **    %
            9'h192: data = 8'b00000110; // %       **    %
            9'h193: data = 8'b00001100; // %      **     %
            9'h194: data = 8'b00110000; // %    **       %
            9'h195: data = 8'b01100000; // %   **        %
            9'h196: data = 8'b01111110; // %   ******    %
            9'h197: data = 8'b00000000; // %             %
  
            9'h198: data = 8'b00111100; // %    ****     %
            9'h199: data = 8'b01100110; // %   **  **    %
            9'h19a: data = 8'b00000110; // %       **    %
            9'h19b: data = 8'b00011100; // %     ***     %
            9'h19c: data = 8'b00000110; // %       **    %
            9'h19d: data = 8'b01100110; // %   **  **    %
            9'h19e: data = 8'b00111100; // %    ****     %
            9'h19f: data = 8'b00000000; // %             %
  
            9'h1a0: data = 8'b00000110; // %       **    %
            9'h1a1: data = 8'b00001110; // %      ***    %
            9'h1a2: data = 8'b00011110; // %     ****    %
            9'h1a3: data = 8'b01100110; // %   **  **    %
            9'h1a4: data = 8'b01111111; // %   *******   %
            9'h1a5: data = 8'b00000110; // %       **    %
            9'h1a6: data = 8'b00000110; // %       **    %
            9'h1a7: data = 8'b00000000; // %             %
  
            9'h1a8: data = 8'b01111110; // %   ******    %
            9'h1a9: data = 8'b01100000; // %   **        %
            9'h1aa: data = 8'b01111100; // %   *****     %
            9'h1ab: data = 8'b00000110; // %       **    %
            9'h1ac: data = 8'b00000110; // %       **    %
            9'h1ad: data = 8'b01100110; // %   **  **    %
            9'h1ae: data = 8'b00111100; // %    ****     %
            9'h1af: data = 8'b00000000; // %             %
  
            9'h1b0: data = 8'b00111100; // %    ****     %
            9'h1b1: data = 8'b01100110; // %   **  **    %
            9'h1b2: data = 8'b01100000; // %   **        %
            9'h1b3: data = 8'b01111100; // %   *****     %
            9'h1b4: data = 8'b01100110; // %   **  **    %
            9'h1b5: data = 8'b01100110; // %   **  **    %
            9'h1b6: data = 8'b00111100; // %    ****     %
            9'h1b7: data = 8'b00000000; // %             %
  
            9'h1b8: data = 8'b01111110; // %   ******    %
            9'h1b9: data = 8'b01100110; // %   **  **    %
            9'h1ba: data = 8'b00001100; // %      **     %
            9'h1bb: data = 8'b00011000; // %     **      %
            9'h1bc: data = 8'b00011000; // %     **      %
            9'h1bd: data = 8'b00011000; // %     **      %
            9'h1be: data = 8'b00011000; // %     **      %
            9'h1bf: data = 8'b00000000; // %             %
  
            9'h1c0: data = 8'b00111100; // %    ****     %
            9'h1c1: data = 8'b01100110; // %   **  **    %
            9'h1c2: data = 8'b01100110; // %   **  **    %
            9'h1c3: data = 8'b00111100; // %    ****     %
            9'h1c4: data = 8'b01100110; // %   **  **    %
            9'h1c5: data = 8'b01100110; // %   **  **    %
            9'h1c6: data = 8'b00111100; // %    ****     %
            9'h1c7: data = 8'b00000000; // %             %
  
            9'h1c8: data = 8'b00111100; // %    ****     %
            9'h1c9: data = 8'b01100110; // %   **  **    %
            9'h1ca: data = 8'b01100110; // %   **  **    %
            9'h1cb: data = 8'b00111110; // %    *****    %
            9'h1cc: data = 8'b00000110; // %       **    %
            9'h1cd: data = 8'b01100110; // %   **  **    %
            9'h1ce: data = 8'b00111100; // %    ****     %
            9'h1cf: data = 8'b00000000; // %             %
        endcase

endmodule
