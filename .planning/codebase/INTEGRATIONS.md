# External Integrations

**Analysis Date:** 2026-04-06

## APIs & External Services

**Source control and release hosting:**
- GitHub - repository hosting, issue/wiki/documentation links, and Catch2 source fetches from `https://github.com/catchorg/Catch2`
- GitHub raw content - used by the build system to fetch Catch2 sources when Travis is not providing the source path

**CI/CD:**
- Travis CI - legacy Linux/macOS build and deploy orchestration in `.travis.yml`
- AppVeyor - Windows build orchestration in `appveyor.yml`
- Coverity Scan - legacy badge and scan branch referenced by the README and Travis branch filters

**Downloads and deployment:**
- `dl.slic3r.org` - Slic3r download/deployment host used by the README and SFTP deploy scripts in `package/deploy/`
- `slic3r.org` - project homepage, update check endpoint, and release/download links
- `www.siusgs.com` - legacy buildserver host used by the Travis scripts to fetch prebuilt Perl, Boost, wxWidgets, and related archives
- Bintray - legacy artifact source used by the Linux and Windows bootstrap scripts in `package/linux/` and `package/win/`

**Package/repository services:**
- CPAN - Perl dependency source used by `Build.PL` and `xs/Build.PL` through `cpanm`
- `cpanm` - local installer invoked to populate `local-lib/`

**Communication:**
- IRC on `chat.freenode.net#slic3r` - legacy CI notification target defined in `.travis.yml`
- Twitter/manual links in `README.md` are informational only and not runtime dependencies

## Data Storage

**Databases:**
- None

**File Storage:**
- `local-lib/` - local Perl dependency installation directory created by `Build.PL`
- Cached archives in CI workspace locations such as `$HOME/boost_1_63_0`, `$HOME/perl5`, `$HOME/wx302`, and the Windows/AppVeyor cache paths

**Caching:**
- Travis and AppVeyor caches are used for Perl modules, Boost, wxWidgets, and packaging archives
- The repository itself does not contain application-level caching infrastructure

## Authentication & Identity

**Auth Provider:**
- None for end-user runtime

**OAuth Integrations:**
- None

## Monitoring & Observability

**Error Tracking:**
- Coverity Scan is referenced for static analysis/scan status only

**Analytics:**
- None

**Logs:**
- CI scripts emit build/deploy output to the Travis and AppVeyor job logs
- Deployment scripts use SFTP/CURL command output as operational feedback

## Operational Notes

- `package/deploy/sftp.sh` uses SSH key-based SFTP to publish artifacts to `dl.slic3r.org`
- `package/deploy/bintray.sh` uses Bintray API credentials to create and publish package versions
- `package/common/travis-decrypt-key` conditionally decrypts the deployment key when Travis exposes the encrypted key material
- `Build.PL` can auto-install missing Perl modules, so network access to CPAN is part of the developer bootstrap path
