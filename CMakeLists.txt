project(DeepSeek LANGUAGES CXX Fortran)
cmake_minimum_required(VERSION 3.0)

find_package(OpenMP)

add_subdirectory(Conjugate_gradient)
add_subdirectory(Matrix\ Multiplication)
add_subdirectory(Parallel\ Heat)
add_subdirectory(Stream)
add_subdirectory(DGEMM)

