
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>

#pragma comment(linker, "/ALIGN:16")

#ifdef _M_IX86
#    ifndef _DEBUG
#        pragma comment(linker, "/MERGE:.rdata=.text")
#        pragma comment(linker, "/MERGE:.pdata=.text")
#    endif
#endif

// x64: 592 bytes
// x86: 560 bytes
void maincrt()
{
    static constexpr char message[] = "Hello";

    MessageBoxA(nullptr, message, message, MB_OK | MB_ICONASTERISK);
}
