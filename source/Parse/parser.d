module Parse.parser;
import std.stdio:   File;
import std.conv:    to;
import std.array:   Appender;
import Parse.token;


// assumes complete list
Token[] lex(S)(S input, uint r = 0, uint c = 0) {
    uint row = r;
    uint col = c;
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
                // whitespace
                case ' ', '\t': break;
                // Comment
                case ';':       goto NextRow;       // skip line-comments
                // Begin List
                case '(':   tokens ~= Token("(", Type.Open,  row, col); break;
                // End List
                case ')':   tokens ~= Token(")", Type.Close, row, col); break;
                // String
                case '\"':  // read the entire string.
                            Appender!string buffer; 
                            uint column = col; //save column start number.
                            i++;  // skip "
                            while(i < line.length && line[i] != '\"' ) {
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data, Type.String, row, column);
                            col++; // skip "
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, Type.Close, row, col);    
                            break;
                // Number
                case '.': case '0': .. case '9':  //read the entire number
                            Appender!string buffer; 
                            uint column = col;
                            while(i < line.length && line[i] != ' ' && line[i] != '\t' && line[i] != ')' && line[i] != '#' ) {  
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data.to!float, Type.Number, row, column);
    
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, Type.Close, row, col);    
                            break; 
                // ^-D
                case '\0':  goto End;
                // Symbol
                default:     
                            Appender!string buffer; 
                            uint column = col;
                            while(i < line.length && line[i] != ' ' && line[i] != '\t' && line[i] != ')' && line[i] != '#' ) {  
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

End:
    return tokens.data; 
}
