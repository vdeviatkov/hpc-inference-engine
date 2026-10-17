add_executable(hie-cli main.cpp)
set_target_properties(hie-cli PROPERTIES OUTPUT_NAME hie)
target_link_libraries(hie-cli PRIVATE hie::hie)

hie_configure_target(hie-cli)
