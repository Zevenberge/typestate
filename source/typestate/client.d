module typestate.client;

import std.stdio : writeln;
import openmethods;
import typestate.state;

mixin(registerMethods);

void readFile(string filename)
{
    auto file = File.newFile(filename);
    while(!file.isHandled)
    {
        file = file.handle;
    }
}

private:
File handle(virtual!File file);

@method
File _handle(File.Init file)
{
    return file.open;
}

@method
File _handle(File.Open file)
{
    string line;
    auto state = file.readLine(line);
    writeln(line);
    return state;
}

@method
File _handle(File.Read file)
{
    return file.close;
}

@method
File _handle(File.Closed file)
{
    return file;
}

bool isHandled(virtual!File file);

@method
bool _isHandled(File file)
{
    return false;
}

@method
bool _isHandled(File.Closed file)
{
    return true;
}