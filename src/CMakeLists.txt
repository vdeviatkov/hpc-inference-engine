configure_file("${PROJECT_SOURCE_DIR}/include/hie/version.hpp.in"
               "${PROJECT_BINARY_DIR}/generated/include/hie/version.hpp" @ONLY)

add_library(hie core/build_info.cpp)
add_library(hie::hie ALIAS hie)

target_include_directories(
  hie PUBLIC "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
             "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/generated/include>")
target_include_directories(hie PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_features(hie PUBLIC cxx_std_20)
target_compile_definitions(hie PRIVATE HIE_BUILD_TYPE="$<CONFIG>")

hie_configure_target(hie)
