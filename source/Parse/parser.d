module Parse.parser;
import std.stdio;
import std.conv: to;
import std.array;
import Parse.token;

Token[] lex(File input) {
    uint row;
    uint col;
    Appender!(Token[]) tokens;

    foreach(line; input.byLine) {
        row++;
        for(size_t i; i < line.length; i++) {
            auto ch = line[i];
            col++;
            
            switch(ch) {
                case ' ':   break;
                case '#':   while(line[i] != '\n' && i < line.length) { i++; col++; } 
                            break;
                case '(':   tokens ~= Token("(", Type.Open,  row, col); break;
                case ')':   tokens ~= Token(")", Type.Close, row, col); break;
                case '\"':  
                            string buffer; 
                            uint column = col;
                            i++; 
                            while(line[i] != '\"' && i < line.length) {
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer, Type.String, row, column);
                            col++;
                            break;
                case '0': case '1': case '2': case '3': case '4': 
                case '5': case '6': case '7': case '8': case '9':
                            string buffer; 
                            uint column = col;
                            while(line[i] != ' ' && line[i] != ')' && line[i] != '#' && i < line.length) {  
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer, Type.Integer, row, column);
                            
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, Type.Close, row, col);    
                            break; 

                default:     
                            string buffer; 
                            uint column = col;
                            while(line[i] != ' ' && line[i] != ')' && line[i] != '#' && i < line.length) {  
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer, Type.Symbol, row, column);
                            
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, Type.Close, row, col);    
                            break; 
            }
        }
    } 

    return tokens.data; 
}
