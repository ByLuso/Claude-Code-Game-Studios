# System GDD: Farm Economy — Cultivos, Terreno, Máquinas e Infraestructura

*Created: 2026-08-10*
*Status: Draft — revisado tras cuatro rondas de `/design-review` (2026-08-10). Ronda 1: veredicto MAJOR REVISION NEEDED, 8 especialistas + síntesis de creative-director, bloqueantes resueltos. Ronda 2 (mismo día, re-revisión): veredicto NEEDS REVISION, 5 bloqueantes adicionales resueltos. Ronda 3 (mismo día, re-revisión): veredicto NEEDS REVISION — el hallazgo principal de la síntesis fue que los 5 bloqueantes "resueltos" en ronda 2 tenían defectos vivos en ronda 3 porque los parches se insertaron localmente sin propagarse por Formulas/Edge Cases/Acceptance Criteria; esta ronda corrige eso y añade el Apéndice D (matriz de estado×acción×elegibilidad, tabla de EV del Pilar 5, matriz de cobertura de AC) como los tres artefactos verificables que la síntesis exigió antes de dar por cerrada la revisión. Ronda 4 (mismo día, pasada de verificación acotada, sin especialistas — confirmar que la ronda 3 se sostiene): encontró 2 bloqueantes reales que sobrevivieron a la propia auditoría de propagación de ronda 3 — el piso anti-softlock (5.10, AC 3d) no cubría el costo de resiembra tras una reparación gratuita (deadlock real alcanzable), y el cap de concurrencia de Fresa (3.2, 5.12) no contaba el estado Descansando, dejando abierta una vía de intercalado distinta a la que ronda 3 cerró. Ambos corregidos. Ver Apéndice C, C2, C3 y C4 para el registro completo de decisiones de las cuatro rondas. Tier: contenido MVP-adyacente / Vertical Slice — NO es contenido de MVP (ver Scope Tiers de `game-concept.md`).*
*Origen: Sesión de diseño con ENGRANAJE (arquitecto de mecánicas), a partir de la hipótesis confirmada
en `prototypes/rincon-compartido-concept/REPORT.md` (Concept Prototype Report — Economía Compartida + Amenazas)*
*Propósito: especificación de sistemas lista para pasar a un agente de código que va a ampliar el
concept prototype confirmado con multi-cultivo, expansión de terreno, máquinas, infraestructura,
decoración y confort.*

> **Nota de integración (resuelta en esta revisión, ver Dependencies)**: este documento NO reemplaza
> la automatización de `game-concept.md` (cintas transportadoras + trabajadores en cuadrícula) —
> las Máquinas descritas aquí son una capa de progresión temprana (MVP-adyacente/Vertical Slice)
> que antecede al sistema de automatización de largo plazo, que sigue siendo cintas/trabajadores
> según `game-concept.md`. Decisión tomada en el `/design-review` del 2026-08-10; `game-concept.md`
> se actualizó para referenciar este documento (ver Dependencies).
>
> **Nota sobre spikes pendientes (añadida en esta revisión)**: este documento fue escrito por
> delante de tres spikes técnicos que `game-concept.md` marca como bloqueantes (rendimiento de
> entidades antes de `/map-systems`; red y UX táctil/aviso entre compañeros antes de
> `/create-architecture`). Las reglas que dependen de esos spikes están marcadas explícitamente
> como **provisionales** en el texto — no se ha inventado una solución definitiva para ellas en
> esta revisión, a propósito, para no adelantarse a esos spikes. Ver Dependencies.

---

## 1. Overview

Este sistema define la capa de contenido y progresión económica del terreno compartido de Rincón
Compartido: multi-cultivo con estados discretos, expansión de terreno por compra, el evento de
amenaza (plaga) escalado al número de parcelas activas, máquinas de compra única, infraestructura
de eficiencia, decoración cosmética y confort/QoL — todo construido encima del core loop ya
validado por el concept prototype (economía compartida de un solo pozo de dinero, tecla de acción
única y contextual, patrón de decisión prevenir-instantáneo-caro vs. reparar-barato-con-downtime).
El prototipo confirmó que ese core loop genera negociación real entre los dos jugadores; su único
punto débil fue la falta de variedad de contenido en qué invertir, que es lo que este sistema busca
abordar. **Nota (revisión post-review)**: este documento por sí solo no agota ese riesgo — el pool
total de gasto que define (~$2.539, ver Formulas 4.5) sigue siendo modesto frente a la duración de
una sesión larga; la profundidad de sink completa depende del sistema de automatización de cintas/
trabajadores de largo plazo (`game-concept.md`, Long-Term Progression), que queda fuera del alcance
de este documento. Confirmar en el playtest de Vertical Slice (Apéndice B, paso 6) si este contenido
por sí solo ya es suficiente o si hace falta adelantar parte de ese sistema.

## 2. Player Fantasy

Construir, junto a tu compañero, una operación agrícola que, **durante aproximadamente los primeros
20-30 minutos de una sesión** (ver acotación exacta más abajo), da una decisión de inversión nueva y
visible cada pocos minutos — otro tipo de cultivo, otra parcela, una máquina que cambia el ritmo, una
mejora de eficiencia — sin que ninguna de esas compras vuelva irrelevante la cosecha manual (Pilar 2:
Manual siempre vale la pena) y siempre representada físicamente en el terreno (Pilar 4: Crecimiento
visible). La sensación de "aburrimiento por falta de opciones" que reportó el playtest del prototipo
busca abordarse aquí, sin introducir parálisis por exceso de opciones — de ahí la progresión de
desbloqueo por hitos (sección 3.10). **No se afirma que este documento resuelva por completo esa
sensación de aburrimiento, ni que la promesa de "decisión cada pocos minutos" cubra la sesión
completa** — eso se confirma o descarta en el playtest de Vertical Slice (Apéndice B).

**Acotación explícita (resuelta en ronda 3 de `/design-review`, antes una promesa sin acotar)**: la
promesa de "decisión cada pocos minutos" de este párrafo aplica solo a la ventana de ~20-30 minutos
documentada más abajo (hasta agotar terreno, Máquinas e Infraestructura tiers 1-3). Más allá de esa
ventana, y hasta que exista el sistema de cintas/trabajadores de largo plazo (`game-concept.md`), la
única opción de gasto restante (Silo tier 4+) es explícitamente **no** una decisión interesante en sí
misma — es un sink de dinero sobrante para jugadores completistas (ver 3.7, 4.5). Para sesiones de
duración típica (15-60 min, hasta 120 min si el par sigue jugando por gusto, `game-concept.md`), esto
significa que la mitad o más de una sesión larga puede transcurrir sin una decisión de inversión nueva
desde este documento. Este documento no propone un sink adicional para cubrir ese hueco a propósito —
la decisión consciente tomada en esta ronda es dejarlo así y confirmarlo o refutarlo en el playtest de
Vertical Slice (Apéndice B, paso 6), no inventar contenido nuevo para taparlo sin validar primero si
hace falta.

**Aclarado en la ronda 2 de `/design-review` (2026-08-10)**: la promesa de "una decisión nueva cada
pocos minutos" se sostiene con el contenido de este documento durante aproximadamente los primeros
20-30 minutos de una sesión (hasta agotar terreno, Máquinas, e Infraestructura tiers 1-3); más allá
de ese punto, el Silo tier 4+ (ver 3.7/4.5) deja de ser una decisión interesante en sí misma, y la
profundidad de opciones reales pasa a depender del futuro sistema de cintas/trabajadores de
`game-concept.md`. No es una falla de este documento — es el límite honesto de lo que su alcance
puede resolver. Confirmar en el playtest de Vertical Slice (Apéndice B) si esa ventana de 20-30
minutos alcanza para la duración típica de sesión (15-60 min) antes de que el aburrimiento reaparezca.

## 3. Detailed Rules

### 3.1 La parcela de cultivo

Cada parcela tiene un **tipo de semilla asignado** (ver 3.2) además de su estado. El color base de
tierra no cambia; el dibujo del cultivo sí varía por tipo, con silueta distinta para que nunca se
confundan entre sí incluso a distancia.

**Estados discretos** (comunes a todos los tipos de cultivo):

| Estado | Señal visual | Duración / disparador |
|---|---|---|
| Vacía | Marrón liso | Estado base tras cosecha o reparación |
| Creciendo | Planta dibujada que gana altura/hojas con el tiempo | Duración según tipo (tabla 3.2) |
| Lista | Brote en color brillante distintivo, parpadeo suave (ciclo 1s) | Tras completar Creciendo |
| Pre-alerta de plaga | Parpadeo rojo tenue ×2 (0.25s cada uno) | 0.5s antes de que se dispare la plaga |
| Marchita | Dibujo craquelado gris-marrón | Tras impacto de plaga sin prevenir |
| Dañada (si hay Refugio comprado) | Marchito recuperable, menos severo que Marchita | Tras impacto de plaga estando dentro del radio de Refugio |
| Reparando (**nuevo en ronda 3**, ver Edge Case 5.10) | Icono de herramienta/martillo sobre el dibujo craquelado, sin parpadeo | Tras tocar una parcela Marchita o Dañada para repararla; dura 4.0s (Marchita) o 2.0s (Dañada) antes de pasar a Vacía — ver 3.4, 4.6, Tuning Knobs |
| Descansando (solo Fresa, añadido en ronda 2, **alcance corregido en ronda 3**) | Tierra removida sin brote, sin parpadeo | 3s tras cosechar una parcela de Fresa; durante este estado **no se puede volver a plantar Fresa en esa parcela**, pero sí cualquier otro cultivo desbloqueado de inmediato (corrección de ronda 3, ver 3.2, Edge Case 5.9) |

**Aclarado en ronda 3 de `/design-review` (elegibilidad de plaga, antes ambigua)**: solo las parcelas
en estado Creciendo o Lista son objetivo válido de plaga y cuentan para `nº_parcelas_activas` (fórmula
4.3) — Vacía, Marchita, Dañada, Reparando y Descansando quedan explícitamente fuera de ambos conteos.
"Pre-alerta de plaga" es un overlay visual sobre una parcela que ya estaba en Creciendo o Lista, no un
estado independiente en la máquina de estados — ver 3.5 y Apéndice D (matriz de estado × acción ×
elegibilidad) para la tabla completa y su justificación.

**Aclarado en `/design-review` 2026-08-10 (mecanismo de render, antes sin especificar)**: "Creciendo"
sigue siendo un estado discreto a nivel de datos (una sola variable de estado), pero su
representación visual interpola entre 3-4 keyframes de sprite/escala (no fotogramas continuos)
según el % de tiempo transcurrido de la duración de ese cultivo — p. ej. vía `AnimationPlayer` con
keyframes en 0%/33%/66%/100% del tiempo de crecimiento. Confirmar contra las APIs de Godot 4.7.1
vigentes (ver `docs/engine-reference/godot/VERSION.md`) antes de implementar, dado el riesgo de
conocimiento marcado ALTO para esta versión. Para el enjambre de plaga (3.5) y las partículas de
impacto, usar nodos pooled/reutilizados (`GPUParticles2D` reutilizado por parcela, o
`MultiMeshInstance2D` para los triángulos del enjambre) en vez de un nodo de partículas nuevo por
evento — necesario para mantenerse dentro del presupuesto de <100 draw calls con hasta 6 parcelas
potencialmente animando a la vez (ver `.claude/docs/technical-preferences.md`).

### 3.2 Tabla de cultivos

| Cultivo | Coste semilla | Duración Creciendo | Unidades al cosechar | Precio venta/unidad | Descanso post-cosecha | Desbloqueo |
|---|---|---|---|---|---|---|
| Trigo | $2 | 6s | 3 | $5 | — | Disponible desde el inicio |
| Maíz | $5 | 12s | 5 | $8 | — | Tras vender 100 unidades acumuladas de trigo |
| Fresa | $8 | 4s | 2 | $12 | 3s (ver Edge Case 5.9) | Tras comprar la 4ª parcela |

**Decisión de balance (resuelta en `/design-review` del 2026-08-10, ver Edge Cases 5.6)**: la Fresa
mantiene su precio de semilla y su $/s más alto que el resto — no se busca igualar su tasa de
beneficio a la del Maíz. En su lugar, es la opción de **mayor riesgo/mayor recompensa** del set,
diferenciada por fragilidad, no por precio: su ventana de reacción a plaga se reduce a 4s (regla
3.5) y queda excluida de la Cosechadora de radio (regla 3.6) — solo se puede cosechar a mano.

**Añadido en la ronda 2 de `/design-review` (2026-08-10, ver Edge Case 5.9)**: la Fresa introduce
además un estado "Descansando" de 3s tras cada cosecha, exclusivo de este cultivo. Esto no cambia su
$/s nominal (la fórmula 4.1 sigue usando solo `duración_creciendo`), pero sí su ciclo real jugable:
4s de crecimiento + 3s de descanso = 7s de ciclo efectivo. El objetivo es puramente de atención, no
de balance económico: sin este descanso, un jugador optimizador puede plantarse en una sola parcela
de Fresa indefinidamente mientras la Cosechadora de radio (3.6) atiende Trigo/Maíz en automático,
eliminando la variedad de decisiones que promete el Player Fantasy (ver nota de alcance en la
Sección 2). Con el descanso, el ciclo efectivo de Fresa ($16 / 7s ≈ $2.29/s) queda mucho más cerca
del de Trigo ($2.17/s) y Maíz ($2.92/s), sin tocar el precio de semilla ni la ventana de reacción a
plaga ya resueltos en la ronda 1.

**Corregido en la ronda 3 de `/design-review` (2026-08-10, ver Edge Case 5.9 y Apéndice C3 #1 — el
descanso por sí solo no cerraba el problema)**: el descanso de 3s es un estado **por parcela**, y el
`/design-review` de ronda 3 encontró que un jugador con 2+ parcelas de Fresa puede intercalarlas
(cosechar A, atender B mientras A descansa, cosechar B, atender A mientras B descansa) y recuperar el
mismo patrón de atención-cero que el descanso existe para evitar — sin perder nada de $/s, al costo de
una parcela adicional (alcanzable de inmediato, ya que la Fresa se desbloquea justo al comprar la 4ª
parcela). Para cerrar esto sin volver a penalizar la parcela individual (que ya castigaba replantar
*cualquier* cultivo durante el descanso, no solo Fresa — otro hallazgo de ronda 3, ver el párrafo
anterior sobre Descansando en 3.1), la regla se traslada de "por parcela" a **"por granja"**:

- **Regla de concurrencia de Fresa (nueva en ronda 3, alcance de estados corregido en ronda 4)**: como
  máximo **una** parcela puede tener Fresa en estado Creciendo, Lista **o Descansando** al mismo
  tiempo, en toda la granja compartida. Si ya existe una parcela con Fresa en cualquiera de esos tres
  estados, Fresa no aparece como opción en el ciclo de semillas (regla 3.4) para ninguna otra parcela
  — igual que un cultivo aún no desbloqueado, no genera penalización, solo no está disponible para
  elegir.
- **Corregido en ronda 4 de `/design-review` (la versión de ronda 3 solo bloqueaba Creciendo/Lista,
  dejando el intercalado abierto a través de Descansando)**: si el gate solo mira Creciendo/Lista, en
  el instante en que la parcela A se cosecha y entra en Descansando, Fresa vuelve a estar disponible
  de inmediato en cualquier otra parcela — un jugador con 2+ parcelas de Fresa puede plantar B justo
  en ese momento, de forma que el crecimiento de B (4s) absorbe por completo el descanso de A (3s) en
  paralelo. La cadencia efectiva de cosecha baja de 7s (4s + 3s) a 4s, igual que si Descansando no
  existiera, para cualquier jugador con 2+ parcelas de Fresa — exactamente el patrón de
  atención-mínima que esta regla existe para cerrar, solo que a través de una puerta distinta a la que
  la ronda 3 cerró (el intercalado entre dos ciclos Creciendo/Lista simultáneos, que sí queda cerrado,
  pero no el intercalado vía Descansando). Incluir Descansando en el conjunto de estados que activan
  el gate cierra esta puerta también: mientras A esté Descansando, Fresa sigue sin estar disponible en
  ninguna otra parcela, así que B solo puede plantarse con Trigo o Maíz durante esos 3s.
- Esto cierra el intercalado por completo: no pueden existir dos ciclos de Fresa progresando —ni uno
  progresando mientras otro descansa— a la vez, sin importar cuántas parcelas de Fresa posea el
  jugador.
- El estado Descansando, que solo bloquea Fresa (no otros cultivos) en esa parcela específica, sigue
  siendo una decisión real: mientras la única parcela de Fresa activa de la granja descansa (Creciendo,
  Lista, o ahora también Descansando), el jugador puede usar cualquier otra parcela para Trigo o Maíz
  sin restricción — la fricción del descanso no es fricción de ejecución sin agencia (violación de
  Pilar 3 identificada en ronda 3), es una decisión real sobre qué hacer con las demás parcelas
  mientras se espera el próximo ciclo de Fresa.

### 3.3 Terreno y expansión

