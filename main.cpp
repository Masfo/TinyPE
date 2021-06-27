#pragma warning(disable : 5039)  // warning C5105: pointer or reference to potentially throwing function passed to
                                 // 'extern "C"' function under -EHc.

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define STRICT
#include <Windows.h>
#include <cstdint>

#define CONSOLE 0		// 1 - console application
                        // 0 - Windows application

#pragma comment(linker, "/ALIGN:16")
#ifndef _DEBUG
#pragma comment(linker, "/MERGE:.rdata=.text")
#pragma comment(linker, "/MERGE:.pdata=.text")

#endif


#if (CONSOLE == 1)
#pragma comment(linker, "/SUBSYSTEM:CONSOLE")

void mainCRTStartup()
{
    DWORD written{ 0 };
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "Hello", 6, &written, nullptr);
}

#else
#pragma comment(linker, "/SUBSYSTEM:WINDOWS")

void WinMainCRTStartup()
{
    MessageBoxA(nullptr, "Hello", "Hello", MB_OK | MB_ICONASTERISK);
}
#endif
