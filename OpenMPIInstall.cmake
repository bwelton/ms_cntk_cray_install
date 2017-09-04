file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/wrappers)
configure_file (
    "${PROJECT_SOURCE_DIR}/install_wrappers/BuildOpenMPI.ksh.in"
	"${PROJECT_BINARY_DIR}/wrappers/BuildOpenMPI.ksh"
	@ONLY
)
configure_file (
    "${PROJECT_SOURCE_DIR}/install_wrappers/BuildOpenMPI.sh.in"
	"${PROJECT_BINARY_DIR}/wrappers/BuildOpenMPI.sh"
	@ONLY
)

ExternalProject_Add(
	spack 
	GIT_REPOSITORY "https://github.com/bwelton/spack.git"
	SOURCE_DIR "${PROJECT_BINARY_DIR}/3rdparty/spack"
	CONFIGURE_COMMAND ""
	BUILD_COMMAND bash ${PROJECT_BINARY_DIR}/wrappers/BuildOpenMPI.sh
	UPDATE_COMMAND ""
	)