#!/bin/bash
set -x -e

for PYBIN in /opt/python/*/bin; do
    ${PYBIN}/pip install cffi
    ${PYBIN}/pip wheel argon2_cffi -w wheelhouse/
done

for whl in wheelhouse/argon2_cffi*.whl; do
    auditwheel repair $whl -w /build/wheelhouse/
done

for PYBIN in /opt/python/*/bin/; do
    ${PYBIN}/pip install argon2_cffi -f /build/wheelhouse
    ${PYBIN}/python -c "import argon2; argon2.verify_password(argon2.hash_password(b'secret', b'somesalt'), b'secret')"
done
