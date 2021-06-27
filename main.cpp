
#ifdef _WIN64
#pragma warning(disable : 5039)  // warning C5105: pointer or reference to potentially throwing function passed to
                                 // 'extern "C"' function under -EHc.
#endif

#pragma comment(linker, "/ALIGN:16")
#pragma comment(linker, "/SUBSYSTEM:CONSOLE")
#ifndef _DEBUG
#pragma comment(linker, "/MERGE:.rdata=.text")
#pragma comment(linker, "/MERGE:.pdata=.text")
#else
#endif

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define STRICT
#include <Windows.h>
#include <cstdint>





void mainCRTStartup()
{
    DWORD written{ 0 };
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "Hello", 5, &written, nullptr);
}

