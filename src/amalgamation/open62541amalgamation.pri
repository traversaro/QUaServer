# TODO : handle other open62541 options (e.g. full namespace)
# TODO : help needed for MINGW on Windows
# TODO : help needed for LINUX
# TODO : help needed for MAC

# Options

ua_namespace_full {
	UA_NAMESPACE = "-DUA_NAMESPACE_ZERO=FULL"
}
ua_events {
	UA_NAMESPACE = "-DUA_NAMESPACE_ZERO=FULL"
	UA_EVENTS    = "-DUA_ENABLE_SUBSCRIPTIONS_EVENTS=ON"
}

# Paths
OPEN62541_PATH       = $$PWD/../../depends/open62541.git
OPEN62541_BUILD_PATH = $$OPEN62541_PATH/build
OPEN62541_H_PATH     = $$OPEN62541_BUILD_PATH/open62541.h
OPEN62541_C_PATH     = $$OPEN62541_BUILD_PATH/open62541.c
OPEN62541_H_LOCAL    = $$PWD/open62541.h
OPEN62541_C_LOCAL    = $$PWD/open62541.c
# Generate amalgamation (only once)
if(!build_pass) {
	# Windows
	win32 {
		message("Compiling Open62541 for Windows")
		# Fix PWD slashes
		OPEN62541_PATH_WIN = $$OPEN62541_PATH
		OPEN62541_PATH_WIN ~= s,/,\\,g
		OPEN62541_BUILD_PATH_WIN = $$OPEN62541_BUILD_PATH
		OPEN62541_BUILD_PATH_WIN ~= s,/,\\,g
		# Look for CMake
		CMAKE_BIN = $$system(where cmake)
		isEmpty(CMAKE_BIN) {
			error("CMake not found. Cannot build open62541 amalgamation.")
		}
		else {
			message("CMake found.")
		}
		# Look for msbuild
		MSBUILD_BIN = $$system(where msbuild)
		isEmpty(MSBUILD_BIN) {
			error("MsBuild not found. Cannot build open62541 amalgamation.")
		}
		else {
			message("MsBuild found.")
		}
		# Clean up old build if any
		exists($${OPEN62541_BUILD_PATH}) {
			system("rmdir $${OPEN62541_BUILD_PATH_WIN} /s /q")
		}
		# Create build
		BUILD_CREATED = FALSE
		system("mkdir $${OPEN62541_BUILD_PATH_WIN}"): BUILD_CREATED = TRUE
		equals(BUILD_CREATED, TRUE) {
			message("Build directory created for open62541.")
		}
		else {
			error("Build directory could not be created for open62541.")
		}
		# Find compatible compiler
		MSVC_VER = $$(VisualStudioVersion)
	    equals(MSVC_VER, 12.0){
			message("Compiler Detected : MSVC++ 12.0 (Visual Studio 2013)")
			COMPILER = "Visual Studio 12 2013"
	    }
	    equals(MSVC_VER, 14.0){
			message("Compiler Detected : MSVC++ 14.0 (Visual Studio 2015)")
			COMPILER = "Visual Studio 14 2015"
	    }
	    equals(MSVC_VER, 15.0){
			message("Compiler Detected : MSVC++ 15.0 (Visual Studio 2017)")
			COMPILER = "Visual Studio 15 2017"
	    }
	    equals(MSVC_VER, 16.0){
			message("Compiler Detected : MSVC++ 16.0 (Visual Studio 2019)")
			COMPILER = "Visual Studio 16 2019"
	    }
	    isEmpty(COMPILER) {
			error("No compatible compiler found to generate open62541 amalgamation.")
		}
	    # Find platform
		contains(QT_ARCH, i386) {
			message("Platform Detected : 32 bits")
			PLATFORM = "Win32"	
		}
		contains(QT_ARCH, x86_64) {
			message("Platform Detected : 64 bits")
			PLATFORM = "x64"			
		}
		isEmpty(PLATFORM) {
			error("Non compatible platform $${QT_ARCH} to generate open62541 amalgamation.")
		}
		# Generate CMake project
		PROJECT_CREATED = FALSE
		system("cmake $${OPEN62541_PATH_WIN} -B$${OPEN62541_BUILD_PATH_WIN} -DUA_ENABLE_AMALGAMATION=ON $${UA_NAMESPACE} $${UA_EVENTS} -G \"$${COMPILER}\" -A $${PLATFORM}"): PROJECT_CREATED = TRUE
		equals(BUILD_CREATED, TRUE) {
			message("CMake generate open62541 successful.")
		}
		else {
			error("CMake generate open62541 failed.")
		}
		# Build Visual Studio project
		PROJECT_BUILT = FALSE
		system("msbuild $${OPEN62541_BUILD_PATH_WIN}\open62541.sln"): PROJECT_BUILT = TRUE
		equals(BUILD_CREATED, TRUE) {
			message("Open62541 build successful.")
		}
		else {
			error("Open62541 build failed.")
		}		
		# Copy amalgamation locally
		# Fix PWD slashes
		OPEN62541_H_PATH_WIN  = $$OPEN62541_H_PATH
		OPEN62541_H_PATH_WIN ~= s,/,\\,g
		OPEN62541_C_PATH_WIN  = $$OPEN62541_C_PATH
		OPEN62541_C_PATH_WIN ~= s,/,\\,g
		OPEN62541_H_LOCAL_WIN  = $$OPEN62541_H_LOCAL
		OPEN62541_H_LOCAL_WIN ~= s,/,\\,g
		OPEN62541_C_LOCAL_WIN  = $$OPEN62541_C_LOCAL
		OPEN62541_C_LOCAL_WIN ~= s,/,\\,g
		# Copy header
		H_COPY = FALSE
		system("copy /y $${OPEN62541_H_PATH_WIN} $${OPEN62541_H_LOCAL_WIN}"): H_COPY = TRUE
		equals(H_COPY, TRUE) {
			message("Open62541 header file copied locally.")
		}
		else {
			error("Failed to copy open62541 header file.")
		}
		# Copy source
		C_COPY = FALSE
		system("copy /y $${OPEN62541_C_PATH_WIN} $${OPEN62541_C_LOCAL_WIN}"): C_COPY = TRUE
		equals(C_COPY, TRUE) {
			message("Open62541 source file copied locally.")
		}
		else {
			error("Failed to copy open62541 source file.")
		}
	}
	# Linux
	linux-g++ {
		#message("Compiling Open62541 for Linux.")
		if(!exists($${OPEN62541_H_LOCAL}) || !exists($${OPEN62541_C_LOCAL})) {
			error("Automatic QMake build for open62541 amalgamation not yet supported on Linux. Please build it manually and move the files here.")
		}
	}
	# Mac OS
	mac {
		#message("Compiling Open62541 for Mac.")
		if(!exists($${OPEN62541_H_LOCAL}) || !exists($${OPEN62541_C_LOCAL})) {
			error("Automatic QMake build for open62541 amalgamation not yet supported on Mac. Please build it manually and move the files here.")
		}
	}	
}
