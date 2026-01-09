# SNGR Creative's MinIO Container Image

[![Build Status](https://github.com/sngrcreative/minio/actions/workflows/build-publish.yml/badge.svg)](https://github.com/sngrcreative/minio/actions/workflows/build-publish.yml)
[![GitHub License](https://img.shields.io/github/license/sngrcreative/minio)](https://github.com/sngrcreative/minio/blob/master/LICENSE)
![FIPS Compliant](https://img.shields.io/badge/Compliance-FIPS%20%7C%20CIS%20%7C%20STIG-success)

Hardened, **FIPS-compliant (BoringCrypto)**, AMD64-only MinIO Object Storage images built on top of Distroless and Chainguard (Wolfi) foundations. Designed for maximum security and compliance.

## Compliance & Security
All images in this repository are built with **`GOEXPERIMENT=boringcrypto`** enabled, using FIPS 140-2 validated cryptographic modules. They are designed to meet **CIS** benchmarks and **STIG** requirements.

## Quick Reference

- **Maintained by**: [SNGR Creative](https://github.com/sngrcreative)
- **Where to get help**: [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- **Where to file issues**: [GitHub Issues](https://github.com/sngrcreative/minio/issues)
- **Supported architectures**: `linux/amd64`

## Supported Tags

| Tag | Base Image | Description |
| :--- | :--- | :--- |
| `latest` | [Distroless Static](https://github.com/GoogleContainerTools/distroless) | **Recommended.** FIPS-compliant. Minimal production image. Non-root, no shell. |
| `canary` | Distroless Static | Bleeding edge build from MinIO master branch. FIPS-compliant. |
| `*-secure` | [Chainguard Static](https://github.com/chainguard-images/images/tree/main/images/static) | **Maximum Security.** Chainguard-based (lowest CVEs). FIPS-compliant. No shell. |
| `*-dev` | Distroless Debug | Includes busybox shell for debugging. FIPS-compliant. |
| `*-secure-dev` | [Chainguard Wolfi](https://github.com/chainguard-images/images/tree/main/images/wolfi-base) | Wolfi-based with shell and APK. FIPS-compliant. |

## Quick Start
### Docker CLI
```bash
docker run -p 9000:9000 -p 9001:9001 \
  -e MINIO_ROOT_USER=admin \
  -e MINIO_ROOT_PASSWORD=password \
  ghcr.io/sngrcreative/minio:latest server /data --console-address ":9001"
```

### Docker Compose
```yaml
services:
  minio:
    image: ghcr.io/sngrcreative/minio:latest
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: admin
      MINIO_ROOT_PASSWORD: password
    command: server /data --console-address ":9001"
```

## Image Variants
Our images come in a few flavors, all sharing the same **FIPS-compliant** core binary:

### `minio:latest`
The defacto image. Based on **Distroless Static (Debian 12)**. Extremely small (~25MB), no shell, runs as non-root (UID 65532). Ideal for standard production use.

### `minio:*-secure`
Based on **Chainguard Static**. These images are hardened for high-security environments, offering the smallest possible attack surface and near-zero CVEs. Combined with FIPS compliance, this is the choice for regulated industries.

### `minio:*-dev`
For debugging. Includes a shell. **Not recommended for production** unless required for diagnostic sidecars.

## Compliance Crash Course
- **FIPS 140-2/3**: We use Go's `boringcrypto` mechanism to offload cryptography to BoringSSL (FIPS validated). This mandates the use of `linux/amd64` architecture.
- **CIS Benchmarks**: Our images align with best practices: non-root user, minimal base image (Distroless/Chainguard), and no unnecessary tools.
- **STIG**: By enforcing FIPS and using hardened base images, these builds are ready for DoD/Federal deployments requiring strict security baselines.

## License
This project (build scripts and automation) is licensed under the [MIT License](LICENSE).

**Legal Notice**: The resulting container images contain MinIO software, which is licensed under the [GNU Affero General Public License v3.0 (AGPLv3)](https://github.com/minio/minio/blob/master/LICENSE). This project is not affiliated with MinIO, Inc.