#!/bin/bash
set -e

# Configuration
MC_ALIAS="local"
MINIO_ENDPOINT="http://127.0.0.1:9000"
ACCESS_KEY="admin"
SECRET_KEY="password"
TEST_BUCKET="smoke-test-bucket-$(date +%s)"
TEST_FILE="smoke-test-file.txt"
DOWNLOADED_FILE="downloaded-smoke-file.txt"

# Function to run mc commands
# If Docker is available and MC_HOST is not set locally (or we want to enforce docker), use docker
# But for the CI, we are already inside a runner.
# The previous workflow used: docker run --network host --rm -e MC_HOST_local=... minio/mc ls local
# We will replicate that behavior for the script to be portable.

mc_cmd() {
    docker run --network host --rm -i \
        -e MC_HOST_${MC_ALIAS}="http://${ACCESS_KEY}:${SECRET_KEY}@127.0.0.1:9000" \
        minio/mc "$@"
}

echo "Waiting for MinIO to be ready..."
for i in {1..30}; do
    if mc_cmd ls ${MC_ALIAS} > /dev/null 2>&1; then
        echo "MinIO is ready."
        break
    fi
    echo "Waiting for MinIO... ($i/30)"
    sleep 2
done

echo "Creating test bucket: ${TEST_BUCKET}"
mc_cmd mb ${MC_ALIAS}/${TEST_BUCKET}

echo "Creating test file"
echo "This is a smoke test file created at $(date)" > ${TEST_FILE}

echo "Uploading file to ${MC_ALIAS}/${TEST_BUCKET}/${TEST_FILE}"
# For upload, we need to map the file into the container or pipe it.
# Piping is easier.
cat ${TEST_FILE} | mc_cmd pipe ${MC_ALIAS}/${TEST_BUCKET}/${TEST_FILE}

echo "Verifying file existence"
mc_cmd ls ${MC_ALIAS}/${TEST_BUCKET}/${TEST_FILE}

echo "Downloading file from ${MC_ALIAS}/${TEST_BUCKET}/${TEST_FILE}"
# Pipe stdout to file
mc_cmd cat ${MC_ALIAS}/${TEST_BUCKET}/${TEST_FILE} > ${DOWNLOADED_FILE}

echo "Comparing files"
if diff ${TEST_FILE} ${DOWNLOADED_FILE}; then
    echo "Files match. Smoke test passed!"
else
    echo "Files do not match!"
    exit 1
fi

echo "Cleaning up"
mc_cmd rm ${MC_ALIAS}/${TEST_BUCKET}/${TEST_FILE}
mc_cmd rb ${MC_ALIAS}/${TEST_BUCKET}
rm ${TEST_FILE} ${DOWNLOADED_FILE}

echo "Done."
