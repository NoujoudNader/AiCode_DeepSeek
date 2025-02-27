add_executable(dgemm-cpp dgemm.cpp)
if(OpenMP_CXX_FOUND)
    target_link_libraries(dgemm-cpp PUBLIC OpenMP::OpenMP_CXX)
endif()

add_executable(dgemm-f dgemm.f90)
if(OpenMP_CXX_FOUND)
    target_link_libraries(dgemm-f PUBLIC OpenMP::OpenMP_CXX)
endif()