
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>

#pragma comment(linker, "/ALIGN:16")

#ifndef _DEBUG
#    pragma comment(linker, "/MERGE:.rdata=.text")
#    pragma comment(linker, "/MERGE:.pdata=.text")
#endif


// x64: 688 bytes
// x86: 592 bytes
void maincrt()
{
    static constexpr char message[] = "Hello";

    DWORD written{0};
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), message, sizeof(message), &written, nullptr);
}
