# TinyPE

# **Not for production use, disables security features.**

POC Tiny PE - CMake and VS2022 (open as local folder)
  - uses undocumented linker flags: */emittoolversioninfo:no /emitpogophaseinfo, /emitvolatilemetadata:no*

| Hello World    | Console    | Gui       |
|----------------|------------|-----------|
| 64-bit         | 640 bytes  | 560 bytes |
| 32-bit         | 560 bytes  | 528 bytes |

| Empty program     | Console    | Gui       |
|-------------------|------------|-----------|
| 64-bit            | 384 bytes  | 384 bytes |
| 32-bit            | 368 bytes  | 368 bytes |



Tested on Windows 11:
  - 21H2 (22000.258  - 22000.2057)
  - 22H2 (22621.1992 - 22621.4317)
  - 24H2 (26100.1742 - 26100.7171)
  - 25H2 (26200.7171 - 26200.7462)

<img width="860" alt="readme_image" src="readmeimage.png">



