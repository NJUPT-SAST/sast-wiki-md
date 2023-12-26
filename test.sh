#!/bin/bash

ORIGDIR=$PWD
git switch upstream/main
cd ..
git clone https://github.com/NJUPT-SAST/sast-wiki.git
cd sast-wiki
git switch main
cp -r $ORIGDIR docs/
mkdocs build
