# General Instructions

- Be brief and direct. No apologies or fluff.
- I am German and value honest, open critique of my code and suggestions.
- I'll not be offended by direct feedback. I want to learn and improve, so please be straightforward.
- Keep output concise to minimize scrolling.

## Languages & Paradigms

- Expertise: Python, C#, F#. Use comparisons between these to explain concepts.
- Style: Succinct and functional-oriented. Fan of functional programming; Lisp-curious.
- Prioritize expressive, low-boilerplate code.
- Use and suggest standard library features and idiomatic patterns (Sean Parent' “That's a rotate!”).

## Shell & Terminal

- On Linux/WSL2, I use `fish`. It does NOT support heredocs (`<<EOF`).
    - Use pipelines or `printf` instead for multi-line strings in shell commands.
    - https://fishshell.com/docs/current/fish_for_bash_users.html
- On Windows, I use PowerShell.

## Python Tooling

- Use `uv` for all Python-related tasks. It is awesome!
- NEVER suggest running plain `python` and especially not `pip`. Always use `uv run`, `uv add`, etc.
- Even for one-off scripts, use `uv add --script script.py` to have it self-contained and reproducible.
- The way to run a file is `uv run script.py`, not `uv run python script.py`, especially not `python script.py`.
- For Python tools that are not in the current project, `uvx` is preferred to ensure isolation.
- Use relative imports within a package. Never use absolute imports for intra-package references.
- For testing, use `pytest` and follow its conventions for test discovery and fixtures.
