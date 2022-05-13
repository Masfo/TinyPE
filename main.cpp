
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>

#pragma comment(linker, "/ALIGN:16")

#ifndef _DEBUG
#    pragma comment(linker, "/MERGE:.rdata=.text")
#    pragma comment(linker, "/MERGE:.pdata=.text")
#endif


// X64: 944 bytes
// X86: 864 bytes
void mainCRTStartup()
{
    DWORD written{0};
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "Hello", 5, &written, nullptr);

}
