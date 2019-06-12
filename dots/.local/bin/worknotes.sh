#! /bin/bash

# copied from
# https://lobste.rs/s/di5vin/shared_personal_note_taking#c_tkrc7g

set -eou pipefail

WORK_NOTE_PATH="$HOME/.work_notes"

if [[ ! -e "$WORK_NOTE_PATH" ]]; then
    echo '<!-- vim: set ft=markdown: -->' > "$WORK_NOTE_PATH"
else
    touch "$WORK_NOTE_PATH"
fi

cat <<HEREDOC>>"$WORK_NOTE_PATH"

---
# $(date -u +"%Y-%m-%dT%H:%M:%SZ")

HEREDOC
vim + "$WORK_NOTE_PATH"
