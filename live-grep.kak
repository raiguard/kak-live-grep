declare-option -hidden bool live_grep_select_matches false
declare-option int live_grep_timeout 300
declare-option int live_grep_results_limit 10000

set-face global LiveGrepMatch default+bu

define-command -params ..1 -docstring "live-grep [init]: start a live grep in the *grep* buffer" live-grep %{
    try %{ focus %opt{toolsclient} }
    evaluate-commands -try-client %opt{toolsclient} %{
        edit -scratch *grep*
        set-option buffer filetype grep
        try %{
            set-option buffer jump_current_line 0
        } catch %{
            set-option buffer grep_current_line 0
        }
        set-option window idle_timeout %opt{live_grep_timeout}
        prompt -init %arg{1} -on-change %{
            evaluate-commands -save-regs '"' %{
              set-register '"' %sh{
                if [ -z "$kak_quoted_text" ]; then
                    exit
                fi
                result=$($kak_opt_grepcmd "$kak_quoted_text" < /dev/null | tr -d '\r' | head -n $kak_opt_live_grep_results_limit)
                echo "$result"
              }
              execute-keys '<a-;>%<a-;>"_d<a-;>P<a-;>gg'
            }
            try %{
                add-highlighter -override window/grep/live_grep_match regex "%val{text}" 0:LiveGrepMatch
            }
        } -on-abort %{
            remove-hooks window LiveGrepPrompt
            remove-highlighter window/grep/live_grep_match
            unset-option window idle_timeout
        } live-grep: %{
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
            unset-option window idle_timeout
        }
        hook -group LiveGrepPrompt window RawKey <a-ret> %{
            set-option window live_grep_select_matches true
            remove-highlighter window/grep/live_grep_match
            execute-keys -with-hooks <ret>
        }
    }
}

hook -once global NormalIdle .* %{
  echo -debug "WARNING: kak-live-grep has moved to https://codeberg.org/raiguard/kak-live-grep. Please update your plugin configuration."
  echo -markup "{Error}WARNING:{default} kak-live-grep has moved to https://codeberg.org/raiguard/kak-live-grep. Please update your plugin configuration."
}
