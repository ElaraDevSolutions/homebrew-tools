# homebrew-tools — Update script for gt formula

This repository contains a Homebrew formula for `gt` at `Formula/gt.rb` and a helper script to update the formula when a new tag is published in the `ElaraDevSolutions/gittool` repository.

## scripts/update-gt-formula.sh

A small convenience script to:

- download the tarball for a given tag from GitHub
- compute the tarball SHA-256
- update `Formula/gt.rb` with the new `url`, `sha256` and `version` fields
- create a backup of the formula before changing it
- show a diff and optionally commit & push the change

### Usage

Make the script executable (once):

```bash
chmod +x scripts/update-gt-formula.sh
```

Basic usage (commits changes locally):

```bash
./scripts/update-gt-formula.sh v1.0.12
```

Options:

- `--no-commit` — do not run `git add`/`git commit` automatically (useful for review)
- `--push` — after committing, run `git push` to push the change to the remote

Examples:

- Update and commit locally:

```bash
./scripts/update-gt-formula.sh v1.0.12
```

- Update, commit and push:

```bash
./scripts/update-gt-formula.sh --push v1.0.12
```

- Update but do not commit automatically:

```bash
./scripts/update-gt-formula.sh --no-commit v1.0.12
```

### What it modifies

- `Formula/gt.rb` — the script updates or inserts the following lines:
  - `url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/<TAG>.tar.gz"`
  - `sha256 "<CALCULATED_SHA256>"`
  - `version "<TAG_WITHOUT_LEADING_v>"`

A backup is created in the repository root next to the formula, e.g. `Formula/gt.rb.bak-20251112...`.

### Safety notes

- Review the printed diff before pushing. The script commits automatically by default; use `--no-commit` if you prefer manual commits.
- The script assumes the repository is checked out at the repo root and that `Formula/gt.rb` follows the usual Homebrew formula format.
- If you republish the same tag with different content, prefer creating a new tag/release to avoid confusion.

### Testing locally without pushing

If you want to test the formula locally without pushing to GitHub, you can tap your local repo as a Homebrew tap:

```bash
brew tap --custom-remote ElaraDevSolutions/homebrew-tools "$(pwd)"
brew install ElaraDevSolutions/homebrew-tools/gt
```

When you're done testing:

```bash
brew untap ElaraDevSolutions/homebrew-tools
```

## License

This repository follows the same licensing used for the formula; adjust as necessary.
