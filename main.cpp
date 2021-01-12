 
#define WIN32_LEAN_AND_MEAN									   
#define NOMINMAX
#define STRICT
#include <Windows.h>											   

#ifndef _DEBUG
#pragma comment(linker, "/ALIGN:16")
#pragma comment(linker, "/MERGE:.text=.tinype")
#pragma comment(linker, "/MERGE:.rdata=.tinype")
#pragma comment(linker, "/MERGE:.pdata=.tinype")
#endif




void mainCRTStartup()
{

	DWORD written{ 0 };
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "Hello World", 12, &written, nullptr);
}												
