# GameMaker Project Instructions

This is a GameMaker project written in GML.

## Coding Style

- Prefer compact GML formatting.
- Avoid unnecessary vertical whitespace.
- Use snake_case names.
- Opening braces go on the next line.
- Reuse existing functions instead of duplicating systems.
- Make the smallest reasonable change.
- Do not refactor unrelated code unless specifically requested.

## Investigation

Before modifying an existing file:

1. Search for the relevant function/resource if necessary.
2. Read the actual file before editing it.
3. Inspect relevant callers and related functions.
4. Never guess file contents or file paths.
5. Use existing project architecture instead of inventing parallel systems.

If an edit fails, read the current file again before retrying.

## GameMaker

Use GameMaker ResourceTool MCP when resource information is useful.

Use gm-cli to compile after code changes.

Do not manually modify GameMaker .yy resource files unless necessary.
Prefer ResourceTool MCP for structured GameMaker resource operations.

## Verification

After making code changes:

1. Review the modified code.
2. Run gm-cli compile.
3. Read any compiler errors.
4. Fix errors caused by the changes.
5. Compile again.

Do not claim a change works unless compilation succeeds.

## Project Architecture

Primary game states:

- MAIN_MENU
- HIDEOUT
- RAID

Most menus should be substates of HIDEOUT rather than new global game states.

Enemy firing should use existing shared weapon/firing functions when possible.