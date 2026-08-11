# Session State

## Current Task
Ronda 5 de `/design-review design/gdd/amenazas.md` completa — veredicto **MAJOR REVISION NEEDED**
(escaló desde NEEDS REVISION). El `creative-director` de esa ronda recomendó explícitamente dejar de
parchear y reescribir 5 áreas desde invariantes; el usuario, informado de esa recomendación, decidió
seguir parcheando por lotes. Apliqué los 10 bloqueantes + 2 desacuerdos en 6 lotes, verificando
matemática/lógica yo mismo antes de escribir cada arreglo (no solo aceptando el texto del informe).
Pendiente: comitear y pushear.

## Qué se corrigió en la ronda 5 (resumen para retomar si la sesión se corta)

Ver `design/gdd/reviews/amenazas-review-log.md` (entrada de ronda 5) para el detalle completo. Los 6
lotes, cada uno verificado independientemente antes de aplicarse:

1. **Modelo de temporización**: `cooldown_global` (15s) era matemáticamente redundante en CUALQUIER
   punto de referencia — verificado con números propios, no solo aceptado del informe. Eliminado por
   completo; la exclusión mutua ahora se apoya solo en secuenciación (Core Rule 2 simplificada).
   Barrido en ~15 lugares del documento + registro de entidades.
2. **Invariante de instanciación**: el piso de `coste_no_prevenir` estaba anclado a la cantidad
   equivocada (verificado con contraejemplo propio) — reanclado a `costo_prevenir`. Segundo requisito
   de t* fortalecido de "existencia" a "≥25% del rango a cada lado".
3. **Máquina de estados Prevenir/Reparar**: Core Rule 7b contradecía la tabla de States and
   Transitions — resuelto moviendo el "crédito" a contabilidad RPC, no transición de estado. AC-19
   ahora prueba el invariante de temporización real. `resultado=prevenido_automatico` distingue el
   default de desconexión de una acción real.
4. **Modelo de interacción táctil**: el usuario eligió botón único que apunta a la entidad más
   cercana (resuelve la violación de autonomía de la prioridad fija de ronda 4). Core Rule 11 recibió
   nueva justificación.
5. **Visual**: conflicto de color real entre `farm-economy-system.md` (verde/naranja) y el art bible
   (dorado) para Prevenida — corregido en la fuente. Mandato de VFX corregido (rig único es mejora
   deliberada, no "el mismo patrón"). Severidad de Dañada/Reparando sin acotar reabierta con propuesta
   técnica concreta (`MultiMeshInstance2D`).
6. **Testabilidad**: AC-1/AC-6(a) no implementables contra la API real de Godot — añadidos requisitos
   explícitos de interfaz de RNG abstracta, pool inyectable, y contrato de señal
   (`severidad_pendiente_cambiada`).

## Progress Checklist
- [x] Rondas 1-4 aplicadas (sesiones anteriores)
- [x] Ronda 5 (8 especialistas + creative-director, revisión pura sin autocorrección) — MAJOR
      REVISION NEEDED
- [x] Decisión del usuario: seguir parcheando en vez de reescribir desde invariantes (informado del
      riesgo explícitamente)
- [x] 10 bloqueantes + 2 desacuerdos de ronda 5 aplicados, cada uno verificado independientemente
- [x] Log de revisión actualizado con la entrada de ronda 5
- [ ] **Siguiente paso inmediato**: comitear y pushear
- [ ] Correr `/design-review` una sexta vez, en sesión nueva — el patrón de "cada ronda encuentra
      defectos más profundos" lleva 3 rondas consecutivas (3, 4, 5), no asumir que ronda 6 aprobará
- [ ] Si ronda 6 sigue encontrando el mismo patrón, reconsiderar seriamente la recomendación del
      creative-director de ronda 5: reescribir desde invariantes en vez de seguir parcheando

## Key Decisions Carried Forward
- Ver "Qué se corrigió en la ronda 5" arriba para el detalle completo.
- **Riesgo aceptado explícitamente por el usuario**: continuar parcheando contra la recomendación
  expresa del creative-director de reescribir desde invariantes. Documentado en el Status header del
  propio GDD para que no se pierda esta decisión.
- Patrón a vigilar: 3 rondas consecutivas (3, 4, 5) han encontrado defectos en las correcciones de la
  ronda inmediatamente anterior. Si la ronda 6 repite el patrón, la recomendación de reescritura deja
  de ser una opción a considerar y pasa a ser la más razonable.

## Files Modified This Session (sin comitear)
- `design/gdd/amenazas.md` — todas las correcciones de la ronda 5
- `design/gdd/farm-economy-system.md` — corrección del conflicto de color (verde/naranja → dorado)
- `design/registry/entities.yaml` — `plague_cooldown_global` reforzado como deprecated con nota
  completa de ronda 5
- `design/gdd/reviews/amenazas-review-log.md` — entrada de ronda 5 añadida
- `production/session-state/active.md` — este archivo

## Current Phase
Ronda 5 completamente aplicada, sin comitear todavía. Si la sesión se interrumpe: leer este archivo,
confirmar con `git status` si ya se comiteó, y si no, comitear/pushear antes de nada más. El siguiente
paso real (fuera de esta sesión) es correr `/design-review` una sexta vez en sesión nueva.
