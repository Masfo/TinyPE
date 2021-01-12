 
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
#if 0
	HMODULE hModule = GetModuleHandle(nullptr);
	if(!hModule) return;

	// Get DOS header
	IMAGE_DOS_HEADER *pDOSHeader = (IMAGE_DOS_HEADER *)hModule;

	// Get PE header
	IMAGE_NT_HEADERS *pPEHeader = (IMAGE_NT_HEADERS *)((BYTE *)pDOSHeader + pDOSHeader->e_lfanew);

	struct DOS_STUB
	{
		BYTE header[64];
	};

	// DOS Stub, 64 bytes from module start
	DOS_STUB *pDOSStub = (DOS_STUB *)((BYTE *)pDOSHeader + 64);

	// PE - DosHeader+64 = Stub + Rich 
#endif


	DWORD written{ 0 };
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), "Hello World", 12, &written, nullptr);
}												
