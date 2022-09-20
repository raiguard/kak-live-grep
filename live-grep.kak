declare-option -hidden str live_grep_file %sh{ echo "${TMPDIR:-/tmp}/kak-live-grep.$kak_session" }
declare-option \
    -docstring "select all query matches in the grep buffer upon completing the search" \
    bool live_grep_select_matches false

set-face global LiveGrepMatch "+u"

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
                $kak_opt_grepcmd $kak_quoted_text | tr -d '\r' > $kak_opt_live_grep_file
                echo "execute-keys '<a-;>%<a-;>d<a-;>!cat $kak_opt_live_grep_file<ret><a-;>gg'"
            }
            try %{
                add-highlighter -override window/grep/result regex "%val{text}" 0:LiveGrepMatch
            }
        } live-grep: %{ evaluate-commands %sh{
            if [ $kak_opt_live_grep_select_matches = true ]; then
                echo "execute-keys '%s$kak_text<ret>)'"
            fi
            rm $kak_opt_live_grep_file
        }}
    }
}
