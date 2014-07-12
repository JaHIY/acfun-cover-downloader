#!/bin/sh -

readonly USER_AGENT='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20130406 Firefox/23.0'
readonly COVER_DOWNLOAD_URL='http://avdot.net/cover.php'

clean_up_on_exit() {
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
}

get_file_extension_for() {
    local file_sign="$(od -An -tx1 -N2 -v "$1" | tr -d ' ')"
    case "$file_sign" in
        'ffd8')
            printf '%s\n' 'jpg'
        ;;
        '4749')
            printf '%s\n' 'gif'
        ;;
        *)
            printf '%s\n' 'err'
    esac
}

main() {
    trap 'clean_up_on_exit' EXIT

    local md5sum_hash
    local file_extension
    while true; do
        TMP_FILE="$(mktemp "${TMPDIR-/tmp}/acfun.XXXXXXXXX")"
        curl -L -A "$USER_AGENT" -e 'http://h.acfun.tv/' "$COVER_DOWNLOAD_URL" > "$TMP_FILE"
        md5sum_hash="$(md5sum "$TMP_FILE" | grep -o '^[[:xdigit:]]\{32\}')"
        file_extension="$(get_file_extension_for "$TMP_FILE")"
        if [ -f "${md5sum_hash}.${file_extension}" ]; then
            rm "$TMP_FILE"
        else
            mv "$TMP_FILE" "${md5sum_hash}.${file_extension}"
        fi
    done
}

main "$@"
