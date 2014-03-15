#!/bin/sh -

USER_AGENT='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20130406 Firefox/23.0'

clean_up_on_exit() {
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
}

trap 'clean_up_on_exit' EXIT

while true; do
    TMP_FILE=$(mktemp "${TMPDIR-/tmp}/acfun.XXXXXXXXX")
    curl -A "$USER_AGENT" -o "$TMP_FILE" 'http://wiki.acfun.tv/keyheaders/cover.php?.jpg'
    mv "$TMP_FILE" "$(md5sum "$TMP_FILE" | grep -o '^[[:xdigit:]]\{32\}').jpg"
done
