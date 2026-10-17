# Common configuration for every first-party target: warnings, optional
# clang-tidy, and optional host-specific code generation.
function(hie_configure_target target)
  hie_set_warnings(${target})

  if(HIE_ENABLE_CLANG_TIDY)
    find_program(HIE_CLANG_TIDY_EXE NAMES clang-tidy REQUIRED)
    set(tidy_command "${HIE_CLANG_TIDY_EXE}")
    if(APPLE)
      # Non-Apple clang-tidy builds need the SDK path to find system headers,
      # and CMake >= 4 no longer sets CMAKE_OSX_SYSROOT by default.
      set(sdk_path "${CMAKE_OSX_SYSROOT}")
      if(NOT sdk_path)
        execute_process(
          COMMAND xcrun --show-sdk-path
          OUTPUT_VARIABLE sdk_path
          OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY)
      endif()
      list(APPEND tidy_command "--extra-arg=-isysroot${sdk_path}")
    endif()
    set_target_properties(${target} PROPERTIES CXX_CLANG_TIDY "${tidy_command}")
  endif()

  if(HIE_NATIVE_ARCH AND NOT MSVC)
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm64|aarch64)$")
      target_compile_options(${target} PRIVATE -mcpu=native)
    else()
      target_compile_options(${target} PRIVATE -march=native)
    endif()
  endif()
endfunction()
