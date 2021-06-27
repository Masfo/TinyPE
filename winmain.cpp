#pragma warning(disable : 5039)  // warning C5105: pointer or reference to potentially throwing function passed to
                                 // 'extern "C"' function under -EHc.

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define STRICT
#include <Windows.h>
#include <cstdint>


#pragma comment(linker, "/ALIGN:16")
#pragma comment(linker, "/SUBSYSTEM:WINDOWS")
#ifndef _DEBUG
#pragma comment(linker, "/MERGE:.rdata=.text")
#pragma comment(linker, "/MERGE:.pdata=.text")
#endif


void WinMainCRTStartup()
{
    MessageBoxA(nullptr, "Hello", "Hello", MB_OK | MB_ICONASTERISK);
}
