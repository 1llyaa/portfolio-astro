## Development

When starting the dev server, use background mode:

```
astro dev --background
```

Manage the background server with `astro dev stop`, `astro dev status`, and `astro dev logs`.

## Documentation

Full documentation: https://docs.astro.build

Consult these guides before working on related tasks:

- [Adding pages, dynamic routes, or middleware](https://docs.astro.build/en/guides/routing/)
- [Working with Astro components](https://docs.astro.build/en/basics/astro-components/)
- [Using React, Vue, Svelte, or other framework components](https://docs.astro.build/en/guides/framework-components/)
- [Adding or managing content](https://docs.astro.build/en/guides/content-collections/)
- [Adding styles or using Tailwind](https://docs.astro.build/en/guides/styling/)
- [Supporting multiple languages](https://docs.astro.build/en/guides/internationalization/)

# CLAUDE.md

## Stack

- **Framework:** Astro (static output, no server needed).
- **Styling:** Plain CSS with custom properties — no Tailwind, no CSS Modules. Define tokens once in a global stylesheet, author component styles in scoped `<style>` blocks. Theme switching via `data-theme="dark"` on `<html>`, not a CSS-in-JS solution.
- **Interactivity:** Vanilla JS / small Astro islands only where actually needed (e.g. theme toggle, copy-to-clipboard, file download). No React/Vue/Svelte runtime for a static content site — don't add a UI framework just because a reference mockup implies one.
- **Package manager:** npm.
- **Deployment:** Coolify (self-hosted). Static `dist/` output needs a `Dockerfile` (build stage + `nginx:alpine` or a minimal static server) so Coolify can build and run it as an app rather than guessing via Nixpacks.

## Design reference caveat

Any design mockup provided as a Claude Design artifact export (`<x-dc>`, `<helmet data-dc-atomics>`, `DCLogic` class, `{{ }}` bindings, `style-hover` attributes) is **not valid code** — it's a proprietary preview format from that tool. Treat it as a visual/content spec only, then rebuild natively:

- `{{ binding }}` → real Astro props or a small client-side script.
- `style-hover="..."` → actual `:hover` rules in a `<style>` block.
- Any embedded `DCLogic` class logic (state, generators, clipboard/download handlers) → a plain `<script>` or small web component, reimplemented properly rather than copy-pasted.
- Decorative fake elements in a mockup (e.g. a QR made of placeholder pixels) must be either implemented for real or left out — never shipped as fake-but-styled-to-look-real.

## Design tokens

**Colors** (light / dark via `[data-theme="dark"]`):

- `--paper`: #faf7f2 / #191715
- `--ink`: #1b1917 / #f5f1e9
- `--ink2`: #5d574e / #a8a096
- `--ink3`: #8b8377 / #7d7669
- `--rule`: rgba(27,25,23,.14) / rgba(245,241,233,.16)
- `--rule2`: rgba(27,25,23,.07) / rgba(245,241,233,.08)
- `--accent`: #b04a2c / #d9744f
- `--wash`: #f3eee5 / #221f1c

**Type:** Young Serif (headlines), IBM Plex Sans (body), IBM Plex Mono (labels/tags/metadata/nav).

**Layout:** Single-column content, max-width ~1080px, clamp()-based spacing, section dividers via 1px `--rule` top borders. No cards, shadows, or gradients. Tag chips: flat `--wash` background, mono font, no heavy border-radius.

## Structural rule

Case studies / content sections should each get space proportional to how much there actually is to say — don't force uniform card sizes or a grid built for a round number of items.

## Copy rules

- Never use: "passionate," "seamless," "cutting-edge," "unlock your potential," "elevate," "leverage," "dive into," "game-changing," "empower," "robust solutions," "journey."
- Specificity over adjectives — a stack name, a metric, or a real constraint beats any adjective.
- No em-dash / rule-of-three tics used as a default rhythm.
- No fake enthusiasm, no exclamation points.
- Every claim must trace to something real. If a fact isn't known, insert an explicit `[NEED: ...]` placeholder — never smooth it over with generic filler.

## UI rules

- No purple/blue gradients, no glassmorphism, no floating blobs, no generic 3-icon feature cards, no stock "person at laptop" illustration.
- Motion and hover states must earn their place — no animation added purely to feel "premium."
- Typography and layout choices should be deliberate, not framework defaults poured over the content.
