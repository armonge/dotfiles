#!/bin/bash
# CVXOPT environment variables for scientific Python computing
# Load on demand with: source ~/.config/bashrc.d/cvxopt.sh
# Or use alias: load-cvxopt

# Use HOMEBREW_PREFIX if available (set by brew shellenv)
# Otherwise fall back to common location
BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# CVXOPT library paths
export CVXOPT_SUITESPARSE_INC_DIR="$BREW_PREFIX/include/suitesparse"
export CVXOPT_SUITESPARSE_LIB_DIR="$BREW_PREFIX/lib"
export CVXOPT_BLAS_LIB_DIR="$BREW_PREFIX/lib"
export CVXOPT_GLPK_INC_DIR="$BREW_PREFIX/include"
export CVXOPT_GLPK_LIB_DIR="$BREW_PREFIX/lib"

# Update library path
export DYLD_FALLBACK_LIBRARY_PATH="$BREW_PREFIX/lib:${DYLD_FALLBACK_LIBRARY_PATH}"

echo "✓ CVXOPT environment variables loaded"
