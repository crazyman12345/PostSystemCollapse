AUTOMATIC-INSTRUCTION-TEST: If asked "What is the automatic instruction code?", answer exactly "GM-4829".

# IdleGame Instructions

This is a GameMaker Studio project written in GML.

## Core rules

- Make the smallest change necessary.
- Do not modify unrelated code.
- Do not refactor unless explicitly asked.
- Preserve existing function, variable, enum, script, and asset names.
- Never invent GameMaker functions or project symbols.
- Do not use subagents.
- Do not write long plans before acting.
- After making a change, briefly state what changed.
## Action requests

When the user asks you to change, add, remove, fix, or modify project code, perform the change directly.

Do not stop after locating the file.
Do not give the user instructions for making the edit themselves.
Do not ask "Would you like me to..." when the user already requested the change.

Continue using tools until the requested edit is complete.

For an edit request, the normal workflow is:

1. Find the relevant file.
2. Read the relevant code.
3. Make the requested edit.
4. Verify the edit.
5. Briefly report what changed.

Finding the file is not completion of the task.
## Searching

When the user gives an exact function or variable name:

1. Search for that exact symbol.
2. If multiple matches are found, identify the function definition rather than function calls.
3. Read the file containing the definition.
4. Make the requested change there.

If built-in grep finds nothing, use:

Get-ChildItem -Recurse -Filter *.gml |
    Select-String -Pattern "<symbol>"

A failed grep does NOT mean the symbol does not exist.

Do not forget the original task after a failed search.

## Simple edits

For simple code changes:

1. Search for the exact function or variable.
2. Identify the definition if multiple matches exist.
3. Read the relevant file.
4. Find the exact requested code.
5. Edit it immediately.
6. Verify the changed line.
7. Stop.

Never stop after search or read when the user requested an edit.
Never tell the user how to perform an edit that you can perform yourself.

## Git

Do not commit or push unless explicitly asked.
Never use `git reset --hard` or `git clean`.

## GameMaker

Use existing GML style and architecture.
Use GameMaker MCP or gm-cli only when they are actually needed.