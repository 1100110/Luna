module Parse.parser;
import std.stdio;
import std.conv: to;
import std.array;
import Parse.token;




// assumes complete list
Token[] lex(File input) {
    size_t row;
    size_t col;
    Appender!(Token[]) tokens;

/// Don't Judge me!
NextRow:
    foreach(line; input.byLine) {
        row++;
        col = 0;
/// Ditto
NextColumn:
        for(size_t i; i < line.length; i++) {
            auto ch = line[i];
            col++; 
           
            switch(ch) {
                case ' ':   goto NextColumn;
                case ';':   goto NextRow;
                case '(':   tokens ~= Token("(", Type.Open,  row, col); break;
                case ')':   tokens ~= Token(")", Type.Close, row, col); break;
                case '\"':  
                            Appender!string buffer; 
                            size_t column = col;
                            i++; 
                            while(line[i] != '\"' && i < line.length) {
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data, Type.String, row, column);
                            col++;
                            break;
                case '0': .. case '9': 
                            Appender!string buffer; 
                            size_t column = col;
                            while(line[i] != ' ' && line[i] != ')' && line[i] != '#' && i < line.length) {  
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data, Type.Integer, row, column);
          
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, Type.Close, row, col);    
                            break; 
                case '\0': 
                            break NextRow;
                default:     
                            Appender!string buffer; 
                            size_t column = col;
                            while(line[i] != ' ' && line[i] != ')' && line[i] != '#' && i < line.length) {  
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data, Type.Symbol, row, column);
                            
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, Type.Close, row, col);    
                            break; 
            }
        }
    } 
    return tokens.data; 
}
