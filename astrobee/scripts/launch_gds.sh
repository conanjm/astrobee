#!/bin/bash
#
# Copyright (c) 2017, United States Government, as represented by the
# Administrator of the National Aeronautics and Space Administration.
#
# All rights reserved.
#
# The Astrobee platform is licensed under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with the
# License. You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Fix for vmware issues with OpenGL
LIBGL_ALWAYS_SOFTWARE=1

# Set the arch
arch=`uname -i`
if [ "${arch}" = "x86_64" ]; then
  ld_arch=${arch}
else
  ld_arch="x86"
fi

# We are not running in a known context, so look for script arguments
if [ -z ${ASTROBEE_WORLD+x} ] ; then
  if [ $# -ge 1 ] ; then
    ASTROBEE_WORLD="$1"
  else
    echo "Error: set ASTROBEE_WORLD or provide an 'world' argument"
    exit -1
  fi
fi

# Should be set by launch script
cd ~/gds/latest

# Add libraries to our search path
export LD_LIBRARY_PATH=$PWD/plugins/com.rti.dds.target_5.2.3/os/linux/${ld_arch}/:$LD_LIBRARY_PATH

unset arch
unset ld_arch

if [ "$ASTROBEE_WORLD" == "iss" ]; then
	exec ./AstroBeeWB -engineering -noZoomToClick -precision 3 > /dev/null 2>&1
elif [ "$ASTROBEE_WORLD" == "granite" ]; then
  exec ./AstroBeeWB -engineering -agent1 Bsharp -agent2 Bumble -agent3 killer -noZoomToClick -precision 3 -world GraniteLab
elif [ "$ASTROBEE_WORLD" == "mgtf" ]; then
	exec ./AstroBeeWB -engineering -agent1 P4C -noZoomToClick -precision 3 -mgtfLab > /dev/null 2>&1
fi
