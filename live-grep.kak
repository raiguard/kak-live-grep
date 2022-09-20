declare-option -hidden str live_grep_file %sh{ echo "${TMPDIR:-/tmp}/kak-live-grep.$kak_session" }
declare-option \
    -docstring "select all query matches in the buffer while searching" \
    bool live_grep_select_matches false

define-command -docstring "start a live grep in the *grep* buffer" live-grep %{
    try %{ focus %opt{toolsclient} }
    evaluate-commands -try-client %opt{toolsclient} %{
        edit -scratch *grep*
        set-option buffer filetype grep
        set-option global grep_current_line 0
        prompt -on-change %{
            evaluate-commands %sh{
                if [ -z "$kak_quoted_text" ]; then
                    exit
                fi
                $kak_opt_grepcmd "$kak_quoted_text" | tr -d '\r' > $kak_opt_live_grep_file
                # Insert grep results
                printf %s\\n "execute-keys '<a-;>%<a-;>d<a-;>!cat $kak_opt_live_grep_file<ret><a-;>gg'"
                # Select matches
                if [ $kak_opt_live_grep_select_matches = true ]; then
                    query=$(echo $kak_quoted_text | sed "s/'/''/g")
                    printf %s\\n "try %{
                        execute-keys '<a-;>%<a-;><a-s><a-;>s[^:]*:[^:]*:([^:]*:)?<ret><a-;>l<a-;><a-l><a-;>s$query<ret><a-;>)'
                    }"
                fi
            }
        } -on-abort %{ evaluate-commands %sh{
            rm $kak_opt_live_grep_file
            # Deselect matches
            if [ $kak_opt_live_grep_select_matches = true ]; then
                echo "execute-keys gg"
            fi
        }} live-grep: %{ nop %sh{
            rm $kak_opt_live_grep_file
        }}
    }
}
