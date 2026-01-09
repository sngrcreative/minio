# Custom MinIO Minimal Builds

Hardened, multi-arch (AMD64/ARM64) MinIO images built on Distroless and Chainguard's Static image.

## Image Variants

| Tag Suffix | Base Image | Features |
| :--- | :--- | :--- |
| `latest` | Distroless Static | Minimal production |
| `-dev` | Distroless Debug | Production with basic shell |
| `-secure` | Chainguard Static | Hardened, no shell |
| `-secure-dev` | Chainguard Wolfi | Hardened with Shell & APK |

## Usage
Images run as nonroot (UID 65532). 
`docker run -p 9000:9000 ghcr.io/YOUR_ORG/YOUR_REPO:latest`

## Credits
This project architecture and automation were designed with the assistance of **Gemini**, an AI thought partner from Google.