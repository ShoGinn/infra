#!/usr/bin/env sh
#
# Pre-commit hook that verifies if all files containing 'vault' in the name
# are encrypted.
# If not, commit will fail with an error message
#
# Original author: @ralovely
# https://www.reinteractive.net/posts/167-ansible-real-life-good-practices
#
# File should be .git/hooks/pre-commit and executable

# Should match any file that contains 'vault' in the name
# Also should match the digital_ocean.ini file and the do_env.sh file
FILES_PATTERN='.*vault.*\.*$|digital_ocean\.ini|do_env\.sh'
REQUIRED='ANSIBLE_VAULT'
EXIT_STATUS=0
CR=$(printf '\n\t')
UNENCRYPTED_FILES=''
for f in $(git diff --cached --name-only | grep -E "$FILES_PATTERN"); do
    # test for the presence of the required bit.
    MATCH=$(head -n1 "$f" | grep --no-messages "$REQUIRED")
    if [ ! "$MATCH" ]; then
        # Build the list of unencrypted files if any
        UNENCRYPTED_FILES="$f$CR$UNENCRYPTED_FILES"
        EXIT_STATUS=1
    fi
done
if [ ! "$EXIT_STATUS" = 0 ]; then
    printf '# COMMIT REJECTED\n'
    printf '# Looks like unencrypted ansible-vault files are part of the commit:\n'
    printf '#\n'
    printf '%s\n' "$UNENCRYPTED_FILES" | while read -r line; do
        if [ -n "$line" ]; then
            printf "#\t"
            printf '%s\n' "unencrypted: '$line'"
        fi
    done
    printf '#\n'
    printf "# Please encrypt them with 'ansible-vault encrypt <file>'\n"
    printf "#   (or force the commit with '--no-verify').\n"
    exit "$EXIT_STATUS"
fi
exit "$EXIT_STATUS"
