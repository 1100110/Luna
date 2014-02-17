module luna.parse.ast;
import luna.parse.token;

class List {
    Token   car;
    List[]  cdr;

    this() {}

    this(Token t, List[] l = []) {
        this.car = t;
        this.cdr = l;
    }
    
    void put(List l) { cdr ~= l; }
    
    
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
}
