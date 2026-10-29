# Contributing

Please use the following guidelines when contributing to this project.

Before contributing significant changes, please begin a discussion of the desired changes via a GitHub Issue to prevent doing unnecessary or overlapping work.

## Developer Setup

After cloning the repository, set up your local development environment:

```bash
# Create and activate a virtual environment
uv venv .venv
source .venv/bin/activate

# Install developer dependencies
uv pip install -r docker/requirements-dev.txt

# Install pre-commit hooks
pre-commit install
```

The developer dependencies in `docker/requirements-dev.txt` include:

| Package | Used by |
|---|---|
| `pre-commit` | Git pre-commit hooks. |
| `nbformat` | `docker/test-notebook-format.py` for canonical notebook validation. |

You will also need the following non-Python tools. On Ubuntu/Debian:

```bash
# Docker Engine (https://docs.docker.com/engine/install/ubuntu/)
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Git LFS (https://git-lfs.com/)
sudo apt-get install git-lfs
git lfs install
```

## Tutorial Images

Every tutorial image is built on the fly from an NVIDIA base image on `nvcr.io`; there are no prebuilt base images to maintain.

* **Python tutorials** share one Dockerfile, [`docker/dockerfile`](docker/dockerfile). It starts from the CUDA devel image, installs the tutorial's packages with pip into a virtual environment using Ubuntu's Python, and takes the tutorial name as the `ACH_TUTORIAL` build argument. Each tutorial provides:
  * `docker/requirements.txt` (required): the tutorial's Python packages. `-r` lines resolve relative to `docker/`, so a tutorial can point at a lock file elsewhere in its directory.
  * `docker/install.bash` (optional): extra build steps, run as root after the Python packages are installed.
* **The stdpar tutorial** needs the NVIDIA HPC SDK compilers, so it has its own Dockerfile, [`tutorials/stdpar/docker/dockerfile`](tutorials/stdpar/docker/dockerfile), based on the HPC SDK image.

Each tutorial's `docker/docker-compose.yml` points at its Dockerfile, so `docker compose -f tutorials/<tutorial>/docker/docker-compose.yml up --build` builds and starts it.

## Development Scripts

The `docker/` directory contains scripts for building, running, and testing tutorial Docker containers locally, as well as validation and CI helper scripts.

### Docker Workflow (`docker/dev-*`)

These are the primary scripts for local development. They all accept a tutorial name (the directory name under `tutorials/`, e.g. `accelerated-python`) and manage Docker Compose services for that tutorial.

* **`docker/dev-build.bash [<tutorial-name>]`** - Builds Docker images. If a tutorial name is provided, builds only that tutorial; if omitted, builds all tutorials discovered by `discover-tutorials.bash`.

* **`docker/dev-start.bash [--mount|--no-mount] <tutorial-name>`** - Starts containers for a tutorial. By default (`--mount`), bind-mounts the local repository into the containers at `/accelerated-computing-hub` so edits are reflected immediately. Use `--no-mount` to run from the image content only. Rebinds ports to `0.0.0.0` for local access.

* **`docker/dev-stop.bash <tutorial-name>`** - Stops and tears down containers for a tutorial.

* **`docker/dev-shell.bash [--mount|--no-mount] <tutorial-name|docker-compose-file> <service-name>`** - Opens an interactive bash shell inside a running container. Accepts either a tutorial name or a path to a `docker-compose.yml` file, plus the service name (e.g. `base`, `jupyter`, `nsys`, `ncu`).

* **`docker/dev-test.bash [--mount|--no-mount] <tutorial-name|docker-compose-file> [test-args...]`** - Runs the tutorial's test suite inside Docker. Defaults to `--no-mount` (tests the image as-built). Extra arguments are forwarded to the tutorial's `test.bash` script (e.g. `docker/dev-test.bash accelerated-python test/test_notebooks.py -k "03"`).

### Validation Scripts (`docker/test-*`)

These scripts are used by the pre-commit hooks and CI. You can also run them directly.

* **`docker/test-notebook-format.py [<tutorial-name>] [--fix]`** - Checks that notebooks are in canonical format (1-space indentation, sorted keys, standard metadata, clean outputs for non-SOLUTION notebooks). Pass `--fix` to auto-rewrite notebooks to canonical form.

* **`docker/test-git-lfs.bash [<path>...]`** - Verifies that binary files (images, PDFs, presentations) are properly tracked by Git LFS and that no `.gitattributes` files exist in subdirectories.

* **`docker/test-docker-compose.bash [--mount|--no-mount] <tutorial-name|docker-compose-file> [test-args...]`** - The lower-level test runner that `dev-test.bash` delegates to. Starts containers, checks for restart loops, runs the tutorial's tests, verifies restart behavior, and tears everything down.

