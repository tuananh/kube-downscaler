variable "IMAGE_REPO" {
  default = "ghcr.io/tuananh/kube-downscaler"
}

group "default" {
  targets = ["build"]
}

target "build" {
  dockerfile = "Dockerfile"
}

target "cross" {
  inherits = ["build"]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REPO}"]
}
