add_executable(mat-cpp pmp.cpp)
if(OpenMP_CXX_FOUND)
    target_link_libraries(mat-cpp PUBLIC OpenMP::OpenMP_CXX)
endif()

add_executable(mat-f pmp.f90)
if(OpenMP_CXX_FOUND)
    target_link_libraries(mat-f PUBLIC OpenMP::OpenMP_CXX)
endif()
