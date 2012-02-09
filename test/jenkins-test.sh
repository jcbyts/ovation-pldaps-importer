#!/bin/bash

cd test
echo "Running tests with $MATLAB..."
export PATH=$MATLAB_ROOT/bin:$PATH
touch startup.m
matlab -nodisplay -nodesktop -r "addpath(OVATION_MATLAB);addpath(getenv('MATLAB_XUNIT_PATH'));javaaddpath(getenv('OVATION_JAR_PATH'));ovation.OvationMatlabStartup(); runtestsuite test; exit(0)"
cd ..