# GameMaker Project Instructions

This is a GameMaker project written in GML.

## Coding style

- Prefer compact GML formatting.
- Avoid unnecessary vertical whitespace.
- Use snake_case names.
- Opening braces go on the next line.
- Reuse existing functions instead of duplicating systems.
- Make the smallest reasonable change.
- Do not refactor unrelated code unless specifically requested.

## Search workflow

When investigating code:

1. Use grep to locate exact functions and references.
2. Read the relevant GML files.
3. Inspect callers before changing shared functions.
4. Use GameMaker MCP when GameMaker resource information is needed.

Do not invent file paths or assume how a system works without reading it.

## Game architecture

Primary game states:
- MAIN_MENU
- HIDEOUT
- RAID

Most menus should be substates of HIDEOUT, not global game states.

Enemy firing should use shared weapon/firing functions where possible.

## Verification

After making code changes:

1. Review the modified files.
2. Run gm-cli compile.
3. Read compiler errors.
4. Fix errors caused by the changes.
5. Compile again.

Do not claim a change works unless compilation succeeds.