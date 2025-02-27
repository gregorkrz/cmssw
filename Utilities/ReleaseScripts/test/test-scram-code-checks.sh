#!/bin/bash -ex

ORIG_TEST_PATH=$SCRAM_TEST_PATH
scram project $CMSSW_VERSION
cd $CMSSW_VERSION

#Get FWCore/Version
mkdir src/FWCore
RefDir=$CMSSW_BASE/src/FWCore/Version
[ -e $RefDir ] || RefDir=$CMSSW_RELEASE_BASE/src/FWCore/Version
rsync -a --no-g $RefDir/ src/FWCore/Version/
chmod -R u+w src/FWCore/Version

#Get latest clang-tidy and format files
RefDir=$CMSSW_BASE/src
[ -e ${RefDir}/.clang-tidy ] || RefDir=$CMSSW_RELEASE_BASE/src
cp ${RefDir}/.clang-tidy src/
cp ${RefDir}/.clang-format src/

#Get latest build rules
rm -rf config/SCRAM
rsync -a $CMSSW_BASE/config/SCRAM/ config/SCRAM/

#Make sure external release external lib/bin are in env
chmod a-x config/SCRAM/hooks/runtime/50-remove-release-external-lib

#Test clang-tidy
cp $ORIG_TEST_PATH/test-clang-tidy.cc src/FWCore/Version/src
cp $ORIG_TEST_PATH/test-clang-tidy.h src/FWCore/Version/src
FILES="src/FWCore/Version/src/test-clang-tidy.cc src/FWCore/Version/src/test-clang-tidy.h"
USER_CODE_CHECKS_FILES="${FILES}" scram b code-checks

diff -u src/FWCore/Version/src/test-clang-tidy.cc $ORIG_TEST_PATH/ref/test-clang-tidy.cc
diff -u src/FWCore/Version/src/test-clang-tidy.h $ORIG_TEST_PATH/ref/test-clang-tidy.h
cp $ORIG_TEST_PATH/test-clang-tidy.cc src/FWCore/Version/src
scram b code-checks-all
diff -u src/FWCore/Version/src/test-clang-tidy.cc $ORIG_TEST_PATH/ref/test-clang-tidy.cc
diff -u src/FWCore/Version/src/test-clang-tidy.h $ORIG_TEST_PATH/ref/test-clang-tidy.h

#Test clang-format
sed -i -e 's|int m_x|    int     m_x   |'      src/FWCore/Version/src/test-clang-tidy.cc
sed -i -e 's|override_func|  override_func  |' src/FWCore/Version/src/test-clang-tidy.h
USER_CODE_FORMAT_FILES="${FILES}" scram b code-format
diff -u src/FWCore/Version/src/test-clang-tidy.cc $ORIG_TEST_PATH/ref/test-clang-tidy.cc
diff -u src/FWCore/Version/src/test-clang-tidy.h $ORIG_TEST_PATH/ref/test-clang-tidy.h
