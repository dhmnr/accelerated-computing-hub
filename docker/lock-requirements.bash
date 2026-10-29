#! /bin/bash
#
# Generate or check each tutorial's docker/requirements.lock.txt from its
# docker/requirements.txt.
#
# The lock pins every package, including dependencies, with hashes, and the
# tutorial's image installs only from it. It is resolved with Ubuntu 24.04's
# Python 3.12, the Python every tutorial image uses, inside a container so the
# host's Python does not matter. Existing pins are kept unless requirements.txt
# no longer allows them or --upgrade is given.
#
# Usage:
#   docker/lock-requirements.bash <tutorial>...            # update the locks
#   docker/lock-requirements.bash --upgrade <tutorial>...  # move to the newest allowed versions
#   docker/lock-requirements.bash --check <tutorial>...    # fail if a lock is out of date
#
# With no tutorials, every tutorial with a docker/requirements.txt is used.

set -euo pipefail

PIP_VERSION=26.2.2
PIP_TOOLS_VERSION=7.6.2
LOCK_IMAGE=ubuntu:24.04

SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "${SCRIPT_PATH}/.." && pwd)

MODE=update
case "${1:-}" in
    --check) MODE=check; shift ;;
    --upgrade) MODE=upgrade; shift ;;
esac

if [ $# -eq 0 ]; then
    mapfile -t TUTORIALS < <("${SCRIPT_PATH}/discover-tutorials.bash" | xargs -n1 basename)
else
    TUTORIALS=("$@")
fi

STATUS=0
for TUTORIAL in "${TUTORIALS[@]}"; do
    DOCKER_DIR="tutorials/${TUTORIAL}/docker"
    if [ ! -f "${REPO_ROOT}/${DOCKER_DIR}/requirements.txt" ]; then
        echo "Skipping ${TUTORIAL}: no ${DOCKER_DIR}/requirements.txt"
        continue
    fi
    echo "Locking ${TUTORIAL}..."

    UPGRADE_FLAG=""
    [ "${MODE}" = upgrade ] && UPGRADE_FLAG="--upgrade"

    NEW_LOCK=$(mktemp)
    # The repository is mounted read-only; the lock is written to stdout.
    docker run --rm --network host \
        -v "${REPO_ROOT}:/src:ro" \
        -v ach-lock-pip-cache:/root/.cache/pip \
        -w "/src/${DOCKER_DIR}" \
        -e CUSTOM_COMPILE_COMMAND="docker/lock-requirements.bash ${TUTORIAL}" \
        "${LOCK_IMAGE}" bash -euo pipefail -c "
            apt-get update -qq >/dev/null
            DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
                ca-certificates git python3-venv >/dev/null
            python3 -m venv /tmp/venv
            /tmp/venv/bin/pip install -q 'pip==${PIP_VERSION}' 'pip-tools==${PIP_TOOLS_VERSION}'
            if [ -f requirements.lock.txt ]; then cp requirements.lock.txt /tmp/requirements.lock.txt; fi
            /tmp/venv/bin/pip-compile --quiet --generate-hashes --allow-unsafe --strip-extras \
                ${UPGRADE_FLAG} --output-file /tmp/requirements.lock.txt requirements.txt >&2
            cat /tmp/requirements.lock.txt
        " > "${NEW_LOCK}"

    LOCK="${REPO_ROOT}/${DOCKER_DIR}/requirements.lock.txt"
    if [ "${MODE}" = check ]; then
        if ! diff -u "${LOCK}" "${NEW_LOCK}" > /dev/null 2>&1; then
            echo "❌ ${DOCKER_DIR}/requirements.lock.txt is out of date with requirements.txt."
            echo "   Run: docker/lock-requirements.bash ${TUTORIAL}"
            diff -u "${LOCK}" "${NEW_LOCK}" | head -n 40 || true
            STATUS=1
        else
            echo "✅ ${DOCKER_DIR}/requirements.lock.txt is up to date."
        fi
    else
        cat "${NEW_LOCK}" > "${LOCK}"
        echo "Wrote ${DOCKER_DIR}/requirements.lock.txt"
    fi
    rm -f "${NEW_LOCK}"
done

exit "${STATUS}"
