---
name: save
description: "Persist per-player and game-wide state across sessions via the Save API: restore/write patterns, JSON records, migration authority rules, concurrent-safe game counters"
---
# CSL Save System
Game-scoped KV store. Per-player data keyed by user id (survives rejoin, any server); game-level shared by all. Plain fields do NOT survive disconnect. Economy/inventory persist themselves — never mirror into Save.

## API
```csl
// Per-player:
Save.set_string|set_int|set_f64(p: Player, key: string, v);
Save.get_string|get_int|get_f64(p, key, default) -> string|s64|f64;
Save.set_json(p, key, v: ref $T); // @ao_serialize fields
Save.try_get_json(p, key, out: ref $T) -> bool;
Save.delete_key(p, key /*missing ok*/); Save.delete_all_keys(p); Save.get_all_keys(p) -> []string;
// Game-level (no Player; shared by ALL):
Save.set_game_string(key, v: string);  Save.get_game_string(key, default) -> string;
Save.increment_game_int(key, amount: s64, optimistic_update: bool = true);
Save.get_game_int(key, default: s64) -> s64;
Save.delete_game_key(key); // deletes a game string or int; missing is ok; batched with game saves
Save.get_all_game_strings()|get_all_game_ints()|get_all_game_keys(); // []{key,value} / {key,kind:.INT/.STRING}
// Ordered docs: async f64 scores; copy cb results into synced fields; prefer Global_Leaderboard.
Save.ordered_set(doc,key:string,v:f64);
Save.ordered_get(doc,key,default:f64,ud:Object,cb:proc(Ordered_Save_Entry{key,value:f64,position:s64},Object));
Save.ordered_get_all(doc,offset,limit:s64,ud,cb:proc([]Ordered_Save_Entry,Object));
```
No: bool get/set (int 0/1); `set_game_int`/any game absolute setter; game-level f64/json (pack JSON into a game string); load/flush/has_key/is_loaded (reads always work, giving `default`); string->number parsing in CSL.

## Rules
- Persist only what's required — nothing transient/derivable.
- One get/set pair per key, same literal; wrong-type reads return garbage/0 silently.
- Per-player ints pass through 32-bit C++: past ±2^31 silently corrupts (ms timestamps!) — big values go in strings/JSON; game ints are true s64.
- Write at every change point (all paths), never per frame.
- Client writes are prediction-only; only the server run persists — an `is_local()`-only write is silently lost. Reads work both sides.
- `$AO.` keys are engine-reserved (write/delete raises); delete_all_keys/get_all_keys skip them — resets yours, not Economy/inventory.
- `ao_start` reads are safe (data loads before spawn); no wait-until-loaded code.
- Accumulators: write at bounded moments + final Player `ao_end` write (persists; runs pre-unload).
- Restore in `ao_start` into Player fields, never globals. One-time grants: read 0, set 1, grant.

## JSON
- `try_get_json` false ONLY on missing key/malformed text (out untouched, maybe null): build full defaults. Wrong-shaped valid JSON panics.
- Success replaces the record wholesale: absent fields come back at class initializers (zero if none / structs) — version records, default new fields after load.
- Never retype a stored field: kind changes (string<->number, scalar<->object) panic on old saves; numeric retypes silently truncate. Add a new field + migrate.

## Migrations
Ascending `if v < N` steps before other reads; each idempotent, no-op on blank saves; write version key AFTER steps; delete stale keys. Overlapping keys: authority = schema history, NEVER magnitude — max/min/sum silently corrupts. Non-idempotent step: guard on the old key holding a meaningful value.

## Game-level
No per-player progress (shared key = mutual overwrite).
- `increment_game_int` sends server-applied deltas: concurrent increments accumulate across instances — never get-then-set a counter. Default optimistic_update shows the delta at once; false waits. No absolute setter; reset (increment by -current) is racy — absolute values go in a game string.
- `delete_game_key` is batched and deduplicated. A later game-string set cancels it; a later game-int increment runs after the delete and therefore restarts the counter from zero.
- Game strings: last-writer-wins; set NOT visible to get until round-trip — durable storage, not shared memory; keep live copy in synced fields.