Parcelas no desbloqueadas se ven como tierra gris con textura de "reja" semitransparente y un
icono de candado — no se puede plantar en ellas. Costes en la tabla de Formulas 4.2.

### 3.4 La interacción (tecla de acción única, contextual)

Sigue habiendo una **sola tecla de acción**, contextual según el objeto y estado con el que se
interactúa:

- **Sobre parcela Vacía, mantener 0.4s** (no toque simple, para evitar plantar por accidente al
  pasar corriendo): cicla el tipo de semilla disponible con toques repetidos antes de soltar;
  soltar planta el tipo mostrado en ese momento. Solo aparecen en el ciclo los cultivos ya
  desbloqueados. **⚠ Provisional (ronda 1 de `/design-review` 2026-08-10, alcance corregido en
  ronda 2)**: 0.4s cae en la zona de disparo accidental típica de gestos "hold" en táctil.
  **Corrección de ronda 2**: "toques repetidos mientras se mantiene presionado" no es solo
  riesgoso — es incoherente con un solo dedo. Un toque es en sí mismo un evento de soltar
  (down+up); tocar repetidamente con el mismo dedo que sostiene la pulsación necesariamente suelta
  esa pulsación en cada toque, así que no existe una secuencia de un solo dedo que satisfaga
  "mantener presionado" y "tocar repetidamente" a la vez. El spike de UX táctil ya bloqueante en
  `game-concept.md` (ver Dependencies) no debe leer esto como "confirmar duración y conteo de
  toques" — debe leerse como "seleccionar un mecanismo de ciclado distinto" (p. ej. arrastre
  lateral mientras se sostiene, o ciclar con toques sueltos antes de un hold final de
  confirmación). No se rediseña aquí a propósito, para no adelantarse al resultado del spike — pero
  el marco de la pregunta que el spike debe responder queda corregido.
- **Sobre parcela Lista, toque simple:** cosecha, añade las unidades correspondientes al silo
  compartido. **Feedback añadido en ronda 3 de `/design-review` (antes ausente — el verbo más
  ejecutado del juego no tenía ninguna especificación de feedback, pese al compromiso explícito de
  `game-concept.md` con la estética Sensation: "feedback rápido e inmediato al cosechar —
  partículas, sonido, contador subiendo")**: partícula breve sobre la parcela (silueta del cultivo
  cosechado, ~0.3s), sonido corto de cosecha (varía sutilmente por cultivo, no debe confundirse con
  el flash verde de prevenir plaga), y el número de unidades ganadas aparece brevemente sobre la
  parcela antes de sumarse al contador del silo en HUD. Especificación completa de asset (curvas de
  partícula, mezcla de audio) fuera de alcance de este documento — ver `/asset-spec` y un pase de
  `sound-designer` antes de implementar.
- **Sobre parcela en alerta de plaga, toque simple:** previene, –$15 del dinero compartido, la
  parcela vuelve a su estado previo (Creciendo o Lista) sin pérdidas.
