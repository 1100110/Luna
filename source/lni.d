#!/usr/local/bin/rdmd --compiler=ldmd -O -g
//             Copyright Jude Young 2014.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
import std.stdio;
version(LDC) import luna.parse.parser, luna.parse.token;
else         import luna.parse;


void main() {
    auto test = "(define (add a b) (+ a b))";
    //auto tree = stdin.lex;
    auto tree = test.lex;
    writefln("%s", tree);
}
