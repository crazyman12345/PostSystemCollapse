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

FPS / TIMING RULES

The game supports multiple target FPS values and active gameplay must remain frame-rate independent.

All new gameplay code must preserve the existing normalized 60-FPS frame_scale system.

Rules:
- Do not add new per-Step movement without multiplying by frame_scale.
- Do not use timer-- / timer++ for real-time durations unless scaled appropriately.
- Do not rely on exact timer equality checks.
- Use <= 0 or threshold-crossing logic for timers.
- Projectile movement, enemy movement, dash movement, boss movement, hazards, cooldowns, reloads, recoil, stamina, animations, and visual effect timing must remain FPS-independent.
- Existing tuning values are based on a 60 FPS baseline and should preserve the same real-world behavior at 60 and 120 FPS.
- Do not introduce hardcoded assumptions that the game always runs at 60 FPS.
- For multiplicative effects such as scale *= 0.94, use frame-rate-correct exponential scaling rather than multiplying the factor by frame_scale.
- When modifying an existing system, preserve its current frame-independent implementation.

If unsure, inspect existing frame_scale usage and follow the same pattern.
Before modifying any system, inspect the CURRENT working-tree files.
Git may be used only to understand history or review diffs.
NEVER use Git to restore, reset, checkout, clean, revert, or replace current working-tree files unless I explicitly ask.
Assume uncommitted changes are intentional and must be preserved.
When editing a system that already has uncommitted changes, modify the current version in place and preserve existing functionality.
After completing changes, you may inspect `git diff` to review what you changed, but do not automatically revert or reconcile differences against the last commit.

### GameMaker Script Organization

- Organize scripts by system and responsibility.
- Prefer one main public function per script, with the script named after that function.
- Small, tightly related helper functions may share a script when they directly support its main function.
- Never append unrelated functions to an existing script.
- Avoid large multipurpose scripts containing numerous independent functions.
- Create and register new GameMaker script resources correctly (`.gml`, `.yy`, `.yyp`).
- Place scripts in the appropriate Asset Browser folders.
- Prioritize readability, maintainability, and minimal code duplication over rigid file-count rules.