


# setup_piku_executable(targetname "renamed output exe")
function(setup_piku_executable_msvc target outputname cx_standard)

    set_property(TARGET "${target}" PROPERTY CXX_STANDARD          ${cx_standard})
    set_property(TARGET "${target}" PROPERTY CXX_STANDARD_REQUIRED ON)
    set_property(TARGET "${target}" PROPERTY CXX_EXTENSIONS        OFF)


    if(UNITY_BUILD)
    message(STATUS "Unity Build for ${target}")
    set_target_properties(${target} PROPERTIES
                                    UNITY_BUILD ON
                                    UNITY_BUILD_MODE BATCH
                                    UNITY_BUILD_BATCH_SIZE 8)
    endif()

    set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/install)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)


    set(PIKU_EXE_NAME ${target})

    if(NOT outputname STREQUAL "")
        set_target_properties(${target} PROPERTIES OUTPUT_NAME "${outputname}")
        set(PIKU_EXE_NAME ${outputname})
    endif()

    string(APPEND PIKU_EXE_NAME ${architecture})

    
    set_property(TARGET "${target}" PROPERTY VS_STARTUP_PROJECT  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})

    set_target_properties("${target}" PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

    set_target_properties("${target}" PROPERTIES 
                          RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_SOURCE_DIR}/bin
                          RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
                          RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_SOURCE_DIR}/bin
    )

    if(MSVC)
        target_compile_definitions("${target}" PRIVATE -DUNICODE)
        target_compile_definitions("${target}" PRIVATE -D_UNICODE)
        #target_compile_definitions("${target}" PRIVATE -D_CRT_SECURE_NO_WARNINGS)
        target_compile_definitions("${target}" PRIVATE -DNOMINMAX)
        target_compile_definitions("${target}" PRIVATE -DWIN32_LEAN_AND_MEAN)


        target_compile_options("${target}" PRIVATE /nologo)
        target_compile_options("${target}" PRIVATE /Zc:__cplusplus /Zc:alignedNew)
        target_compile_options("${target}" PRIVATE /utf-8)
        target_compile_options("${target}" PRIVATE /EHsc)
        target_compile_options("${target}" PRIVATE /Za)

        target_compile_options("${target}"  PRIVATE /fp:precise)
        target_compile_options("${target}" PRIVATE /diagnostics:caret)


        target_compile_options("${target}" PRIVATE /experimental:module)
        target_compile_options("${target}" PRIVATE /Zc:preprocessor)
        target_compile_options("${target}" PRIVATE /permissive-)
        #target_compile_options("${target}" PRIVATE /std:c++latest)

        target_compile_options("${target}" PRIVATE /Wall)
        # target_compile_options("${target}" PRIVATE /WX) # Warnings as errors


        # Release
        if (${CMAKE_BUILD_TYPE} MATCHES "Release")
           set_target_properties("${target}" PROPERTIES INTERPROCEDURAL_OPTIMIZATION ON)

            target_compile_definitions("${target}" PRIVATE -DNDEBUG)
        
            target_compile_options("${target}"  PRIVATE /O2 /Os)
            target_compile_options("${target}"  PRIVATE /GS-)
            target_compile_options("${target}"  PRIVATE /GF)

            target_link_options("${target}" PRIVATE /Release)
            target_link_options("${target}" PRIVATE /INCREMENTAL:NO)
            target_link_options("${target}" PRIVATE /OPT:REF /OPT:ICF)

            # Undocumented options
            target_link_options("${target}" PRIVATE  /emittoolversioninfo:no /emitpogophaseinfo)
            
            # DOS Stub
            if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/stub.bin)
                    execute_process( COMMAND cmd /C genstub.cmd
                                     WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
            endif()

            if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/stub.bin)
                target_link_options("${target}" PRIVATE  /stub:${CMAKE_CURRENT_SOURCE_DIR}/stub.bin )
            else()
                message(WARNING "Could not find stub.bin")
            endif()

        endif()

        # Release w/ Debug
        if(${CMAKE_BUILD_TYPE} MATCHES "RelWithDebInfo")
            string(APPEND PIKU_EXE_NAME "dr")

            target_compile_options("${target}"  PRIVATE /Zi)     # /ZI edit/continue
            target_link_options("${target}" PRIVATE /DEBUG)
        endif()


        # Debug
        if (${CMAKE_BUILD_TYPE} MATCHES "Debug")
            string(APPEND PIKU_EXE_NAME "d")
            
            target_compile_options("${target}"  PRIVATE /JMC)    # Just my debugging
            target_compile_definitions("${target}" PRIVATE -DDEBUG)

            target_compile_options("${target}"  PRIVATE /Od)

            #target_compile_options("${target}"  PRIVATE /Ob1)


            target_compile_options("${target}"  PRIVATE /RTC1)
            target_compile_options("${target}"  PRIVATE /GS)
            target_compile_options("${target}"  PRIVATE /Zi)     # /ZI edit/continue

            target_link_options("${target}" PRIVATE /DEBUG)

        endif()

        set_target_properties(${target} PROPERTIES OUTPUT_NAME "${PIKU_EXE_NAME}")



        # Minimum Windows 10.
        # target_compile_definitions(CMakeTest+1 PRIVATE -DWINVER=0x0a00)
        # target_compile_definitions(CMakeTest+1 PRIVATE -D_WIN32_WINNT=0x0a00)

        # Check if has manifest.txt then add one
        target_link_options("${target}" PRIVATE  /MANIFEST:NO)

        # Disabled warnings
        target_compile_options("${target}" PRIVATE 
        
            /wd5039 # pointer or reference to potentially throwing function passed to 'extern "C"' function under -EHc.

            /wd5262 # implicit fall-through occurs here; are you missing a break statement? Use [[fallthrough]] when a break 
                    # statement is intentionally omitted between cases
        )




    endif() # MSVC

endfunction()
