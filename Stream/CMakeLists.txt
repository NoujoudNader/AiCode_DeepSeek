add_executable(stream-cpp stream.cpp)
if(OpenMP_CXX_FOUND)
    target_link_libraries(stream-cpp PUBLIC OpenMP::OpenMP_CXX)
endif()

add_executable(stream-f stream.f90)
target_compile_options(stream-f PRIVATE -fcoarray=single)
    
