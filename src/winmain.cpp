
#include <Windows.h>


// x64: 592 bytes
// x86: 560 bytes
void maincrt()
{
    static constexpr char message[] = "Hello";


    MessageBoxA(nullptr, message, message, MB_OK);
}
