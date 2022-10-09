
#include <Windows.h>


// x64: 688 bytes
// x86: 592 bytes
void maincrt()
{
    static constexpr char message[] = "Hello";

    DWORD written{0};
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), message, sizeof(message), &written, nullptr);
}
