
function(setup_tiny_pe target desktop outputname include_dir)

    if(NOT WIN32 OR NOT MSVC OR CMAKE_CXX_COMPILER_ID MATCHES "Clang" )
        message(FATAL_ERROR "\nThis project is really just for Windows and MSVC")
    endif()

    set(RELEASE_LIBS
        kernel32.lib
        user32.lib
    )

    set(DEBUG_LIBS
        kernel32.lib
        user32.lib

        libcpmtd.lib
        libcmtd.lib
        libconcrtd.lib
        libvcruntimed.lib
        libucrtd.lib
    )

    add_executable (${target} ${desktop}) 

    set_property(TARGET ${target} PROPERTY CXX_STANDARD          23)
    set_property(TARGET ${target} PROPERTY CXX_STANDARD_REQUIRED ON)
    set_property(TARGET ${target} PROPERTY CXX_EXTENSIONS        OFF)

    target_include_directories(${target} PRIVATE ${include_dir})

    set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/install)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)


     set(OUTPUT_EXE ${target})

    if(NOT outputname STREQUAL "")
        set(OUTPUT_EXE ${outputname})
    endif()




    set_property(TARGET ${target} PROPERTY VS_STARTUP_PROJECT  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})

    set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

    set_target_properties(${target} PROPERTIES 
                          RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_SOURCE_DIR}/bin
                          RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
                          RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_SOURCE_DIR}/bin
    )

  
    # Options for all build types
    target_compile_definitions(${target} PRIVATE -DUNICODE)
    target_compile_definitions(${target} PRIVATE -D_UNICODE)
    #target_compile_definitions(${target} PRIVATE -D_CRT_SECURE_NO_WARNINGS)
    target_compile_definitions(${target} PRIVATE -DNOMINMAX)
    target_compile_definitions(${target} PRIVATE -DWIN32_LEAN_AND_MEAN)


    target_compile_options(${target} PRIVATE /nologo)
    target_compile_options(${target} PRIVATE /Zc:__cplusplus /Zc:alignedNew /Zc:checkGwOdr)
    target_compile_options(${target} PRIVATE /utf-8)
    target_compile_options(${target} PRIVATE /EHsc)
    target_compile_options(${target} PRIVATE /Za)

    target_compile_options(${target} PRIVATE /fp:precise)
    target_compile_options(${target} PRIVATE /diagnostics:caret)


    target_compile_options(${target} PRIVATE /experimental:module)
    target_compile_options(${target} PRIVATE /Zc:preprocessor)
    target_compile_options(${target} PRIVATE /permissive-)
    #target_compile_options(${target} PRIVATE /std:c++latest)

    target_compile_options(${target} PRIVATE /Wall)
    # target_compile_options(${target} PRIVATE /WX) # Warnings as errors


    target_link_options(${target} PRIVATE /entry:maincrt )
    
    if (${CMAKE_BUILD_TYPE} MATCHES "Release")
        target_link_options(${target} PRIVATE /MERGE:.pdata=.text /MERGE:.rdata=.text)
        #target_link_options(${target} PRIVATE /DYNAMICBASE:NO)
        target_link_options(${target} PRIVATE /ALIGN:16)


        set_target_properties(${target} PROPERTIES INTERPROCEDURAL_OPTIMIZATION ON)

        target_compile_definitions(${target} PRIVATE -DNDEBUG)
        
        target_compile_options(${target}  PRIVATE /O2 /Os)
        target_compile_options(${target}  PRIVATE /GS-)
        target_compile_options(${target}  PRIVATE /GF)

        target_compile_options(${target}  PRIVATE /Gw /MP)

        target_link_options(${target} PRIVATE /RELEASE)
        target_link_options(${target} PRIVATE /INCREMENTAL:NO)
        target_link_options(${target} PRIVATE /OPT:REF /OPT:ICF)
        #target_link_options(${target} PRIVATE /DEPENDENTLOADFLAG:0x800)

        target_link_libraries(${target} PRIVATE ${RELEASE_LIBS})

        # Undocumented options
        target_link_options(${target} PRIVATE  /emittoolversioninfo:no /emitpogophaseinfo)
        

        # Generate out stub
        if(NOT EXISTS ${CMAKE_SOURCE_DIR}/stub.bin)
            file(WRITE newstub.txt "4D 5A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00")
            # CertUtil has been included since Windows XP
            execute_process( COMMAND certutil -f -decodehex newstub.txt stub.bin WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
            file(REMOVE newstub.txt)
        endif()

        # Our own stub
        if(EXISTS ${CMAKE_SOURCE_DIR}/stub.bin)
            target_link_options(${target} PRIVATE /stub:${CMAKE_SOURCE_DIR}/stub.bin )
        else()
            message(WARNING "Could not find stub.bin")
        endif()

    elseif(${CMAKE_BUILD_TYPE} MATCHES "Debug" OR ${CMAKE_BUILD_TYPE} MATCHES "RelWithDebInfo")

        target_compile_options(${target}  PRIVATE /JMC)    # Just my debugging
        target_compile_options(${target}  PRIVATE /RTC1)
        target_compile_options(${target}  PRIVATE /Od)
        target_compile_options(${target}  PRIVATE /GS)
        #target_compile_options(${target}  PRIVATE /Ob1)

        if (${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.25")
            set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>")
        endif()

        target_link_libraries(${target} PRIVATE ${DEBUG_LIBS})

        target_link_options(${target} PRIVATE /DEBUG  /NOVCFEATURE /NOCOFFGRPINFO)
        target_link_options(${target} PRIVATE /NODEFAULTLIB)

    endif()

    set_target_properties(${target} PROPERTIES DEBUG_POSTFIX "d") 
    
    # Add arch to name
    string(SUBSTRING ${CMAKE_CXX_COMPILER_ARCHITECTURE_ID} 1 -1 TINY_PE_ARCH)
    string(APPEND OUTPUT_EXE ${TINY_PE_ARCH})
    set_target_properties(${target} PROPERTIES OUTPUT_NAME ${OUTPUT_EXE})


    # Minimum Windows 10.
    # target_compile_definitions(CMakeTest+1 PRIVATE -DWINVER=0x0a00)
    # target_compile_definitions(CMakeTest+1 PRIVATE -D_WIN32_WINNT=0x0a00)

     # Check if has manifest.txt then add one
    target_link_options(${target} PRIVATE  /MANIFEST:NO)

    # Disabled warnings
    target_compile_options(${target} PRIVATE 
        
        /wd5039 # pointer or reference to potentially throwing function passed to 'extern "C"' function under -EHc.
        /wd5262 # implicit fall-through occurs here; are you missing a break statement? Use [[fallthrough]] when a break 
                # statement is intentionally omitted between cases
        /wd4820 # 4' bytes padding added after data member
    )
endfunction()

