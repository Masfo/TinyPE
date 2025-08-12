
#include <Windows.h>

// GUI
//	x64: 560 bytes
//	x86: 528 bytes

// CON:
//  x64: 640 bytes
//  x86: 560 bytes
void maincrt()
{
	static constexpr char message[] = "Hello";

#if defined(TINY_GUI)
	MessageBoxA(nullptr, message, message, MB_OK);
#else
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), message, sizeof(message), nullptr, 0);
#endif
}
