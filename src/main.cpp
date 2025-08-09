
#include <Windows.h>

// GUI
//	x64: 560 bytes
//	x86: 528 bytes

// CON:
//  x64: 640 bytes
//  x86: 560 bytes

constexpr unsigned int seed_from_time(const char* t)
{
	return (t[0] - '0') * 36000u + (t[1] - '0') * 3600u + (t[3] - '0') * 600u + (t[4] - '0') * 60u + (t[6] - '0') * 10u + (t[7] - '0');
}

static unsigned int seed = seed_from_time(__TIME__);

unsigned int rand()
{
	seed = seed * 1664525 + 1013904223; // Numerical Recipes LCG parameters
	return seed;
}


void maincrt()
{
	static constexpr char message[] = "Hello";

#if defined(TINY_GUI)
	MessageBoxA(nullptr, message, message, MB_OK);
#else
	unsigned int size = 1024 * 16;

	unsigned int chars_per_line = 0;
	for (unsigned int i = 0; i < size; ++i)
	{
		char c = static_cast<char>((rand() % 95) + 32);
		WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), &c, 1, nullptr, 0);

		chars_per_line++;
		if (chars_per_line >= 50+(rand()%40))
		{
			WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "\n", 1, nullptr, 0);
			chars_per_line = 0;

		if(rand() % 10 == 0)
			WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "\n", 1, nullptr, 0);
		}


	}
#endif
}
