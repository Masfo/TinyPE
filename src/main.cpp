
#include <Windows.h>

// GUI
//	x64: 592 bytes
//	x86: 560 bytes

// CON:
//  x64: 672 bytes
//  x86: 592 bytes
void maincrt()
{
	static constexpr char message[] = "Hello1";

#if defined(TINY_GUI)
	MessageBoxA(nullptr, message, message, MB_OK);
#else
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), message, sizeof(message), nullptr, 0);
#endif
}
