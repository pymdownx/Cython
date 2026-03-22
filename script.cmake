# WARNING: This is wrong for multi-config generators because they don't use
#          and typically don't even set CMAKE_BUILD_TYPE
import sysconfig
sysconfig.get_config_var('LIBS')

sysconfig.get_config_var('LINKFORSHARED')
string(TOLOWER ${CMAKE_BUILD_TYPE} build_type)
if (build_type STREQUAL debug)
  target_compile_definitions(exe1 PRIVATE DEBUG_BUILD)
endif()
add_library(MyFramework SHARED MyFramework.cpp)
set_target_properties(MyFramework PROPERTIES
  FRAMEWORK TRUE
  FRAMEWORK_VERSION A # Version "A" is macOS convention
  MACOSX_FRAMEWORK_IDENTIFIER org.cmake.MyFramework
)
add_library(archive SHARED archive.cpp zip.cpp)

if (LZMA_FOUND)
  # Add a source implementing support for lzma.
  target_sources(archive PRIVATE lzma.cpp)

  # Compile the 'archive' library sources with '-DBUILDING_WITH_LZMA'.
  target_compile_definitions(archive PRIVATE BUILDING_WITH_LZMA)
endif()

target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

add_executable(consumer consumer.cpp)

# Link 'consumer' to 'archive'.  This also consumes its usage requirements,
# so 'consumer.cpp' is compiled with '-DUSING_ARCHIVE_LIB'.
target_link_libraries(consumer archive)
add_library(archive archive.cpp)
target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

add_library(serialization serialization.cpp)
target_compile_definitions(serialization INTERFACE USING_SERIALIZATION_LIB)

add_library(archiveExtras extras.cpp)
target_link_libraries(archiveExtras PUBLIC archive)
target_link_libraries(archiveExtras PRIVATE serialization)
# archiveExtras is compiled with -DUSING_ARCHIVE_LIB
# and -DUSING_SERIALIZATION_LIB

add_executable(consumer consumer.cpp)
# consumer is compiled with -DUSING_ARCHIVE_LIB
target_link_libraries(consumer arc
add_library(example INTERFACE)
set_target_properties(example PROPERTIES
  TRANSITIVE_COMPILE_PROPERTIES "CUSTOM_C"
  TRANSITIVE_LINK_PROPERTIES    "CUSTOM_L"

  INTERFACE_CUSTOM_C "EXAMPLE_CUSTOM_C"
  INTERFACE_CUSTOM_L "EXAMPLE_CUSTOM_L"
  )

add_library(mylib STATIC mylib.c)
target_link_libraries(mylib PRIVATE example)
set_target_properties(mylib PROPERTIES
  CUSTOM_C           "MYLIB_PRIVATE_CUSTOM_C"
  CUSTOM_L           "MYLIB_PRIVATE_CUSTOM_L"
  INTERFACE_CUSTOM_C "MYLIB_IFACE_CUSTOM_C"
  INTERFACE_CUSTOM_L "MYLIB_IFACE_CUSTOM_L"
  )

add_executable(myexe myexe.c)
target_link_libraries(myexe PRIVATE mylib)
set_target_properties(myexe PROPERTIES
  CUSTOM_C "MYEXE_CUSTOM_C"
  CUSTOM_L "MYEXE_CUSTOM_L"
  )

add_custom_target(print ALL VERBATIM
  COMMAND ${CMAKE_COMMAND} -E echo
    # Prints "MYLIB_PRIVATE_CUSTOM_C;EXAMPLE_CUSTOM_C"
    "$<TARGET_PROPERTY:mylib,CUSTOM_C>"

    # Prints "MYLIB_PRIVATE_CUSTOM_L;EXAMPLE_CUSTOM_L"
    "$<TARGET_PROPERTY:mylib,CUSTOM_L>"

    # Prints "MYEXE_CUSTOM_C"
    "$<TARGET_PROPERTY:myexe,CUSTOM_C>"

    # Prints "MYEXE_CUSTOM_L;MYLIB_IFACE_CUSTOM_L;EXAMPLE_CUSTOM_L"
    "$<TARGET_PROPERTY:myexe,CUSTOM_L>"
  )
  add_library(lib1Version2 SHARED lib1_v2.cpp)
set_property(TARGET lib1Version2 PROPERTY INTERFACE_CUSTOM_PROP ON)
set_property(TARGET lib1Version2 APPEND PROPERTY
  COMPATIBLE_INTERFACE_BOOL CUSTOM_PROP
)

add_library(lib1Version3 SHARED lib1_v3.cpp)
set_property(TARGET lib1Version3 PROPERTY INTERFACE_CUSTOM_PROP OFF)

add_executable(exe1 exe1.cpp)
target_link_libraries(exe1 lib1Version2) # CUSTOM_PROP will be ON

add_executable(exe2 exe2.cpp)
target_link_libraries(exe2 lib1Version2 lib1Version3) # Diagnostic
add_library(lib1Version2 SHARED lib1_v2.cpp)
set_property(TARGET lib1Version2 PROPERTY
  INTERFACE_CONTAINER_SIZE_REQUIRED 200)
set_property(TARGET lib1Version2 APPEND PROPERTY
  COMPATIBLE_INTERFACE_NUMBER_MAX CONTAINER_SIZE_REQUIRED
)

add_executable(exe1 exe1.cpp)
target_link_libraries(exe1 lib1Version2)
target_compile_definitions(exe1 PRIVATE
    CONTAINER_SIZE=$<TARGET_PROPERTY:CONTAINER_SIZE_REQUIRED>
)
add_library(lib1 lib1.cpp)
target_compile_definitions(lib1 INTERFACE
  $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:LIB1_WITH_EXE>
  $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:LIB1_WITH_SHARED_LIB>
  $<$<TARGET_POLICY:CMP0182>:CONSUMER_CMP0182_NEW>
)

add_executable(exe1 exe1.cpp)
target_link_libraries(exe1 lib1)

cmake_policy(SET CMP0182 NEW)

add_library(shared_lib shared_lib.cpp)
target_link_libraries(shared_lib lib1)
add_library(ClimbingStats climbingstats.cpp)
target_compile_definitions(ClimbingStats INTERFACE
  $<BUILD_INTERFACE:ClimbingStats_FROM_BUILD_LOCATION>
  $<INSTALL_INTERFACE:ClimbingStats_FROM_INSTALLED_LOCATION>
)
install(TARGETS ClimbingStats EXPORT libExport ${InstallArgs})
install(EXPORT libExport NAMESPACE Upstream::
        DESTINATION lib/cmake/ClimbingStats)
export(EXPORT libExport NAMESPACE Upstream::)

add_executable(exe1 exe1.cpp)
target_link_libraries(exe1 ClimbingStats)
add_library(lib1 lib1.cpp)
add_library(lib2 lib2.cpp)
target_link_libraries(lib1 PUBLIC
  $<$<TARGET_PROPERTY:POSITION_INDEPENDENT_CODE>:lib2>
)
add_library(lib3 lib3.cpp)
set_property(TARGET lib3 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

add_executable(exe1 exe1.cpp)
target_link_libraries(exe1 lib1 lib3)



