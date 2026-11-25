# claude-bff

A Claude Code plugin that holds Ekin's rules for how Claude replies and works.
Built 2026-11-11.

## What it does

- At the start of every session (and after a resume, a clear or a compaction)
  Claude Code hands `rules.md` to Claude.
- With every message Ekin sends, Claude Code hands `reminder.txt` to Claude.
- With every message, `hooks/context-size.sh` also measures how full the
  conversation is. Once it passes 500,000 tokens it tells Claude the number,
  so Claude can suggest compacting or handing over to a new session. Claude
  cannot see this number by itself. The script needs `jq`.

Nothing checks Claude's reply afterwards. It works by repetition.

## Files

- `rules.md` — the rules. Edit this to change them.
- `reminder.txt` — the short reminder sent with every message.
- `hooks/hooks.json` — the hooks that do the handing over.
- `hooks/context-size.sh` — measures the conversation and warns Claude past 500,000 tokens.
- `if-it-does-not-work.md` — things to try if Claude's behaviour does not change enough.

## Changing the rules

Claude Code runs a copy of this folder, not the folder itself. After editing:

    claude plugin marketplace update claude-bff
    claude plugin update claude-bff@claude-bff

Then start a new session.

## Installing from scratch

    claude plugin marketplace add /Users/ekinsigic/Lab/claude-bff
    claude plugin install claude-bff@claude-bff

## Turning it off

    claude plugin disable claude-bff@claude-bff
