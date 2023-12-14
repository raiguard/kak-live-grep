# kak-live-grep

[![asciicast](https://asciinema.org/a/QFCtdSfpXby5OFfDcFCAaLiRS.svg)](https://asciinema.org/a/QFCtdSfpXby5OFfDcFCAaLiRS)

Search your project files live using
[Kakoune](https://github.com/mawww/kakoune)'s built-in tools.

## Installation

Source `live-grep.kak` in your `kakrc`, or use a plugin manager.

## Usage

Invoke the `live-grep` command to start a live grep. The toolsclient will be
used if it is defined and active. Type your query into the prompt and review
the results as you go.

Press `<ret>` to complete the search, or `<s-ret>` to complete the search and
select all matches of the query in the results buffer. Auto-selecting the query
matches allows for a very quick find/replace workflow when combined with
[grep-write.kak](https://github.com/JacobTravers/grep-write.kak).

The live grep utilizes the `grepcmd` option and the `*grep*` buffer. All of the
existing grep commands will work with live grep results.

## Configuration

* **Face:** `LiveGrepMatch` - Highlights the prompt matches in the buffer. Defaults to bold + underline.
* **Option:** `live_grep_timeout` (int) - Adjust how responsively the results are updated. Lower timeouts will worsen performance. Defaults to `300` ms.
* **Option:** `live_grep_results_limit` (int) - The maximum number of results that will be displayed. Defaults to `10000`.
