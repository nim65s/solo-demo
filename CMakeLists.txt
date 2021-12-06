cmake_minimum_required(VERSION 3.16)

project(solo-meta)

include(ExternalProject)

set(META_CMAKE_ARGS
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DCMAKE_C_COMPILER_LAUNCHER=${CMAKE_C_COMPILER_LAUNCHER}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX})
set(JRL_CMAKE_ARGS
  -DPYTHON_STANDARD_LAYOUT=ON
  -DPYTHON_DEB_LAYOUT=ON
  -DPYTHON_EXECUTABLE=/usr/bin/python3
  -DBUILD_TESTING=OFF)
set(OSQP_CMAKE_ARGS
  -DPRINTING=OFF
  -DPROFILING=OFF
  -DDLONG=OFF)

ExternalProject_Add("eigenpy"
  GIT_REPOSITORY "https://github.com/stack-of-tasks/eigenpy"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${JRL_CMAKE_ARGS})
ExternalProject_Add("hpp-fcl"
  GIT_REPOSITORY "https://github.com/humanoid-path-planner/hpp-fcl"
  DEPENDS "eigenpy"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${JRL_CMAKE_ARGS})
ExternalProject_Add("pinocchio"
  GIT_REPOSITORY "https://github.com/stack-of-tasks/pinocchio"
  DEPENDS "hpp-fcl"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${JRL_CMAKE_ARGS})
ExternalProject_Add("eiquadprog"
  GIT_REPOSITORY "https://github.com/stack-of-tasks/eiquadprog"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${JRL_CMAKE_ARGS})
ExternalProject_Add("example-robot-data"
  GIT_REPOSITORY "https://github.com/gepetto/example-robot-data"
  DEPENDS "pinocchio"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${JRL_CMAKE_ARGS})
ExternalProject_Add("osqp"
  GIT_REPOSITORY "https://github.com/osqp/osqp"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${OSQP_CMAKE_ARGS})
ExternalProject_Add("master-board"
  GIT_REPOSITORY "https://github.com/nim65s/master-board"
  SOURCE_SUBDIR "sdk/master_board_sdk"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${JRL_CMAKE_ARGS})
ExternalProject_Add("odri_control_interface"
  GIT_REPOSITORY "https://github.com/nim65s/odri_control_interface"
  GIT_TAG "successive-calib"
  DEPENDS "master-board" "eigenpy"
  CMAKE_ARGS ${META_CMAKE_ARGS} ${JRL_CMAKE_ARGS})
ExternalProject_Add("quadruped-reactive-walking"
  GIT_REPOSITORY "https://github.com/nim65s/quadruped-reactive-walking"
  GIT_TAG "demo-raspberry"
  DEPENDS "odri_control_interface" "osqp" "eiquadprog" "pinocchio" "example-robot-data"
  CMAKE_ARGS ${META_CMAKE_ARGS})
