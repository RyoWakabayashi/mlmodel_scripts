#!/bin/bash

cat Extensions/* Modules/* DetectObject.swift | swift - $1 $2
