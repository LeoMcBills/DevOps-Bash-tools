#!/usr/bin/env bash
# shellcheck disable=SC2230
# command -v catches aliases, not suitable
#
#  Author: Hari Sekhon
#  Date: 2019-09-19 11:26:11
#  (moved from Makefile)
#
#  https://github.com/harisekhon/devops-bash-tools
#
#  License: see accompanying LICENSE file
#
#  https://www.linkedin.com/in/harisekhon
#

# Installs AWS CLI & SAM CLI

# You might need to first:
#
# yum install -y epel-release
# yum install -y gcc git make python-pip which
#
# this is automatically done first when called via 'make aws' at top level of this repo

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "${BASH_SOURCE[0]}")"

if type -P aws &>/dev/null &&
   type -P sam &>/dev/null &&
   type -P awless &>/dev/null; then
    echo "AWS CLI, SAM and awless already installed"
    exit 0
fi

echo "Installing AWS CLI tools"
echo

echo "Installing AWS CLI"
PYTHON_USER_INSTALL=1 "$srcdir/../python_pip_install.sh" awscli
echo

"$srcdir/install_homebrew.sh"
echo

# root installs to first one, user installs to the latter
for x in /home/linuxbrew/.linuxbrew/bin ~/.linuxbrew/bin; do
    if [ -d "$x" ]; then
        export PATH="$PATH:$x"
    fi
done

echo "Installing AWS SAM CLI"
brew tap aws/tap
echo
brew install aws-sam-cli
echo

echo "Installing AWLess"
brew tap wallix/awless
echo
brew install awless
echo

cat <<EOF
Done

AWS CLI will be installed to ~/.local/bin/aws on Linux or ~/Library/Python/2.7/bin on Mac

AWS SAM CLI command will be installed to the standard HomeBrew directory

On Mac that will be /usr/local/bin/sam
On Linux it will be /home/linuxbrew/.linuxbrew/bin for root or ~/.linuxbrew/bin for users

EOF
