# Systems Index: Rincón Compartido

> **Status**: Draft
> **Created**: 2026-08-10
> **Last Updated**: 2026-08-10
> **Source Concept**: design/gdd/game-concept.md

---

## Overview

Rincón Compartido es un tycoon de automatización cooperativo para 2 jugadores en 2 dispositivos
móviles conectados por wifi local, compartiendo una sola economía y un solo terreno. El alcance
mecánico se organiza en tres capas: sistemas de **Foundation** que ningún otro sistema puede asumir
sin definir primero (red, input, economía compartida); sistemas de **Core** que instancian esa base
sobre un terreno concreto (parcelas, amenazas, recolección manual); y sistemas de **Feature** que
aplican ese Core a los 3 recursos base del juego (cultivo, madera, mineral) más la progresión de
automatización que los conecta. `farm-economy-system.md` ya construyó una instancia rica y
completamente revisada (5 rondas de `/design-review`) de varios de estos sistemas, pero **acotada al
recurso cultivo** y a nivel de contenido Vertical Slice — no MVP puro. Esta indexación formaliza esa
cobertura parcial y ordena lo que falta.

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|---|---|---|---|---|---|
| 1 | Networking / Arquitectura Cliente-Host | Core | MVP | Not Started | — | — |
| 2 | Input / Acción Contextual Única | Core | MVP | In Design (parcial, ⚠ Provisional) | design/gdd/farm-economy-system.md §3.4 | — |
| 3 | Economía Compartida | Economy | MVP | In Design (parcial) | design/gdd/farm-economy-system.md (embebido) | — |
| 4 | Terreno y Parcelas | Core | MVP | In Design (parcial, crop-specific) | design/gdd/farm-economy-system.md §3.3 | Economía Compartida |
| 5 | Amenazas (framework genérico) | Gameplay | MVP | Designed (pendiente `/design-review`) | design/gdd/amenazas.md | Economía Compartida, Terreno y Parcelas, Networking |
| 6 | Recolección Manual | Gameplay | MVP | In Design (parcial, crop-specific) | design/gdd/farm-economy-system.md §3.4 | Input, Terreno y Parcelas |
| 7 | Cultivos (versión MVP mínima) | Economy | MVP | Not Started (la versión existente es Vertical Slice, no MVP) | — | Terreno, Amenazas, Recolección, Economía |
| 8 | Madera (inferred) | Economy | MVP | Not Started | — | Terreno, Amenazas, Recolección, Economía |
| 9 | Minerales (inferred) | Economy | MVP | Not Started | — | Terreno, Amenazas, Recolección, Economía |
| 10 | Automatización (cintas + trabajadores, versión MVP mínima) | Gameplay | MVP | Not Started | — | Recolección, Terreno, Economía, Cultivos/Madera/Minerales |
| 11 | Cultivos (expansión Vertical Slice) | Economy | Vertical Slice | ✅ Approved | design/gdd/farm-economy-system.md | #7 (versión MVP) |
| 12 | Máquinas | Gameplay | Vertical Slice | ✅ Approved | design/gdd/farm-economy-system.md §3.6 | Recolección, Economía, Cultivos |
| 13 | Infraestructura (Silo/Almacén/Refugio) | Economy | Vertical Slice | ✅ Approved | design/gdd/farm-economy-system.md §3.7 | Economía, Cultivos |
| 14 | Progresión de Desbloqueo (inferred, crop-specific → generalizar) | Progression | Vertical Slice | In Design (parcial, crop-specific) | design/gdd/farm-economy-system.md §3.10 | Economía, Cultivos |
| 15 | UI/HUD (inferred) | UI | MVP (básico) → Vertical Slice (pulido) | Not Started (spec formal) | design/gdd/farm-economy-system.md §3.4/§7 (notas, no spec de UX) | Casi todos los anteriores |
| 16 | Panel de estadísticas de contribución | Meta | Vertical Slice | Not Started | — | Economía Compartida |
| 17 | Decoración/Confort | Meta | Vertical Slice | ✅ Approved | design/gdd/farm-economy-system.md §3.8, §3.9 | Economía, Progresión |

