# Counterfeit Tycoon

A multiplayer factory tycoon for [All Out](https://allout.game/). Build a cartoon money-making operation: harvest wood, turn it into paper, process it through successive bill presses, and grow your business. Hire workers, improve production stations and trucks, unlock more of your plot, and equip weapons and defenses.

Each player owns a production base. The scripts coordinate the machines, workers, inventory, upgrades, and economy around that ownership.

## Script architecture

| Start here | Responsibility |
| --- | --- |
| [scripts/main.csl](scripts/main.csl) | Imports, item/currency registration, purchase handling, and the `Player` class. |
| [scripts/GameManager.csl](scripts/GameManager.csl), [PlayerBase.csl](scripts/PlayerBase.csl) | Plot allocation, base setup, station/worker spawning, and ownership. |
| [scripts/TreeManager.csl](scripts/TreeManager.csl), [Treecutting.csl](scripts/Treecutting.csl), [PaperMill.csl](scripts/PaperMill.csl) | Resource gathering and the first production stage. |
| [scripts/BlankBillPress.csl](scripts/BlankBillPress.csl), [ColoredBillPress.csl](scripts/ColoredBillPress.csl), [FinishedBillPress.csl](scripts/FinishedBillPress.csl) | The successive bill-production stations. |
| [scripts/Harvester.csl](scripts/Harvester.csl), [PressOperator.csl](scripts/PressOperator.csl), [Colorist.csl](scripts/Colorist.csl), [Stamper.csl](scripts/Stamper.csl), [Courier.csl](scripts/Courier.csl) | Worker behaviors that automate the production chain. |
| [scripts/ItemManager.csl](scripts/ItemManager.csl), [ItemDrops.csl](scripts/ItemDrops.csl) | Item definitions and world pickups. |
| [scripts/ui/](scripts/ui/) | Upgrades, quests, shops, managers, and inventory presentation. |
| [scripts/Truck.csl](scripts/Truck.csl), [Bank.csl](scripts/Bank.csl), [Vault.csl](scripts/Vault.csl), [Turret.csl](scripts/Turret.csl) | Transport, banking, storage, and defense mechanics. |

The production chain is **wood → paper → blank bills → colored bills → finished bills**. `GameManager` and `PlayerBase` establish the player's base; individual station and worker components advance that base's production.

## How CSL works here

[ao.project](ao.project) enables CSL, All Out's statically typed scripting language. The editor compiles `.csl` source and runs it with the All Out engine.

- [main.csl](scripts/main.csl) imports `core:ao`, `ui`, and `reusable_weapons`. Its `ao_before_scene_load` registers definitions needed by inventory and economy systems.
- Stations derive from `Interactable`; workers and managers use `Component` subclasses. `@ao_serialize` fields connect them to entities and configuration in the authored scene.
- `ao_start` sets up each component, and frame callbacks advance work, movement, and interactions. `Player` extends `Player_Base` for each participant's inventory, progression, and UI.
- Production and purchases interact with All Out's inventory, economy, and purchasing APIs. Client prediction and authoritative server reconciliation are supplied by the engine; keep production state scoped to the owning base or player when adding mechanics.

[scene/](scene/) contains the world and component assignments; [res/](res/) contains assets and prefabs. [scripts/reusable_weapons/](scripts/reusable_weapons/) contains shared combat components. `scripts/.ao_core/` and `api_references/` are engine reference material.

## Open and remix

1. Follow the [Windows editor setup](https://docs.allout.game/getting-started/first-game).
2. Clone this repository:

   ```sh
   git clone https://github.com/All-Out-Games/counterfeit-tycoon.git
   ```

3. Select the folder containing `ao.project` with **Open project**. Let compilation and asset preparation complete, then press **Play**. Add a second client to check that plots, workers, and upgrades stay with their owners.
4. Create your own Creator Portal game before publishing a remix and associate your working copy with its identity. Replace original game-specific product IDs and review economy/progression configuration for your game.

Requires the All Out editor/runtime and any referenced platform assets. Saving scripts triggers compilation; restart play mode after changing startup registration or scene data. Read more about [CSL](https://docs.allout.game/scripting/syntax), [networking](https://docs.allout.game/scripting/networking-fundamentals), and [playtesting](https://docs.allout.game/getting-started/playtesting-your-game).

## License

The code, documentation, and original assets contributed by All Out Games are available under the [MIT License](LICENSE). You may copy, modify, remix, distribute, and use them in commercial games, including games published on All Out. Keep the copyright and license notice with copies or substantial portions.

Separately licensed third-party material retains its own terms. References to platform-provided assets, such as `$AO/...`, do not transfer ownership of those assets or license the All Out engine and services.
