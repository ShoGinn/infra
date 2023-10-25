#!/usr/bin/env sh
# sets up a pre-commit hook to ensure that encrypted files shoudl be encrypted
# See the unencrypted_pre_commit.sh file for more details

if [ -d .git/ ]; then
    rm .git/hooks/pre-commit
    touch .git/hooks/pre-commit
    cp dev/unencrypted_pre_commit.sh .git/hooks/pre-commit
fi

chmod +x .git/hooks/pre-commit
