# Prototipo de Concepto: Rincón Compartido

**PROTOTIPO — NO ES PRODUCCIÓN.** Código desechable, formas de color como arte,
sin manejo de errores, sin pulido.

## Pregunta que prueba este prototipo

> Si dos jugadores comparten una sola cuenta y deben decidir juntos en tiempo
> real cómo invertir entre crecimiento y protección contra amenazas, ¿sentirán
> la interdependencia como algo atractivo? Lo sabremos si, tras un evento de
> amenaza, ambos jugadores negocian activamente la respuesta en vez de que uno
> ignore al otro.

**Supuesto más riesgoso probado**: que la economía compartida + amenazas sea
divertida de gestionar entre dos, no frustrante.

**Explícitamente NO prueba**: la sensación táctil final de cosechar (eso es un
prototipo Engine aparte), ni el networking wifi local real (co-op aquí es en la
misma pantalla/dispositivo, con dos esquemas de teclado).

## Cómo correrlo

1. Abre Godot 4.7.1 (o compatible).
2. "Import" este directorio (`prototypes/rincon-compartido-concept/`) como proyecto.
3. Presiona Play (F5). La escena principal (`Main.tscn`) corre directo.

## Controles

| Acción | Jugador 1 | Jugador 2 |
|---|---|---|
| Moverse | W A S D | Flechas |
| Acción (cosechar / vender / prevenir / reparar) | E | Enter |

**Ambos jugadores comparten teclado en la misma pantalla** — no hay red real en
este prototipo.

## Cómo jugar

- El cuadro de tierra es el **cultivo**. Tu tecla de acción es contextual:
  - **Tierra vacía** (marrón) → plantar.
  - **Creciendo** (verde, crece visualmente con el tiempo, ~6s) → esperar, no
    puedes cosechar todavía.
  - **Listo** (amarillo brillante) → cosechar (da 3 unidades al silo de golpe).
- El rectángulo azul es el **punto de venta** — acércate y pulsa tu tecla de
  acción para vender todo lo que llevan en el silo compartido y convertirlo en
  dinero compartido.
- Cada cierto tiempo aparece una **alerta de plaga**: verás un **borde rojo
  pulsante alrededor del cultivo** además del texto naranja en el HUD. Durante
  esa ventana, cualquiera de los dos puede ir al cultivo y pulsar su tecla de
  acción para **prevenir** pagando $15 del dinero compartido.
- Si nadie previene a tiempo, la plaga **golpea**: si había algo plantado o
  listo, se pierde (vuelve a tierra vacía) y hay que pagar $10 para
  **reparar/replantar**.
- El dinero y el silo son compartidos entre los dos jugadores — todas las
  decisiones de gasto afectan a ambos.

## Qué observar durante el playtest

- ¿Los dos jugadores hablan/coordinan cuando aparece la alerta de plaga, o
  la ignoran / dejan que el otro se encargue?
- ¿Alguno se frustra por que el otro gastó dinero compartido sin avisar?
- ¿Sienten que vale la pena pagar por prevenir, o prefieren dejar que la
  plaga golpee y reparar después?
- ¿El ciclo cosechar → vender → decidir sobre la amenaza se siente como un
  ciclo con el que quieren seguir jugando, o se vuelve repetitivo rápido?
