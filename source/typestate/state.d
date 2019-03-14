module typestate.state;

import std.stdio;
import std.traits : ReturnType;
import std.conv : to;
alias StdFile = std.stdio.File;

interface File
{
    static File newFile(string filename)
    {
        return new InitFile(filename);
    }
}

class InitFile : File
{
    private this(string filename)
    {
        _filename = filename;
    }

    private string _filename;

    File open()
    {
        return new OpenFile(new StdFile(_filename, "r"));
    }
}

class OpenFile : File
{
    private this(StdFile* file)
    {
        _file = file;
        _lines = _file.byLine;
    }

    alias Iterator = StdFile.ByLineImpl!(char, char);
    private StdFile* _file;
    private Iterator _lines;

    File readLine(out string buffer)
    {
        buffer = _lines.front.to!string;
        _lines.popFront;
        if(_lines.empty)
        {
            return new ReadFile(_file);
        }
        else
        {
            return this;
        }    
    }

    File close()
    {
        _file.close;
        return new ClosedFile();
    }
}

class ReadFile : File
{
    private this(StdFile* file)
    {
        _file = file;
    }

    private StdFile* _file;

    File close()
    {
        _file.close;
        return new ClosedFile();
    }
}

class ClosedFile : File
{
    private this(){};
}