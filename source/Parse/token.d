module Parse.token;
//          Copyright Joe Coder 2004 - 2006.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
import std.conv: to;

enum Type :ubyte {
    Symbol,     String,
    Integer,    Float,
    Open,       Close,
    Quote,      Macro,
}

struct Token {
    uint row;
    uint col;
    union {
        uint number;
        string text;
    }
    Type   type;
    
    this(string s, Type t, uint r, uint c) {
        this.text = s;
        this.type = t;
        this.row  = r;
        this.col  = c;

        if(this.type == Type.Integer) 
            this.number = this.text.to!uint;
    }

    string toString() const {
        if(type == Type.Integer) {
            return "Token("~this.number.to!string ~", "~ row.to!string ~", "~ col.to!string~")";
        }
        else
            return "Token(\""~this.text~"\""~", "~ row.to!string ~", "~ col.to!string~")";
    }
}

immutable SpecialChars = [
    '(', ')',
    '{', '}',
    '[', ']',
    '\"','\'', 
    '#',
];