### Other Utility Scripts

* **`docker/discover-tutorials.bash`** - Prints one line per tutorial directory (relative to repo root) for every tutorial that has a `docker/docker-compose.yml`. Used by `dev-build.bash` and CI.

## Continuous Integration

Two GitHub Actions workflows run on this repository:

| Workflow | Runs on | What it does |
|---|---|---|
| [`tutorials.yml`](.github/workflows/tutorials.yml) | Pushes to `main` and `pull-request/<number>` | For each tutorial whose files changed (or every tutorial, when shared files under `docker/` change), builds the image, runs the tutorial's tests on a GPU runner with `docker/test-docker-compose.bash`, and, on `main`, publishes the image to `ghcr.io/<owner>/<tutorial>-tutorial` once the tests pass. |
| [`checks.yml`](.github/workflows/checks.yml) | Pull requests and pushes to `main` | Runs the notebook format and Git LFS checks on a GitHub-hosted runner. |

## Pre-Commit Hooks

This repository uses [pre-commit](https://pre-commit.com/) to run the same checks as `checks.yml` before each commit. Install the hooks after cloning:

```bash
pip install pre-commit
pre-commit install
```

The following hooks are configured:

| Hook | Stage | Files | What it checks |
|---|---|---|---|
| **`notebook-format`** | pre-commit | `*.ipynb` | Validates that notebooks are in canonical format (consistent cell metadata, output ordering, etc.) to prevent noisy diffs from editor reformatting. |
| **`git-lfs`** | pre-commit | Binary files (`*.pptx`, `*.pdf`, `*.png`, `*.jpg`, etc.) | Ensures binary files are tracked by Git LFS rather than committed directly to the repository. |

If a hook fails, fix the issue and re-stage your changes before committing again. `python3 docker/test-notebook-format.py --fix` rewrites notebooks into canonical format.

## Branches

### `main`

The primary integration branch. All changes land here via pull requests.

### `feature/<description>` and `fix/<description>`

Development branches for new features and bug fixes, respectively. Create these from `main` and open a pull request when ready.

- `feature/<description>` — new functionality or enhancements (e.g. `feature/matplotlib-dark-mode-detect`).
- `fix/<description>` — bug fixes or corrections (e.g. `fix/dockerfile-copy-chmod-layers`).

### `pull-request/<number>`

These branches are created to enable GPU CI on pull requests from forks. Because the tutorial tests run on NVIDIA's self-hosted GitHub Actions runners, they cannot run directly on fork PRs for security reasons. NVIDIA's [**copy-pr-bot**](https://docs.gha-runners.nvidia.com/cpr/vetters/) automates this process -- when a maintainer determines a fork PR is safe to test, they push a copy of the PR to a `pull-request/<number>` branch on the upstream repo (where `<number>` is the PR number). The `tutorials.yml` workflow triggers on branches matching the `pull-request/[0-9]+` pattern, so pushing to this branch builds and tests the changed tutorials. The results are reported back on the original PR because the commit SHAs match. See the [Reviewing PRs From Forks](#reviewing-prs-from-forks) section below for the step-by-step process.

### Event branches (`YYYY-MM-<event-name>`)

Long-lived branches for conference workshops and training events (e.g. `2025-09-ndc-techtown`, `2026-01-internal-cuda-tile-hackathon`). These capture the exact state of tutorials as delivered at a specific event.

## Commit Messages

Commit messages use a **`Category[/Subcategory]: Summary.`** format. The summary is a sentence in imperative mood that starts with a capital letter and ends with a period.

### Format

```
Category[/Subcategory[/...]]: Imperative summary of the change.
```

Examples:

```
Docker: Fix entrypoint failure when target UID already exists.
Tutorials/Accelerated Python/Kernel Authoring: Add correctness check cell before profiling copy_blocked kernel.
CI: Add nightly schedule trigger to build workflow.
```

### Categories

Use the most specific category path that accurately describes what was changed. The top-level category identifies the broad area of the codebase, and subcategories narrow it down.

| Category | When to use |
|---|---|
| **`Tutorials/<tutorial>`** | Changes to tutorial content (notebooks, scripts, solutions). Use subcategories to identify the specific module when applicable, e.g. `Tutorials/Accelerated Python/Memory Spaces`, `Tutorials/Accelerated Python/CUDA Tile`. |
| **`Docker`** | Changes to Dockerfiles, Docker Compose files, entrypoint scripts, or container configuration that affect multiple tutorials or the shared Docker infrastructure. |
| **`CI`** | Changes to GitHub Actions workflows, CI scripts, or CI configuration. |
| **`Scripts`** | Changes to development and utility scripts (e.g. `docker/dev-build.bash`). |
| **`Tests`** | Changes to test infrastructure, test scripts, or test validation. |
| **`Nsight`** | Changes to Nsight Systems/Compute integration, Nsight Streamer, or profiling configuration. |
| **`Docs`** | Changes to documentation files (READMEs, contributing guides, link fixes). |
| **`Slides`** | Changes to presentation materials. |

### Summary Guidelines

- Use **imperative mood**: "Fix bug" not "Fixed bug" or "Fixes bug".
- Start with a **capital letter** and end with a **period**.
- Describe the **what and why**, not the how: "Fix entrypoint failure when target UID already exists." rather than "Add an if-check around useradd."
- If the commit fixes a GitHub issue, append `Fixes #<number>.` to the end of the summary.

## Pull Requests From Forks

When opening a pull request from a fork, please check the **"Allow edits from maintainers"** checkbox. This lets maintainers push small fixes (typos, formatting, CI tweaks) directly to your PR branch without requiring a round-trip, which significantly speeds up the review process. You can find this checkbox at the bottom of the "Open a pull request" form on GitHub. See the [GitHub documentation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/allowing-changes-to-a-pull-request-branch-created-from-a-fork) for more details.

## License

The preferred license for contributions to this project is detailed in the [LICENSE file](LICENSE).

## Signing Your Commits

This project requires that all commits and contributions must be **verified** on GitHub. This is necessary to protect against security threats and protect both our codebase and our CI system.

This means each commit needs two things:

1. A **`Signed-off-by` trailer** asserting the [Developer Certificate of Origin (DCO)](https://developercertificate.org/).
2. A **cryptographic signature** (GPG or SSH) so GitHub displays the "Verified" badge.

### Signed-off-by (DCO)

The `Signed-off-by` trailer certifies that you wrote the contribution or otherwise have the right to submit it under the project's license. Add it by passing `--signoff` (or `-s`) when committing:

```bash
git commit -s -m "CI: Add nightly schedule trigger to build workflow."
```

This appends a line like the following to the commit message:

```
Signed-off-by: Your Name <your.email@example.com>
```

Your name and email must match your Git identity (`user.name` and `user.email`).

### Cryptographic Commit Signing

We require that all commits be cryptographically signed so they display as **"Verified"** on GitHub. You can sign with either a GPG key or an SSH key.

#### Option A: GPG Signing

1. [Generate a GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key) and [add it to your GitHub account](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).
2. Tell Git to use your key:

```bash
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey <YOUR_KEY_ID>
```

3. Enable automatic signing so you don't have to pass `-S` every time:

```bash
git config --global commit.gpgsign true
```

#### Option B: SSH Signing

1. [Add your SSH key to your GitHub account as a **signing** key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-ssh-key).
2. Configure Git to use SSH for signing:

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

### Recommended Git Configuration

To sign and sign-off on every commit by default, add both settings:

```bash
git config --global commit.gpgsign true
git config --global format.signoff true
```

With these defaults, a simple `git commit -m "message"` will produce a signed, signed-off commit.

## Styling

Please use the guidelines detailed in the [notebook template](docs/notebook_template.ipynb) for contributions.

## Tutorial Architecture

For details on the tutorial directory structure, Docker Compose services, notebook conventions (exercise vs. solution notebooks), tests, and deployment infrastructure, see the [Tutorial Architecture](docs/tutorial_architecture.md) documentation.

## Reviewing PRs From Forks

The checks in `checks.yml` run on fork PRs automatically. The tutorial build and test workflow runs on self-hosted GPU runners, so it does not trigger automatically on fork PRs.

To run it, a maintainer needs to inspect the PR to ensure there are no concerns with running it, then push a copy of the PR to a branch on the upstream repo. This will trigger the CI to run. The results of the workflow will be reported back on the PR due to the matching SHAs of each commit.

```bash
# Use the GitHub CLI to check out the PR
gh pr checkout 123

# Push to a PR branch on the upstream
git push upstream pull-request/123
```

If the contributor makes further changes these will also need to be pulled/pushed to trigger the CI again.

```bash
# Check out the PR branch again
gh pr checkout 123
# Or just `git checkout <name of branch> && git pull` if you already have it

# Push to upstream PR branch
git push upstream pull-request/123  # You may need --force id the contributor has rewritten their history
```

See the [GitHub Actions NVIDIA Runners documentation for more information](https://docs.gha-runners.nvidia.com/platform/onboarding/pull-request-testing/).

## Attribution

Portions adopted from [https://github.com/OpenACC/openacc-training-materials/blob/master/CONTRIBUTING.md](https://github.com/OpenACC/openacc-training-materials/blob/master/CONTRIBUTING.md)
