# Session State

## Current Task
`design/gdd/amenazas.md` completo — las 8 secciones requeridas + 3 opcionales (Visual/Audio, UI
Requirements, Open Questions), escritas sección por sección vía `/design-system amenazas`, cada una
aprobada antes de escribirse. Listo para `/design-review` en una sesión aparte.

## Estado del proyecto

- **`game-concept.md`**: APPROVED (4 rondas de `/design-review`).
- **`farm-economy-system.md`**: 5 rondas de `/design-review` resueltas. Editado hoy: §6 Dependencies
  ahora referencia `amenazas.md` bidireccionalmente (la plaga es la instancia de referencia del
  framework genérico).
- **`design/art/art-bible.md`**: completo, 9 secciones. 📌 Pendiente: addendum corto con las 3
  familias de forma de amenaza (plaga/derrumbe/incendio) y la simplificación del cooldown único,
  identificado en la sección Visual/Audio de `amenazas.md`.
- **`design/gdd/systems-index.md`**: 17 sistemas, creado vía `/map-systems`. Amenazas era el #5 en
  el orden de diseño — ahora **Designed**, pendiente actualizar su fila de status a "Designed" en el
  índice (todavía no hecho, siguiente paso menor).
- **`design/gdd/amenazas.md`**: ✅ recién completo. Decisiones clave: framework genérico único (no 3
  sistemas paralelos) generalizado desde plagas; cooldown global compartido entre los 3 tipos de
  amenaza (decisión explícita del usuario); severidad evaluada en el momento de RESOLUCIÓN, no de
  disparo; 2 fórmulas nuevas (`amenaza_interval`, `coste_no_prevenir`); 2 criterios de aceptación
  marcados BLOQUEADOS (red) en vez de fingirse verificables.
- **`design/registry/entities.yaml`**: actualizado — `plague_interval` marcado `deprecated` (superado
  por `amenaza_interval`), `plague_cooldown_global` con `source` movido a `amenazas.md` (mismo valor,
  dueño real distinto), 2 fórmulas nuevas añadidas. YAML validado.

## Progress Checklist
- [x] Concepto, motor, prototipo, art bible, registro base — todo aprobado
- [x] `systems-index.md` creado
- [x] `design/gdd/amenazas.md` completo (8 secciones requeridas + 3 opcionales)
- [x] Registro de entidades actualizado con las fórmulas nuevas y las correcciones de propiedad
- [x] Bidireccionalidad de Dependencies corregida entre `farm-economy-system.md` y `amenazas.md`
- [ ] **Siguiente paso inmediato**: comitear y pushear este trabajo
- [ ] Actualizar la fila de Amenazas en `systems-index.md` a status "Designed" (Fase 5d de
      `/design-system`, todavía no ejecutada)
- [ ] Correr `/design-review design/gdd/amenazas.md` — **en una sesión NUEVA**, nunca en esta misma
      (el skill lo exige explícitamente para que la revisión sea independiente)
- [ ] Addendum al art bible con las 3 familias de forma de amenaza (plaga/derrumbe/incendio)
- [ ] Resto de sistemas MVP del orden de diseño (Economía Compartida, Terreno y Parcelas, Recolección
      Manual, Cultivos-MVP-mínimo, Madera, Minerales, Automatización-mínima) — todos Not Started,
      Madera/Minerales ahora tienen un contrato claro que cumplir gracias a `amenazas.md`
- [ ] Ejecutar los 3 spikes técnicos (red, UX táctil, rendimiento combinado) — bloqueantes antes de
      `/create-architecture`, ninguno se ha corrido

## Key Decisions Carried Forward
- Pilar 5 (prevenir-vs-reparar, nunca combate, fallo nunca punitivo) — núcleo de Amenazas, no reabrir.
- Cooldown global único compartido entre los 3 tipos de amenaza (no uno por tipo) — decisión explícita
  del usuario en esta sesión, ya reflejada en Core Rules, Formulas, Tuning Knobs y el registro.
- Amenazas hereda la incertidumbre de autoridad de red (⚠ Provisional) — 2 Acceptance Criteria
  (AC-9, AC-16) están marcados BLOQUEADOS a propósito en vez de fingirse verificables hoy.
- Valores del registro que Madera/Minerales NO deben contradecir sin flaggear conflicto: rango de
  ventana de reacción recomendado 3-8s, ratio de downtime severo:reducido 1.5:1 a 3:1, fórmulas
  `amenaza_interval` y `coste_no_prevenir` (usar estas, no re-derivar nuevas).
- **Lección de proceso ya aplicada dos veces esta sesión**: tanto `amenazas.md` como el flujo que lo
  precedió (`systems-index.md` vía `/map-systems`) pasaron por sus skills correspondientes desde el
  principio — a diferencia de `farm-economy-system.md`, no dejaron huecos de registro/bidireccionalidad
  que cerrar después.

## Files Modified This Session (sin comitear)
- `design/gdd/amenazas.md` — nuevo, completo
- `design/gdd/farm-economy-system.md` — §6 Dependencies, referencia bidireccional a amenazas.md
- `design/registry/entities.yaml` — 2 fórmulas nuevas, 2 correcciones de propiedad/estado
- `production/session-state/active.md` — este archivo

## Current Phase
`/design-system amenazas` completo (Fase 5b terminada). Falta Fase 5c (ofrecer `/design-review` en
sesión aparte — ya se le indicó al usuario, no se ejecuta aquí), 5d (actualizar systems-index.md), y
comitear/pushear. Si la sesión se interrumpe: leer este archivo, confirmar con `git status` si ya se
comiteó, y continuar desde el paso pendiente más alto de la lista de arriba.
