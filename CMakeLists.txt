cmake_minimum_required (VERSION 2.8.11)
SET(CMAKE_CXX_STANDARD 11)
include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)
project(cntk_install)

find_package(Boost COMPONENTS system thread REQUIRED)
find_package(PythonLibs REQUIRED)
find_package(PythonInterp REQUIRED)

cmake_host_system_information(RESULT BUILD_HOST QUERY HOSTNAME)
if ("${BUILD_HOST}" MATCHES "(titan-ext)[1-7]")
	## Set ProjID for job launching
	set(PROJ_ID "$ENV{PROJ_ID}")
	set(CRAY_MACHINE "Yes")
	set(CUDA_TOOLKIT_ROOT_DIR "$ENV{CRAY_CUDATOOLKIT_DIR}")
	add_custom_target(CUDNN
  		COMMAND cp $ENV{CUDNN_DIR}/cudnn.h ${CMAKE_INSTALL_PREFIX}/include && cp $ENV{CUDNN_DIR}/libcudnn.so.5.1.10 ${CMAKE_INSTALL_PREFIX}/lib && ln -s ${CMAKE_INSTALL_PREFIX}/lib/libcudnn.so.5.1.10 ${CMAKE_INSTALL_PREFIX}/lib/libcudnn.so)
endif("${BUILD_HOST}" MATCHES "(titan-ext)[1-7]")

## Setup Python Paths
include(${CMAKE_SOURCE_DIR}/PythonInstall.cmake)
## Install Spack
#include(${CMAKE_SOURCE_DIR}/OpenMPIInstall.cmake)

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/wrappers)
configure_file (
    "${PROJECT_SOURCE_DIR}/install_wrappers/BuildCNTK.ksh.in"
	"${PROJECT_BINARY_DIR}/wrappers/BuildCNTK.ksh"
	@ONLY
)
configure_file (
    "${PROJECT_SOURCE_DIR}/install_wrappers/BuildCNTK.sh.in"
	"${PROJECT_BINARY_DIR}/wrappers/BuildCNTK.sh"
	@ONLY
)

ExternalProject_Add(
	spack 
	URL "http://pages.cs.wisc.edu/~welton/spack_titan.tar.gz"
	URL_MD5 "c4fe0a279f4d6f74aeba99e89567b460"
	SOURCE_DIR "${PROJECT_BINARY_DIR}/3rdparty/spack"
	CONFIGURE_COMMAND ""
	BUILD_COMMAND bash ${PROJECT_BINARY_DIR}/wrappers/BuildCNTK.sh
	UPDATE_COMMAND ""
)
