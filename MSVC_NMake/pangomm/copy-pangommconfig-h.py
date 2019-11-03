#! /usr/bin/env python3

import os
import sys
from shutil import copyfile

if len(sys.argv) != 3:
   raise ValueError('build root directory and current build directory required')

srcfile = os.path.join(sys.argv[1], 'pango', 'pangommconfig.h')
destfile = os.path.join(sys.argv[2], 'pangommconfig.h')

copyfile(srcfile, destfile)
