# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/home/enoc/projecte/OpenCV&BGS/Background_Pipe"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/home/enoc/projecte/OpenCV&BGS/Background_Pipe"

# Include any dependencies generated for this target.
include CMakeFiles/output.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/output.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/output.dir/flags.make

CMakeFiles/output.dir/Proximity.cpp.o: CMakeFiles/output.dir/flags.make
CMakeFiles/output.dir/Proximity.cpp.o: Proximity.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report "/home/enoc/projecte/OpenCV&BGS/Background_Pipe/CMakeFiles" $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/output.dir/Proximity.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/output.dir/Proximity.cpp.o -c "/home/enoc/projecte/OpenCV&BGS/Background_Pipe/Proximity.cpp"

CMakeFiles/output.dir/Proximity.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/output.dir/Proximity.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E "/home/enoc/projecte/OpenCV&BGS/Background_Pipe/Proximity.cpp" > CMakeFiles/output.dir/Proximity.cpp.i

CMakeFiles/output.dir/Proximity.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/output.dir/Proximity.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S "/home/enoc/projecte/OpenCV&BGS/Background_Pipe/Proximity.cpp" -o CMakeFiles/output.dir/Proximity.cpp.s

CMakeFiles/output.dir/Proximity.cpp.o.requires:
.PHONY : CMakeFiles/output.dir/Proximity.cpp.o.requires

CMakeFiles/output.dir/Proximity.cpp.o.provides: CMakeFiles/output.dir/Proximity.cpp.o.requires
	$(MAKE) -f CMakeFiles/output.dir/build.make CMakeFiles/output.dir/Proximity.cpp.o.provides.build
.PHONY : CMakeFiles/output.dir/Proximity.cpp.o.provides

CMakeFiles/output.dir/Proximity.cpp.o.provides.build: CMakeFiles/output.dir/Proximity.cpp.o

# Object files for target output
output_OBJECTS = \
"CMakeFiles/output.dir/Proximity.cpp.o"

# External object files for target output
output_EXTERNAL_OBJECTS =

output: CMakeFiles/output.dir/Proximity.cpp.o
output: CMakeFiles/output.dir/build.make
output: /usr/local/lib/libopencv_videostab.so.2.4.9
output: /usr/local/lib/libopencv_video.so.2.4.9
output: /usr/local/lib/libopencv_ts.a
output: /usr/local/lib/libopencv_superres.so.2.4.9
output: /usr/local/lib/libopencv_stitching.so.2.4.9
output: /usr/local/lib/libopencv_photo.so.2.4.9
output: /usr/local/lib/libopencv_ocl.so.2.4.9
output: /usr/local/lib/libopencv_objdetect.so.2.4.9
output: /usr/local/lib/libopencv_nonfree.so.2.4.9
output: /usr/local/lib/libopencv_ml.so.2.4.9
output: /usr/local/lib/libopencv_legacy.so.2.4.9
output: /usr/local/lib/libopencv_imgproc.so.2.4.9
output: /usr/local/lib/libopencv_highgui.so.2.4.9
output: /usr/local/lib/libopencv_gpu.so.2.4.9
output: /usr/local/lib/libopencv_flann.so.2.4.9
output: /usr/local/lib/libopencv_features2d.so.2.4.9
output: /usr/local/lib/libopencv_core.so.2.4.9
output: /usr/local/lib/libopencv_contrib.so.2.4.9
output: /usr/local/lib/libopencv_calib3d.so.2.4.9
output: libbgs.so
output: /usr/local/lib/libopencv_videostab.so.2.4.9
output: /usr/local/lib/libopencv_ts.a
output: /usr/lib/i386-linux-gnu/libGLU.so
output: /usr/lib/i386-linux-gnu/libGL.so
output: /usr/lib/i386-linux-gnu/libSM.so
output: /usr/lib/i386-linux-gnu/libICE.so
output: /usr/lib/i386-linux-gnu/libX11.so
output: /usr/lib/i386-linux-gnu/libXext.so
output: /usr/local/lib/libopencv_superres.so.2.4.9
output: /usr/local/lib/libopencv_stitching.so.2.4.9
output: /usr/local/lib/libopencv_contrib.so.2.4.9
output: /usr/local/lib/libopencv_nonfree.so.2.4.9
output: /usr/local/lib/libopencv_ocl.so.2.4.9
output: /usr/local/lib/libopencv_gpu.so.2.4.9
output: /usr/local/lib/libopencv_photo.so.2.4.9
output: /usr/local/lib/libopencv_objdetect.so.2.4.9
output: /usr/local/lib/libopencv_legacy.so.2.4.9
output: /usr/local/lib/libopencv_video.so.2.4.9
output: /usr/local/lib/libopencv_ml.so.2.4.9
output: /usr/local/lib/libopencv_calib3d.so.2.4.9
output: /usr/local/lib/libopencv_features2d.so.2.4.9
output: /usr/local/lib/libopencv_highgui.so.2.4.9
output: /usr/local/lib/libopencv_imgproc.so.2.4.9
output: /usr/local/lib/libopencv_flann.so.2.4.9
output: /usr/local/lib/libopencv_core.so.2.4.9
output: CMakeFiles/output.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable output"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/output.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/output.dir/build: output
.PHONY : CMakeFiles/output.dir/build

CMakeFiles/output.dir/requires: CMakeFiles/output.dir/Proximity.cpp.o.requires
.PHONY : CMakeFiles/output.dir/requires

CMakeFiles/output.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/output.dir/cmake_clean.cmake
.PHONY : CMakeFiles/output.dir/clean

CMakeFiles/output.dir/depend:
	cd "/home/enoc/projecte/OpenCV&BGS/Background_Pipe" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/home/enoc/projecte/OpenCV&BGS/Background_Pipe" "/home/enoc/projecte/OpenCV&BGS/Background_Pipe" "/home/enoc/projecte/OpenCV&BGS/Background_Pipe" "/home/enoc/projecte/OpenCV&BGS/Background_Pipe" "/home/enoc/projecte/OpenCV&BGS/Background_Pipe/CMakeFiles/output.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : CMakeFiles/output.dir/depend
