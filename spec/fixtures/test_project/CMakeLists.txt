cmake_minimum_required(VERSION 2.8)

project(test_project)

SET(LIBRARY_NAME ltest_project)

aux_source_directory(./src/ SRC_LIST)
aux_source_directory(./src/data/ DATA_LIST)

add_executable(${PROJECT_NAME} ${SRC_LIST} ${DATA_LIST})

target_link_libraries(${PROJECT_NAME} m)

add_library(${LIBRARY_NAME} SHARED ${DATA_LIST})