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

**Explícitamente NO prueba**: red real (2 jugadores locales, mismo teclado,
mismo dispositivo — la capa de red de `amenazas.md` sigue ⚠ Provisional, un
prototipo local no puede validarla), Máquinas/Infraestructura (más allá del
Refugio)/Silo/expansión de terreno, más de un tipo de cultivo, la sensación
táctil final en móvil (esto corre con teclado en escritorio).

**Actualizado 2026-08-11**: se añadió el segundo jugador local (Pilar 1
necesita 2 personas para probarse de verdad) y el Refugio (para poder ver la
distinción Severo/Reducido de Core Rule 6 en acción, incluyendo el preview en
tiempo real que cambia si la severidad pendiente cambia durante la ventana).

## Cómo correrlo

1. Abre Godot 4.7.1 (o compatible).
2. "Import" este directorio (`prototypes/rincon-compartido-spike-2026-08-11/`) como proyecto.
3. Presiona Play (F5). La escena principal (`Main.tscn`) corre directo.

## Controles

| Acción | Jugador 1 | Jugador 2 |
|---|---|---|
| Moverse | WASD | Flechas |
| Acción contextual (plantar/cosechar/prevenir/reparar) | E | Enter |

**Ambos jugadores comparten teclado en la misma pantalla** — no hay red real
en este spike.

| Debug | Tecla |
|---|---|
| Forzar un disparo de amenaza inmediato (evita esperar 25-90s) | T |

## Cómo jugar

- Hay **2 parcelas de Trigo**. Camina hacia una parcela vacía (marrón) y pulsa
  tu tecla de acción para plantar ($2). El HUD sobre tu jugador siempre
  muestra qué acción va a ejecutar tu tecla — apunta a la parcela elegible
  **más cercana** a ti, no a una prioridad fija (así quedó decidido en la
  ronda 5 de revisión). Cada jugador tiene su propio objetivo independiente
  según su propia posición.
- Tras ~6s la parcela está Lista (brote amarillo, pulso dorado) — acércate y
  pulsa tu tecla para cosechar (+$15 al pozo compartido).
- En algún momento (o pulsa **T** para forzarlo ahora) una parcela elegible
  recibe una **amenaza**: 0.5s de parpadeo azul-blanco (pre-alerta, sin poder
  actuar todavía) seguido de una ventana de 6s con un enjambre de formas de
  gota/diamante suaves (no triángulos — ver art bible) y una barra de tiempo
  restante. Cualquiera de los dos jugadores puede acercarse y pulsar su tecla
  para **Prevenir** ($15, instantáneo, del pozo compartido).
- El anillo verde-menta es el **Refugio** — protege la parcela de abajo a la
  izquierda (Parcela1), pero NO la de la derecha (Parcela2). Mientras la
  ventana de amenaza está activa, el texto y el color de la barra de tiempo
  muestran en tiempo real si la parcela **resolvería como Reducido** (menta,
  protegida) o **Severo** (ámbar, sin protección) — este preview en vivo
  (Core Rule 6) es uno de los hallazgos centrales que varias rondas de
  revisión corrigieron.
- Si nadie previene a tiempo, la parcela queda **Dañada** (con su severidad
  ya fijada) — pulsa tu tecla para **Reparar** ($10). El downtime varía:
  **2s si fue Reducido, 4s si fue Severo** — reparar algo que sí estaba
  protegido es más rápido.
- Solo puede haber **una amenaza activa a la vez** en todo el mapa —
  verificable jugando: nunca vas a ver el parpadeo azul-blanco en las 2
  parcelas simultáneamente.

## Qué observar durante el playtest

- ¿El botón único "apunta a lo más cercano" se siente predecible, o alguna
  vez actúa sobre la parcela que NO querías (p. ej. estando entre las dos)?
- ¿La ventana de 6s (0.5s de pre-alerta + 6s de reacción) da tiempo suficiente
  para notar la amenaza y decidir, o se siente injustamente corta?
- ¿Vale la pena pagar $15 por Prevenir vs. dejar que dañe y pagar $10 +
  esperar 2-4s de Reparar? ¿La decisión se siente real o obvia?
- ¿El enjambre de gota/diamante se lee como "presta atención a esto", o
  todavía da una sensación de amenaza/combate que el diseño quiere evitar?
- ¿El preview de severidad en tiempo real (color/texto cambiando según estás
  dentro o fuera del Refugio) se nota, o pasa desapercibido bajo presión?
- Con 2 jugadores compartiendo el mismo pozo: ¿negocian quién responde a la
  amenaza, o cada uno actúa por su cuenta sin coordinarse? ¿Alguno se
  frustra si el otro gasta del pozo compartido sin avisar?

## Estado

**En progreso** — recién construido, pendiente de que el usuario lo corra y
reporte errores/observaciones.

## Hallazgos

_(Pendiente — se actualiza tras el playtest.)_
