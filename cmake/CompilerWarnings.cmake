# Strict warning set applied to every first-party target via hie_configure_target().
function(hie_set_warnings target)
  if(MSVC)
    set(warnings /W4 /permissive-)
    if(HIE_WARNINGS_AS_ERRORS)
      list(APPEND warnings /WX)
    endif()
  else()
    set(warnings
        -Wall
        -Wextra
        -Wpedantic
        -Wshadow
        -Wconversion
        -Wsign-conversion
        -Wold-style-cast
        -Wcast-align
        -Wnon-virtual-dtor
        -Woverloaded-virtual
        -Wnull-dereference
        -Wdouble-promotion
        -Wimplicit-fallthrough
        -Wformat=2)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      list(APPEND warnings -Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wuseless-cast)
    endif()
    if(HIE_WARNINGS_AS_ERRORS)
      list(APPEND warnings -Werror)
    endif()
  endif()

  target_compile_options(${target} PRIVATE ${warnings})
endfunction()
