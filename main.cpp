
#pragma comment(linker, "/ALIGN:16")

#ifndef _DEBUG
#    pragma comment(linker, "/MERGE:.rdata=.text")
#    pragma comment(linker, "/MERGE:.pdata=.text")
#endif

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define STRICT
#include <Windows.h>
#include <cstdint>

void mainCRTStartup()
{
    DWORD written{0};
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "Hello", 5, &written, nullptr);
}
