module Parse.token;
//          Copyright Joe Coder 2004 - 2006.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
import std.conv: to;
import std.traits;

enum Type {
    Symbol,     String,
    Integer,    Float,
    Open,       Close,
    List
}

auto token(D)(D d, Type t, size_t r = 1, size_t c = 1) 
    if(isSomeString!D || isNumeric!D) {
    return Token(d, t, r, c);
}

struct Token {
    size_t row;
    size_t col;
    Type   type;
union {
    size_t number;
    string text;
}
    alias type this;

    this(string s, Type t, size_t r, size_t c) {
        this.text = s;
        this.type = t;
        this.row  = r;
        this.col  = c;

        if(this.type == Type.Integer) 
            this.number = this.text.to!size_t;
    }

    string toString() const {
        import std.string: format;

        if(type == Type.Integer)
            return format("%s<%s:%s>", this.number.to!string, row.to!string, col.to!string);
        else
            return format("%s<%s:%s>", this.text, row.to!string, col.to!string);
    }
}
