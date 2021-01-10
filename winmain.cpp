 
#define WIN32_LEAN_AND_MEAN									   
#include <Windows.h>											   

#pragma comment(linker, "/ALIGN:16")
#pragma comment(linker, "/MERGE:.rdata=.text")
#pragma comment(linker, "/MERGE:.pdata=.text")



void mainCRTStartup()
{
	DWORD written{ 0 };
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "Hello World", 12, &written, nullptr);
}												