---

## Categories

| Category | Description | Typical Systems |
|---|---|---|
| **Core** | Sistemas de fundación de los que todo lo demás depende | Networking, Input, Terreno |
| **Gameplay** | Los sistemas que hacen divertido el juego | Amenazas, Recolección, Automatización, Máquinas |
| **Economy** | Creación y consumo de recursos | Economía Compartida, los 3 recursos base, Infraestructura |
| **Progression** | Cómo crece la operación con el tiempo | Progresión de Desbloqueo |
| **UI** | Displays de información al jugador | UI/HUD |
| **Meta** | Sistemas fuera del loop central | Panel de contribución, Decoración/Confort |

*(Persistence, Audio y Narrative se omiten — el juego no persiste entre sesiones por diseño explícito
de `farm-economy-system.md` Formulas 4.5, no tiene narrativa dirigida per `game-concept.md` MDA
Framework, y el audio todavía no tiene alcance definido más allá de notas del art bible.)*

---

## Priority Tiers

(Sin cambios respecto al template — MVP primero, Vertical Slice segundo, Alpha tercero, Full Vision
según haga falta.)

---

## Dependency Map

### Foundation Layer (sin dependencias)

1. Networking / Arquitectura Cliente-Host — nada más puede sincronizar estado sin esto
2. Input / Acción Contextual Única — el único verbo de entrada de todo el juego
3. Economía Compartida — Pilar 1, fundacional para cualquier costo/venta

### Core Layer (depende de Foundation)

1. Terreno y Parcelas — depende de: Economía Compartida
2. Amenazas — depende de: Economía Compartida, Terreno y Parcelas, Networking (autoridad de red)
3. Recolección Manual — depende de: Input, Terreno y Parcelas

### Feature Layer (depende de Core)

1. Cultivos (MVP mínimo) — depende de: Terreno, Amenazas, Recolección, Economía
2. Madera — depende de: Terreno, Amenazas, Recolección, Economía
3. Minerales — depende de: Terreno, Amenazas, Recolección, Economía
4. Automatización (MVP mínimo) — depende de: Recolección, Terreno, Economía, los 3 recursos
5. Cultivos (expansión Vertical Slice) — depende de: Cultivos (MVP mínimo)
6. Máquinas — depende de: Recolección, Economía, Cultivos
7. Infraestructura — depende de: Economía, Cultivos
8. Progresión de Desbloqueo — depende de: Economía, Cultivos

### Presentation Layer (depende de Feature)

1. UI/HUD — depende de: casi todo lo anterior (lo que muestra)
2. Panel de estadísticas de contribución — depende de: Economía Compartida

### Polish Layer (depende de todo)

1. Decoración/Confort — depende de: Economía, Progresión de Desbloqueo

---

## Recommended Design Order

| Order | System | Priority | Layer | Agent(s) | Est. Effort |
|---|---|---|---|---|---|
| 1 | Networking / Arquitectura Cliente-Host | MVP | Foundation | network-programmer | L (bloqueado por spike técnico de red, ver Next Steps) |
| 2 | Input / Acción Contextual Única | MVP | Foundation | ux-designer, gameplay-programmer | M (bloqueado por spike técnico de UX táctil) |
| 3 | Economía Compartida | MVP | Foundation | economy-designer | S |
| 4 | Terreno y Parcelas | MVP | Core | game-designer, systems-designer | S |
| 5 | **Amenazas** (framework genérico) | MVP | Core | game-designer, systems-designer | M |
| 6 | Recolección Manual | MVP | Core | game-designer, ux-designer | S |
| 7 | Cultivos (MVP mínimo) | MVP | Feature | economy-designer, game-designer | S |
| 8 | Madera | MVP | Feature | economy-designer, game-designer | M |
| 9 | Minerales | MVP | Feature | economy-designer, game-designer | M |
| 10 | Automatización (MVP mínimo) | MVP | Feature | game-designer, systems-designer | M |
| 11 | Progresión de Desbloqueo (generalizar) | Vertical Slice | Feature | game-designer | S |
| 12 | UI/HUD (spec formal) | MVP→VS | Presentation | ux-designer | M |
| 13 | Panel de estadísticas de contribución | Vertical Slice | Presentation | economy-designer, ux-designer | S |

