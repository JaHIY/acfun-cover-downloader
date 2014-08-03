#!/bin/sh -

readonly USER_AGENT='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20130406 Firefox/23.0'
readonly COVER_DOWNLOAD_URL='http://avdot.net/cover.php'

clean_up_on_exit() {
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
}

get_file_extension_for() {
    local file_extension="$(file --mime-type --brief "$1" | cut -d '/' -f 2)"
    case "$file_extension" in
        'jpeg')
            printf '%s\n' 'jpg'
        ;;
        *)
            printf '%s\n' "$file_extension"
        ;;
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
