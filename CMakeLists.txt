#
cmake_minimum_required (VERSION 3.23)


if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "Do not build in-source. Please remove CMakeCache.txt and the CMakeFiles/ directory. Then build out-of-source.")
endif()


set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_SYSROOT_FLAG_CODE "list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS ixx)")

enable_testing()

set(PROJECT_VERSION 1.0.0)

project(TinyPE VERSION ${PROJECT_VERSION} LANGUAGES CXX)


if(NOT WIN32 OR NOT MSVC OR CMAKE_CXX_COMPILER_ID MATCHES "Clang" )
message(FATAL_ERROR "\nThis project is really just for Windows and MSVC")
endif()

include(SetupMSVC)




set(DEBUG_LIBS
    kernel32
    user32
    libcmtd.lib
    libvcruntimed.lib
    libucrtd.lib
)


# globally:
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Ob1")
# for specified source files:
#set_source_files_properties(${sources} PROPERTIES COMPILE_FLAGS "/Ob1")


# Tinycon
add_executable (tinycon)
setup_piku_executable_msvc(tinycon "" 11)
target_include_directories(tinycon PRIVATE ${CMAKE_CURRENT_LIST_DIR}/src)
if(MSVC)

    target_link_options(tinycon PRIVATE /entry:maincrt )
    
    if (${CMAKE_BUILD_TYPE} MATCHES "Release")
        target_link_options(tinycon PRIVATE /MERGE:.pdata=.text /MERGE:.rdata=.text)
        target_link_options(tinycon PRIVATE /DYNAMICBASE:NO)
        target_link_options(tinycon PRIVATE /ALIGN:16)
    elseif(${CMAKE_BUILD_TYPE} MATCHES "Debug" OR ${CMAKE_BUILD_TYPE} MATCHES "RelWithDebInfo")
        target_link_options(tinycon PRIVATE /MTd)
        target_link_options(tinycon PRIVATE /NODEFAULTLIB)
        target_link_libraries(tinycon PRIVATE ${DEBUG_LIBS})
    endif()
endif()

# TinyGui
add_executable (tinygui WIN32)
setup_piku_executable_msvc(tinygui "" 11)
target_include_directories(tinygui PRIVATE ${CMAKE_CURRENT_LIST_DIR}/src)

if(MSVC)
    target_link_options(tinygui PRIVATE /entry:maincrt )

    if (${CMAKE_BUILD_TYPE} MATCHES "Release")
        if(${architecture} STREQUAL "32")
            target_link_options(tinygui PRIVATE /MERGE:.pdata=.text /MERGE:.rdata=.text)
        endif()
    
        target_link_options(tinygui PRIVATE /DYNAMICBASE:NO)
        target_link_options(tinygui PRIVATE /ALIGN:16)
    
    elseif(${CMAKE_BUILD_TYPE} MATCHES "Debug" OR ${CMAKE_BUILD_TYPE} MATCHES "RelWithDebInfo")
        target_link_options(tinygui PRIVATE /MTd)
    
        target_link_options(tinygui PRIVATE /NODEFAULTLIB)
        target_link_libraries(tinygui PRIVATE ${DEBUG_LIBS})
    endif()
endif()

# Sources
add_subdirectory(src)


# Install
#install(TARGETS tinycon
#        CONFIGURATIONS Release
#DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/install)
#
#install(TARGETS tinygui
#        CONFIGURATIONS Release
#DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/install)
#


