add_executable(cg-cpp cg.cpp)
if(OpenMP_CXX_FOUND)
    target_link_libraries(cg-cpp PUBLIC OpenMP::OpenMP_CXX)
endif()

add_executable(cg-f cg.f90)
if(OpenMP_CXX_FOUND)
    target_link_libraries(cg-f PUBLIC OpenMP::OpenMP_CXX)
endif()
