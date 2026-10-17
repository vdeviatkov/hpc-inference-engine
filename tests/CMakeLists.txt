include(GoogleTest)

add_executable(hie-unit-tests unit/build_info_test.cpp)
target_link_libraries(hie-unit-tests PRIVATE hie::hie GTest::gtest_main)

hie_configure_target(hie-unit-tests)

gtest_discover_tests(hie-unit-tests DISCOVERY_MODE PRE_TEST)
