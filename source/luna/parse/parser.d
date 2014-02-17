module luna.parse.parser;
import std.array:   Appender;
import std.conv:    to;
import std.stdio:   File;
import std.traits:  isSomeString;
import luna.parse.token, luna.parse.ast;
//this(Token[] input) {
    //import std.array: Appender;
    //Token first;
    //Appender!(List[]) output;

    //foreach(index, token; input) {
        //final switch(token.type) {
            //case TokenType.Open:    index++;
            //case TokenType.Close:   goto End;
            //case TokenType.Symbol, TokenType.String: break;
            //case TokenType.Number: break;
        //}
    //}
//End:
    //this.car = first;
    //this.cdr = output.data[0..$];
//}



List[] parse(Token[] tokens) {
    Token first;
    Appender!(List[]) rest;

    foreach(token; tokens) {
        final switch(token.type) {
            case TokenType.Open:    
                rest.put(new List(token));
                break;
            case TokenType.Close:  
                return rest.data;
                break;
            case TokenType.Symbol, TokenType.String: 
                break;
            case TokenType.Number:  
                break;
        }
    }

    return new List(first, rest.data);
}


// assumes complete list
Token[] lex(S)(S input, uint r = 0, uint c = 0) if(is(S : File) || isSomeString!S) {
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

                // Quote List
                case '\'':  tokens ~= Token("\'", TokenType.Symbol, row, col); break;

                // Begin List
                case '(':   tokens ~= Token("(", TokenType.Open,  row, col); break;
                // End List
                case ')':   tokens ~= Token(")", TokenType.Close, row, col); break;
                // String
                case '\"':  // read the entire string.
                            Appender!string buffer; 
                            uint column = col; //save column start number.
                            i++;  // skip "
                            while(i < line.length && line[i] != '\"' ) {
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data, TokenType.String, row, column);
                            col++; // skip "
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, TokenType.Close, row, col);    
                            break;
                // Number
                case '.': case '0': .. case '9':  //read the entire number
                            Appender!string buffer; 
                            uint column = col;
                            while(i < line.length && line[i] != ' ' && line[i] != '\t' && line[i] != ')' && line[i] != '#' ) {  
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data.to!float, TokenType.Number, row, column);
    
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, TokenType.Close, row, col);    
                            break; 
                // Control-D
                case '\0':  goto End;
                // Symbol
                default:     
                            Appender!string buffer; 
                            uint column = col;
                            while(i < line.length && line[i] != ' ' && line[i] != '\t' && line[i] != ')' && line[i] != '#' ) {  
                                buffer ~= line[i];
                                i++; col++;
                            } 
                            tokens ~= Token(buffer.data, TokenType.Symbol, row, column);
                            
                            if(line[i] == ')') 
                                tokens ~= Token(line[i].to!string, TokenType.Close, row, col);    
                            break; 
            }
        }
    } 

End:
    return tokens.data; 
}

// Private byLine for strings
private S[] byLine(S)(S str) if(isSomeString!S) { 
    import std.string:  splitLines;
    return str.splitLines;
}
