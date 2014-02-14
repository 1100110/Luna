#!/usr/bin/env rdmd
module luna;
//             Copyright Jude Young 2014.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
import std.algorithm, std.array, std.stdio, std.range;
// No package support.
version(LDC) import Parse.parser, Parse.token, Parse.ast;
else         import Parse;

void main() {
    auto tree   = stdin.lex;

    writeln(tree);
}

void eval(List list) {

}



Lisp parseToAST(Token[] tokens)
{
    
    auto left = countUntil(tokens, Type.Open);  
    auto right= countUntil(tokens, Type.Close);
    
    if(left == 0 && right > left ) {
        auto list = new List(tokens[left+1..right]);         
        tokens.drop(right);
    }
    
        

    return new Lisp;
}
