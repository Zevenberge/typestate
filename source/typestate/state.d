module typestate.state;

import std.stdio;
import std.traits : ReturnType;
import std.conv : to;

abstract class File
{
    alias StdFile = std.stdio.File;
    static File newFile(string filename)
    {
        return new File.Init(filename);
    }

    static class Init : File
    {
        private this(string name)
        {
            _name = name;
        }

        private string _name;

        File open()
        {
            return new File.Open(new StdFile(_name, "r"));

        }
    }

    static class Open : File
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
            if (_lines.empty)
            {
                return new File.Read(_file);
            }
            else
            {
                return this;
            }
        }

        File close()
        {
            _file.close;
            return new File.Closed();
        }
    }

    static class Read : File
    {
        private this(StdFile* file)
        {
            _file = file;
        }

        private StdFile* _file;

        File close()
        {
            _file.close;
            return new File.Closed();
        }
    }

    static class Closed : File
    {
        private this()
        {
        }
    }
}