- **Sobre parcela Marchita o Dañada, toque simple:** inicia la reparación (–$10 Marchita / –$5
  Dañada) y la parcela pasa a estado **Reparando** (**corregido en ronda 3 de `/design-review`** —
  antes instantánea, lo cual contradecía el patrón de trade-off ya validado en `game-concept.md`
  Pilar 5: "reparar cuesta menos pero incluye tiempo de inactividad"). Reparando dura 4.0s (Marchita)
  o 2.0s (Dañada, ver 3.7 Refugio) antes de pasar a Vacía — la parcela requiere replantar desde cero
  tras la reparación (paga semilla de nuevo), consistente con 3.1 ("Vacía... Estado base tras cosecha
  o reparación"). Ver Edge Case 5.10, Formulas 4.6, AC 3c.
- **Sobre parcela con reja (no comprada), toque simple:** si hay saldo suficiente, la compra al
  instante (sin canalización — es decisión "antes de la partida", no "en caliente"). Sin saldo:
  el candado tiembla, sin penalización (ver Edge Cases).
- **Regla general de saldo insuficiente (añadida en ronda 3 de `/design-review`, antes solo cubría
  compras discrecionales — ver Edge Case 5.10)**: cualquier acción con costo fijo — comprar terreno,
  prevenir plaga, reparar, comprar máquina/infraestructura/decoración/confort — que se intenta sin
  saldo suficiente en el pozo compartido produce el mismo feedback (temblor + sonido negativo breve),
  sin descontar dinero ni ejecutar el efecto. Para **prevenir** y **reparar** específicamente, que son
  costos forzosos (el jugador no elige si enfrentarlos, a diferencia de una compra), esto implica que
  intentar pagarlos sin saldo simplemente no hace nada — no es un bloqueo adicional, porque prevenir
  sin saldo ya lleva a la resolución automática de la plaga (pasa a Marchita al expirar la ventana,
  regla 3.5) y reparar sin saldo simplemente deja la parcela en Marchita/Dañada hasta que haya saldo.
  Ver Edge Case 5.10 para el piso anti-softlock que cubre el caso límite de saldo $0 con toda la
  granja Marchita/Dañada simultáneamente (mandato del Pilar 5 de `game-concept.md`, no implementado
  en rondas anteriores).
- **Sobre el punto de venta, toque simple:** inicia la canalización de venta (duración según 4.4,
  entre 1s y 2s según nivel de Silo ampliado) durante la cual el jugador no puede moverse ni
  defender ninguna parcela. **Un segundo toque sobre el punto de venta mientras se canaliza cancela
  la venta**: no se descuenta ni se suma nada, el jugador recupera movimiento de inmediato — solo
  pierde el tiempo ya invertido en la canalización (resuelto en `/design-review` 2026-08-10, ver
  Edge Cases 5.4). Si la canalización completa sin cancelar, vende todo el silo y suma el dinero
  correspondiente al pozo compartido. **⚠ Provisional**: si el compañero en el otro dispositivo
  puede ver que el vendedor está canalizando (para poder cubrir esa parcela) depende del spike de
  UX táctil/aviso entre compañeros — no definido aquí, ver Dependencies.
- **Sobre el Taller de máquinas, toque simple:** abre menú de compra de máquina. No pausa el
  juego — las plagas siguen corriendo mientras decides.
- Pulsar en el momento equivocado (p. ej. cosechar sobre Creciendo): feedback de "no todavía"
  (el brote tiembla una vez), sin penalización económica.

### 3.5 Evento de tensión — plaga

- Intervalo entre plagas por parcela: aleatorio, escala con el número de parcelas activas (fórmula
  en 4.3).
- **Cooldown global obligatorio de 15s** entre disparos de plaga en parcelas distintas.
- Señal doble siempre: enjambre físico (triángulos oscuros cerrándose sobre la parcela en pasos
  discretos de ~0.8s) + texto naranja en HUD que especifica lado/parcela afectada.
- Ventana de reacción: 6s desde que el enjambre es visible (tras los 0.5s de pre-alerta) para
  Trigo y Maíz. **Para Fresa, la ventana se reduce a 4s** (decisión de balance, ver 3.2 y Edge
  Cases 5.6) — es parte deliberada de su perfil alto riesgo/alta recompensa, no un descuido.
- Prevenir a tiempo: –$15 compartido, flash verde 0.3s, la parcela vuelve a su estado previo sin
  pérdidas.
- No prevenir: pasa a Marchita (o Dañada si hay Refugio y el jugador está dentro), se pierde
  cualquier cosecha que hubiera, sacudida de cámara 0.2s + partícula de polvo/hojas rotas + sonido
  grave. Este es el camino de fallo — ver Acceptance Criteria 8.3b para su criterio de prueba
  (antes ausente).
- **Elegibilidad de objetivo (aclarado en ronda 3 de `/design-review`, antes ambiguo — ver 3.1 y
  Apéndice D)**: solo una parcela en Creciendo o Lista puede recibir una plaga. Una parcela Vacía,
  Marchita, Dañada, Reparando o Descansando nunca es objetivo — no tiene nada que perder, y
  targetearla habría producido resultados sin sentido (p. ej. una plaga "marchitando" tierra vacía).
  **Excepción explícita, resuelta en ronda 3 (ver 3.7, Edge Case 5.8)**: una parcela Lista que está
  bloqueada por silo lleno (5.8) queda excluida de la elegibilidad de plaga mientras dure el bloqueo
  — no puede perder su cosecha por una plaga que el jugador no podía haber prevenido cosechando a
  tiempo, porque cosechar a tiempo ya estaba mecánicamente bloqueado por el silo. Esto evita el doble
  castigo que ronda 3 encontró (silo lleno + plaga sin prevenir = pérdida de una cosecha que el
  sistema ya le había impedido bancar), y mantiene honesta la promesa de "sin pérdida" de 5.8. No es
  explotable como escudo permanente: mientras el silo esté lleno, esa misma parcela tampoco puede
  cosecharse ni venderse — el jugador no gana nada manteniendo el silo lleno a propósito, solo evita
  perder valor ya generado por una restricción de capacidad ajena a su control.
- **⚠ Provisional (network-authority)**: los 0.5s de pre-alerta y la ventana de reacción se
  describen como si ambos dispositivos vieran el mismo instante — en una arquitectura cliente/host,
  la latencia de wifi local puede retrasar cuándo el enjambre se hace visible en el dispositivo
  cliente frente al host. El margen real de reacción en el cliente, y qué regla de autoridad
  resuelve un empate si ambos jugadores actúan sobre la misma parcela casi simultáneamente, quedan
  sujetos al spike técnico de red (ver Dependencies) — no se define una regla de autoridad aquí a
  propósito.

### 3.6 Máquinas (Taller — compra única, efecto permanente)

**Resuelto en `/design-review` 2026-08-10 (Pilar 4 — Crecimiento visible)**: ambas máquinas deben
tener presencia física visible en el terreno, no ser solo un efecto de menú. Cada máquina, al
comprarse, coloca una estructura visible junto al Taller (un objeto de escena distinto por
máquina, con su propio sprite/silueta) — no requiere colocación por el jugador ni cuadrícula
propia, pero debe ser visualmente identificable desde el terreno como una pieza de equipo
instalada, igual que cualquier otra mejora del Pilar 4.

| Máquina | Coste | Efecto | Presencia visual |
|---|---|---|---|
| Sembradora rápida | $200 | Reduce el mantener-tecla de plantar de 0.4s a 0.15s | Estructura pequeña junto al Taller (silueta de sembradora) |
| Cosechadora de radio | $350 | Al cosechar manualmente una parcela Lista, dispara la auto-cosecha de cualquier otra parcela Lista **de Trigo o Maíz** (nunca Fresa, ver 3.2) en radio Chebyshev de 1 tile (las 8 parcelas orto/diagonalmente adyacentes a la parcela objetivo), con un retraso de **25% de la `duración_creciendo` de la parcela auto-cosechada** tras el disparo (ver 3.2 nota abajo, Formulas 4.1, Tuning Knobs) | Estructura junto al Taller (silueta de cosechadora), más un indicador visual breve (parpadeo) sobre cada parcela que auto-cosecha |

**Resuelto en `/design-review` 2026-08-10 (Pilar 2 — Manual siempre vale la pena)**: la Cosechadora
nunca cosecha Fresa (es manual-only, ver 3.2) y su auto-cosecha en Trigo/Maíz tiene un retraso desde
que se dispara — la cosecha manual sigue siendo instantánea. Esto preserva dos ventajas concretas de
lo manual: acceso al cultivo de mayor $/s, y velocidad de ciclo en cualquier cultivo.

**Corregido en ronda 3 de `/design-review` (mecanismo de disparo, antes contradictorio en tres
lugares del documento)**: la tabla de arriba, los Tuning Knobs y AC9 describían el retraso de tres
formas distintas — dos de ellas ("tras alcanzar Lista", per-parcela e independiente de cualquier
acción del jugador) equivalían a que la Cosechadora cosechara sola sin que el jugador tocara nada,
lo cual roza el Anti-Pilar de `game-concept.md` ("NO automatización 100% desatendida"). Se fija la
lectura correcta, la única no contradictoria con el Anti-Pilar y la que ya usaba AC9: **la
auto-cosecha solo se dispara como reacción a una cosecha manual del jugador** sobre la parcela
objetivo — sin esa cosecha manual disparadora, ninguna otra parcela en radio se auto-cosecha jamás,
sin importar cuánto tiempo lleven en Lista. El retraso mide el tiempo desde ese disparo manual hasta
que se ejecuta la auto-cosecha en las parcelas vecinas elegibles.

**Corregido en ronda 3 de `/design-review` (retraso proporcional, antes un valor fijo de 1.5s)**: un
retraso fijo de 1.5s representa el 25% del ciclo de Trigo (6s) pero solo el 12.5% del ciclo de Maíz
(12s) — la ventaja de lo manual se debilitaba justo en el cultivo de mayor $/s de los dos que la
Cosechadora sí puede tocar. Se cambia a **25% de la `duración_creciendo` de la parcela auto-cosechada**
(Trigo: 1.5s, sin cambio; Maíz: 3.0s), preservando la misma proporción de ventaja manual en ambos
cultivos según crece el juego. Ver Tuning Knobs para el rango seguro del porcentaje.

**Añadido en la ronda 2 de `/design-review` 2026-08-10, mecanismo de reanudación especificado en
ronda 3 (antes un hand-wave — "se retoma automáticamente" sin definir qué lo dispara)**: si el silo
está lleno (ver 3.7, Edge Case 5.8) en el momento en que la auto-cosecha debería ejecutarse, la
auto-cosecha se pospone — la parcela objetivo permanece en Lista, el retraso ya transcurrido no se
pierde (se reanuda desde donde iba, no desde cero). El re-chequeo de espacio disponible es
**event-driven**, no un sondeo por frame: se dispara en cualquier evento que libere capacidad del
silo (venta completada, o cualquier cosecha manual que reduzca el valor almacenado), y también en
cualquier nueva cosecha manual disparadora de la Cosechadora (ver corrección de mecanismo de disparo
arriba). No consume el retraso proporcional en vano ni pierde la cosecha objetivo.

### 3.7 Infraestructura (eficiencia, no cosmética — compra en Taller o estructura dedicada)

| Estructura | Coste | Límite | Efecto | Presencia visual | Desbloqueo |
|---|---|---|---|---|---|
| Silo ampliado (tiers 1-3) | $80 → $200 → $400 ($680 acumulado) | 3× | Cada compra suma +$200 de capacidad; la canalización de venta baja según fórmula 4.4 (2s → 1s) | Estructura de silo física junto al Taller; cada tier comprado añade un segmento/anillo visible a la misma estructura (no una estructura nueva por tier), creciendo en altura | Tras acumular $500 en ventas totales |
| Silo ampliado (tiers 4+) | Cada tier adicional cuesta el doble del anterior ($800, $1.600, ...) | Sin límite (económico); **cap visual de 6 segmentos** (ver nota abajo, nueva en ronda 3) | Cada compra suma +$200 de capacidad adicional; **no reduce más la canalización** (se queda en 1s, piso fijado en tier 3) | Mismo silo, añade un segmento visible por tier hasta un máximo técnico de 6 segmentos apilados; tiers adicionales más allá del 6º no añaden geometría nueva — el segmento superior muestra una insignia numérica con el conteo de tiers extra (ver nota abajo) | Tras completar el tier 3 |
| Almacén de semillas | $120 | 1× (la estructura); 5 slots, cada uno recargable de forma independiente | Desbloquea 5 slots de semilla, cada uno asignable a un tipo de cultivo desbloqueado. **Recarga manual (especificada en ronda 3, antes sin definir)**: tocar el Almacén abre un selector de cultivo por slot vacío; recargar un slot cuesta el precio de semilla de ese cultivo (tabla 3.2, cobrado al recargar, no al plantar) más ~1.0s de animación de recarga. Con un slot cargado, plantar en una parcela Vacía pasa de mantener 0.4s a **toque simple 0.1s** y consume 1 unidad del slot | Estructura pequeña tipo cobertizo/estante junto al Taller, distinta de las Máquinas y del Silo, visible desde que se compra; cada slot cargado muestra un icono del cultivo asignado | Tras plantar 50 unidades totales |
| Abrigo/Refugio | $150 | 1× | Estar dentro del radio de **1.5 unidades de mundo** (ver nota abajo, antes "1 tile" sin unidad definida) cuando llega una plaga reduce el daño: la parcela pasa a "Dañada" (reparable, –$5, 2.0s de Reparando) en vez de "Marchita" (rota, –$10, 4.0s de Reparando — ver 3.4, 4.6) | Estructura de techo/refugio visible, colocada en un punto fijo del terreno — su radio de efecto (ver Efecto) se ancla siempre a esta estructura, nunca a una posición abstracta; un **sprite de anillo (`Sprite2D` o `Line2D` circular — corregido en ronda 3: "decal" es un nodo 3D-only en Godot, no aplica a este juego 2D)** en el suelo marca el borde del radio | Tras sufrir 3 plagas |

**Resuelto en la ronda 2 de `/design-review` 2026-08-10 (Pilar 4 — Crecimiento visible)**: la
Infraestructura tenía la misma omisión que las Máquinas tuvieron en la ronda 1 — sin presencia
física obligatoria. Cada estructura de esta tabla ahora tiene una regla de presencia visual
explícita (columna nueva), incluyendo el Refugio, cuyo radio de efecto ahora se ancla a una
estructura física concreta en vez de a una zona abstracta sin ubicación definida — esto también
resuelve la ambigüedad de dónde está "la zona" del Refugio, que ninguna ronda anterior había fijado.

**Añadido en la ronda 2 de `/design-review` 2026-08-10 (capacidad base y desbordamiento del Silo,
antes sin definir)**: antes de comprar cualquier tier de Silo, la capacidad base del silo compartido
es **$150** de valor de venta acumulado sin vender (no unidades físicas — ver fórmula 4.4). Si el
silo está lleno (el valor de las unidades almacenadas sin vender iguala su capacidad actual) y una
parcela pasa a Lista o ya lo está, cosecharla a mano no funciona: produce el feedback de "silo
lleno" (icono de silo con un parpadeo rojo breve), no descuenta ni pierde nada, y la parcela
permanece en estado Lista indefinidamente hasta que haya espacio. No hay pérdida de cosecha ni
penalización — el costo es puramente de oportunidad (la parcela sigue "Lista" en vez de reiniciar su
ciclo), preservando el Pilar 2 en vez de castigar lo manual. Ver Edge Case 5.8 y AC 2b.

**Resuelto en `/design-review` 2026-08-10 (profundidad de sinks), acotado en ronda 3**: el Silo
ampliado ya no tiene un techo duro de 3 compras — a partir del tier 4, cada compra sigue sumando
capacidad (aunque ya no reduce la canalización de venta) a un coste que se duplica cada vez. Esto
extiende el pool total de gasto disponible sin rediseñar Máquinas ni inventar contenido nuevo — ver
Formulas 4.5 para el cálculo actualizado del runway. **Ronda 3 encontró que esta extensión es solo
nominal, no funcional**: el $/capacidad se degrada ~40× entre el tier 1 y el tier 6 (de $0.40 a
$16 por cada $1 de capacidad extra), así que un jugador que calcula el retorno deja de comprar
alrededor del tier 3-4 — el hallazgo original ("pool de sinks poco profundo, ~$2.539") no queda
resuelto por esta extensión, solo aplazado unos tiers. Se recalifica explícitamente: el Silo tier 4+
es un **sink de prestigio/cosmético** para jugadores completistas dispuestos a gastar dinero
sobrante sin retorno mecánico real (la estructura sigue creciendo visualmente, ver Pilar 4), no una
solución a la escasez de decisiones interesantes. Ver Apéndice C (fila 3) para la corrección de la
etiqueta "resuelto" y Apéndice D para el detalle numérico.

**Especificado en ronda 3 de `/design-review` (cap visual del Silo, antes "sin límite de segmentos"
sin matizar)**: el diseño económico del Silo tier 4+ es deliberadamente sin techo (arriba), pero
nada obliga a que la representación visual escale 1:1 con los tiers comprados — hacerlo sería un
riesgo real de draw calls en un presupuesto móvil de <100 draw calls (`.claude/docs/technical-
preferences.md`), especialmente combinado con hasta 6 parcelas animadas, el enjambre de plaga, 2
máquinas, Almacén, Refugio y hasta 10 ítems de decoración simultáneos en pantalla. Se fija un **cap
técnico de 6 segmentos visibles**, independiente del cap económico (que sigue sin límite): tiers
más allá del 6º no instancian geometría nueva, solo actualizan una insignia numérica en el segmento
superior. Esto no afecta el efecto mecánico de ningún tier (Formulas 4.4/4.5 no cambian).

**Añadido en ronda 3 de `/design-review` (Almacén de semillas vs. Sembradora rápida, antes sin
resolver)**: con Almacén completamente especificado arriba (recarga manual, cobro al recargar), la
comparación entre ambas máquinas queda: Sembradora ($200) da mantener-0.15s **permanente, sin
fricción de recarga, en cualquier cultivo, para siempre**; Almacén ($120) da toque-simple-0.1s **por
ráfaga**, limitada a 5 unidades antes de necesitar recargar (costo de semilla + ~1s de animación por
slot). Esto evita que Almacén domine estrictamente a Sembradora pese a ser más barato: Almacén es
mejor para ráfagas cortas de plantado (p. ej. tras expandir terreno), Sembradora es mejor para juego
sostenido donde la fricción de recarga de Almacén se vuelve costosa en tiempo. Poseer ambas es
válido y no se anulan entre sí — si un slot de Almacén tiene semilla cargada del tipo mostrado en el
ciclo, un toque simple usa Almacén (0.1s); si el slot está vacío o sin ese tipo, la interacción cae
al comportamiento de mantener de Sembradora (0.15s) o al de base (0.4s) si no se posee Sembradora.

### 3.8 Decoración (cosmética, sin efecto mecánico)

| Item | Coste | Límite |
|---|---|---|
| Valla de madera | $15 | 6× |
| Bandera de parcela | $8 | 3× |
| Cartel de bienvenida | $25 | 1× |

Disponibles desde el minuto 1 — son baratas y no necesitan hito de desbloqueo.

### 3.9 Confort / QoL

| Item | Coste | Límite | Efecto |
|---|---|---|---|
| Timbre de alarma personalizado | $10 | 1× | Cambia el sonido de alerta de plaga por uno menos estresante, sin efecto funcional |
| Mostrador de dinero grande | $20 | 1× | Amplía el HUD de dinero compartido para que sea más visible |

Aparecen en el menú tras 5 minutos de partida, para que el jugador primero entienda el ritmo base
antes de que se le ofrezcan mejoras de comodidad.

### 3.10 Progresión de desbloqueo de menú (mitigación de parálisis por análisis)

Con 10+ opciones de gasto disponibles desde el minuto 1, el jugador se bloquea decidiendo. Regla:
nada de infraestructura/confort visible hasta cumplir su hito:

- Silo ampliado → $500 acumulados en ventas
- Almacén de semillas → 50 unidades plantadas totales
- Abrigo/Refugio → 3 plagas sufridas
- Valla, bandera, cartel → siempre visibles desde el inicio
- Timbre, mostrador → visibles tras 5 minutos de partida

Parcelas y máquinas siempre visibles desde el inicio (son la progresión principal).

**Resuelto en `/design-review` 2026-08-10 (aviso de desbloqueo)**: cumplir un hito no añade el
ítem al menú en silencio — dispara un aviso breve en pantalla (ícono + nombre del ítem, ~2s,
no bloqueante) en el dispositivo de ambos jugadores, para que el desbloqueo se sienta como un
momento ganado y no como una entrada más en una lista. Si dos hitos se cumplen en el mismo frame,
ambos ítems se desbloquean y se avisan a la vez, sin orden especial entre ellos.

## 4. Formulas

### 4.1 Rentabilidad por cultivo ($/segundo de crecimiento)

`beneficio_por_segundo = (unidades_al_cosechar × precio_venta − coste_semilla) / duración_creciendo`

| Cultivo | Cálculo | Beneficio/s | Ventana de reacción a plaga |
|---|---|---|---|
| Trigo | (3×$5 − $2) / 6s = $13/6s | **$2.17/s** | 6s |
| Maíz | (5×$8 − $5) / 12s = $35/12s | **$2.92/s** | 6s |
| Fresa | (2×$12 − $8) / 4s = $16/4s | **$4.00/s** | **4s** (ver 3.5) |

**Decisión de balance (resuelta en `/design-review` 2026-08-10, ver 3.2 y Edge Cases 5.6)**: la
Fresa se queda con el $/s más alto ($4.00/s) a propósito — no se buscó igualarlo al del Maíz
($2.92/s) subiendo el precio de semilla, porque el propio cálculo mostraba que ni siquiera el
extremo alto de un rango de precio candidato ($11 → $3.25/s) cerraba la brecha del todo. En su
lugar, la Fresa se diferencia por **riesgo**, no por tasa: ventana de reacción más corta (4s en vez
de 6s) y exclusión de la Cosechadora de radio (3.6, manual-only). Es la opción alto riesgo/alta
recompensa del set por diseño.

### 4.2 Coste de expansión de terreno

| Parcela | Coste | Ratio vs. anterior |
|---|---|---|
| 3ª | $50 | — |
| 4ª | $120 | ×2.40 |
| 5ª | $250 | ×2.08 |
| 6ª | $450 | ×1.80 |

Nota: la fuente original describe esta progresión como "~×2.1"; el promedio de los tres ratios es
2.09, pero ningún paso individual es exactamente ×2.1 — es una tabla de valores fijos, no una
fórmula geométrica estricta. Se preserva la tabla tal cual (cambiar los valores sería una decisión
de balance fuera del alcance de este reformateo).

### 4.3 Intervalo de plaga (por parcela activa)

`intervalo_min = 25 + (nº_parcelas_activas × 3)` segundos
`intervalo_max = 45 + (nº_parcelas_activas × 3)` segundos

donde `nº_parcelas_activas` = parcelas en estado **Creciendo o Lista únicamente** (definición
corregida en ronda 3 de `/design-review` — la definición anterior, "no vacías, no bloqueadas por
reja", era auto-contradictoria para Marchita/Dañada/Reparando/Descansando, que no son "vacías" en
sentido literal pero tampoco deberían presionar el ritmo de plagas; ver 3.1 y Apéndice D para la
matriz completa). **Aclarado en ronda 4 (la formulación anterior era imprecisa, no solo redundante)**:
esta definición **casi** coincide con la elegibilidad de objetivo de plaga (3.5), pero no son
estrictamente equivalentes — hay una única excepción, ya documentada en 3.5 y en la matriz de
Apéndice D.1: una parcela Lista bloqueada por silo lleno sigue contando para `nº_parcelas_activas`
(sigue "ocupando" un ciclo de cultivo) pero **no** es objetivo válido de plaga (5.8 la excluye para
evitar el doble castigo). La relación correcta es "objetivo de plaga válido ⟹ cuenta como activa",
no "si y solo si" — ver Apéndice D.1 para la regla derivada completa.

| nº parcelas activas | intervalo_min | intervalo_max |
|---|---|---|
| 2 | 31s | 51s |
| 4 | 37s | 57s |
| 6 | 43s | 63s |

Más el **cooldown global de 15s** entre disparos en parcelas distintas (regla 3.5), independiente
de esta fórmula.

**Aclarado en `/design-review` 2026-08-10 (rango y caso límite, antes sin definir)**: la fórmula es
válida para `nº_parcelas_activas` entre 0 y 6 (el máximo de parcelas de la sección 3.3 — si una
futura revisión añade una 7ª parcela o más, esta fórmula debe revisarse explícitamente, no
extrapolarse en silencio). En `nº_parcelas_activas = 0` (todas las parcelas vacías o bloqueadas),
el temporizador de plaga se pausa por completo — no se genera ninguna amenaza sin al menos un
cultivo plantado.

### 4.4 Silo ampliado — capacidad y canalización de venta

- **Capacidad base (añadido en ronda 2, antes sin definir)**: $150 de valor de venta acumulado sin
  vender, antes de comprar cualquier tier de Silo. Ver Edge Case 5.8 para el comportamiento de
  desbordamiento.
- Capacidad extra acumulada por tier: $200 por compra. Tiers 1-3 cuestan $80/$200/$400 ($680
  acumulado); desde el tier 4 (ver 3.7), cada compra cuesta el doble de la anterior ($800, $1.600...).
- **Canalización de venta (aclarado en `/design-review` 2026-08-10 — antes un lookup de 2 puntos
  sin regla para tiers parciales)**:
  `canalización_venta = max(1.0, 2.0 − (tiers_completados × (1.0 / 3.0)))` segundos, para
  `tiers_completados` de 0 a 3 (tier 4+ no reduce más este valor, se queda fijo en 1.0s).

| tiers_completados | canalización_venta |
|---|---|
| 0 | 2.00s |
| 1 | 1.67s |
| 2 | 1.33s |
| 3+ | 1.00s (piso) |

*(Nota: la tabla muestra valores redondeados a 2 decimales para lectura; la implementación debe
calcular desde la fórmula directamente, no copiar los valores de la tabla — 1.67s y 1.33s son
decimales periódicos (5/3 y 4/3) y hardcodearlos introduce ~0.003s de desvío. Aclarado en ronda 3.)*

**Aclarado en ronda 3 de `/design-review` (comportamiento cerca de la capacidad, antes solo probado
en el caso exacto)**: el chequeo de desbordamiento (Edge Case 5.8) compara el valor almacenado
**antes** de la cosecha contra la capacidad actual — no proyecta si la cosecha entrante empujaría el
total por encima de la capacidad. Esto es intencional, no un descuido: una parcela a $140/$150 de
capacidad puede aceptar una cosecha de Maíz de $40 y terminar en $180 (20% sobre el nominal). Se
prioriza nunca bloquear una cosecha manual válida (Pilar 2) por encima de hacer cumplir un techo
duro de capacidad — el "desbordamiento" es una holgura de hasta el valor de una cosecha, no un bug.
Ver AC 2c para el caso de prueba explícito de esta zona (antes solo cubierta la igualdad exacta).

### 4.5 Runway total del pool de gasto (añadido en `/design-review` 2026-08-10)

Suma de todo el contenido comprable una sola vez (excluye cultivos, que son un gasto recurrente):
terreno (4.2: $50+$120+$250+$450 = $870) + máquinas (3.6: $200+$350 = $550) + infraestructura base
(3.7: Silo tiers 1-3 $680 + Almacén $120 + Refugio $150 = $950) + decoración (3.8: 6×$15 + 3×$8 +
$25 = $139) + confort (3.9: $10+$20 = $30) = **$2.539** en contenido de un solo tier. Con la
extensión del Silo más allá del tier 3 (3.7), el pool ya no tiene techo duro: el tier 4 cuesta
$800, el 5 cuesta $1.600, etc. — cada tier adicional dobla el anterior, así que agregar tiers
sucesivos extiende el runway con retornos decrecientes rápidos (útil como sink de "dinero
sobrante" en sesiones largas, no como contenido con decisión interesante en sí mismo). Esto reduce
el riesgo de "se me acabó en qué gastar" documentado como hallazgo principal del `/design-review`,
pero no lo elimina — ver la nota en Overview sobre la dependencia del sistema de automatización de
largo plazo para la profundidad de sink definitiva. **Corrección de ronda 3**: esta extensión resulta
ser solo nominal por el colapso de $/capacidad descrito en 3.7 — no se elimina la etiqueta "riesgo
reducido" del párrafo, pero se retira la etiqueta "resuelto" que Apéndice C (fila 3) le había dado
al hallazgo original; ver 3.7 y Apéndice D para el detalle.

**Supuesto de persistencia entre sesiones (añadido en ronda 3, antes ausente — ronda 3 encontró que
todas las conclusiones de runway de esta sección dependían de una respuesta no declarada)**: este
documento asume que la economía de la granja **no persiste entre sesiones** — no hay guardado/carga
de progreso económico en el alcance de este documento ni de `game-concept.md`, que tampoco lo
menciona. Esto es coherente con sesiones de duración típica 15-60 min (hasta 120 min) descritas como
la unidad de juego completa en `game-concept.md`. Si una fase posterior añade persistencia entre
sesiones, este supuesto debe revisarse explícitamente junto con el runway de esta sección (4.5) y el
cap visual de segmentos del Silo (3.7) — persistencia cross-session vuelve alcanzables tiers de Silo
mucho más altos de los que una sola sesión permite, lo cual reabriría la pregunta de si el cap visual
de 6 segmentos sigue siendo suficiente.

### 4.6 Reparación — downtime y valor esperado (nuevo en ronda 3, ver Apéndice D para la tabla de EV completa)

Implementa el patrón de trade-off ya validado por el prototipo y exigido por `game-concept.md` Pilar
5 ("reparar cuesta menos pero incluye tiempo de inactividad"), que rondas 1 y 2 de este documento no
habían instanciado — el repair de este documento era instantáneo hasta esta ronda (ver 3.4).

| Camino de fallo | Costo | Downtime (Reparando) | Resultado tras downtime |
|---|---|---|---|
| Marchita → reparar | –$10 | 4.0s | Vacía (requiere replantar, paga semilla de nuevo) |
| Dañada (con Refugio) → reparar | –$5 | 2.0s | Vacía (requiere replantar, paga semilla de nuevo) |
| Prevenir a tiempo | –$15 | 0s (instantáneo) | Vuelve a Creciendo/Lista, sin pérdida de progreso |

El downtime, sumado a la pérdida total del progreso de crecimiento (reparar siempre vuelve a Vacía,
nunca a Creciendo/Lista) y al costo de resembrar, es lo que hace que prevenir valga la pena cuando
hay progreso real que proteger — ver Apéndice D (tabla de EV) para la comparación numérica completa
por cultivo y etapa, que confirma que la relación se sostiene mejor que en las rondas anteriores
(donde reparar no tenía downtime y por tanto dominaba a prevenir en la mayoría de los casos) pero
identifica que sigue sin ser una dominancia limpia en todos los casos — ver Apéndice D para el
detalle y la recomendación.

## 5. Edge Cases

5.1. **Toque en el momento equivocado** (p. ej. cosechar sobre una parcela en Creciendo): el brote
   tiembla una vez, sin penalización económica ni de tiempo.

5.2. **Compra de parcela sin saldo suficiente**: el candado tiembla, no se descuenta dinero, la
   parcela permanece bloqueada — no hay reintento automático ni cola de compra.

5.3. **Plagas en parcelas distintas próximas a dispararse a la vez**: el cooldown global de 15s
   (regla 3.5) impide que dos plagas se disparen con menos de 15s de diferencia entre sí,
   independientemente de lo que indique la fórmula 4.3 para cada parcela individual. **Comportamiento
   por defecto mientras no se confirme en playtest** (resuelto en `/design-review` 2026-08-10, antes
   sin fallback): se asume que 15s es aceptable y no se cambia nada hasta tener datos de Vertical
   Slice con 5-6 parcelas activas; si el playtest muestra que se siente injusto o abrumador, el
   primer ajuste a probar es subir el cooldown a 20s (dentro del rango ya definido en Tuning Knobs)
   antes de tocar la fórmula 4.3.

5.4. **Vulnerabilidad durante la venta**: durante la canalización de venta (fórmula 4.4, entre 1s y
   2s según Silo), el jugador no puede moverse ni defender ninguna parcela. **Resuelto en
   `/design-review` 2026-08-10**: un segundo toque sobre el punto de venta durante la canalización
   la cancela sin penalización (regla 3.4) — si llega una plaga durante la canalización, el jugador
   puede cancelar y reaccionar en vez de quedar indefenso hasta que termine. Sigue pendiente de
   confirmar en playtest si el compañero puede ver que el vendedor está canalizando para cubrir esa
   parcela él mismo — ver nota provisional en regla 3.4 (depende del spike de UX táctil/aviso entre
   compañeros).

5.5. **Menú con 10+ opciones de gasto desde el minuto 1**: mitigado por la progresión de desbloqueo
   por hitos (regla 3.10) con aviso visible al desbloquear (resuelto en `/design-review`
   2026-08-10). **Comportamiento asumido por defecto**: se considera mitigado por diseño hasta que
   el playtest de Vertical Slice indique lo contrario; no se requiere ninguna acción provisional
   adicional a menos que el playtest muestre parálisis persistente.

5.6. **Fresa desequilibrada frente a Maíz y Trigo en $/segundo** (ver Formulas 4.1): **resuelto en
   `/design-review` 2026-08-10**. Se descartó buscar paridad de $/s (el cálculo mostraba que ni el
   extremo alto del rango de precio candidato la cerraba del todo) y se optó por diferenciación de
   riesgo: ventana de reacción de 4s en vez de 6s (regla 3.5) y exclusión de la Cosechadora de radio
   —manual-only— (regla 3.6). La Fresa sigue teniendo el $/s más alto del set, a propósito, como
   recompensa por el riesgo. Confirmar en playtest si 4s de ventana es suficientemente arriesgado sin
   sentirse imposible de reaccionar en pantalla táctil real (relacionado con el spike de UX táctil,
   ver Dependencies).

5.7. **(Añadido en `/design-review` 2026-08-10) Colisión de acciones simultáneas de ambos jugadores
   sobre la misma parcela** (p. ej. uno cosecha mientras el otro previene una plaga en la misma
   parcela, en dispositivos separados): **sin resolver a propósito** — depende de la regla de
   autoridad que defina el spike técnico de red (host-autoritativo o similar). No se inventa una
   regla de desempate aquí para no adelantarse a ese spike; ver Dependencies. Hasta que se resuelva,
   este documento no debe tratarse como implementation-ready para la interacción compartida de
   parcelas.

   **Ampliado en la ronda 2 de `/design-review` 2026-08-10**: la misma clase de riesgo aplica a
   cualquier compra de un solo uso o con límite desde el pozo compartido — expansión de terreno
   (3.4), Máquinas (3.6, compra única), tiers de Silo (3.7), y los límites de Decoración/Confort
   (3.8/3.9, AC10). Si ambos jugadores intentan comprar el mismo ítem limitado en el mismo instante
   (p. ej. el último tier disponible de una Máquina, o la última unidad de Valla), existe el mismo
   riesgo de doble gasto o doble asignación por encima del límite que en la colisión de parcela ya
   documentada arriba. **Sin resolver a propósito, por la misma razón**: depende del modelo de
   autoridad que fije el spike técnico de red (ver el supuesto base no vinculante añadido en
   Dependencies). Hasta entonces, ninguna compra limitada de este documento debe tratarse como segura
   contra condiciones de carrera entre los dos dispositivos.

5.8. **(Añadido en la ronda 2 de `/design-review` 2026-08-10, feedback y elegibilidad corregidos en
   ronda 3) Silo lleno al intentar cosechar**: si el valor de venta de las unidades almacenadas sin
   vender ya iguala o supera la capacidad actual del silo (base $150, ver Formulas 4.4 — chequeo
   pre-cosecha, ver 4.4 para la nota sobre desbordamiento tolerado), tocar una parcela Lista no
   cosecha — no descuenta ni pierde nada, y la parcela permanece en estado Lista indefinidamente.
   **Feedback corregido en ronda 3 (antes solo un icono de HUD desconectado del punto de toque)**: se
   dispara *tanto* el parpadeo rojo breve del icono de silo en HUD *como* un sacudido/overlay
   localizado sobre la parcela misma tocada (distinto del temblor de "no todavía" de 5.1, para no
   confundirse con un fallo de input) — el jugador recibe la señal exactamente donde tocó, no solo en
   un rincón de la pantalla. La auto-cosecha de la Cosechadora de radio (3.6) tampoco se dispara
   mientras el silo esté lleno; ver 3.6 para el mecanismo de reanudación event-driven especificado en
   ronda 3. **Elegibilidad de plaga corregida en ronda 3**: mientras una parcela Lista esté bloqueada
   por silo lleno, queda excluida de ser objetivo de plaga (ver 3.5) — evita que el jugador pierda una
   cosecha que el propio sistema le impidió bancar. Ver AC 2b y AC 2c.

5.9. **(Añadido en la ronda 2 de `/design-review` 2026-08-10, alcance corregido en ronda 3) Descanso
   de Fresa tras cosecha**: tras cosechar una parcela de Fresa (a mano — nunca aplica a Trigo/Maíz),
   esa parcela entra en estado Descansando durante exactamente 3.0s. **Corregido en ronda 3**: durante
   este estado, intentar **replantar Fresa en esa misma parcela** produce el mismo feedback de "no
   todavía" que sobre una parcela en Creciendo, sin penalización económica — pero plantar **cualquier
   otro cultivo desbloqueado** en esa parcela funciona de inmediato (antes bloqueaba cualquier
   cultivo, lo cual era fricción de ejecución sin agencia, violando el Pilar 3). Ver 3.1, 3.2, la
   regla de concurrencia de Fresa por granja (3.2, nueva en ronda 3) y AC 9c.

5.10. **(Nuevo en ronda 3 de `/design-review`, alcance ampliado en ronda 4 — ver corrección abajo)
   Saldo insuficiente para un costo forzoso (prevenir o reparar) — piso anti-softlock del Pilar 5**:
   a diferencia de una compra discrecional (5.2), el jugador no elige si enfrentar el costo de
   prevenir una plaga o reparar una parcela — estos costos se le imponen. Regla general (ver 3.4):
   intentar pagar sin saldo suficiente simplemente no ejecuta la acción (mismo feedback que 5.2), sin
   generar saldo negativo. Para **prevenir**: si no hay saldo, la plaga simplemente sigue su curso y
   expira sin cobro al final de su ventana (regla 3.5 — este comportamiento ya existía implícitamente
   como "no prevenir", ahora se declara explícitamente como la resolución cuando falta saldo, no solo
   cuando el jugador decide no actuar). Para **reparar**: si no hay saldo, la parcela permanece
   Marchita/Dañada hasta que haya saldo — sin generar deuda ni bloquear otras acciones. **Piso
   anti-softlock explícito (mandato de Pilar 5 de `game-concept.md`)**: en el caso límite donde el
   pozo compartido está en $0 (o por debajo del costo de reparación más barato) **y** ninguna parcela
   está en un estado productivo (todas Marchita, Dañada o Reparando — sin ninguna Creciendo/Lista que
   pueda generar ingreso), la siguiente reparación que el jugador intente se ejecuta **gratis** (sin
   descontar el costo), rompiendo el deadlock. Este piso nunca se activa si existe cualquier vía de
   ingreso disponible (una parcela Creciendo/Lista, o una venta pendiente) — es estrictamente el
   último recurso, igual que la resolución automática de plagas sin cobro que ya exige `game-
   concept.md` Pilar 5.

   **Corrección de ronda 4 (defecto encontrado en la ronda 4 de `/design-review` — la versión de
   ronda 3 no cerraba el deadlock que dice cerrar)**: una reparación gratuita siempre termina en Vacía
   (3.4, 4.6, "requiere replantar desde cero, paga semilla de nuevo"). Si el pozo seguía en $0
   después de la reparación gratis (la reparación no genera dinero, solo evita el costo), el jugador
   se queda con una parcela Vacía y sin saldo para comprar ni la semilla más barata (Trigo, $2) — sin
   ningún cultivo Creciendo/Lista, el pozo nunca puede volver a subir de $0, y el "piso" tal como se
   escribió en ronda 3 solo cubre el paso de reparar, no el paso de replantar que la propia reparación
   exige para volver a producir ingreso. Es un segundo deadlock, alcanzable inmediatamente después de
   que el primer piso se activa. **Se extiende el piso**: bajo la misma condición de activación (pozo
   en $0 o por debajo del costo relevante, y ninguna parcela Creciendo/Lista) aplicada ahora también
   al **plantar sobre una parcela Vacía que quedó así por una reparación gratuita reciente** — ese
   primer intento de plantar Trigo (el cultivo más barato, siempre desbloqueado desde el inicio) tras
   una reparación gratuita se ejecuta igualmente gratis si el pozo sigue sin saldo suficiente en ese
   momento. El piso, en conjunto, garantiza una cadena completa reparar-gratis → replantar-gratis que
   siempre logra devolver al menos una parcela a un estado productivo (Creciendo) sin depender de que
   el pozo tenga saldo en ningún punto de la cadena — es la única forma de que la garantía de
   no-deadlock del Pilar 5 se sostenga de verdad. Ver AC 3d.

5.11. **(Nuevo en ronda 3 de `/design-review`) Downtime de reparación (Reparando)**: tras tocar una
   parcela Marchita o Dañada para repararla, la parcela entra en estado Reparando (4.0s Marchita /
   2.0s Dañada, ver 3.4, 4.6) antes de pasar a Vacía. Durante Reparando, tocar la parcela produce el
   mismo feedback de "no todavía" que sobre una parcela en Creciendo — no se puede cancelar la
   reparación ni acelerarla. Al completarse, la parcela pasa a Vacía y requiere replantar desde cero
   (paga semilla de nuevo). Ver AC 3c.

5.12. **(Nuevo en ronda 3 de `/design-review`, alcance de estados corregido en ronda 4) Concurrencia
   de Fresa a nivel de granja**: como máximo una parcela puede tener Fresa en Creciendo, Lista **o
   Descansando** a la vez, en toda la granja compartida (ver 3.2). **Corrección de ronda 4**: la
   versión de ronda 3 solo contaba Creciendo/Lista, lo cual dejaba una puerta abierta — en el instante
   en que una parcela pasa a Descansando tras cosechar, Fresa volvía a estar disponible de inmediato
   en otra parcela, permitiendo que el crecimiento de la segunda absorbiera por completo el descanso
   de la primera (cadencia efectiva de 4s en vez de 7s con 2+ parcelas de Fresa). Incluir Descansando
   en el conjunto de estados que activan el gate cierra esa puerta. Si el jugador intenta plantar
   Fresa en una segunda parcela mientras ya existe una en Creciendo, Lista o Descansando, Fresa
   simplemente no aparece como opción en el ciclo de semillas de esa parcela (regla 3.4) — no hay
   feedback de error porque no es un intento fallido, es una opción no disponible, igual que un
   cultivo aún no desbloqueado. Ver AC 9c.

5.13. **(Nuevo en ronda 3 de `/design-review`) Carrera entre la auto-cosecha de la Cosechadora y una
   cosecha manual sobre el mismo objetivo**: la auto-cosecha diferida de la Cosechadora de radio
   (3.6) puede estar en curso sobre una parcela vecina en el momento en que el otro jugador la
   cosecha manualmente. Esta es una tercera clase de condición de carrera, distinta de las dos ya
   documentadas en 5.7 (colisión jugador-vs-jugador sobre una parcela, y colisión de compras
   limitadas) — aquí es una acción ya programada por el host (la auto-cosecha diferida) contra una
   intención de un jugador (cosecha manual) sobre el mismo objetivo. **Sin resolver a propósito,
   igual que 5.7**: depende del modelo de autoridad de red que fije el spike técnico pendiente (ver
   Dependencies) — bajo el supuesto no vinculante de host-autoritativo ya declarado ahí, la
   resolución más simple sería que el host re-verifique el estado de la parcela objetivo justo antes
   de ejecutar la auto-cosecha diferida (evitando cosechar dos veces), pero esto no se fija como
   regla definitiva aquí, solo se enumera para que el spike de red no lo pase por alto.

5.14. **(Nuevo en ronda 3 de `/design-review`) Cancelación de venta por un jugador distinto al que la
   inició**: la regla 3.4 permite cancelar la canalización de venta con un segundo toque sobre el
   punto de venta, pero no especifica si ese segundo toque debe venir del mismo jugador que inició la
   venta o si cualquiera de los dos puede cancelarla. **Comportamiento por defecto explícito (nuevo en
   ronda 3)**: cualquiera de los dos jugadores puede cancelar la venta en curso, no solo quien la
   inició — es un punto de venta compartido sobre un pozo compartido (Pilar 1), y restringir la
   cancelación a un solo jugador introduciría una dependencia innecesaria si ese jugador está
   distraído por una plaga en otra parte de la granja. Confirmar en playtest si esto genera
   fricción social no deseada (p. ej. cancelaciones no coordinadas); si es así, el ajuste a probar
   primero es requerir confirmación visual de ambos jugadores antes de permitir que el no-iniciador
   cancele, no revertir a "solo el iniciador puede cancelar".

## 6. Dependencies

- **Extiende** `design/gdd/game-concept.md`: reutiliza el core loop validado por el concept
  prototype — economía compartida de un solo pozo de dinero (Pilar 1), tecla de acción única y
  contextual, patrón de decisión prevenir (instantáneo, caro) vs. reparar (barato, con downtime)
  (Pilar 5), sin combate directo (Anti-Pilar).
- **Conflicto con `game-concept.md` Core Mechanics #2 — RESUELTO en `/design-review` 2026-08-10**:
  el concept doc describe la automatización de largo plazo como "cintas transportadoras y
  trabajadores contratables, colocados en una cuadrícula 2D/isométrica"; las Máquinas de este
  documento (Sembradora rápida, Cosechadora de radio) **no la reemplazan** — son una capa de
  progresión temprana (MVP-adyacente/Vertical Slice) que antecede al sistema de cintas/trabajadores,
  que sigue siendo la visión de automatización de largo plazo del concept doc. Cada máquina tiene
  ahora presencia visual obligatoria en el terreno (regla 3.6) para no comprometer el Pilar 4
  mientras tanto. `game-concept.md` fue actualizado (ver abajo) para referenciar esta secuenciación.
  - **Dependencia bidireccional confirmada**: `game-concept.md` ahora referencia este documento en
    su tabla de Content Volume y en Core Mechanics #2 (ver el diff de esa revisión) — la violación
    de la regla de `design-docs.md` señalada en el `/design-review` está resuelta.
- **Depende de** una decisión de `/design-system` de economía para el mecanismo de mitigación del
  riesgo de free-riding (documentado como Open Question en `game-concept.md` tras el round 3 de
  `/design-review`) — este documento no lo aborda; el gasto sigue siendo libre del pozo compartido
  sin atribución, y las nuevas categorías de compra (Máquinas, Infraestructura, Decoración, Confort)
  amplían la superficie de ese riesgo sin mitigarlo. **Nota añadida en ronda 3**: la categoría
  Confort (3.9, Timbre y Mostrador) es un caso más concreto y específico que el framing general de
  `game-concept.md` — no es "un jugador carga más peso económico que otro" (asimetría de carga
  compartida), es "un jugador gasta del pozo compartido en una preferencia personal que solo él
  disfruta" (sonido de alerta menos estresante, tamaño de HUD). Se deja fuera de alcance por la misma
  razón que el resto de free-riding (depende del `/design-system` de economía), pero se nombra aquí
  explícitamente para que esa pasada futura no lo pase por alto dentro del paraguas genérico.
- **Depende del spike de rendimiento por escala de entidades** (`game-concept.md` Next Steps,
  **bloqueante antes de `/map-systems`**). **Corregido en ronda 3 — la afirmación anterior era falsa
  y se contradecía con el propio Apéndice C2 de este documento**: la ronda 2 afirmaba aquí que el
  contenido de este documento "es exactamente la carga que ese spike existe para validar", pero el
  Apéndice C2 de esa misma ronda ya reconocía (como ítem no bloqueante) que el spike de
  `game-concept.md` está delimitado para cintas/trabajadores y el tamaño de la cuadrícula de
  automatización de largo plazo, **no** para el contenido específico de este documento (hasta 6
  parcelas con estados animados independientes vía `AnimationPlayer`, enjambre de plaga vía
  `MultiMeshInstance2D`, partículas pooled por parcela, 2 máquinas, y hasta 6 segmentos visibles de
  Silo + Almacén + Refugio + hasta 10 ítems de decoración simultáneos). **El contenido de este
  documento no tiene, a día de hoy, ningún spike que lo cubra.** Se corrige la afirmación aquí para
  que no contradiga el propio Apéndice C2, y se añade como acción concreta: el alcance del spike de
  `game-concept.md` debe ampliarse explícitamente para incluir una escena de prueba con el contenido
  completo de este documento (6 parcelas + evento de enjambre + ambas máquinas + Silo en su tier
  máximo alcanzable en una sesión + infraestructura/decoración completas), o debe programarse un
  segundo spike dedicado a este contenido — cualquiera de las dos opciones, pero no ninguna. **Este
  documento sigue sin estar listo para implementación hasta que exista cobertura real de spike para
  su propio contenido** — ver nota de Status al inicio del documento.
- **Depende del spike técnico de red** (`game-concept.md` Next Steps, **bloqueante antes de
  `/create-architecture`**): este documento introduce una capa entera de estado compartido mutable
  (crecimiento por parcela, pozo de dinero, temporizadores de plaga, propiedad de máquinas, tiers de
  infraestructura, contadores de hitos) sin definir autoridad de red, replicación, ni resolución de
  colisiones (ver Edge Case 5.7). Las reglas marcadas "⚠ Provisional" en este documento (3.4, 3.5)
  quedan sujetas a lo que ese spike determine.
  - **Añadido en la ronda 2 de `/design-review` 2026-08-10 (supuesto base no vinculante)**: mientras
    el spike de red no determine el modelo de autoridad definitivo, este documento asume como
    placeholder no vinculante que **el host es dueño de todo el estado mutable compartido** descrito
    aquí (dinero, temporizadores de crecimiento y de plaga, propiedad de máquinas, tiers de
    infraestructura, contadores de hitos, capacidad y contenido del silo) y que **los clientes solo
    envían intenciones, nunca calculan ni confirman ese estado localmente**. Este supuesto no
    resuelve las reglas "⚠ Provisional" (3.4, 3.5) ni la colisión de Edge Case 5.7 — solo evita que
    otras partes del documento (AC 6, AC 8, AC 3) contradigan en silencio la deferencia declarada
    aquí mismo. Queda sujeto a reemplazo total por lo que determine el spike.
  - **Ampliado en ronda 3 de `/design-review` — el supuesto no se había aplicado de forma
    consistente**: ronda 3 encontró que el placeholder de host-autoritativo se auditó explícitamente
    contra AC3/AC6/AC8 (párrafo anterior) pero no contra AC7 (compra de terreno, "compra al
    instante") ni contra el lenguaje de "mismo frame"/"instantáneo" que aparece en AC2, AC4 y AC9 —
    ese lenguaje describe una latencia percibida de cero, que solo puede ser cierta para el
    dispositivo host bajo este modelo; el dispositivo no-host necesariamente ve un retraso de ida y
    vuelta de red. No se resuelve aquí (pertenece al spike), pero se extiende la marca "⚠
    Provisional" — ya presente en 3.5 para la ventana de reacción a plaga — a **todas** las
    interacciones que este documento describe como instantáneas o de mismo-frame (3.4, AC2, AC4,
    AC9), no solo a la plaga.
  - **Añadido en ronda 3 — tercera clase de condición de carrera enumerada, no resuelta**: la
    auto-cosecha diferida de la Cosechadora de radio (3.6) introduce una carrera entre una acción ya
    programada por el host y una intención de jugador sobre el mismo objetivo — distinta de las dos
    clases que Edge Case 5.7 ya cubre (jugador-vs-jugador, y compras limitadas concurrentes). Ver
    Edge Case 5.13 para el detalle; queda igualmente sin resolver a propósito, sujeta al spike.
  - **Añadido en ronda 3 — supuesto de persistencia entre sesiones**: ver Formulas 4.5 para el
    supuesto explícito de que la economía no persiste entre sesiones — este supuesto también
    depende, indirectamente, de cómo el spike de red termine modelando la reconexión/reanudación de
    sesión (ver `game-concept.md` Open Questions sobre pérdida del host).
- **Depende del spike de UX táctil / aviso entre compañeros** (`game-concept.md` Next Steps,
  **bloqueante antes de `/create-architecture`**): el gesto de mantener 0.4s (3.4) y el mecanismo
  para que un jugador vea el estado de su compañero (canal de venta, compras en curso) quedan
  provisionales hasta ese spike — ver notas inline en 3.4.

## 7. Tuning Knobs

| Knob | Valor actual | Rango seguro sugerido | Afecta |
|---|---|---|---|
| Coste semilla Fresa | $8 (fijo, ver Edge Cases 5.6 — decisión de diferenciación por riesgo, no de precio) | $8–$10, sin bajar de $8 | Beneficio/s de la Fresa, ver Formulas 4.1 |
| Ventana de reacción a plaga (Trigo/Maíz) | 6s | 4–8s | Dificultad de proteger esos cultivos a tiempo |
| Ventana de reacción a plaga (Fresa) | 4s (fijo, resuelto en Edge Cases 5.6) | 3–5s | Riesgo específico de la Fresa — no bajar de 3s sin volver a probar en playtest de UX táctil |
| Duración de crecimiento (`duración_creciendo`, todos los cultivos) | 4s–12s según cultivo (tabla 3.2) | **mínimo absoluto 2s** | Validez de la fórmula de beneficio/segundo para cultivos futuros — **rationale corregido en ronda 3**: el piso no es por riesgo de división por near-cero (formula 4.1 es numéricamente estable hasta valores muy por debajo de 2s; solo 0 exacto divide por cero). El piso real es de **balance y legibilidad**: valores por debajo de 2s desacoplan el ritmo de crecimiento de las ventanas de reacción a plaga (4-8s) y no dejan tiempo legible para las 3-4 keyframes de animación de crecimiento (3.1). Futuros tuners no deben asumir que ≥2s es "seguro" solo por evitar división por cero — el riesgo real de balance en el piso sigue sin cuantificar |
| Cooldown global entre plagas | 15s | 10–20s | Densidad de alarmas simultáneas al escalar parcelas |
| Constante base intervalo plaga | 25s (min) / 45s (max) | ±10s | Ritmo de tensión temprano |
| Constante de escalado por parcela | +3s por parcela, válido para 0-6 parcelas (ver Formulas 4.3) | +2 a +5s por parcela | Cómo crece la frecuencia total de alarmas con el mapa |
| Costes de expansión de terreno (3ª–6ª parcela) | $50 / $120 / $250 / $450 | mantener progresión creciente, no bajar por debajo de ×1.5 por paso | Cadencia de decisión terreno vs. máquinas |
| Coste Sembradora rápida | $200 | $150–$250 | Ritmo de la primera inversión en Taller |
| Coste Cosechadora de radio | $350 | $300–$450, siempre > Sembradora | Ritmo de la segunda inversión, debe doler comprarla pronto |
| Retraso de auto-cosecha de la Cosechadora (**cambiado en ronda 3**: de 1.5s fijo a % de `duración_creciendo`) | 25% de `duración_creciendo` de la parcela auto-cosechada (Trigo 1.5s, Maíz 3.0s) | 15%–35% | Preserva ventaja de velocidad de la cosecha manual (Pilar 2) proporcionalmente en todos los cultivos, no solo en el de ciclo más corto |
| Costes Silo ampliado (tiers 1-3) | $80 / $200 / $400 | mantener progresión creciente | Pacing del sink de infraestructura |
| Costes Silo ampliado (tier 4+) | ×2 el tier anterior, sin techo económico | mantener multiplicador ≥1.8 | Runway total del pool de gasto — **recalificado en ronda 3 como sink de prestigio, no de decisión real, ver Formulas 4.5/3.7** |
| Cap visual de segmentos del Silo (**nuevo en ronda 3**) | 6 segmentos | 4–8, no menos de 4 (debe cubrir tiers 1-3 sin insignia) | Presupuesto de draw calls (<100, `.claude/docs/technical-preferences.md`) independiente del cap económico |
| Umbral desbloqueo Silo | $500 en ventas acumuladas | $300–$700 | Cuándo aparece la primera opción de infraestructura |
| Umbral desbloqueo Almacén de semillas | 50 unidades plantadas (cuenta semillas plantadas, no unidades cosechadas — aclarado en `/design-review` 2026-08-10) | 30–80 | Cuándo aparece la 2ª opción de infraestructura |
| Recarga de slot de Almacén (**nuevo en ronda 3**) | Precio de semilla del cultivo + ~1.0s de animación | 0.5–2.0s de animación | Fricción que evita que Almacén domine estrictamente a Sembradora rápida (ver 3.7) |
| Umbral desbloqueo Refugio | 3 plagas sufridas | 2–5 | Cuándo aparece la mitigación de daño de plaga |
| Radio de efecto del Refugio (**unidad fijada en ronda 3**, antes "1 tile" sin definir) | 1.5 unidades de mundo | 1.0–2.0 unidades de mundo | Cuántas parcelas puede cubrir el Refugio según el layout final de la granja |
| Radio de la Cosechadora (**métrica fijada en ronda 3**, antes sin definir) | 1 tile, distancia Chebyshev (8 vecinas orto/diagonales) | Chebyshev 1–2 tiles | Cuántas parcelas cubre cada disparo de auto-cosecha — directamente afecta el margen manual del Pilar 2 |
| Umbral desbloqueo Confort | 5 minutos de partida | 3–8 min | Cuándo se ofrecen mejoras de comodidad no esenciales |
| Canalización de venta | fórmula 4.4: 2.0s a 1.0s según tiers de Silo | 1–3s en los extremos | Ventana de vulnerabilidad al vender (mitigada por cancelación, regla 3.4) |
| Límites de decoración | Valla 6× / Bandera 3× / Cartel 1× | mantener límites bajos | Evita clutter visual en el mapa |
| Descanso post-cosecha de Fresa (nuevo, ronda 2; **alcance corregido en ronda 3** — ver 3.2/5.9, ahora solo bloquea replantar Fresa, no otros cultivos) | 3s | 2–5s | Ciclo efectivo de la Fresa (junto con el cap de concurrencia por granja, nuevo en ronda 3) — ya no es la única mitigación de monopolio de atención, ver 3.2 |
| Cap de concurrencia de Fresa por granja (**nuevo en ronda 3, conjunto de estados corregido en ronda 4**) | 1 parcela en Creciendo, Lista **o Descansando** a la vez, farm-wide | fijo en 1; el conjunto de estados que activan el gate debe incluir Descansando — excluirlo reabre el exploit de intercalado vía descanso (ver ronda 4) | Cierra el intercalado de 2+ parcelas de Fresa, incluido el intercalado vía el estado de descanso (ver 3.2, Edge Case 5.12) |
| Capacidad base del Silo (nuevo, ronda 2) | $150 | $100–$250 | Cuán pronto se siente el desbordamiento antes de la primera compra de Silo (ver 4.4, Edge Case 5.8) |
| Downtime de reparación (**nuevo en ronda 3**) | 4.0s Marchita / 2.0s Dañada | 2–6s Marchita, 1–3s Dañada, Dañada siempre < Marchita | Instancia el trade-off de Pilar 5 (prevenir instantáneo/caro vs. reparar barato/con downtime) — ver 4.6, Apéndice D |
| Multiplicador de ventana de reacción accesible (**nuevo en ronda 3, placeholder no vinculante**) | 1.0× (sin multiplicador aplicado por defecto) | 1.0×–2.0× | Modo de accesibilidad opcional para contenido dependiente de tiempo de reacción (3.5) — valor exacto y mecanismo de activación pendientes de diseño dedicado, este knob solo reserva el gancho |
| Banda relativa de $/s para cultivos futuros (**nuevo en ronda 3, placeholder**) | Sin definir — rango observado actual 2.17–4.00 $/s (tabla 4.1) | A definir en `/design-system` de economía, expresado como banda relativa (no solo dirección), igual que exige `game-concept.md` para la variante exótica | Evita que un futuro cultivo produzca un $/s degenerado (negativo o muy fuera de rango) sin que ninguna regla lo capture |

## 8. Acceptance Criteria

1. **(reescrito en ronda 3 de `/design-review` — la versión anterior describía un mecanismo que la
   propia regla 3.4 declara físicamente incoherente para un solo dedo, y por tanto no era ejecutable
   por un tester)** Dada una parcela Vacía y ningún slot de Almacén cargado con semilla, mantener el
   botón de acción abre el ciclo de selección de semilla entre los tipos ya desbloqueados (mecanismo
   exacto de ciclado **⚠ Provisional, ver regla 3.4** — pendiente del spike de UX táctil, que debe
   resolver un mecanismo de un solo dedo, no ajustar duración/conteo de toques del mecanismo actual);
   soltar planta el tipo mostrado en ese momento. **Este AC no es verificable hasta que el spike de
   UX táctil determine un mecanismo real** — se marca explícitamente como bloqueado, no solo
   "provisional", hasta entonces. Verificar contra el valor vigente de duración en la configuración
   de input, no contra 0.4s escrito aquí (igual que AC3).
2. Dado un cultivo en estado Lista y silo con capacidad disponible, un toque simple lo cosecha y
   añade al silo compartido exactamente las unidades definidas en la tabla 3.2 para ese cultivo.
2b. **(añadido en la ronda 2 de `/design-review` 2026-08-10 — antes sin AC; corregido en ronda 3)**
   Dado un silo cuyo valor almacenado sin vender ya iguala o supera su capacidad actual, un toque
   simple sobre una parcela Lista no cosecha, no descuenta ni suma dinero, y produce **tanto** el
   feedback visual de "silo lleno" en el icono de HUD **como** un feedback localizado sobre la propia
   parcela tocada (distinto del temblor "no todavía" de AC 1/5.1); la parcela permanece en estado
   Lista. La auto-cosecha de la Cosechadora de radio (AC 9) tampoco se dispara mientras el silo esté
   lleno, y se retoma automáticamente (event-driven, ver 3.6) en cuanto haya espacio, sin perder el
   retraso proporcional ya transcurrido. Mientras esté bloqueada por silo lleno, esta parcela no es
   objetivo válido de plaga (ver AC 3, Edge Case 5.8).
2c. **(nuevo en ronda 3 — antes solo se probaba el caso de igualdad exacta)** Dado un silo con
   $140 de $150 de capacidad almacenados (ejemplo con capacidad base) y una parcela de Maíz en Lista
   (valor de cosecha $40), un toque simple sí cosecha exitosamente y el silo termina en $180 —
   por encima de la capacidad nominal. Este desbordamiento de hasta el valor de una cosecha es
   intencional (ver Formulas 4.4) y no debe tratarse como un bug si se observa en QA.
3. Dada una parcela en Creciendo o Lista que entra en pre-alerta de plaga, tras 0.5s se activa el
   enjambre visual y el jugador dispone exactamente de 6.0s (medidos en tiempo del host, ver
   Dependencies) desde ese momento para prevenir (–$15) antes de que la parcela pase a Marchita. Para
   Fresa, la ventana es exactamente 4.0s (regla 3.5). Si el temporizador de tuning cambia estos
   valores, este AC se verifica contra el valor vigente en `plague_config` (o equivalente) en el
   momento de la prueba, no contra el número aquí escrito. Una parcela Vacía, Marchita, Dañada,
   Reparando, Descansando, o Lista-bloqueada-por-silo-lleno (AC 2b) nunca es objetivo (ver 3.5, 4.3,
   Apéndice D).
3b. **(añadido en `/design-review` 2026-08-10 — antes sin AC)** Dada una parcela en pre-alerta de
   plaga cuya ventana de reacción expira sin que ningún jugador prevenga, la parcela pasa
   exactamente a Marchita (o a Dañada si hay Refugio comprado y un jugador está dentro de 1.5
   unidades de mundo del Refugio), se pierde cualquier cosecha pendiente en esa parcela, y se
   disparan sacudida de cámara (0.2s) + partícula de polvo/hojas + sonido grave, en ese orden o
   simultáneamente, dentro del mismo frame de la transición de estado.
3c. **(nuevo en ronda 3 — antes la reparación era instantánea y no tenía AC de downtime)** Dada una
   parcela Marchita, tocarla inicia la reparación: –$10 inmediato, la parcela pasa a Reparando
   durante exactamente 4.0s (2.0s si la parcela es Dañada en vez de Marchita, con costo –$5), durante
   los cuales tocarla produce el mismo feedback "no todavía" que sobre Creciendo. Al expirar el
   downtime, la parcela pasa a Vacía (no a Creciendo/Lista — requiere replantar y pagar semilla de
   nuevo).
3d. **(nuevo en ronda 3 — piso anti-softlock del Pilar 5, antes no implementado en este documento;
   ampliado en ronda 4 — la versión de ronda 3 no cerraba el deadlock completo, ver Edge Case 5.10)**
   Dado un pozo compartido en $0 y todas las parcelas de la granja en Marchita, Dañada o Reparando
   (ninguna Creciendo/Lista), la siguiente reparación que el jugador intente se ejecuta gratis (sin
   descontar el costo). Dado el mismo pozo en $0 pero con al menos una parcela Creciendo o Lista
   (una vía de ingreso disponible), la reparación NO se ejecuta gratis — el piso solo se activa en el
   caso límite sin ninguna vía de ingreso restante. **Continuación (nueva en ronda 4)**: dada la
   parcela que acaba de quedar Vacía por esa reparación gratuita, y el pozo compartido todavía sin
   saldo suficiente para comprar semilla de Trigo ($2) en ese momento, el siguiente intento de
   plantar Trigo en esa parcela también se ejecuta gratis (sin descontar el costo de semilla). Dado
   el mismo escenario pero con el pozo ya con $2 o más disponibles, plantar Trigo cobra el costo
   normal — el piso extendido solo se activa mientras la cadena reparar→replantar no tenga, en ningún
   punto, una fuente de ingreso alternativa disponible.
4. Dado el punto de venta, un toque simple inicia la canalización de venta (duración según fórmula
   4.4); durante la canalización el jugador que la inició no puede moverse. Un segundo toque sobre el
   punto de venta durante la canalización, de cualquiera de los dos jugadores (ver Edge Case 5.14), la
   cancela: no se descuenta ni se suma dinero, y el jugador que la inició recupera movimiento (**⚠
   Provisional en dispositivo no-host, ver Dependencies — "recupera movimiento" no está garantizado
   en el mismo frame salvo en el dispositivo host bajo el modelo de autoridad de red asumido**). Si la
   canalización completa sin cancelar, vende todo el silo compartido y suma el dinero correspondiente
   al pozo compartido.
4b. **(nuevo en ronda 3 — antes sin cobertura de los valores numéricos por tier, solo del
   comportamiento genérico de cancelar/completar)** Dado un Silo con N tiers completados (0 a 3), la
   canalización de venta dura exactamente `max(1.0, 2.0 − N/3)` segundos (± un frame de tolerancia),
   medida desde el toque inicial hasta la venta efectiva; para `tiers_completados` ≥ 3, la duración es
   exactamente 1.00s. Verificar contra el valor calculado de la fórmula 4.4, no contra los decimales
   redondeados de su tabla.
5. Dado el Taller, un toque simple abre el menú de compra sin pausar la simulación — las plagas
   activas siguen corriendo su temporizador durante la decisión.
6. Dado que dos plagas están próximas a dispararse en parcelas distintas dentro de los 15s del
   cooldown global, solo una se dispara; la segunda espera hasta que el cooldown expire. La que se
   dispara primero es la que haya alcanzado su `intervalo_min` individual antes, por tiempo del host
   (ver Dependencies para la autoridad de red). **Requisito de verificabilidad, añadido en ronda 3
   (antes no verificable sin overlay de depuración)**: el build debe emitir un log estructurado por
   parcela al alcanzar `intervalo_min` (p. ej. `plague_eligible parcela=<id> host_time=<t>`); el
   orden de disparo observado en el juego debe coincidir con el orden de esos timestamps para que
   este AC se considere verificado.
7. Dada una parcela con reja y saldo compartido insuficiente para comprarla, tocarla no descuenta
   dinero ni la desbloquea, y produce el feedback visual de candado temblando. **(⚠ Provisional en
   dispositivo no-host, ver Dependencies — la compra exitosa cuando sí hay saldo suficiente se
   describe como "al instante" en 3.4, lo cual bajo el modelo de host-autoritativo asumido solo es
   estrictamente cierto para el jugador en el dispositivo host; nuevo en ronda 3, antes no auditado
   contra el placeholder de autoridad de red igual que AC3/AC6/AC8.)**
8. Ningún ítem de infraestructura (Silo, Almacén, Refugio) aparece en el menú de compra antes de
   cumplirse su hito de desbloqueo respectivo (regla 3.10); tras cumplirse, dispara el aviso de
   desbloqueo (regla 3.10) en ambos dispositivos y aparece en la siguiente apertura del menú. Si dos
   hitos se cumplen en el mismo frame (de simulación del host), ambos avisos se disparan juntos.
8b. **(nuevo en ronda 3 — antes 3.8/3.9 no tenían AC de visibilidad, solo AC10 de límites de
   compra)** Los ítems de Decoración (Valla, Bandera, Cartel) están disponibles en el menú de compra
   desde el minuto 0 de la sesión, sin hito de desbloqueo. Los ítems de Confort (Timbre, Mostrador)
   no aparecen en el menú antes de los 5:00 de partida; al alcanzar los 5:00, disparan el mismo aviso
   de desbloqueo de la regla 3.10 que los ítems de infraestructura (resuelve la ambigüedad entre 3.9 y
   3.10 sobre si Confort dispara aviso — sí lo hace, igual que infraestructura).
9. Tras comprar la Cosechadora de radio, cosechar manualmente una parcela Lista de Trigo o Maíz
   dispara, tras un retraso de 25% de la `duración_creciendo` de cada parcela vecina elegible (ver
   Tuning Knobs — Trigo: 1.5s, Maíz: 3.0s), la auto-cosecha de cualquier otra parcela de Trigo o Maíz
   en estado Lista dentro de radio **Chebyshev de 1 tile** (las 8 parcelas orto/diagonalmente
   adyacentes a la parcela objetivo cosechada manualmente) de esa parcela objetivo. **Sin una cosecha
   manual disparadora, ninguna auto-cosecha ocurre jamás** (mecanismo de disparo corregido en ronda 3,
   ver 3.6). Una parcela de Fresa en el mismo radio **nunca** se auto-cosecha, sin importar su estado.
9b. **(añadido en `/design-review` 2026-08-10 — antes sin AC)** Tras comprar la Sembradora rápida,
   mantener el botón de acción sobre una parcela Vacía (sin slot de Almacén cargado, ver AC 9d)
   planta el cultivo mostrado tras 0.15s de sostenido, en vez de los 0.4s por defecto. Verificar
   contra el valor vigente de configuración, no contra 0.15s escrito aquí (igual que AC3).
9c. **(añadido en la ronda 2 de `/design-review` 2026-08-10 — antes sin AC; alcance corregido en
   ronda 3)** Tras cosechar una parcela de Fresa a mano, esa parcela entra en estado Descansando
   durante exactamente 3.0s. Durante ese estado, intentar replantar Fresa en esa misma parcela
   produce el feedback "no todavía"; intentar plantar cualquier otro cultivo desbloqueado funciona de
   inmediato, sin restricción. Adicionalmente (regla de concurrencia por granja, nueva en ronda 3,
   alcance de estados corregido en ronda 4): mientras exista cualquier otra parcela con Fresa en
   Creciendo, Lista **o Descansando** en la granja, Fresa no aparece como opción en el ciclo de
   semillas de ninguna otra parcela — incluir Descansando en el gate (no solo Creciendo/Lista) cierra
   el intercalado vía descanso que la versión de ronda 3 dejaba abierto (ver Edge Case 5.12).
9d. **(nuevo en ronda 3 — Almacén de semillas no tenía ningún AC pese a ser un mecanismo
   determinista completo)** Dado el Almacén de semillas comprado y al menos un slot cargado con
   semilla de tipo X (cargado mediante el flujo de recarga de 3.7, con el costo de semilla ya
   descontado en ese momento), un toque simple (sin mantener) sobre una parcela Vacía planta de
   inmediato el tipo X en 0.1s y decrementa en 1 la cantidad de ese slot. Con el slot en 0 unidades,
   la interacción sobre esa parcela vuelve al comportamiento por defecto según qué otras máquinas
   posea el jugador (Sembradora rápida: mantener 0.15s; ninguna: mantener 0.4s — ver 3.7 para la
   precedencia completa).
10. **(añadido en `/design-review` 2026-08-10 — antes sin AC)** Cada ítem de Decoración (Valla,
   Bandera, Cartel) y Confort (Timbre, Mostrador) puede comprarse hasta su límite definido en las
   tablas 3.8/3.9; al alcanzar el límite, la opción de compra se deshabilita visualmente (no solo
   rechaza el toque en silencio) y no se puede volver a comprar esa unidad.
11. **(nuevo en ronda 3 — ningún AC de este documento cubría el presupuesto de rendimiento que 3.1 ya
   invoca)** Con las 6 parcelas activas y animando de forma independiente, ambas Máquinas instaladas,
   el Silo en el tier máximo alcanzable dentro de una sesión típica (ver Formulas 4.5, Dependencies —
   supuesto de no-persistencia), Almacén, Refugio y la Decoración/Confort completos en pantalla, más
   un evento de plaga activo con su enjambre visible, el frame time se mantiene ≤16.6ms y el total de
   draw calls de la escena se mantiene por debajo de 100 en el dispositivo de referencia de gama
   baja (ver `.claude/docs/technical-preferences.md`). Este AC no puede considerarse verificado hasta
   que el spike de rendimiento cubra explícitamente este contenido (ver Dependencies).

*(El AC anterior sobre paridad de $/s Fresa-Maíz se retira de esta sección — resuelto en Edge Case
5.6 mediante diferenciación por riesgo, no por paridad; no hay un AC de "no debe superar en más de
X" porque ya no es el objetivo de diseño.)*

**Clasificación por tipo de historia (nueva en ronda 3, ver Apéndice D para la matriz completa)**:
cada AC de esta sección se etiqueta Logic / Integration / Visual / UI / Config según
`.claude/docs/coding-standards.md`, ya que ese tipo determina si la evidencia de prueba es BLOCKING o
ADVISORY. Ver Apéndice D — Matriz de cobertura de AC.

---

## Apéndice A — Riesgos de balance abiertos (resumen, actualizado tras `/design-review` 2026-08-10, ronda 4)

Ver detalle completo en Edge Cases (sección 5) y Formulas (sección 4). Resumen de seguimiento.
**Nota de ronda 3**: la síntesis de esta ronda encontró que los 5 ítems que ronda 2 había marcado
"resuelto" (#1, #7, #8, #9, y el placeholder de red del Apéndice C2 #5) tenían defectos vivos —
la etiqueta "resuelto" se retira o se acota explícitamente en cada uno de ellos abajo, y el
detalle de por qué está en Apéndice D y en las secciones citadas. **Nota de ronda 4**: la pasada de
verificación acotada encontró que 2 de las correcciones de ronda 3 (#7 y #10 abajo) también tenían
defectos vivos — ver las notas "Corregido en ronda 4" en cada uno y Apéndice C4 para el registro
completo.

1. ~~Fresa desequilibrada frente a Maíz/Trigo en $/s~~ — diferenciación por riesgo (Edge Case 5.6),
   no paridad, **sigue resuelto sin cambios en ronda 3**. El descanso post-cosecha (ítem 7 abajo) es
   un mecanismo separado — no reabre esta decisión de $/s.
2. Solapamiento de plagas con 5-6 parcelas activas — mitigado por diseño (cooldown 15s), con
   comportamiento por defecto explícito si el playtest lo rechaza (Edge Case 5.3). Sin cambios en
   ronda 3.
3. Parálisis de menú con 10+ opciones — mitigado por desbloqueo por hitos + aviso visible (Edge
   Case 5.5, regla 3.10). Riesgo residual identificado en ronda 2: una vez todo desbloqueado, la
   lista plana de opciones no tiene agrupación/pestañas — aceptado como riesgo menor no bloqueante.
   godot-specialist señaló en ronda 3 que `FoldableContainer` (nuevo en Godot 4.5) y `TabContainer`
   (propiedades de tab editables desde 4.6) hacen esto barato de resolver cuando se implemente —
   sigue sin ser bloqueante para este documento, pero ya no hace falta aceptarlo por falta de opción
   técnica.
4. ~~Vulnerabilidad durante la canalización de venta~~ — mitigada: canal cancelable (Edge Case 5.4),
   ahora explícitamente por cualquiera de los dos jugadores (Edge Case 5.14, nuevo en ronda 3).
   Pendiente de confirmar en playtest si además hace falta que el compañero la vea (depende del
   spike de UX táctil), y si permitir la cancelación por el no-iniciador genera fricción social no
   anticipada (ver Edge Case 5.14).
5. Runway total de gasto poco profundo (~$2.539 en contenido de un solo tier) — **re-etiquetado en
   ronda 3: la extensión de Silo tier 4+ (Formulas 4.5) es solo nominal, no funcional** (el
   $/capacidad colapsa ~40× entre tier 1 y tier 6, así que un jugador racional deja de comprar
   alrededor del tier 3-4 — ver 3.7, Apéndice D). Se recalifica el Silo tier 4+ como sink de
   prestigio/cosmético para completistas, no como solución a la escasez de decisiones. El hallazgo
   original **no está resuelto**, solo parcialmente aplazado. La Player Fantasy (Sección 2) ahora
   acota explícitamente la promesa de "decisión cada pocos minutos" a la ventana real de ~20-30
   minutos, en vez de prometerla para la sesión completa — decisión tomada en ronda 3 (ver Sección 2)
   en vez de añadir un sink nuevo sin validar primero en playtest.
6. Colisión de acciones simultáneas sobre la misma parcela entre los dos jugadores — sin resolver a
   propósito, depende del spike técnico de red (Edge Case 5.7). **Ronda 3 añadió una tercera clase**:
   la auto-cosecha diferida de la Cosechadora vs. una cosecha manual concurrente sobre el mismo
   objetivo (Edge Case 5.13) — igualmente sin resolver a propósito, solo enumerada para el spike.
7. **(nuevo, ronda 2, corregido en ronda 3, defecto vivo encontrado y cerrado en ronda 4)** ~~Cosechadora
   de radio + Fresa combinadas volvían "manual siempre vale la pena" y "decisión cada pocos minutos"
   simultáneamente falsos~~ — **la mitigación de ronda 2 (descanso post-cosecha de 3s) no cerraba el
   problema**: un jugador con 2+ parcelas de Fresa podía intercalarlas y recuperar el mismo patrón de
   atención-cero sin perder $/s, al costo de una parcela adicional. Corregido en ronda 3 con un **cap
   de concurrencia de Fresa a nivel de granja** (máximo 1 parcela con Fresa activa a la vez, ver 3.2,
   Edge Case 5.12) — esto cierra el intercalado independientemente de cuántas parcelas de Fresa posea
   el jugador. El descanso de 3s en sí también se corrigió de alcance: ahora solo bloquea replantar
   Fresa en esa parcela específica, no cualquier cultivo (antes era fricción de ejecución sin agencia,
   violando el Pilar 3 — ver 3.1, Edge Case 5.9). **Corregido en ronda 4**: el cap de ronda 3 solo
   contaba Creciendo/Lista, no Descansando — dejaba abierta una vía de intercalado distinta (plantar
   una segunda parcela justo cuando la primera entra en descanso, absorbiendo los 3s de descanso
   dentro del crecimiento de la segunda). Se amplía el gate para contar también Descansando (3.2,
   5.12) — ahora sí cierra el intercalado por completo.
8. **(nuevo, ronda 2, corregido en ronda 3)** ~~Silo sin capacidad base ni regla de
   desbordamiento~~ — capacidad base $150 (sin cambios). **Ronda 3 encontró y corrigió cuatro
   defectos en la resolución de ronda 2**: (a) el chequeo de desbordamiento era ambiguo entre
   pre-cosecha y post-cosecha — se fija explícitamente en pre-cosecha, con hasta una cosecha de
   holgura tolerada (4.4, AC 2c); (b) el mecanismo de reanudación de la auto-cosecha era un
   hand-wave — se especifica event-driven (3.6); (c) el feedback de "silo lleno" estaba
   desconectado del punto de toque — se añade feedback localizado en la parcela (5.8, AC 2b); (d)
   una parcela Lista bloqueada por silo lleno seguía siendo objetivo de plaga, lo que podía destruir
   una cosecha que el propio sistema le había impedido bancar al jugador — se excluye explícitamente
   de elegibilidad de plaga mientras dure el bloqueo (3.5).
9. **(nuevo, ronda 2, corregido en ronda 3)** ~~Infraestructura sin presencia visual obligatoria~~ —
   columna "Presencia visual" añadida en ronda 2 (sin cambios). **Ronda 3 encontró tres defectos
   dentro de esa misma columna**: (a) "decal" para el radio del Refugio nombraba un nodo 3D-only de
   Godot que no existe en 2D — corregido a `Sprite2D`/`Line2D` (3.7); (b) el radio del Refugio nunca
   tuvo una unidad definida ("1 tile" sin métrica) — fijado a 1.5 unidades de mundo (3.7, Tuning
   Knobs); (c) el Silo tier 4+ prometía "sin límite de segmentos" sin considerar el presupuesto de
   draw calls — se añade un cap técnico de 6 segmentos visibles, independiente del cap económico
   (3.7, Tuning Knobs).
10. **(nuevo, ronda 3, defecto vivo encontrado y cerrado en ronda 4)** Pilar 5 (anti-softlock, EV de
   prevenir vs. reparar) no estaba implementado en este documento — la reparación era instantánea
   (sin el downtime que `game-concept.md` exige para el patrón validado por el prototipo) y no existía
   piso anti-softlock para costos forzosos sin saldo. Corregido en ronda 3: reparación ahora tiene
   downtime (4.6, Edge Case 5.11) y existe un piso explícito para el caso límite de saldo $0 sin
   ninguna parcela productiva (Edge Case 5.10, AC 3d). **Corregido en ronda 4**: el piso de ronda 3
   solo cubría el costo de reparación, no el de resiembra que la propia reparación exige (siempre
   termina en Vacía) — un pozo en $0 podía seguir en $0 después de la reparación gratuita, sin poder
   pagar ni la semilla más barata, sin ningún cultivo Creciendo que generara ingreso: un deadlock real,
   no solo teórico. Se extiende el piso para cubrir también el primer intento de plantar Trigo sobre
   la parcela recién Vacía, bajo la misma condición de activación (5.10, AC 3d) — ahora la cadena
   completa reparar-gratis → replantar-gratis garantiza volver a un estado productivo sin depender de
   saldo en ningún punto. Ver Apéndice D para la tabla de EV completa — la relación se sostiene mejor que antes pero no es una
   dominancia limpia en todos los casos; ver Apéndice D para la recomendación de seguimiento.
11. **(nuevo, ronda 3)** El spike de rendimiento que este documento declaraba como cobertura de su
   propio contenido en realidad está delimitado (por el propio `game-concept.md`) para el sistema de
   cintas/trabajadores de largo plazo, no para este documento — contradicción entre Dependencies y el
   propio Apéndice C2 de ronda 2. Corregido: Dependencies ahora declara honestamente que este
   contenido no tiene cobertura de spike todavía, y pide ampliar el alcance del spike existente o
   programar uno dedicado — ver Dependencies.
12. **(nuevo, ronda 3)** Almacén de semillas no tenía mecanismo de recarga especificado ni dominaba
   o era dominado de forma consciente frente a Sembradora rápida pese a ser más barato y más rápido.
   Corregido: mecanismo de recarga manual con fricción (costo de semilla + ~1s por slot) que
   diferencia ambas máquinas por caso de uso en vez de por dominancia estricta (3.7).

## Apéndice B — Orden de implementación sugerido

0. **(añadido en `/design-review` 2026-08-10)** No implementar nada de este documento hasta que
   corran los tres spikes técnicos que `game-concept.md` marca como bloqueantes (rendimiento de
   entidades, red, UX táctil) — ver Dependencies. El orden 1-6 de abajo asume que ya corrieron.
1. Implementar multi-cultivo (sección 3.1–3.2) sobre el prototipo confirmado, sin tocar el core
   loop validado (plantar/crecer/cosechar/vender/prevenir/reparar).
2. Añadir expansión de terreno (sección 3.3) — validar en playtest si el jugador entiende el coste
   creciente sin explicación adicional en pantalla.
3. Añadir Taller y las dos máquinas (sección 3.6), con su presencia visual obligatoria — es el
   gancho de progresión con más impacto en ritmo, priorizar sobre infraestructura/decoración.
4. Añadir infraestructura con desbloqueo por hitos y aviso visible (secciones 3.7 y 3.10).
5. Añadir decoración y confort al final (secciones 3.8 y 3.9) — son las de menor riesgo de balance.
6. Playtest de 1 sesión con los pasos 1-2 implementados antes de añadir máquinas, para aislar si
   la variedad de cultivo + expansión ya resuelve el aburrimiento reportado, o si hace falta llegar
   hasta máquinas para sostener el interés.

> Nota: este documento no rediseña el core loop confirmado (economía compartida, tecla contextual
> única, patrón prevenir/reparar) — lo da por bueno y construye la capa de contenido/progresión que
> el propio playtest del concept prototype identificó como la pieza que faltaba.

## Apéndice C — Registro de decisiones del `/design-review` (2026-08-10, MAJOR REVISION NEEDED → revisado en esta sesión)

Especialistas consultados: game-designer, systems-designer, economy-designer, ux-designer,
network-programmer, godot-specialist, qa-lead, creative-director (síntesis).

| # | Bloqueante | Decisión aplicada |
|---|---|---|
| 1 | Máquinas sin presencia visual (Pilar 4) | Estructura visible obligatoria por máquina (3.6) |
| 2 | Cosechadora sin desventaja manual (Pilar 2) | Retraso de 1.5s + exclusión de Fresa (3.6) |
| 3 | Pool de sinks poco profundo (~$2.540, headline finding) | Silo ampliado sin techo desde tier 4 (3.7, 4.5); resto documentado como dependiente del sistema de automatización de largo plazo |
| 4 | Canal de venta inmovilizante sin cancelar | Cancelable con un segundo toque (3.4, 5.4) |
| 5 | Gesto de 0.4s en zona de disparo accidental | Marcado provisional, sujeto al spike de UX táctil (3.4) — no rediseñado a propósito |
| 6 | Sin aviso entre compañeros (canal de venta, compras) | Marcado provisional, sujeto al spike de UX táctil (3.4, Dependencies) |
| 7 | Cero consideración de red/autoridad | Dependencies actualizado; Edge Case 5.7 documenta la colisión sin resolver a propósito |
| 8 | Canalización del Silo sin fórmula de interpolación | Fórmula explícita añadida (4.4) |
| 9 | Dependencia bidireccional violada | `game-concept.md` actualizado para referenciar este documento (ver Dependencies y el diff de esa revisión) |
| 10 | Documento escrito por delante de 3 spikes bloqueantes | Nota de Status añadida al inicio; Apéndice B paso 0 |
| 11 | Edge Cases sin comportamiento provisional | 5.3 y 5.5 ahora declaran un comportamiento por defecto explícito |
| 12 | AC3/AC4 no verificables | Reescritas (8.3, 8.4); AC de paridad Fresa retirado (ya no es el objetivo) |
| 13 | Bifurcación Fresa: paridad vs. riesgo | Diferenciación por riesgo (3.2, 3.5, 3.6, 4.1, 5.6) |

Ítems "importantes" (no bloqueantes) también resueltos en esta pasada: mecanismo de render de
crecimiento (3.1), pooling de partículas (3.1), techo/pausa en la fórmula de plaga (4.3), aviso de
desbloqueo de menú (3.10), ACs faltantes para Sembradora/decoración/confort/ruta de fallo (8.3b,
8.9b, 8.10), ambigüedad de "unidades plantadas" (Tuning Knobs), piso de `duración_creciendo`
(Tuning Knobs). No se tocaron por estar fuera de alcance de esta pasada (quedan como riesgo menor
aceptado): los ratios decrecientes del coste de expansión de terreno (4.2).

## Apéndice C2 — Registro de decisiones de la ronda 2 de `/design-review` (2026-08-10, NEEDS REVISION → revisado en esta sesión)

Especialistas consultados: game-designer, systems-designer, economy-designer, ux-designer,
godot-specialist, network-programmer, performance-analyst, qa-lead, creative-director (síntesis).

| # | Bloqueante | Decisión aplicada |
|---|---|---|
| 1 | Cosechadora de radio + Fresa combinadas colapsaban la variedad de decisiones y volvían Trigo/Maíz manual opcional (Pilar 2 y Player Fantasy) | Descanso post-cosecha de Fresa de 3s, exclusivo de ese cultivo (3.1, 3.2, Edge Case 5.9, AC 9c, Tuning Knobs) — no reabre el balance de $/s de la ronda 1 |
| 2 | Infraestructura (Silo, Almacén, Refugio) sin presencia visual obligatoria, a diferencia de las Máquinas (Pilar 4) | Columna "Presencia visual" añadida a la tabla 3.7; radio del Refugio anclado a una estructura física (3.7) |
| 3 | Silo sin capacidad base ni regla de desbordamiento (riesgo de castigar la cosecha manual, Pilar 2) | Capacidad base $150; desbordamiento bloquea cosecha manual y automática sin pérdida (3.7, 4.4, Edge Case 5.8, AC 2b) |
| 4 | Gesto de mantener+tocar repetido es incoherente con un solo dedo, no solo riesgoso | Nota provisional reformulada: el spike debe seleccionar un mecanismo distinto, no ajustar parámetros del actual (3.4) |
| 5 | Ningún supuesto base de autoridad de red declarado, pese a que AC3/AC6/AC8 ya lo asumían en silencio | Supuesto no vinculante añadido en Dependencies (host autoritativo, clientes solo envían intenciones); Edge Case 5.7 ampliado a compras concurrentes limitadas |

Ítems "recomendados" (no bloqueantes) documentados pero no resueltos en esta pasada — quedan como
riesgo abierto o para una pasada futura: techo práctico del multiplicador de Silo tier 4+ (Tuning
Knobs, solo tiene piso ≥1.8, sin techo); viabilidad de la Sembradora rápida frente a la 4ª parcela en
ROI (aceptado como textura de diseño, no reprecio); riesgo de free-riding agravado por las nuevas
categorías de gasto compartido (documentado, no mitigado); métrica de distancia de "radio de 1 tile"
de la Cosechadora (Chebyshev/Manhattan/Euclidiana sin definir) y origen exacto del temporizador de
1.5s; viabilidad de Fresa en modo solo; opción de accesibilidad para contenido dependiente de tiempo
de reacción; alcance del spike de rendimiento (delimitado en `game-concept.md` para cintas/
trabajadores, no para el contenido específico de este documento); soporte de `GPUParticles2D` en el
renderer Compatibility/Mobile; agrupación/pestañas de menú una vez todo desbloqueado; AC6 no
verificable sin overlay de depuración; AC1 sin el mismo matiz de "valor vigente" que AC3; ACs
faltantes para la canalización del Silo por tier, el Almacén de semillas, y la visibilidad de
Decoración/Confort.

**Nota retrospectiva, añadida en ronda 3**: de los 5 bloqueantes de esta tabla marcados como
"decisión aplicada", los 5 tuvieron defectos vivos encontrados en la ronda 3 de `/design-review`
(#1 Fresa: cerrado solo a nivel de parcela, el intercalado de 2+ parcelas seguía abierto y el
bloqueo de replantar cualquier cultivo violaba el Pilar 3; #2 Infraestructura: "decal" era un nodo
3D-only, el radio del Refugio no tenía unidad, el Silo no tenía cap técnico de segmentos; #3 Silo:
el chequeo de desbordamiento no distinguía pre/post-cosecha, el mecanismo de reanudación era un
hand-wave, el feedback estaba desconectado del punto de toque, y colisionaba sin resolver con la
elegibilidad de plaga; #4 gesto: sin cambios, sigue correctamente marcado provisional; #5 red: el
placeholder no se auditó contra AC7 ni contra el lenguaje de "instantáneo" repetido en AC2/AC4/AC9).
Ver Apéndice C3 para el registro de ronda 3 y Apéndice D para los tres artefactos verificables que
la síntesis de ronda 3 exige antes de dar por cerrada una futura ronda de parches locales.

## Apéndice C3 — Registro de decisiones de la ronda 3 de `/design-review` (2026-08-10, NEEDS REVISION → revisado en esta sesión)

Especialistas consultados: economy-designer, game-designer, systems-designer, ux-designer,
godot-specialist, network-programmer, performance-analyst, qa-lead, creative-director (síntesis).

**Hallazgo de síntesis de esta ronda**: los 5 bloqueantes que la ronda 2 marcó "resueltos" tenían
defectos vivos en esta ronda — el patrón identificado es que cada parche de ronda 2 se insertó como
texto local (una fila nueva en una tabla, un párrafo nuevo en Dependencies) sin propagarse a
Formulas, Edge Cases y Acceptance Criteria. Esta ronda corrige eso y añade el Apéndice D —tres
artefactos verificables (matriz de estado×acción×elegibilidad, tabla de EV del Pilar 5, matriz de
cobertura de AC)— como el método exigido para que una futura ronda 4 no repita el mismo patrón.

| # | Bloqueante | Decisión aplicada |
|---|---|---|
| 1 | `nº_parcelas_activas` (4.3) y elegibilidad de objetivo de plaga indefinidos para Descansando/Marchita/Dañada/Reparando | Definición unificada: solo Creciendo/Lista cuentan y son objetivo válido (3.1, 3.5, 4.3, Apéndice D) |
| 2 | Pilar 5 (anti-softlock, EV prevenir-vs-reparar) no implementado en este documento; reparación era instantánea sin downtime | Reparación ahora entra en estado Reparando con downtime (4.0s Marchita / 2.0s Dañada, 3.4, 4.6, Edge Case 5.11); piso anti-softlock explícito para saldo $0 sin parcelas productivas (Edge Case 5.10, AC 3d); tabla de EV en Apéndice D |
| 3 | Mecanismo de disparo de la Cosechadora contradictorio en tres lugares (per-parcela vs. trigger-bound) | Fijado a trigger-bound (reacciona solo a cosecha manual disparadora); retraso cambiado de 1.5s fijo a 25% de `duración_creciendo` (proporcional entre Trigo/Maíz) (3.6, Tuning Knobs, AC 9) |
| 4 | Descanso de Fresa (ronda 2) no cerraba el intercalado de 2+ parcelas; además bloqueaba replantar cualquier cultivo, no solo Fresa (Pilar 3) | Cap de concurrencia de Fresa por granja (máx. 1 parcela activa a la vez, nuevo); descanso acotado a solo bloquear replantar Fresa en esa parcela (3.2, Edge Cases 5.9/5.12) |
| 5 | Desbordamiento de Silo: chequeo pre/post-cosecha ambiguo; reanudación de auto-cosecha sin mecanismo; feedback desconectado del punto de toque; colisión sin resolver con elegibilidad de plaga | Chequeo pre-cosecha explícito con holgura tolerada (4.4, AC 2c); reanudación event-driven (3.6); feedback localizado añadido en la parcela (5.8, AC 2b); exclusión explícita de elegibilidad de plaga mientras el bloqueo dure (3.5) |
| 6 | AC1 describía un mecanismo que la propia regla 3.4 declara físicamente incoherente — no ejecutable por un tester | Reescrita, marcada explícitamente bloqueada (no solo provisional) hasta que el spike de UX táctil resuelva un mecanismo real (8.1) |
| 7 | Métricas de distancia sin definir dentro de ACs numerados (Cosechadora, Refugio) | Cosechadora: Chebyshev 1 tile. Refugio: 1.5 unidades de mundo (3.6, 3.7, Tuning Knobs, AC 9) |
| 8 | Dependencies afirmaba que el spike de rendimiento ya cubría el contenido de este documento — contradecía el propio Apéndice C2 | Corregido a declaración honesta de cobertura faltante; pide ampliar el spike existente o programar uno dedicado (Dependencies) |
| 9 | Placeholder de autoridad de red (ronda 2) no auditado contra AC7 ni contra el lenguaje "instantáneo" de AC2/AC4/AC9 | Marca "⚠ Provisional" extendida a AC7 y a todo el lenguaje de mismo-frame/instantáneo del documento (Dependencies, AC 4, AC 7) |
| 10 | Tercera clase de condición de carrera sin enumerar: auto-cosecha diferida de la Cosechadora vs. cosecha manual concurrente | Enumerada como Edge Case 5.13, sin resolver a propósito, sujeta al spike de red |
| 11 | Almacén de semillas sin mecanismo de recarga especificado; dominaba estrictamente a Sembradora rápida sin que nadie lo notara | Recarga manual con fricción especificada (costo + ~1s por slot); ambas máquinas diferenciadas por caso de uso (3.7, AC 9d) |
| 12 | Player Fantasy (Sección 2) prometía "decisión cada pocos minutos" sin acotar que solo cubre ~20-30 min de una sesión de 15-60(-120) min | Acotación explícita añadida al párrafo (Sección 2) — decisión del usuario, no se añadió contenido nuevo para tapar el hueco |
| 13 | Silo tier 4+ (ronda 2) marcado "resuelto" pese a que el $/capacidad colapsa ~40× — la extensión de runway es solo nominal | Recalificado como sink de prestigio/cosmético, no como solución a la escasez de decisiones; etiqueta "resuelto" del hallazgo original retirada en Apéndice A #5 |
| 14 | 2s floor de `duración_creciendo` justificado con una razón matemáticamente incorrecta ("división por near-cero") | Rationale corregido a balance/legibilidad de animación, no estabilidad numérica (Tuning Knobs) |
| 15 | "Decal" del radio de Refugio nombra un nodo 3D-only de Godot que no existe en 2D | Corregido a `Sprite2D`/`Line2D` circular (3.7) |
| 16 | Silo tier 4+ "sin límite de segmentos" es un riesgo real de draw calls sin cap técnico | Cap técnico de 6 segmentos visibles añadido, independiente del cap económico (3.7, Tuning Knobs) |
| 17 | ACs faltantes: canalización del Silo por tier, visibilidad de Decoración/Confort, Almacén de semillas | Añadidas AC 4b, AC 8b, AC 9d |
| 18 | AC6 no verificable sin overlay de depuración | Requisito de log estructurado añadido a la propia AC (AC 6) |
| 19 | Ningún AC de rendimiento pese a que 3.1 invoca el presupuesto de <100 draw calls | Añadida AC 11 |
| 20 | Ningún gancho de accesibilidad para contenido dependiente de tiempo de reacción, en el documento que fija los timers más ajustados del spec | Placeholder no vinculante añadido en Tuning Knobs (multiplicador de ventana accesible) |
| 21 | Fórmula 4.1 sin banda relativa para el $/s de futuros cultivos, pese a que `game-concept.md` exige esa forma para el caso análogo (variante exótica) | Placeholder de banda relativa añadido en Tuning Knobs, a definir en `/design-system` de economía |
| 22 | Comfort (3.9) es un caso de free-riding más concreto que el framing general de `game-concept.md` | Nombrado explícitamente en Dependencies, sigue fuera de alcance (depende del `/design-system` de economía) |
| 23 | Cancelación de venta (3.4/5.4) no especificaba si solo el iniciador puede cancelar | Comportamiento por defecto explícito: cualquiera de los dos jugadores puede cancelar (Edge Case 5.14) |

**Decisiones de usuario tomadas en esta ronda** (ver AskUserQuestion de la sesión): (1) el cap de
concurrencia de Fresa por granja se adoptó en vez de aceptar el exploit o eliminar Descansando; (2)
la Player Fantasy se reescribió para acotar la promesa a la ventana real, en vez de añadir un sink
nuevo o dejarlo como estaba; (3) esta revisión se hizo produciendo los tres artefactos verificables
del Apéndice D, en vez de solo parchear la lista de bloqueantes — método explícitamente recomendado
por la síntesis de creative-director para romper el patrón de parches locales sin propagar.

Ítems "recomendados" (no bloqueantes) resueltos en esta pasada: rationale del piso de
`duración_creciendo`, retraso proporcional de la Cosechadora, precedencia Almacén/Sembradora,
feedback de cosecha (ver nota abajo — parcialmente, ver ítems pendientes), unidad del radio de
Refugio, métrica de la Cosechadora, cap visual del Silo, corrección de "decal", clasificación de
ACs por tipo de historia (ver Apéndice D).

**Resuelto parcialmente en esta pasada**: feedback de juice para la cosecha manual — se añadió una
especificación mínima (partícula, sonido, contador emergente) directamente en 3.4, cerrando el
hueco "cero feedback" que `game-designer` marcó blocking; la especificación de asset completa
(curvas de partícula, mezcla de audio) sigue fuera de alcance de este documento y queda pendiente
para `/asset-spec` o un pase de `sound-designer`.

Ítems documentados pero **no resueltos en esta pasada** — quedan como riesgo abierto o para una
pasada futura: modalidad del menú del Taller durante una plaga activa; fallback persistente para el toast de
desbloqueo de 2s; salvaguarda de fat-finger en la compra instantánea de terreno; ventanas de reacción
a plaga (4s/6s) sin marcar "⚠ Provisional" igual que el gesto de 0.4s; comportamiento de mantener en
estados de parcela distintos a Vacía; verificación explícita de `GPUParticles2D` bajo el renderer
Compatibility (sigue dependiendo del spike de rendimiento ampliado, ver Dependencies); ledger
consolidado de draw calls (pertenece al spike, no a este documento); viabilidad de Fresa en modo
solo; free-riding general (fuera de alcance, depende del `/design-system` de economía).

## Apéndice C4 — Registro de decisiones de la ronda 4 de `/design-review` (2026-08-10, pasada de verificación acotada)

Modo: `lean` (sin especialistas — verificación de una sola sesión, enfocada en confirmar que los
fixes de ronda 3 se sostienen, no una ronda adversarial completa). Objetivo explícito: comprobar que
el Apéndice D.1, el mecanismo de disparo de la Cosechadora, el cap de concurrencia de Fresa, y la
implementación de Pilar 5 son internamente consistentes y no dejaron huecos — exactamente el tipo de
verificación que la síntesis de ronda 3 pidió para una futura ronda 4 (ver Apéndice C3).

**Resultado**: la mayoría de lo auditado quedó limpio (mecanismo de la Cosechadora, numeración de
Edge Cases y ACs, referencias cruzadas) — pero se encontraron 2 bloqueantes reales, ambos del mismo
tipo que ronda 3 existe para prevenir: una regla que declara resolver un problema pero, al
propagarse hasta el caso límite completo, no lo cierra del todo.

| # | Bloqueante | Decisión aplicada |
|---|---|---|
| 1 | El piso anti-softlock (5.10, AC 3d) solo cubría el costo de reparación, no el de resiembra que la propia reparación exige (siempre termina en Vacía) — un pozo en $0 podía quedar permanentemente sin forma de volver a generar ingreso incluso después de la reparación gratuita, porque plantar Trigo ($2) seguía costando dinero que el pozo no tenía y no podía generar sin ningún cultivo Creciendo. Deadlock real, no solo teórico. | Piso extendido: si el pozo sigue sin saldo suficiente inmediatamente después de una reparación gratuita, el siguiente intento de plantar Trigo (el cultivo más barato, siempre desbloqueado) en la parcela recién Vacía también se ejecuta gratis, bajo la misma condición de activación (5.10, AC 3d) |
| 2 | El cap de concurrencia de Fresa (3.2, 5.12) solo contaba Creciendo/Lista, no Descansando — un jugador con 2+ parcelas de Fresa podía plantar una segunda parcela en el instante en que la primera entraba en Descansando, absorbiendo el descanso de 3s dentro del crecimiento de 4s de la segunda y recuperando una cadencia de cosecha de 4s en vez de 7s, sin atención real al descanso. Reabría, por una puerta distinta, el mismo patrón de atención-mínima que la regla de ronda 3 existe para cerrar. | El gate de concurrencia ahora cuenta Creciendo, Lista **y** Descansando — Fresa deja de estar disponible en cualquier otra parcela mientras exista una parcela de Fresa en cualquiera de esos tres estados (3.2, 5.12, AC 9c, Tuning Knobs) |
| 3 (recomendado, no bloqueante) | Formulas 4.3 afirmaba una equivalencia "si y solo si" entre `nº_parcelas_activas` y elegibilidad de objetivo de plaga, que la propia excepción de silo lleno (3.5, Apéndice D.1) contradice — es una implicación en un solo sentido, no una equivalencia | Corregida la formulación a "objetivo de plaga válido ⟹ cuenta como activa", con la excepción de silo lleno citada explícitamente (4.3) |

Ítems verificados sin defectos en esta ronda: mecanismo de disparo trigger-bound de la Cosechadora y
su retraso proporcional del 25% (consistente en 3.6, Tuning Knobs, AC 9, sin referencias residuales
al valor fijo de 1.5s de rondas anteriores); numeración completa de Edge Cases (5.1–5.14) y
Acceptance Criteria (1–11 con sub-letras); referencias cruzadas entre secciones.

**Decisión de usuario tomada en esta ronda**: revisar los 2 bloqueantes de inmediato en la misma
sesión, en vez de detener para una sesión aparte o aceptar tal cual — ninguno de los dos era
advisory, ambos eran defectos reales de la garantía que la ronda 3 ya declaraba resuelta.

## Apéndice D — Artefactos verificables (nuevo en ronda 3, exigidos por la síntesis de creative-director)

### D.1 Matriz de estado × acción × elegibilidad

Todas las parcelas de este documento tienen exactamente uno de estos 7 estados en un momento dado.
"Cuenta como activa" determina si la parcela entra en `nº_parcelas_activas` (Formulas 4.3). "Objetivo
de plaga" determina si puede recibir una plaga (regla 3.5).

| Estado | Toque simple | Mantener | Cuenta como activa (4.3) | Objetivo de plaga válido | Notas |
|---|---|---|---|---|---|
| Vacía | Planta el tipo mostrado (si hay ciclo activo) o inicia ciclo | Cicla tipo de semilla (⚠ Provisional, ver 3.4) / o toque simple 0.1s-0.15s si Almacén/Sembradora | No | No | Estado base tras cosecha o reparación |
| Creciendo | Feedback "no todavía" (5.1) | Igual que toque simple | **Sí** | **Sí** | Puede recibir pre-alerta de plaga en cualquier punto de su duración |
| Lista (silo con espacio) | Cosecha, suma al silo | N/A | **Sí** | **Sí** | — |
| Lista (silo lleno) | Feedback "silo lleno" localizado + icono HUD (5.8, AC 2b) | N/A | **Sí** (sigue siendo Lista) | **No** (excepción, ver 3.5) | Excluida de plaga para evitar doble castigo — ver Apéndice A #8 |
| Pre-alerta de plaga | Previene, –$15 (3.5) | N/A | Hereda del estado subyacente (Creciendo o Lista) | Es el objetivo activo, no una elegibilidad nueva | Overlay visual sobre Creciendo/Lista, no un estado independiente en la máquina de estados |
| Marchita | Inicia reparación (–$10 → Reparando 4.0s) | N/A | No | No | Ver 4.6 |
| Dañada (con Refugio) | Inicia reparación (–$5 → Reparando 2.0s) | N/A | No | No | Ver 4.6 |
| Reparando | Feedback "no todavía" (5.11) | N/A | No | No | No cancelable, no acelerable |
| Descansando (solo Fresa) | Feedback "no todavía" si intenta Fresa; planta de inmediato si otro cultivo (5.9) | Igual que toque simple | No | No | Exclusivo de Fresa, 3.0s, ver también cap de concurrencia por granja (3.2) |

**Regla derivada**: `nº_parcelas_activas` = objetivo de plaga válido, con una única excepción
(Lista + silo lleno: cuenta como activa para el ritmo, pero no es objetivo). Esto es intencional —
una parcela bloqueada por silo lleno sigue representando inversión de tiempo real en la granja
(sigue "ocupando" un ciclo de cultivo), así que sigue presionando el ritmo de plagas de las demás
parcelas, pero no puede perder su propia cosecha por esa presión.

### D.2 Tabla de EV — Pilar 5 (prevenir vs. reparar), en forma relativa

Requerida por `game-concept.md` Pilar 5: el costo de la resolución automática (y, por extensión, el
de reparar) debe ser peor en valor esperado que prevenir, expresado en relación al output esperado,
no como un número fijo. Cálculo con Trigo (beneficio neto $13 por ciclo de 6s, ver Formulas 4.1);
mismo método aplica proporcionalmente a Maíz y Fresa.

| Situación al momento de la plaga | Prevenir (–$15) | No prevenir → reparar (–$10 o –$5, + downtime + resembrar) | Comparación |
|---|---|---|---|
| Parcela en Lista (cosecha completa en juego, $13-$16 según cultivo) | –$15, conserva la cosecha completa | Pierde la cosecha ($13-16) + repara (–$10) + resiembra (–$2 a –$8) + 4.0s downtime + tiempo de resiembra | **Prevenir gana claramente** — la cosecha perdida sola ya supera el costo de prevenir |
| Parcela en Creciendo, cerca de completar (ej. 80% del ciclo) | –$15, conserva casi todo el progreso | Pierde ~80% de progreso + repara (–$10) + resiembra (–$2) + 4.0s downtime + ciclo completo de nuevo | Prevenir gana — el progreso perdido + downtime supera $15 |
| Parcela en Creciendo, recién plantada (ej. 10% del ciclo) | –$15, conserva poco progreso real | Pierde ~10% de progreso + repara (–$10) + resiembra (–$2) + 4.0s downtime | **Reparar es más barato en dinero** (–$12 vs. –$15), pero el downtime de 4.0s más el tiempo de resiembra suman una demora real que prevenir no tiene — el resultado depende de cuánto valora el jugador el tiempo vs. el dinero en ese momento de la sesión |
| Con Refugio (Dañada en vez de Marchita) | –$15 | Downtime baja a 2.0s, costo baja a –$5 | El caso "recién plantada" se inclina más hacia reparar (–$7 total vs. –$15) — el Refugio hace que ignorar alertas tempranas sea más razonable, no solo más barato |

**Conclusión de la síntesis de esta ronda**: con el downtime añadido en ronda 3 (4.6), la relación ya
no es una dominancia limpia de "reparar siempre gana" como sería sin downtime (round 2), pero
**sigue existiendo una zona genuina donde reparar es la opción racional** (parcelas recién
plantadas, especialmente con Refugio) — eso no es necesariamente un defecto: es coherente con el
patrón validado por el prototipo ("prevenir instantáneo/caro vs. reparar barato/con downtime" es un
trade-off real, no una regla que deba favorecer siempre a uno de los dos lados). El punto que
`game-concept.md` Pilar 5 exige verificar — que la resolución automática/reparación nunca sea *tan*
buena que "ignorar todo" se vuelva la estrategia dominante *en general*, no solo en el caso de
recién plantada — se sostiene: para cualquier parcela con progreso significativo (Lista o Creciendo
avanzado, que es la mayoría del tiempo de vida útil de una parcela), prevenir sigue siendo claramente
mejor. **Recomendación para `/design-system` de economía o para el playtest de Vertical Slice**:
confirmar si la zona de "conviene ignorar" en parcelas recién plantadas se siente como una decisión
interesante (dejar que la Cosechadora se encargue de Trigo/Maíz mientras uno prioriza otra cosa) o
como un exploit no anticipado — no se ajusta el balance aquí sin ese dato.

### D.3 Matriz de cobertura de Acceptance Criteria por tipo de historia

Clasificación según `.claude/docs/coding-standards.md` (Logic/Integration = evidencia BLOCKING;
Visual/UI/Config = evidencia ADVISORY).

| AC | Regla que cubre | Tipo de historia | Evidencia requerida |
|---|---|---|---|
| 1 | Ciclo de semilla (3.4) | UI (bloqueada hasta el spike de UX táctil — ver AC 1) | Walkthrough manual, no automatizable hasta que exista un mecanismo definido |
| 2, 2b, 2c | Cosecha y desbordamiento de silo (3.4, 4.4, 5.8) | Logic | `tests/unit/economy/` |
| 3, 3b | Plaga — ventana y fallo (3.5) | Logic | `tests/unit/plague/` |
| 3c | Downtime de reparación (3.4, 4.6) | Logic | `tests/unit/economy/` |
| 3d | Piso anti-softlock (5.10) | Logic (BLOCKING — es una garantía de no-deadlock) | `tests/unit/economy/` |
| 4, 4b | Canalización de venta (3.4, 4.4) | Logic + Integration (bloqueo de movimiento) | `tests/unit/economy/` + `tests/integration/movement/` |
| 5 | Menú del Taller no pausa (3.4) | Integration | `tests/integration/ui/` |
| 6 | Cooldown y desempate de plaga (3.5) | Logic (requiere el log estructurado especificado en la propia AC) | `tests/unit/plague/` con salida de log verificable |
| 7 | Compra de terreno sin saldo (3.4) | Logic | `tests/unit/economy/` |
| 8, 8b | Desbloqueo por hitos y visibilidad (3.10) | Logic (los hitos y el gate son deterministas) / Config (la lista de qué se muestra es dato) — **ambigüedad heredada, ver nota abajo** | `tests/unit/progression/` para el gate; smoke check para la lista visible |
| 9 | Auto-cosecha de la Cosechadora (3.6) | Logic | `tests/unit/economy/` |
| 9b | Sembradora rápida (3.6) | Logic | `tests/unit/input/` |
| 9c | Descanso y concurrencia de Fresa (3.2, 5.9, 5.12) | Logic | `tests/unit/economy/` |
| 9d | Almacén de semillas (3.7) | Logic | `tests/unit/economy/` |
| 10 | Límites de Decoración/Confort (3.8, 3.9) | Config | Smoke check |
| 11 | Presupuesto de rendimiento (3.1) | Visual/Performance (ADVISORY salvo que el equipo decida elevarlo — recomendación: BLOCKING dado que todo el documento depende de un spike sin correr) | Profiling en dispositivo de referencia |

**Nota sobre la ambigüedad de AC 8/8b**: `qa-lead` señaló en ronda 3 que el desbloqueo por hitos
podría clasificarse como Logic (el contador/temporizador que dispara el desbloqueo, BLOCKING) o
Config (qué aparece en el menú, ADVISORY) según cómo se implemente. Esta matriz no resuelve la
ambigüedad — la deja explícita para que quien escriba la story futura elija conscientemente, en vez
de que se decida por default sin que nadie lo note.
