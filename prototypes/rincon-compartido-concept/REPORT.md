# Concept Prototype Report: Rincón Compartido — Economía Compartida + Amenazas

> **Date**: 2026-08-10
> **Prototype Path**: Engine (Godot 4.7.1, GDScript)
> **Concept File**: design/gdd/game-concept.md

---

## Hypothesis

Si dos jugadores comparten una sola cuenta y deben decidir juntos en tiempo real
cómo invertir entre crecimiento y protección contra amenazas, sentirán la
interdependencia como algo atractivo — lo sabremos si, tras un evento de
amenaza, ambos jugadores negocian activamente la respuesta en vez de que uno
ignore al otro.

---

## Riskiest Assumption Tested

Que la economía compartida (una sola cuenta, gasto individual libre) fuera
divertida de gestionar entre dos jugadores y no frustrante — no la sensación
táctil de cosechar, ni el networking real (deliberadamente fuera de alcance).

---

## Approach

Prototipo Engine en Godot 4.7.1 / GDScript, iterado en 4 rondas dentro de una
sola sesión: (1) build inicial — movimiento, cosecha, economía compartida,
1 amenaza, HUD; (2) fix de colisión física jugador-contra-jugador (se
"pegaban" al tocarse); (3) ciclo plantar → crecer → cosechar con crecimiento
visible, más fix de tipado (`lerp`/`clamp` genéricos vs. `lerpf`/`clampf`
tipados, ya que el proyecto trata warnings como errores); (4) pulido visual
del sistema de amenaza (enjambre de langostas que convergen visualmente sobre
el cultivo) y de la planta (dibujada proceduralmente, no un rectángulo
relleno), a partir de feedback directo del usuario sobre que el arte
placeholder inicial se sentía "cutre".

**Path chosen:** Engine
**Reason for path:** El usuario quería un mundo interactivo real (moverse,
cosechar, economía, amenazas), no solo una prueba de reglas en papel.

**Shortcuts tomados (intencionales):**
- 1 solo tipo de recurso (cultivos) — sin madera ni minerales
- Sin automatización (cintas transportadoras, trabajadores contratables)
- Co-op en hotseat/misma pantalla — sin networking wifi local real
- Arte 100% dibujado por código (`_draw()`), sin assets importados
- Sin menús, sin audio, sin pulido más allá de lo necesario para leer el estado

---

## Result

El trade-off central (prevenir la plaga por $15 al instante vs. dejar que
golpee y reparar por $10 con tiempo de inactividad) generó negociación real
entre los dos jugadores — citando al usuario: *"esta bien planteado para
poder debatir con tu amigo"*.

