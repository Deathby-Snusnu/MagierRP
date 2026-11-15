# Racial voice quality audit (2026-11-14)

## Scope

Static audit of the *single-line, spell-keyed* racial pools in `locales/{deDE,enUS,frFR}/Racial.lua`. This excludes the appended editorial expansions, general spell text, and ambient sources. The metrics describe the parsed source rows, **not every line available at runtime**.

| Metric | Result |
|---|---|
| Races | 10 |
| Ability entries per locale | 670 (67 per race) |
| Extra occurrences of exactly duplicated spoken/emote texts in deDE | 589 |
| Same metric in enUS | 603 |
| Same metric in frFR | 603 |
| Unbalanced asterisk emotes or `%s` in parsed racial rows | 0 |

Duplicate count = sum of (frequency − 1) for exact text matches. It is **not** a count of near-duplicates or interchangeable templates.

## Editorial findings

Many spell-opening phrases recur across all ten race profiles. In deDE, the formula 'stimmt meine Berechnung auf die vierte Stelle' still appears 29 times. Rewriting requires care because existing tests intentionally check text revision fixtures.

## Next steps

1. Review a sample of each race's voice and choose a distinct vocabulary, rhythm, and worldview for that class.
2. Rewrite repeated or template-generated expressions **in place**, without changing ability keys and without swapping text between race blocks.
3. Give target-free and emote alternatives for every rewritten ability; keep emotes wrapped in exactly one pair of `*...` markers.
4. For every PR, run `python -m unittest discover -s tests -p "test_*.py"` and preserve existing source/translation fixtures. Consider full Lua syntax checking and in-game chat tests separately.
5. Update translations thoughtfully in enUS and frFR; do not claim parity until the three locales have been reviewed.
6. **Lower the duplicate ceilings** in `tests/test_racial_quality_audit.py` whenever cleanup removes repeated lines, so quality cannot regress.

## Known limits

This is a static contract test. It does not execute the WoW Lua runtime, verify meaningfulness of every sentence, or detect semantic near-duplicates. Separate runtime checks remain necessary.
