module luna.parse.token;
//          Copyright Joe Coder 2004 - 2006.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

enum TokenType : ubyte { Symbol, String, Number, Open, Close }

struct Token {
    uint row, col;
    union {
        float  number;
        string text;
    }
    TokenType   type;

    this(in string s, in TokenType t, in uint r, in uint c) pure nothrow @safe {
        this.text = s;
        this.type = t;
        this.row  = r;
        this.col  = c;

    }

    this(in float d, in TokenType t, in uint r, in uint c) pure nothrow @safe {
        this.number = d;
        this.type = t;
        this.row = r;
        this.col = c;
    }

    string toString() const @trusted {
        import std.conv:    to;
        import std.string:  format;

        if(type == TokenType.Number)
            return format("%s<%s:%s>", this.number.to!string, row.to!string, col.to!string);
        else
            return format("%s<%s:%s>", this.text, row.to!string, col.to!string);
    }
}
