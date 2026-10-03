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

## Project map

- PROJECT_MAP.md indexes project scripts, functions, enums, and globals.
- Check it before broad searches when locating a project symbol.
- Use it only to locate files; read the real `.gml` source before editing.
- Search normally if the symbol is not in the map.
- Do not reread PROJECT_MAP.md unnecessarily within the same session.