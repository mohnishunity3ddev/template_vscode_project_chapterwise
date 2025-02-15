cmake_minimum_required(VERSION 3.22.0)

project(SharedUtils CXX C)

file(GLOB_RECURSE SRC_FILES     LIST_DIRECTORIES false RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.c *.c??)
file(GLOB_RECURSE HEADER_FILES  LIST_DIRECTORIES false RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.h)

# -----------------------------------------------------------------------------
# Create the library target
# -----------------------------------------------------------------------------
if(SRC_FILES)
    # Create normal library if we have source files
    add_library(SharedUtils ${SRC_FILES} ${HEADER_FILES})
else()
    # Create interface library for header-only
    add_library(SharedUtils INTERFACE)
    target_sources(SharedUtils INTERFACE ${HEADER_FILES})
endif()

# -----------------------------------------------------------------------------
# Target properties for both cases
# -----------------------------------------------------------------------------
# Set Xcode folder organization
if (XCODE)
    set_target_properties(SharedUtils PROPERTIES
        FOLDER "Shared"
        XCODE_ATTRIBUTE_ORGANIZATION "Shared Utilities"
    )
endif()

# Standard properties
set_target_properties(SharedUtils PROPERTIES
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)