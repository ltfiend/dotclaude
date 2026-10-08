---
paths:
  - "**/Dockerfile*"
  - "**/Containerfile*"
  - "**/*.dockerfile"
---

# UBI base images: pin by digest

When writing or editing a Dockerfile/Containerfile whose base is a Red Hat UBI
image (`registry.access.redhat.com/ubi8*`, `ubi9*`, `ubi10*`, including
`ubi-minimal`, `ubi-micro`, `ubi-init`), always pin the base by sha256 digest.
Keep the tag for human readability, but append the digest — the digest is what
the build resolves:

```dockerfile
FROM registry.access.redhat.com/ubi9/ubi-minimal:latest@sha256:186a94b76e386782f576c9c49813b16dceb2ba63102af5a28405dcefec2806d0
```

Rules:

- **Every `FROM` of a UBI image gets a digest**, in every stage of a
  multi-stage build. Never leave a bare mutable tag (`:latest`, `:9.5`).
- **Resolve the digest at authoring time**, don't invent one:
  `skopeo inspect --format '{{.Digest}}' docker://registry.access.redhat.com/ubi9/ubi-minimal:latest`
  (or `docker buildx imagetools inspect <ref>`). Use the manifest-list digest
  so the pin works across architectures.
- **No `dnf`/`microdnf upgrade` at build time.** In-build upgrades duplicate
  base bytes in a higher layer (shadowed files), make builds irreproducible
  ("whatever the repos served that day"), and leave no record of what shipped.
  Base updates arrive by bumping the pinned digest instead.
- **Updates are PRs, not rebuilds**: enable Dependabot docker updates so
  digest bumps arrive as reviewable one-line PRs, and gate CI with a blocking
  Trivy scan (`--pkg-types os --severity HIGH,CRITICAL --ignore-unfixed`,
  exit-code 1) so a stale base with a fixed HIGH/CRITICAL CVE fails the build
  loudly instead of drifting silently.
- When bumping a digest, bump it in **all stages** of the Dockerfile that
  reference the same base, in the same commit.

Why: a digest is content-addressed — the same digest yields the bit-for-bit
same base from any registry or mirror, forever. A tag is a mutable pointer a
registry (or an attacker controlling it) can re-point; a digest cannot be, and
a tampered base fails the pull instead of entering the build. With the digest
in the Dockerfile, `git log` is a complete timestamped record of every base
ever shipped, rollback is a one-line `git revert`, and the digest-stable base
layer never re-uploads on push or re-downloads on pull. Full rationale:
`~/Git/neodocker/README-dns-ubi9.md` ("Why the base is pinned by digest").

Prefer the same digest-pinning for non-UBI bases too (`ubuntu`, `alpine`,
`debian`, …) — the supply-chain argument is identical — but for UBI bases it
is mandatory.
