# Only if encryption enabled
ua_encryption {
	# Only once
	if(!build_pass) {
		# Paths
		MBEDTLS_PATH = $$PWD/../../depends/mbedtls.git
		MBEDTLS_BUILD_PATH = $$MBEDTLS_PATH/build
		# Windows
		win32 {
			message("Compiling MbedTLS for Windows")
			# Fix PWD slashes
			MBEDTLS_PATH_WIN = $$MBEDTLS_PATH
			MBEDTLS_PATH_WIN ~= s,/,\\,g
			MBEDTLS_BUILD_PATH_WIN = $$MBEDTLS_BUILD_PATH
			MBEDTLS_BUILD_PATH_WIN ~= s,/,\\,g
			# Look for CMake
			CMAKE_BIN = $$system(where cmake)
			isEmpty(CMAKE_BIN) {
				error("CMake not found. Cannot build MbedTLS.")
			}
			else {
				message("CMake found.")
			}
			# Look for msbuild
			MSBUILD_BIN = $$system(where msbuild)
			isEmpty(MSBUILD_BIN) {
				error("MsBuild not found. Cannot build MbedTLS.")
			}
			else {
				message("MsBuild found.")
			}
			# Clean up old build if any
			exists($${MBEDTLS_BUILD_PATH}) {
				system("rmdir $${MBEDTLS_BUILD_PATH_WIN} /s /q")
			}
			# Create build
			BUILD_CREATED = FALSE
			system("mkdir $${MBEDTLS_BUILD_PATH_WIN}"): BUILD_CREATED = TRUE
			equals(BUILD_CREATED, TRUE) {
				message("Build directory created for MbedTLS.")
			}
			else {
				error("Build directory could not be created for MbedTLS.")
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
				error("No compatible compiler found to generate MbedTLS.")
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
				error("Non compatible platform $${QT_ARCH} to generate MbedTLS.")
			}
			# Generate CMake project
			PROJECT_CREATED = FALSE
			system("cmake $${MBEDTLS_PATH_WIN} -B$${MBEDTLS_BUILD_PATH_WIN} -G \"$${COMPILER}\" -A $${PLATFORM}"): PROJECT_CREATED = TRUE
			equals(BUILD_CREATED, TRUE) {
				message("CMake generate MbedTLS successful.")
			}
			else {
				error("CMake generate MbedTLS failed.")
			}
			# Build Visual Studio project
			PROJECT_BUILT = FALSE
			system("msbuild \"$${MBEDTLS_BUILD_PATH_WIN}\mbed TLS.sln\""): PROJECT_BUILT = TRUE
			equals(BUILD_CREATED, TRUE) {
				message("MbedTLS build successful.")
			}
			else {
				error("MbedTLS build failed.")
			}
		}
		# Linux
		linux-g++ {
			#message("Compiling MbedTLS for Linux.")
			message("Automatic QMake build for MbedTLS not yet supported on Linux. Please build it manually.")
		}
		# Mac OS
		mac {
			#message("Compiling MbedTLS for Mac.")
			message("Automatic QMake build for MbedTLS not yet supported on Mac. Please build it manually.")
		}	
	}
}
