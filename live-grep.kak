declare-option -hidden bool live_grep_select_matches false
declare-option -hidden str live_grep_file %sh{ echo "${TMPDIR:-/tmp}/kak-live-grep.$kak_session" }

set-face global LiveGrepMatch default

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
                $kak_opt_grepcmd "$kak_quoted_text" | tr -d '\r' 2>&1 > $kak_opt_live_grep_file
                # Insert grep results
                printf %s\\n "execute-keys '<a-;>%<a-;>d<a-;>!cat $kak_opt_live_grep_file<ret><a-;>gg'"
            }
            try %{
                add-highlighter -override window/grep/live_grep_match regex "%val{text}" 0:LiveGrepMatch
            }
        } -on-abort %{
            nop %sh{ rm $kak_opt_live_grep_file }
            remove-hooks window LiveGrepPrompt
            remove-highlighter window/grep/live_grep_match
        } live-grep: %{
            nop %sh{ rm $kak_opt_live_grep_file }
            remove-hooks window LiveGrepPrompt
            evaluate-commands -save-regs / %sh{
                if [ $kak_opt_live_grep_select_matches = true ]; then
                    query=$(echo "$kak_quoted_text" | sed "s/'/''/g")
                    printf %s\\n "try %§
                        execute-keys '%<a-s>s[^:]*:[^:]*:([^:]*:)?<ret>l<a-l>'
                        set-register / '$query'
                        execute-keys 's<ret>)'
                        set-option window live_grep_select_matches false
                    §"
                fi
            }
        }
        hook -group LiveGrepPrompt window RawKey <s-ret> %{
            set-option window live_grep_select_matches true
            remove-highlighter window/grep/live_grep_match
            execute-keys -with-hooks <ret>
        }
    }
}
