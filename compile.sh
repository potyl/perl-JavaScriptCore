#!/bin/sh

exec clang -O0 -g3 $(pkg-config --libs --cflags javascriptcoregtk-3.0) -o jsc jsc.c
