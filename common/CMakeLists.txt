cmake_minimum_required(VERSION 3.22.0)

project(SharedUtils CXX C)

###### generate project path in .h file inside commons folder.
# configure_file(project_paths.h.in ${CMAKE_CURRENT_SOURCE_DIR}/project_paths.h @ONLY)

# -----------------------------------------------------------------------------------------------------------------------
# Get a Library's location path
# -----------------------------------------------------------------------------------------------------------------------

# add_custom_target(dummy ALL
#     DEPENDS always_rebuild
#     COMMAND ${CMAKE_COMMAND}
#         -D lib=$<TARGET_FILE_DIR:assimp>
#         -P ${CMAKE_SOURCE_DIR}/cmake_macros/getLibLoc.cmake
#     COMMENT "Running script..."
#     # WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
# )

# add_custom_command(
#     OUTPUT always_rebuild
#     COMMAND cmake -E echo
# )

# -----------------------------------------------------------------------------------------------------------------------

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
set_target_properties(SharedUtils PROPERTIES
    FOLDER "Shared"  # This groups the target under "Shared" in Xcode
    XCODE_ATTRIBUTE_ORGANIZATION "Shared Utilities"
)

# Standard properties
set_target_properties(SharedUtils PROPERTIES
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)