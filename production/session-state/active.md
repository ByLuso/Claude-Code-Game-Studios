# Session State

## Current Task
Aplicados los 7 bloqueantes de la ronda 2 de `/design-review design/gdd/amenazas.md` (segundo
NEEDS REVISION consecutivo, corrido en la misma sesión independiente que hizo la ronda 1). Sin
desacuerdos esta vez — los 6 especialistas y el creative-director coincidieron en el diagnóstico.
Pendiente: pushear, y correr `/design-review` una tercera vez para confirmar.

## Qué se corrigió en la ronda 2 (resumen para retomar si la sesión se corta)

**Patrón detectado por el creative-director**: todo lo que falló se agrupó en un solo eje — lo
diferido a un spike (red o UX táctil) no tenía marcador visible ni criterio verificable con la misma
fuerza en ambos casos. Los 7 bloqueantes:
1. Banner de cabecera reescrito con paridad estructural — spike de red y spike de UX táctil, cada
   uno con su propia viñeta y su propia Core Rule citada, en vez de mencionados juntos de pasada.
2. Nuevo AC-17: coordinación cross-device excluida explícitamente del alcance de QA, mismo
   tratamiento que AC-9/AC-16 (antes solo estaba declarada en prosa, sin paridad de AC).
3. Default de pérdida de host precisado: "sin daño y SIN COBRO al pozo compartido" — la versión de
   ronda 1 no aclaraba si heredaba el costo de Prevenir, ambigüedad real.
4. Área táctil mínima del botón de acción contextual: 44×44pt/48×48dp — hallazgo que el propio
   `creative-director` reconoció que se le perdió en la síntesis de la ronda 1.
5. RNG de selección de entidad declarado inyectable (requisito de testabilidad para AC-1).
6. AC-1 reescrito con umbral estadístico concreto (Chi-cuadrado, p>0.05) en vez de "no
   sistemáticamente sesgada" (hand-waving prohibido por las reglas del proyecto).
7. AC-6 con cláusula de alcance local explícita — se verifica sobre el estado en el host, la
   sincronía cross-device queda diferida al spike de red, mismo tratamiento que AC-9.

**Recomendados baratos también cerrados**: justificación del piso de 70s en `amenaza_interval`,
limpieza de la fila de Open Questions ya obsoleta bajo el clamp, referencia cruzada del cooldown en
Core Rule 2, nota de diseño deliberado en el RPC descartado, AC-5 con cobertura por evento
(`visibility_changed`) en vez de muestreo de 3 puntos.

**Dejado como Open Question rastreada, no resuelto (a propósito, no en silencio)**: criterio de
salience del preview de severidad + pregunta de playtest, alcanzabilidad de t* dado el ritmo real de
disparo, formalización del sesgo de downtime como invariante, ADR stub externo para AC-9/16/17.

## Progress Checklist
- [x] `/design-system amenazas` completo (sesión anterior)
- [x] `/design-review` ronda 1 — NEEDS REVISION, 7 bloqueantes + 10 recomendados aplicados
- [x] `/design-review` ronda 2 (misma sesión reviewer, re-review válido) — NEEDS REVISION, 7
      bloqueantes nuevos + varios recomendados aplicados
- [ ] **Siguiente paso inmediato**: comitear y pushear
- [ ] Correr `/design-review design/gdd/amenazas.md` una tercera vez (misma sesión reviewer sigue
      siendo válida — nunca escribió el documento) para confirmar
- [ ] Si aprueba: actualizar `systems-index.md` (fila #5) a "Approved"
- [ ] Addendum al art bible con las 3 familias de forma (todavía pendiente, sin tocar en ninguna
      ronda de revisión)
- [ ] Sistemas #1-4 (Networking, Input, Economía Compartida, Terreno y Parcelas) siguen sin GDD
      propio — el banner del propio GDD ahora lo deja explícito con paridad estructural

## Key Decisions Carried Forward
- Es válido reusar la misma sesión de `/design-review` para rondas sucesivas — nunca escribió el
  documento, solo lo evalúa; de hecho es más eficiente porque ya tiene el contexto de hallazgos
  previos. La única regla dura es no correrlo en la sesión que escribe/corrige (esta).
- Ver "Qué se corrigió en la ronda 2" arriba para el detalle completo.
- Patrón a vigilar en futuras rondas: los items "diferidos a un spike" necesitan la misma
  visibilidad/rigor que los items resueltos directamente — no basta con mencionarlos, necesitan su
  propio AC excluido y su propia línea en cualquier banner de estado.

## Files Modified This Session (sin comitear)
- `design/gdd/amenazas.md` — todas las correcciones de la ronda 2
- `production/session-state/active.md` — este archivo

## Current Phase
Revisión ronda 2 de `amenazas.md` completamente aplicada, sin comitear todavía. Si la sesión se
interrumpe: leer este archivo, confirmar con `git status` si ya se comiteó, y si no, comitear/pushear
antes de nada más. El siguiente paso real (fuera de esta sesión) es correr `/design-review` una
tercera vez en la misma sesión reviewer.
