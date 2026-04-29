# General Instructions

- I am German and value honest, open critique of my code and suggestions.
- I'll really not be offended by direct feedback. I want to learn and improve, so please be straightforward.
- Don't bulldoze. If you're stuck on a problem and going in circles, especially with destructive or repo-mutating operations, stop and check in with the user before the next write.
    - Signals to stop:
        - repeated failures on the same command
        - touching tool-internal directories
        - inventing workarounds that bypass the tool's own APIs
        - reasoning from "maybe this will work" rather than understanding the error.
    - Always have a path back to the state when the last instructions were given (temp branches, stashes, archives in temp etc.).
- Be brief and direct. No apologies or fluff.
- Keep output concise to minimize scrolling.

## Line endings when editing files on Windows

Git is usually set up to normalize to LF on commit (`core.autocrlf=input`, `.gitattributes text=auto eol=lf`), but several tools still produce CRLF on Windows. Tested behavior:

- **`create` tool: unconditionally writes CRLF on Windows.** Do not use it for files that should be LF. Use `[System.IO.File]::WriteAllText(path, text)` from PowerShell with `\n` in the string instead.
- **`edit` tool: adapts to the file's existing EOL style.** It detects the first line's EOL and uses it for the replacement text.
    - On an LF file: preserves LF (safe).
    - On a CRLF file: converts LF in `new_str` to CRLF. Normalize the file to LF *before* editing if LF is the goal.
- **PowerShell `Set-Content` / `Out-File` / `>` redirect**: preserves the body's newlines but appends a trailing `\r\n` unless `-NoNewline` is passed → mixed-EOL files.
- **PowerShell `Add-Content`**: joins with `\r\n` → pure CRLF.
- **PowerShell here-strings `@"..."@`**: CRLF (source parsing uses CRLF).
- **PowerShell `[System.IO.File]::WriteAllText(path, "a`nb`n")`**: pure LF. Preferred for LF source files. (PowerShell's backtick-n inside double quotes is the LF escape.)

Verification check (preferred, byte-aware): `git ls-files --eol <path>` — the `i/` column is authoritative for the index.

Hence:
- Don't use `create`, `Add-Content`, or here-strings! They force CRLF or mixed endings.
- `Set-Content` / `Out-File` / `>` are fine **only with `-NoNewline`** and a body using PowerShell's backtick-n LF escape, e.g. `Set-Content -NoNewline -Path p -Value "no CRLFs in here"`. Never without `-NoNewline` as they append a CRLF.
- `[System.IO.File]::WriteAllText(path, text)` with backtick-n in `text` is the most foolproof.
- `edit` is safe as long as the file is already LF; if it's CRLF, normalize first.

## Languages & Paradigms

- Expertise: Python, C#, F#. Use comparisons between these to explain concepts.
- Style: Succinct and functional-oriented. Fan of functional programming; Lisp-curious.
- Prioritize expressive, low-boilerplate code.
- Use and suggest standard library features and idiomatic patterns (Sean Parent's “That's a rotate!” for C++).
- `assert` is a **powerful** tool for documentation and debugging. Sprinkle it freely to check invariants, preconditions,
    postconditions, and assumptions in the code if the language provides it. It can help catch bugs early and clarify
    intent.
- In languages that easily allow it, avoid unnecessary circular dependencies between modules, types and functions.
    Studies in F# prove that re-implementations of huge projects can be done with just a handful of absolutely circular
    dependencies while the original codebase had a mess of hundreds.
- In the same vein
    - prefer pure functions and data structures that can be easily reasoned about in isolation. They are easier to test, debug, and refactor.
    - Avoid global mutable state and side effects when possible. If they are necessary, encapsulate them clearly and minimize their scope.
    - Favor composition over inheritance. Use interfaces, traits, or type classes to define abstractions and compose behavior rather than relying on class hierarchies.
    - Embrace immutability and functional programming concepts where they fit.


### C-Style/curly brace Languages (C, C++, C#, Java, etc.)

**Always add curly braces for single-line blocks!**

Implicit blocks can lead to bugs when adding new lines later. Explicit braces improve readability and maintainability.

### C++

I prefer modern versions with RAII, smart pointers and STL algorithms.

- I prefer east-const as big win for readability (`int const * const all_const`).
- I lean towards “almost always auto”. It makes refactoring easier and reduces visual noise. Use it for
    - iterator variables,
    - complex types,
    - lambda arguments,
    - and when the type is obvious from the right-hand side.

### Python Tooling

- Use `uv` for all Python-related tasks. It is awesome!
- **Never** suggest running plain `pip`. Always use `uv run`, `uv add`, etc.
- Even for one-off scripts, use `uv add --script script.py` to have it self-contained and reproducible.
- The way to run a script is `uv run script.py`, not `uv run python script.py`, especially not `python script.py`.
- For Python tools that are not in the current project, `uvx` is preferred to ensure isolation.
- Use relative imports within a package. Never use absolute imports for intra-package references.
- For testing, use `pytest` and follow its conventions for test discovery and fixtures.

### Testing Code

- Property-based testing rules! Use it for suitable cases and when the language supports it (e.g., `hypothesis` in Python).

## Shell & Terminal

- On Linux/WSL2, I use `fish`. It does **not** support heredocs.
    - Use pipelines or `printf` instead for multi-line strings in shell commands.
    - https://fishshell.com/docs/current/fish_for_bash_users.html
- On Windows, I use PowerShell.
- Always use forward slashes in paths, even on Windows. They work everywhere and avoid escaping issues.

## Version Control

- Commit often with small, focused commits. Each commit should represent a single logical change.
- I'm proficient with Git, but I'm starting to appreciate Jujutsu (jj).
    - So when jj is available in the repository, prefer jj commands and idioms over git.
- For jj, I prefer the squash workflow over the edit workflow.
    - Hence, at the end of an edit session, we should always end up in an empty working copy.
    - That reduces the chances accidentally changing a “finished” commit.
    - https://steveklabnik.github.io/jujutsu-tutorial/real-world-workflows/the-squash-workflow.html
- It is **absolutely forbidden** to reach into the `.git` or `.jj` folder and mutate its guts (read is OK).
    - If there is something that absolutely needs to be done there, ask the user to do it with an explanation of why it is necessary.
