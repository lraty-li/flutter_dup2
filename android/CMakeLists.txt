cmake_minimum_required(VERSION 3.4.1)  # for example

add_library( runDup2

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ../ios/Classes/native_dup2.cpp )