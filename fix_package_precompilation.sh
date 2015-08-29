#!/bin/bash
set -e

pkg_dir=/root/.julia/v0.4

find $pkg_dir -mindepth 1 -maxdepth 1 -type d -printf '%P\n' | while read pkg; do
  echo "Analyzing package ${pkg}..." >&2
  pkg_file="${pkg_dir}/${pkg}/src/${pkg}.jl"
  if [ -f "$pkg_file" ]; then
    if ! grep -q '__precompile__(\(true\|false\))' "$pkg_file"; then
      echo "Adding __precompile__(true) to ${pkg}..." >&2
      sed -i '1i VERSION >= v"0.4.0-dev+6641" && __precompile__(true)' "$pkg_file"
    fi
  fi
done
