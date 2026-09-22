# Remove unused rig recipe

Removed `reusable_weapons/anims/reusable-weapons/player/player.merged_spine_rig`. No default player, script, scene, prefab or other decoded bundled asset in published version `6ab20436236e3076fa1ad9b9` references it. The runtime previously registered and loaded it despite its unused output. Required rigs and gameplay are unchanged.

Game: `697fed014dbbc40714514d3e` (Counterfeit Tycoon).
Published source SHA-256: `9eeb20dd8fa96c97b0f975bdb00a797d059472c6dc1bbfd7ba1f53699f7fd786`.
Prepared candidate SHA-256: `78742d09df9ffb097df657402cda781e0834e3d319aa2f714fb53155a64ce1f5`.

The release candidate was derived from that exact published source archive; all scripts, scenes and remaining cooked asset entries are byte-identical. This avoids republishing unrelated older files from this authoring checkout. Only the recipe entry and related manifest/bundle metadata were removed. Cloud authoritative scene compilation and release verification are recorded in the engine repository's `docs/rig-startup-rollout-2026-09-22.md`. This commit alone is not evidence of production deployment.
