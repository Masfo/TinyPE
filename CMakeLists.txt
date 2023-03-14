#
cmake_minimum_required (VERSION 3.25)


if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "Do not build in-source. Please remove CMakeCache.txt and the CMakeFiles/ directory. Then build out-of-source.")
endif()


set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_SYSROOT_FLAG_CODE "list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS ixx)")

enable_testing()

set(PROJECT_VERSION 1.0.0)

project(TinyPE VERSION ${PROJECT_VERSION} LANGUAGES CXX)

include(SetupMSVC)

add_executable (tinycon) 
setup_tiny_pe(tinycon "" "${CMAKE_CURRENT_LIST_DIR}/src")

add_executable (tinygui WIN32)
setup_tiny_pe(tinygui "" "${CMAKE_CURRENT_LIST_DIR}/src")


add_subdirectory(src)

add_custom_target(print-exe-sizes
   COMMAND ${CMAKE_BUILD_TOOL} clean
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
   DEPENDS  ${CMAKE_SOURCE_DIR}/bin/tinygui32.exe
)

# Install
#install(TARGETS tinycon
#        CONFIGURATIONS Release
#DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/install)
#
#install(TARGETS tinygui
#        CONFIGURATIONS Release
#DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/install)
#


