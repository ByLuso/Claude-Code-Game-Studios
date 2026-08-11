# Spike: Loop actualizado con Amenazas (ronda 5)

**PROTOTIPO — NO ES PRODUCCIÓN.** Código desechable, formas de color como arte,
sin manejo de errores, sin pulido. Spike de media-producción vía `/prototype
--spike` — sin gate de fase, sin veredicto PROCEED/PIVOT/KILL formal.

## Pregunta que prueba este spike

> ¿El loop completo (cultivo + economía compartida + Amenazas) se siente
> coherente y jugable de un vistazo, reflejando las decisiones de diseño de
> las 5 rondas de `/design-review` sobre `design/gdd/amenazas.md`?

El concepto base (economía compartida + amenazas) ya se validó en
`prototypes/rincon-compartido-concept/` (veredicto PROCEED). Este spike NO
repite esa pregunta — prueba específicamente si el diseño *actualizado* de
Amenazas (botón único que apunta a la entidad más cercana, pre-alerta +
ventana con severidad, secuenciación sin cooldown numérico) se traduce bien a
algo jugable.

**Explícitamente NO prueba**: multijugador/red real (un solo jugador local —
la capa de red de `amenazas.md` sigue ⚠ Provisional, un prototipo local no
puede validarla), Severo/Reducido (no hay estructura Refugio en este spike,
solo un nivel de daño), Máquinas/Infraestructura/Silo/expansión de terreno,
más de un tipo de cultivo, la sensación táctil final en móvil (esto corre con
teclado en escritorio).

## Cómo correrlo

1. Abre Godot 4.7.1 (o compatible).
2. "Import" este directorio (`prototypes/rincon-compartido-spike-2026-08-11/`) como proyecto.
3. Presiona Play (F5). La escena principal (`Main.tscn`) corre directo.

## Controles

| Acción | Tecla |
|---|---|
| Moverse | WASD o flechas |
| Acción contextual (plantar/cosechar/prevenir/reparar) | ESPACIO |
| Forzar un disparo de amenaza inmediato (debug, evita esperar 25-90s) | T |

## Cómo jugar

- Hay **2 parcelas de Trigo**. Camina hacia una parcela vacía (marrón) y pulsa
  ESPACIO para plantar ($2). El HUD sobre tu jugador siempre muestra qué acción
  va a ejecutar ESPACIO — apunta a la parcela elegible **más cercana** a ti,
  no a una prioridad fija (así quedó decidido en la ronda 5 de revisión).
- Tras ~6s la parcela está Lista (brote amarillo, pulso dorado) — pulsa
  ESPACIO cerca para cosechar (+$15 al pozo compartido).
- En algún momento (o pulsa **T** para forzarlo ahora) una parcela elegible
  recibe una **amenaza**: 0.5s de parpadeo azul-blanco (pre-alerta, sin poder
  actuar todavía) seguido de una ventana de 6s con un enjambre de formas de
  gota/diamante suaves (no triángulos — ver art bible) y una barra de tiempo
  restante. Acércate y pulsa ESPACIO para **Prevenir** ($15, instantáneo).
- Si no llegas a tiempo, la parcela queda **Dañada** — pulsa ESPACIO para
  **Reparar** ($10), que tarda 4s (icono de reparación pulsando) antes de
  volver a tierra vacía.
- Solo puede haber **una amenaza activa a la vez** en todo el mapa —
  verificable jugando: nunca vas a ver el parpadeo azul-blanco en las 2
  parcelas simultáneamente.

## Qué observar durante el playtest

- ¿El botón único "apunta a lo más cercano" se siente predecible, o alguna
  vez actúa sobre la parcela que NO querías (p. ej. estando entre las dos)?
- ¿La ventana de 6s (0.5s de pre-alerta + 6s de reacción) da tiempo suficiente
  para notar la amenaza y decidir, o se siente injustamente corta?
- ¿Vale la pena pagar $15 por Prevenir vs. dejar que dañe y pagar $10 +
  esperar 4s de Reparar? ¿La decisión se siente real o obvia?
- ¿El enjambre de gota/diamante se lee como "presta atención a esto", o
  todavía da una sensación de amenaza/combate que el diseño quiere evitar?
- Con solo 1 jugador, ¿el loop se siente vacío/lento sin nadie con quién
  coordinar? (Esperado — el concept prototype anterior ya probó la parte
  cooperativa; esto es deliberadamente de un jugador.)

## Estado

**En progreso** — recién construido, pendiente de que el usuario lo corra y
reporte errores/observaciones.

## Hallazgos

_(Pendiente — se actualiza tras el playtest.)_
