
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


void WinMainCRTStartup()
{
    MessageBoxA(nullptr, "Hello", "Hello", MB_OK | MB_ICONASTERISK);
}
