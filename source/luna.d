#!/usr/local/bin/rdmd --compiler=ldmd -O -g
//             Copyright Jude Young 2014.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
import std.algorithm, std.array, std.stdio, std.range;
version(LDC) import Parse.parser, Parse.token;
else         import Parse;

void main() {
    auto tree = stdin.lex;
    writefln("%s:%s", tree, Token.sizeof);
}
