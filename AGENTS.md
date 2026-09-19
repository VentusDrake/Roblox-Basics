# AGENTS.md

# Project Overview

This is a Roblox game project written in Luau.

The project uses:

- Rojo for filesystem <-> Roblox Studio synchronization
- Luau Language Server for type checking and autocomplete
- Roblox Studio for world building, models, parts, UI, terrain, and playtesting
- Git for version control

The filesystem is the source of truth for code managed by Rojo.

---

# General Working Style

Act like a careful software engineer working inside an existing codebase.

Before making changes:

- Inspect the relevant files.
- Understand the existing structure and conventions.
- Prefer extending existing code over creating unnecessary new systems.
- Do not rewrite unrelated code.
- Do not perform large refactors unless they are required by the task.
- If something is already implemented, reuse it instead of duplicating it.

When the request is clear, make the changes directly.

Do not ask for confirmation for ordinary code edits.

If an important requirement is genuinely ambiguous and choosing incorrectly could significantly affect the architecture or behavior, ask a short clarification question.

Otherwise, make a reasonable assumption and mention that assumption in the final response.

---

# Roblox Project Structure

Use the existing project structure.

Typical responsibilities:

src/ReplicatedStorage/

- Shared modules
- Shared types
- Configuration
- Code used by both client and server

src/ServerScriptService/

- Server-only systems
- Game logic
- Data handling
- Server services

src/ServerStorage/

- Server-only assets or modules that should not replicate to clients

src/StarterPlayer/StarterPlayerScripts/

- Client-side controllers
- Input handling
- Client UI logic
- Client effects

Do not move files between these areas unless there is a clear architectural reason.

Do not put server-only logic in ReplicatedStorage.

Do not trust the client with authoritative gameplay decisions.

---

# Roblox Studio Owned Content

Roblox Studio may contain objects that do not exist on the filesystem, such as:

- Parts
- Models
- Terrain
- UI objects
- Attachments
- Assets
- Workspace objects

Do not assume an object does not exist just because it is not represented as a file.

The Luau LSP Studio Companion may expose these objects through type information.

Do not create filesystem representations of Studio-owned objects unless explicitly requested.

---

# Rojo

Treat `default.project.json` as infrastructure.

Only modify Rojo mappings when the requested task actually requires a project structure change.

Do not casually change:

- `$path`
- `$className`
- `$ignoreUnknownInstances`
- service mappings

Do not start or stop `rojo serve` unless necessary.

Do not modify generated files just to make a code change.

`sourcemap.json` is generated output.
Avoid editing it manually.

---

# Luau Coding Style

Prefer modern Luau.

Use:

- `local` variables
- clear names
- small focused functions
- ModuleScripts for reusable logic
- explicit types when they improve clarity
- early returns when they make control flow simpler

Avoid:

- unnecessary globals
- deeply nested logic
- duplicated code
- giant scripts when functionality can naturally be separated
- unnecessary comments explaining obvious code

Comments should explain WHY something exists, not restate WHAT the code does.

Prefer readable code over clever code.

---

# Roblox APIs

Use Roblox services through `game:GetService()`.

Example:

```luau
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

Prefer explicit references over repeatedly accessing long object paths.

When working with Instances:

handle objects possibly not existing yet when appropriate
use WaitForChild() where replication timing requires it
do not use WaitForChild() blindly everywhere
respect client/server boundaries

---

# Client / Server Security

The server is authoritative.

Never trust values sent by the client without validation.

For RemoteEvents and RemoteFunctions:

validate arguments on the server
validate ownership where relevant
validate ranges and allowed values
do not let the client directly control important game state

Do not expose sensitive server-only implementation details unnecessarily.

---

# Architecture

For small features, keep the implementation simple.

Do not introduce frameworks, dependency injection systems, service containers, networking abstractions, or complex architecture unless the project already uses them or the task clearly benefits from them.

Prefer:

simple code
→ small module
→ reusable system

over building a framework prematurely.

If a feature grows large, separate responsibilities into sensible modules.

---

# Naming

Follow existing naming conventions first.

If no convention exists:

Variables and functions:
camelCase

Types:
PascalCase

Modules:
PascalCase.luau

Server scripts:
Something.server.luau

Client scripts:
Something.client.luau

Avoid vague names such as:
Manager2
Thing
Stuff
Util when a more specific name is possible.

---

# Existing Code

Preserve user-written code unless changing it is necessary.

Do not delete functionality merely because you would implement it differently.

Do not rename public APIs, modules, remotes, or important Instances unless required.

When changing an existing function, consider all known callers.

Search the project for usages before changing interfaces.

---

# Error Handling

Handle expected failure cases sensibly.

Do not wrap everything in pcall().

Use pcall() when interacting with APIs that can legitimately fail and where the project can recover or report the failure.

Do not silently swallow errors.

Prefer useful warnings such as:

warn("Failed to load player data:", err)

over empty error handlers.

---

# Performance

Do not optimize prematurely.

However, avoid obvious Roblox performance problems such as:

creating unnecessary connections repeatedly
leaving connections alive forever when they should be cleaned up
expensive work every frame without reason
repeatedly calling expensive searches when references can be cached
unnecessary Instance creation

Do not introduce render-step or heartbeat loops when events can solve the problem.

---

# Editing Rules

Make the smallest coherent change that fully solves the task.

It is acceptable to modify multiple files when the feature naturally requires it.

After editing:

review the changed files
inspect the resulting diff
check for accidental unrelated changes
check for obvious syntax or type issues
ensure names and paths are correct

Do not silently change unrelated formatting across entire files.

Do not touch unrelated files.

---

# Validation

When practical, verify the change using available project tools.

Prefer lightweight validation.

Do not create large generated artifacts only for validation.

If you cannot fully test Roblox runtime behavior from the editor environment, say so clearly.

Never claim that a feature was tested in Roblox Studio unless it actually was.

Distinguish between:

code inspection
static/LSP validation
actual Roblox Studio playtesting

---

# Git

Do not commit, push, pull, reset, rebase, or change branches unless explicitly requested.

You may inspect Git status and diff.

Never discard existing uncommitted user changes.

Assume unrelated uncommitted changes belong to the user.

---

# Communication

Keep progress messages concise.

Do not narrate every trivial action.

After completing a coding task, always provide a short useful summary.

Use this structure:
{
    # Done:

    Explain what was implemented.

    # What has changed:

    Mention the important files that were changed and what changed in them.

    # How it works:

    Briefly explain the resulting behavior if it is not obvious.

    # Check:

    State what was actually verified.

    Examples:

    inspected the diff
    no obvious Luau errors found
    LSP diagnostics are clean
    Roblox Studio playtest was not run
}

---

# Comments

Only include this section when there is something the user should know, such as an assumption, limitation, follow-up step, or Studio-side setup.

Do not provide a long tutorial after every small edit.

For tiny changes, the final response can be shorter while still clearly stating what changed.

---

# Important

Do not claim success for actions you could not verify.

Do not invent Roblox Instances, project files, APIs, or existing architecture.

Inspect the project before making assumptions about its structure.

If code depends on an Instance that exists only in Roblox Studio, use the available project/LSP context and clearly state the dependency when relevant.
```
