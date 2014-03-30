#!/bin/sh -

USER_AGENT='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20130406 Firefox/23.0'

clean_up_on_exit() {
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
}

main() {
    trap 'clean_up_on_exit' EXIT

    local md5sum_hash
    while true; do
        TMP_FILE="$(mktemp "${TMPDIR-/tmp}/acfun.XXXXXXXXX")"
        curl -A "$USER_AGENT" -o "$TMP_FILE" -e 'http://h.acfun.tv/' 'http://wiki.acfun.tv/keyheaders/cover.php'
        md5sum_hash="$(md5sum "$TMP_FILE" | grep -o '^[[:xdigit:]]\{32\}')"
        if [ -f "${md5sum_hash}.jpg" ]; then
            rm "$TMP_FILE"
        else
            mv "$TMP_FILE" "${md5sum_hash}.jpg"
        fi
    done
}

main "$@"
