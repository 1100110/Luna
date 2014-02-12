#!/usr/bin/env rdmd
module luna;
//             Copyright Jude Young 2014.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
import 
    std.stdio, std.array;

import 
    Parse;

void main() {
    auto test = Token();
    writeln(lex(stdin));
    writeln(test.sizeof);
}