*(Máquinas, Infraestructura, Cultivos-expansión-VS y Decoración/Confort ya están Approved dentro de
`farm-economy-system.md` — no vuelven a aparecer en la cola de diseño, solo en la enumeración de
arriba para que quede registrado qué cubren.)*

---

## Circular Dependencies

Ninguna encontrada.

---

## High-Risk Systems

| System | Risk Type | Risk Description | Mitigation |
|---|---|---|---|
| Networking / Arquitectura Cliente-Host | Technical | Descubrimiento de red local sin librería integrada en Godot; permisos iOS/Android sin validar; pérdida de host sin comportamiento definido | Spike técnico dedicado, bloqueante antes de `/create-architecture` (`game-concept.md` Next Steps) |
| Input / Acción Contextual Única | Design + Technical | El propio GDD de farm-economy-system.md encontró que el gesto actual (mantener 0.4s + ciclar con toques) es físicamente incoherente para un solo dedo | Spike técnico de UX táctil dedicado, bloqueante antes de `/create-architecture` |
| Amenazas (rendimiento combinado) | Technical | El spike de rendimiento de `game-concept.md` se amplió para cubrir el contenido de `farm-economy-system.md`, pero derrumbes/incendios (madera/mineral) todavía no existen y podrían sumar más carga simultánea no contemplada en ese spike | Revisar el alcance del spike combinado cuando Madera/Minerales/Amenazas-genérico se diseñen, antes de asumir que ya está cubierto |
| Economía Compartida / free-riding | Design | Documentado como Open Question sin mitigar en `game-concept.md` — un jugador puede cargar sistemáticamente más peso económico sin que el diseño actual lo detecte o corrija | Resolver conscientemente en `/design-system economia-compartida`: aceptar el riesgo o adelantar una mitigación ligera |

---

## Progress Tracker

| Metric | Count |
|---|---|
| Total systems identified | 17 |
| Design docs started (parcial o completo) | 11 |
| Design docs reviewed (`/design-review` corrido) | 5 (todos dentro de `farm-economy-system.md`, 5 rondas) |
| Design docs approved | 4 (Cultivos-VS, Máquinas, Infraestructura, Decoración/Confort — todos como partes de `farm-economy-system.md`) |
| MVP systems designed (completo, no parcial) | 1/10 (Amenazas, pendiente `/design-review`) |
| Vertical Slice systems designed (completo) | 4/5 (falta Panel de estadísticas de contribución) |

---

## Next Steps

- [x] Diseñar **Amenazas** (framework genérico) vía `/design-system amenazas` — completo, ver
      `design/gdd/amenazas.md`; pendiente `/design-review` en sesión aparte
- [ ] Diseñar el resto de sistemas MVP — nota: Amenazas (#5) se diseñó fuera de orden estricto, a
      petición explícita; #1-4 (Networking, Input, Economía Compartida, Terreno y Parcelas) siguen
      Not Started como GDDs propios (solo embebidos parcialmente en `farm-economy-system.md`) y son
      dependencias formales de Amenazas — conviene cerrarlos antes de avanzar a Madera/Minerales, que
      si dependen de todos ellos
- [ ] Ejecutar los 3 spikes técnicos (red, UX táctil, rendimiento combinado) — bloqueantes antes de
      `/create-architecture`, trabajo de ingeniería real
- [ ] Correr `/design-review` en cada GDD nuevo en una sesión aparte
- [ ] Correr `/gate-check pre-production` cuando los sistemas MVP estén diseñados
