
#include <Windows.h>

// x64: 672 bytes
// x86: 592 bytes
void maincrt()
{
	static constexpr char message[] = "Hello";

	WriteConsoleA(GetStdHandle(STD_OUTPUT_HANDLE), message, sizeof(message), nullptr, 0);
}
