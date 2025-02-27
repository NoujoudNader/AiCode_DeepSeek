add_executable(heat-cpp heat.cpp)
if(OpenMP_CXX_FOUND)
    target_link_libraries(heat-cpp PUBLIC OpenMP::OpenMP_CXX)
endif()

add_executable(heat-f heat.f90)
if(OpenMP_CXX_FOUND)
    target_link_libraries(heat-f PUBLIC OpenMP::OpenMP_CXX)
endif()
