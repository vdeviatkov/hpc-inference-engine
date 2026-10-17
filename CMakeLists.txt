cmake_minimum_required(VERSION 3.25)

project(
  hie
  VERSION 0.1.0
  DESCRIPTION "A from-scratch, architecture-agnostic LLM inference engine"
  LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed. Use a preset: cmake --preset debug")
endif()

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------
option(HIE_BUILD_TESTS "Build unit tests" ${PROJECT_IS_TOP_LEVEL})
option(HIE_BUILD_TOOLS "Build command-line tools" ${PROJECT_IS_TOP_LEVEL})
option(HIE_WARNINGS_AS_ERRORS "Treat compiler warnings as errors" ON)
option(HIE_ENABLE_CLANG_TIDY "Run clang-tidy on project targets during the build" OFF)
option(HIE_NATIVE_ARCH "Optimize for the host CPU (-mcpu/-march=native); not portable" OFF)
set(HIE_SANITIZER
    "none"
    CACHE STRING "Sanitizer to build with: none, address (ASan+UBSan), thread")
set_property(CACHE HIE_SANITIZER PROPERTY STRINGS none address thread)

# ---------------------------------------------------------------------------
# Global settings
# ---------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE
      Release
      CACHE STRING "Build type" FORCE)
endif()

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(CompilerWarnings)
include(Sanitizers)
include(ProjectTarget)

# Sanitizers are applied globally (including third-party code such as
# GoogleTest) so that instrumented and uninstrumented code never mix.
hie_enable_sanitizers()

# ---------------------------------------------------------------------------
# Targets
# ---------------------------------------------------------------------------
add_subdirectory(src)

if(HIE_BUILD_TOOLS)
  add_subdirectory(tools)
endif()

if(HIE_BUILD_TESTS)
  enable_testing()
  include(Dependencies)
  add_subdirectory(tests)
endif()
