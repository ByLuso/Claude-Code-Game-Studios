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
prototipo local no puede validarla), Silo/capacidad de venta, Decoración/
Confort, el gesto real de mantener-para-plantar (⚠ Provisional en el GDD,
pendiente del spike de UX táctil — este spike usa un toque simple, ver nota
de Sembradora abajo), la sensación táctil final en móvil (esto corre con
teclado en escritorio).

**Actualizado 2026-08-11**: se añadió el segundo jugador local (Pilar 1
necesita 2 personas para probarse de verdad), el Refugio (para poder ver la
distinción Severo/Reducido de Core Rule 6 en acción, incluyendo el preview en
tiempo real que cambia si la severidad pendiente cambia durante la ventana),
y los 3 tipos de cultivo (Trigo/Maíz/Fresa) con sus números reales de
`farm-economy-system.md` — incluyendo el tope de concurrencia de Fresa (máx.
1 en vuelo en toda la granja). **Los umbrales de desbloqueo están escalados
hacia abajo** (100 unidades de trigo reales tardarían demasiado en un spike
corto) — ver `scripts/cultivos.gd` para los números exactos usados aquí.

**Segunda actualización 2026-08-11**: se añadió expansión de terreno (6
parcelas en total, 4 empiezan bloqueadas con costos reales de
`farm-economy-system.md` §4.2: $50/$120/$250/$450) y Máquinas compradas en
un nuevo edificio, el Taller (Sembradora $200, Cosechadora $350, §3.6). La
Sembradora auto-replanta el cultivo seleccionado apenas una parcela vuelve a
quedar vacía — una divergencia deliberada del efecto real ("reduce el
mantener-para-plantar de 0.4s a 0.15s"), documentada en `scripts/maquinas.gd`
porque este spike nunca modeló ese gesto. La Cosechadora encadena
auto-cosechas a parcelas Listas adyacentes (distancia Chebyshev 1) cada vez
que **cosechas manualmente** una parcela — nunca se dispara sola ni encadena
otra auto-cosecha, respetando el Anti-Pilar "NO automatización 100%
desatendida"; tampoco cosecha Fresa nunca (solo manual, por su tope de
concurrencia).

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

| Debug / compartido | Tecla |
|---|---|
| Ciclar el cultivo seleccionado (Trigo → Maíz → Fresa, salta los bloqueados) | C |
| Forzar un disparo de amenaza inmediato (evita esperar 25-90s) | T |

## Cómo jugar

- Hay **2 parcelas**, vacías al inicio. El HUD (arriba) muestra qué cultivo
  está seleccionado ahora mismo entre corchetes `[Trigo]` — pulsa **C** para
  cambiarlo (Maíz y Fresa empiezan bloqueados, se desbloquean vendiendo
  unidades — el HUD muestra cuántas faltan). Camina hacia una parcela vacía
  (marrón) y pulsa tu tecla de acción para plantar el cultivo seleccionado.
  El HUD sobre tu jugador siempre muestra qué acción va a ejecutar tu tecla —
  apunta a la parcela elegible **más cercana** a ti, no a una prioridad fija
  (así quedó decidido en la ronda 5 de revisión). Cada jugador tiene su
  propio objetivo independiente según su propia posición.
- Cada cultivo tiene su propio tiempo de crecimiento, costo y precio (Trigo:
  barato y rápido; Maíz: intermedio; Fresa: caro, rápido, alta recompensa,
  ventana de amenaza más corta — 4s en vez de 6s — y **solo puede haber una
  Fresa en vuelo a la vez en toda la granja**, tal como especifica
  `farm-economy-system.md`). Cuando esté Lista (brote de color, pulso
  dorado) — acércate y pulsa tu tecla para cosechar.
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
- Ahora hay **6 parcelas** en total (grid 3×2); 4 empiezan **Bloqueadas**
  (textura gris de "reja" + candado, sin poder plantar). Acércate y pulsa tu
  tecla de acción para **comprar el terreno** al precio mostrado ($50 / $120
  / $250 / $450, subiendo con la distancia al Refugio). Una vez comprada,
  queda Vacía como cualquier otra.
- El edificio gris en la parte de abajo es el **Taller**. Acércate y pulsa tu
  tecla de acción para comprar máquinas en orden: primero la **Sembradora**
  ($200), después la **Cosechadora** ($350). El HUD (línea inferior) muestra
  cuáles ya compraste.
- Con la **Sembradora** comprada, cualquier parcela se **auto-replanta** con
  el cultivo seleccionado apenas queda Vacía (después de cosechar o de que
  una amenaza la dañe y la repares) — ya no necesitas volver a plantar a
  mano cada ciclo.
- Con la **Cosechadora** comprada, cosechar una parcela **a mano** dispara
  una cadena: cualquier parcela vecina (las 8 alrededor, no solo arriba/
  abajo/izq/der) que esté Lista se auto-cosecha sola tras un pequeño retraso
  (25% de su tiempo de crecimiento) — verás un contador "Cosechadora: X.Xs"
  sobre la parcela. La Fresa nunca se auto-cosecha (siempre manual), y la
  auto-cosecha nunca dispara otra cadena por sí sola.

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
- ¿El tope de concurrencia de Fresa (máx. 1 en vuelo) se siente como una
  restricción interesante, o como una limitación arbitraria/confusa cuando
  el botón de plantar simplemente no aparece en la segunda parcela?
- ¿La expansión de terreno (6 parcelas, costos crecientes) da una sensación
  de progresión satisfactoria, o el salto de precio ($50 a $450) se siente
  desbalanceado en un pozo que arranca en $20?
- Con la Sembradora comprada: ¿el auto-replante se siente como el "alivio de
  fricción" que busca el diseño real, o quita demasiada agencia (ya no
  decides activamente qué/cuándo plantar)?
- Con la Cosechadora comprada: ¿la cadena de auto-cosecha en vecinos se lee
  con claridad (el contador de tiempo ayuda), o es difícil notar qué
  parcelas se van a cosechar solas?
- ¿Comprar terreno y máquinas en el mismo pozo compartido que paga Prevenir/
  Reparar genera tensión de decisión real (invertir en crecer vs. guardar
  colchón para amenazas), o rara vez compiten en la práctica?

## Estado

**En progreso** — recién construido, pendiente de que el usuario lo corra y
reporte errores/observaciones.

## Hallazgos

_(Pendiente — se actualiza tras el playtest.)_
