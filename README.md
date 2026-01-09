# SNGR Creative's MinIO Container Image

[![Build Status](https://github.com/sngrcreative/minio/actions/workflows/build-publish.yml/badge.svg)](https://github.com/sngrcreative/minio/actions/workflows/build-publish.yml)
[![GitHub License](https://img.shields.io/github/license/sngrcreative/minio)](https://github.com/sngrcreative/minio/blob/master/LICENSE)

Hardened, multi-architecture (AMD64/ARM64) MinIO Object Storage images built on top of Distroless and Chainguard (Wolfi) foundations. Designed for security, minimalism, and performance.

## Quick Reference

- **Maintained by**: [SNGR Creative](https://github.com/sngrcreative)
- **Where to get help**: [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- **Where to file issues**: [GitHub Issues](https://github.com/sngrcreative/minio/issues)
- **Supported architectures**: `linux/amd64`, `linux/arm64`

## Supported Tags

| Tag | Base Image | Description |
| :--- | :--- | :--- |
| `latest` | [Distroless Static](https://github.com/GoogleContainerTools/distroless) | **Recommended.** Minimal production image. Non-root, no shell. |
| `canary` | Distroless Static | Bleeding edge build from MinIO master branch. |
| `*-secure` | [Chainguard Static](https://github.com/chainguard-images/images/tree/main/images/static) | FIPS-ready, hardened, minimal attack surface. No shell. |
| `*-dev` | Distroless Debug | Includes busybox shell for debugging. |
| `*-secure-dev` | [Chainguard Wolfi](https://github.com/chainguard-images/images/tree/main/images/wolfi-base) | Wolfi-based with shell and APK package manager for deep debugging. |

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
Our images come in a few flavors to suit different needs:

### `minio:latest`
This is the defacto image. It is based on **Distroless Static (Debian 12)**. It is extremely small, contains no shell or package manager, and runs as a non-root user (UID 65532). Proceed with this unless you have specific security compliance needs.

### `minio:*-secure`
Based on **Chainguard Static**. These images are designed for high-security environments. They have a minimal CVE footprint and are rebuilt frequently. Like the standard image, they contain no shell.

### `minio:*-dev`
For debugging purposes. These images include a busybox shell, allowing you to `docker exec` into the container to inspect files or network connectivity. **Not recommended for production.**

## License
This project (build scripts and automation) is licensed under the [MIT License](LICENSE).

**Legal Notice**: The resulting container images contain MinIO software, which is licensed under the [GNU Affero General Public License v3.0 (AGPLv3)](https://github.com/minio/minio/blob/master/LICENSE). This project is not affiliated with MinIO, Inc.