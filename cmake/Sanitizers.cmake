# Global sanitizer instrumentation, selected with -DHIE_SANITIZER=<none|address|thread>.
function(hie_enable_sanitizers)
  if(HIE_SANITIZER STREQUAL "none")
    return()
  endif()

  if(MSVC)
    message(FATAL_ERROR "HIE_SANITIZER is only supported with Clang/GCC")
  endif()

  if(HIE_SANITIZER STREQUAL "address")
    set(flags -fsanitize=address,undefined -fno-sanitize-recover=undefined)
  elseif(HIE_SANITIZER STREQUAL "thread")
    set(flags -fsanitize=thread)
  else()
    message(FATAL_ERROR "Unknown HIE_SANITIZER '${HIE_SANITIZER}' (expected none, address, thread)")
  endif()

  add_compile_options(${flags} -fno-omit-frame-pointer -g)
  add_link_options(${flags})
  message(STATUS "hie: sanitizer enabled: ${HIE_SANITIZER}")
endfunction()
