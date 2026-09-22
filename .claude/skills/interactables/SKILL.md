---
name: interactables
description: Interactable for any "walk up and press interact" object - pickups, buttons, levers, chests, doors, NPC prompts, shop/purchase pads, harvest nodes, plot buttons. set_listener, can_use/on_interact/on_holding, prompts, hold-to-interact, radius/priority.
---
Engine renders prompts (icon/text/subtitle/hold fill) and handles proximity/input — never reimplement.

`set_listener(obj)` binds procs by EXACT signature. `Interactable` subclass (below): mismatch = compile error. Separate `Component` listener: mismatch = silent unbind — no `on_interact` = dead prompt; no `can_use` = usable by EVERYONE (prompt still shows). `listener`/`*_proc` read-only.
```csl
can_use     :: method(player: Player) -> bool // gate; re-checked before on_interact
on_interact :: method(player: Player)         // completion; never gate
on_holding  :: method(player: Player)         // each frame while held (optional)
```
- `can_use` runs every frame per nearby player, both realms: pure, cheap, no mutation/SFX. False hides the prompt.
- One-shot: set synced flag FIRST in `on_interact`, check in `can_use`.
- One prompt per player: highest `priority`, then nearest.
- `on_interact`/`on_holding` (not `can_use`) run in an interpolation anchor: world-space `UI.*` needs no manual interp.

```csl
Coin :: class : Interactable {
    claimed: bool;
    ao_start :: method() {
        this.set_listener(this);
        this.set_text("Collect");
        required_hold_time = 0; // default is 0.6!
    }
    can_use :: method(player: Player) -> bool { return !claimed; }
    on_interact :: method(player: Player) {
        claimed = true;
        Economy.deposit_currency(player, "Coins", 1);
        entity.queue_for_destruction(1);
    }
}
```
Separate listener component: configure `Interactable` BEFORE adding it.

Fields: `radius`=2 (scales with world scale; root scale 1), `required_hold_time`=0.6 (0=instant), `offset`={0,0} trigger center, `prompt_offset`={0,1}, `priority`=0, `subtitle_color`. `set_text` (short verb) / `set_hold_text` / ``set_subtitle(`{cost} Coins`)``.

- Listener wiring syncs; do NOT rewire in `ao_on_state_sync`.
- Player hook `ao_can_use_interactable :: method(i: Interactable) -> bool` blocks ALL interactables (checked first).
- Hard gates in `can_use`; affordability in `on_interact` (`Notifier.notify` failures only). Premium: `Purchasing.owns_product`/`prompt_purchase(player, id)`.
