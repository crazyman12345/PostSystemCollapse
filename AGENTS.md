# IdleGame Instructions

This is a GameMaker Studio project written in GML.

- Make the smallest change necessary.
- Do not modify unrelated code.
- Preserve existing function, variable, enum, script, and asset names.
- Do not refactor unless explicitly asked.
- Never invent GameMaker functions or project symbols.
- Do not use subagents.
- Use real file paths; never use placeholder paths.
- For exact symbols, search for the definition, read the file, make the requested change, and verify it.
- If an edit is requested, do not stop after searching or reading.

For code edits:

SEARCH -> READ -> EDIT -> COMPILE -> VERIFY -> DONE

After changing any `.gml` file, run `gm-cli compile`.

If compilation fails because of your change, fix it and compile again.

Do not fix unrelated pre-existing errors.

Do not compile for read-only requests or when no files were changed.

Do not commit or push unless explicitly asked.

Never run:

- `git reset --hard`
- `git clean`

After completing a task, briefly state what changed and whether compilation succeeded.

## Coding Style
- Prioritize readability.
- Use clear, focused scripts/functions instead of large monolithic code blocks.
- Keep simple code on one line when readable; avoid excessive vertical formatting.
- Use descriptive names and clear section comments.
- Extract repeated or substantial logic into reusable helpers.
- Keep changes minimal and avoid unrelated refactors.

Before modifying any system, inspect the CURRENT working-tree files.
Git may be used only to understand history or review diffs.
NEVER use Git to restore, reset, checkout, clean, revert, or replace current working-tree files unless I explicitly ask.
Assume uncommitted changes are intentional and must be preserved.
When editing a system that already has uncommitted changes, modify the current version in place and preserve existing functionality.
After completing changes, you may inspect `git diff` to review what you changed, but do not automatically revert or reconcile differences against the last commit.