La economía como pozo único compartido, sin registro de quién ganó qué, fue
suficiente para generar una sensación orgánica de interdependencia — el
usuario reportó sentir la posibilidad de fricción ("si uno gana más dinero
que el otro se puede llegar a enfadar con el que trabaja menos") sin que el
prototipo mostrara explícitamente ningún contador de contribución individual,
y pidió explícitamente mantener esa dinámica tal cual está.

El punto débil fue la profundidad de contenido, no la mecánica central:
*"se me ha hecho aburrido el hecho de no poder comprar más cultivos... echo
de menos una tienda con más semillas que valgan más y den más dinero...
deberías poder comprar parcelas para poner más cultivos, mejoras, cosas
así."* — con solo 1 recurso y ninguna vía de expansión, la sesión se sintió
repetitiva más allá de los primeros ciclos.

No se reportó ninguna sorpresa (buena ni mala) fuera de lo ya cubierto.

---

## Metrics

| Metric | Value |
|--------|-------|
| Path used | Engine (Godot 4.7.1, GDScript) |
| Iterations to playable | 4 (build inicial, fix de colisión, plantar/crecer + fix de tipado, pulido visual de amenaza) |
| Prototype duration | 1 sesión (dentro del límite de 1 día) |
| Playtesters | 1 interno (usuario, co-op en hotseat) |
| Feel assessment | La tecla de acción única y contextual (plantar / cosechar / vender / prevenir / reparar según contexto) funcionó sin confusión reportada; el momento de decisión ante la amenaza fue señalado específicamente como el punto fuerte |
| Hypothesis verdict | CONFIRMED |

---

## Recommendation: PROCEED

La hipótesis se confirma: la economía compartida con amenazas periódicas
genera negociación real entre dos jugadores, y el trade-off prevenir/reparar
es un patrón de decisión sólido. Se avanza al diseño formal, pero con una
advertencia explícita del propio playtest: la profundidad de contenido
(variedad de cosas en las que invertir — tienda, parcelas, mejoras) no es
solo un "nice to have" de la visión completa, sino algo que se necesita
pronto para sostener el interés incluso en una sola sesión de prueba.

---

## If Proceeding

- **Core tuning values discovered:** el contraste entre "pagar más y evitar
  el daño" ($15, instantáneo) vs. "pagar menos pero aceptar tiempo de
  inactividad" ($10 + downtime) es un patrón de decisión que se siente bien
  y vale la pena mantener como base del Pilar 5 ("El riesgo empuja a
  prepararse").
- **Assumptions confirmed:** un pozo de dinero compartido sin atribución
  individual (Pilar 1, "Compartido, no dividido") basta para generar
  negociación co-op significativa — no hace falta un sistema de "quién puso
  qué" para que la interdependencia se sienta real.
- **Assumptions disproved / a ajustar:** se subestimó cuánto necesita el
  loop una vía de expansión/inversión (tienda, parcelas, mejoras) para
  sostenerse — esto debería entrar al MVP real más temprano de lo planeado
  originalmente, no quedar relegado a "visión completa".
- **Emergent mechanics:**
  - El usuario pidió explícitamente un **panel de estadísticas de
    contribución por jugador** (cuánto aportó cada quien) — vale la pena
    formalizarlo como mecánica de systems design, ya que profundiza la
    tensión social del Pilar 1 sin romper "el dinero se comparte y se gasta
    libremente".
  - La **tecla de acción única y contextual** (una sola acción que hace lo
    correcto según qué esté cerca/qué estado tenga) funcionó limpiamente en
    escritorio — buen candidato a evaluar como patrón de UI táctil (un solo
    botón de acción contextual) en vez de múltiples botones separados por
    acción, relevante para el objetivo de plataforma móvil del juego.

> Nota: este prototipo probó la interdependencia económica, no la sensación
> táctil de cosechar ni el networking wifi local real — ambos siguen
> pendientes de su propia validación (un prototipo Engine de "feel" y un
> spike técnico de networking, respectivamente) antes de comprometerse a
> arquitectura de producción en esas áreas.

**Next steps:**
1. `/design-review design/gdd/game-concept.md`
2. `/gate-check`
3. `/map-systems`
4. `/design-system [mechanic]` (usar los aprendizajes de este reporte en las secciones de Tuning Knobs y Formulas — especialmente el patrón prevenir/reparar y la necesidad de vías de inversión tempranas)

---

## Lessons Learned

- **¿Qué supuestos se rompieron al construir esto de verdad?** Ninguno de
  los pilares de interdependencia se rompió, pero se subestimó cuánto
  contenido/variedad hace falta incluso para un prototipo de una sola
  sesión — la falta de vías de inversión (tienda, parcelas, mejoras) se
  volvió el principal punto de fricción, mezclándose parcialmente con la
  señal de "¿la economía compartida es divertida?".

- **¿Qué nos sorprendió que no apareció en el brainstorm?** El usuario no
  reportó sorpresas de juego, pero sí surgió — jugando, no en el brainstorm
  — la idea concreta de mostrar estadísticas de contribución por jugador
  como una profundización deseada de la tensión social.

- **¿Qué probaríamos distinto la próxima vez?** Incluir al menos 2-3 "cosas
  en las que gastar dinero" (aunque sea de forma desechable/placeholder,
  como una mejora simple o una segunda parcela) desde el primer build, para
  no confundir "la mecánica central no funciona" con "faltó contenido para
  sostener el interés".

---

> *Prototype code location: `prototypes/rincon-compartido-concept/`*
> *This code is throwaway. Never refactor into production.*
