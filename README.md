# kak-live-grep

Search your project files live using
[Kakoune](https://github.com/mawww/kakoune)'s built-in tools.

## Installation

Source `live-grep.kak` in your `kakrc`, or use a plugin manager.

## Usage

Invoke the `live-grep` command to start a live grep. The toolsclient will be
used if it is defined and active. Type your query into the prompt and review
the results as you go. The match(es) on each line will be underlined.

The live grep utilizes the `grepcmd` option and the `*grep*` buffer. All of the
existing grep commands will work with live grep results.

## Configuration

Enabling the `live_grep_select_matches` option will cause all of the query
matches in the results buffer to be selected when you complete the search. This
aids in a find/replace workflow (see
[kakoune-grep-write](https://github.com/JacobTravers/kakoune-grep-write)).

The `LiveGrepMatch` face can be changed to customize highlighting of the query
matches in the grep buffer.

## Contributing

Please send questions, requests, bug reports, and patches to the
[mailing list](https://lists.sr.ht/~raiguard/public-inbox).
