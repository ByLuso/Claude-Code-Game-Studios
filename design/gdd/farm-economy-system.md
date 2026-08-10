# System GDD: Farm Economy — Cultivos, Terreno, Máquinas e Infraestructura

*Created: 2026-08-10*
*Status: Draft — revisado tras dos rondas de `/design-review` (2026-08-10). Ronda 1: veredicto MAJOR REVISION NEEDED, 8 especialistas + síntesis de creative-director, bloqueantes resueltos. Ronda 2 (mismo día, re-revisión): veredicto NEEDS REVISION, 5 bloqueantes adicionales resueltos en esta pasada. Ver Apéndice C para el registro completo de decisiones de ambas rondas. Tier: contenido MVP-adyacente / Vertical Slice — NO es contenido de MVP (ver Scope Tiers de `game-concept.md`).*
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

Construir, junto a tu compañero, una operación agrícola que cada pocos minutos les da una decisión
de inversión nueva y visible — otro tipo de cultivo, otra parcela, una máquina que cambia el ritmo,
una mejora de eficiencia — sin que ninguna de esas compras vuelva irrelevante la cosecha manual
(Pilar 2: Manual siempre vale la pena) y siempre representada físicamente en el terreno (Pilar 4:
Crecimiento visible). La sensación de "aburrimiento por falta de opciones" que reportó el playtest
del prototipo busca abordarse aquí, sin introducir parálisis por exceso de opciones — de ahí la
progresión de desbloqueo por hitos (sección 3.10). **No se afirma que este documento resuelva por
completo esa sensación de aburrimiento** — eso se confirma o descarta en el playtest de Vertical
Slice (Apéndice B).

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
| Descansando (solo Fresa, añadido en ronda 2) | Tierra removida sin brote, sin parpadeo | 3s tras cosechar una parcela de Fresa; no se puede replantar durante este estado (ver 3.2, Edge Case 5.9) |

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
además un estado "Descansando" de 3s tras cada cosecha, exclusivo de este cultivo, durante el cual
esa parcela no puede replantarse. Esto no cambia su $/s nominal (la fórmula 4.1 sigue usando solo
`duración_creciendo`), pero sí su ciclo real jugable: 4s de crecimiento + 3s de descanso = 7s de
ciclo efectivo. El objetivo es puramente de atención, no de balance económico: sin este descanso,
un jugador optimizador puede plantarse en una sola parcela de Fresa indefinidamente mientras la
Cosechadora de radio (3.6) atiende Trigo/Maíz en automático, eliminando la variedad de decisiones
que promete el Player Fantasy (ver nota de alcance en la Sección 2). Con el descanso, el ciclo
efectivo de Fresa ($16 / 7s ≈ $2.29/s) queda mucho más cerca del de Trigo ($2.17/s) y Maíz
($2.92/s), sin tocar el precio de semilla ni la ventana de reacción a plaga ya resueltos en la
ronda 1.

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
  compartido.
- **Sobre parcela en alerta de plaga, toque simple:** previene, –$15 del dinero compartido.
- **Sobre parcela Marchita, toque simple:** repara/replanta, –$10.
- **Sobre parcela con reja (no comprada), toque simple:** si hay saldo suficiente, la compra al
  instante (sin canalización — es decisión "antes de la partida", no "en caliente"). Sin saldo:
  el candado tiembla, sin penalización (ver Edge Cases).
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
| Cosechadora de radio | $350 | Al cosechar una parcela Lista, cosecha automáticamente cualquier otra parcela Lista **de Trigo o Maíz** (nunca Fresa, ver 3.2) en radio de 1 tile, con un retraso de 1.5s tras alcanzar el estado Lista | Estructura junto al Taller (silueta de cosechadora), más un indicador visual breve (parpadeo) sobre cada parcela que auto-cosecha |

**Resuelto en `/design-review` 2026-08-10 (Pilar 2 — Manual siempre vale la pena)**: la Cosechadora
nunca cosecha Fresa (es manual-only, ver 3.2) y su auto-cosecha en Trigo/Maíz tiene un retraso de
1.5s desde que la parcela pasa a Lista — la cosecha manual sigue siendo instantánea. Esto preserva
dos ventajas concretas de lo manual: acceso al cultivo de mayor $/s, y velocidad de ciclo en
cualquier cultivo.

**Añadido en la ronda 2 de `/design-review` 2026-08-10**: si el silo está lleno (ver 3.7, Edge Case
5.8), la auto-cosecha de la Cosechadora no se dispara — la parcela permanece en Lista hasta que haya
espacio disponible en el silo, sin perder la cosecha ni consumir el retraso de 1.5s en vano.

### 3.7 Infraestructura (eficiencia, no cosmética — compra en Taller o estructura dedicada)

| Estructura | Coste | Límite | Efecto | Presencia visual | Desbloqueo |
|---|---|---|---|---|---|
| Silo ampliado (tiers 1-3) | $80 → $200 → $400 ($680 acumulado) | 3× | Cada compra suma +$200 de capacidad; la canalización de venta baja según fórmula 4.4 (2s → 1s) | Estructura de silo física junto al Taller; cada tier comprado añade un segmento/anillo visible a la misma estructura (no una estructura nueva por tier), creciendo en altura | Tras acumular $500 en ventas totales |
| Silo ampliado (tiers 4+) | Cada tier adicional cuesta el doble del anterior ($800, $1.600, ...) | Sin límite | Cada compra suma +$200 de capacidad adicional; **no reduce más la canalización** (se queda en 1s, piso fijado en tier 3) | Mismo silo, sigue añadiendo un segmento visible por tier — sin límite de segmentos, aunque el efecto mecánico se estanca (ver 4.5) | Tras completar el tier 3 |
| Almacén de semillas | $120 | 1× | Desbloquea 5 slots de semilla precargada — plantar pasa de mantener 0.4s a toque simple 0.1s si el slot ya tiene semilla | Estructura pequeña tipo cobertizo/estante junto al Taller, distinta de las Máquinas y del Silo, visible desde que se compra | Tras plantar 50 unidades totales |
| Abrigo/Refugio | $150 | 1× | Estar dentro de la zona (1 tile) cuando llega una plaga reduce el daño: la parcela pasa a "Dañada" (recuperable por $5) en vez de "Marchita" (rota, $10) | Estructura de techo/refugio visible, colocada en un punto fijo del terreno — su radio de 1 tile (ver Efecto) se ancla siempre a esta estructura, nunca a una posición abstracta; un decal en el suelo marca el borde del radio | Tras sufrir 3 plagas |

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

**Resuelto en `/design-review` 2026-08-10 (profundidad de sinks)**: el Silo ampliado ya no tiene un
techo duro de 3 compras — a partir del tier 4, cada compra sigue sumando capacidad (aunque ya no
reduce la canalización de venta) a un coste que se duplica cada vez. Esto extiende el pool total de
gasto disponible sin rediseñar Máquinas ni inventar contenido nuevo — ver Formulas 4.5 para el
cálculo actualizado del runway. Sigue sin ser una solución completa a la profundidad de sink a
largo plazo (ver nota en Overview); es una extensión, no el sistema definitivo.

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

donde `nº_parcelas_activas` = parcelas plantadas (no vacías, no bloqueadas por reja).

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
largo plazo para la profundidad de sink definitiva.

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

5.8. **(Añadido en la ronda 2 de `/design-review` 2026-08-10) Silo lleno al intentar cosechar**: si
   el valor de venta de las unidades almacenadas sin vender iguala la capacidad actual del silo
   (base $150, ver Formulas 4.4), tocar una parcela Lista no cosecha — produce el feedback de "silo
   lleno" (icono de silo con un parpadeo rojo breve), no descuenta ni pierde nada, y la parcela
   permanece en estado Lista indefinidamente. La auto-cosecha de la Cosechadora de radio (3.6)
   tampoco se dispara mientras el silo esté lleno, y se retoma automáticamente en cuanto haya
   espacio, sin perder la parcela objetivo de su estado Lista. Ver AC 2b.

5.9. **(Añadido en la ronda 2 de `/design-review` 2026-08-10) Descanso de Fresa tras cosecha**: tras
   cosechar una parcela de Fresa (a mano — nunca aplica a Trigo/Maíz), esa parcela entra en estado
   Descansando durante exactamente 3.0s, durante el cual intentar plantar produce el mismo feedback
   de "no todavía" que sobre una parcela en Creciendo, sin penalización económica. Ver 3.1, 3.2 y
   AC 9c para el propósito de mitigación de monopolio de atención de esta regla.

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
  amplían la superficie de ese riesgo sin mitigarlo.
- **Depende del spike de rendimiento por escala de entidades** (`game-concept.md` Next Steps,
  **bloqueante antes de `/map-systems`**): el contenido de este documento (hasta 6 parcelas con
  estados animados independientes, efectos de enjambre, partículas, 2 máquinas) es exactamente la
  carga que ese spike existe para validar. **Este documento no debe tratarse como listo para
  implementación hasta que ese spike corra** — ver nota de Status al inicio del documento.
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
| Duración de crecimiento (`duración_creciendo`, todos los cultivos) | 4s–12s según cultivo (tabla 3.2) | **mínimo absoluto 2s** — valores menores no están soportados por la fórmula 4.1 (ver systems-designer, riesgo de división por near-cero) | Validez de la fórmula de beneficio/segundo para cultivos futuros |
| Cooldown global entre plagas | 15s | 10–20s | Densidad de alarmas simultáneas al escalar parcelas |
| Constante base intervalo plaga | 25s (min) / 45s (max) | ±10s | Ritmo de tensión temprano |
| Constante de escalado por parcela | +3s por parcela, válido para 0-6 parcelas (ver Formulas 4.3) | +2 a +5s por parcela | Cómo crece la frecuencia total de alarmas con el mapa |
| Costes de expansión de terreno (3ª–6ª parcela) | $50 / $120 / $250 / $450 | mantener progresión creciente, no bajar por debajo de ×1.5 por paso | Cadencia de decisión terreno vs. máquinas |
| Coste Sembradora rápida | $200 | $150–$250 | Ritmo de la primera inversión en Taller |
| Coste Cosechadora de radio | $350 | $300–$450, siempre > Sembradora | Ritmo de la segunda inversión, debe doler comprarla pronto |
| Retraso de auto-cosecha de la Cosechadora | 1.5s tras alcanzar Lista | 1–3s, siempre > 0 | Preserva ventaja de velocidad de la cosecha manual (Pilar 2) |
| Costes Silo ampliado (tiers 1-3) | $80 / $200 / $400 | mantener progresión creciente | Pacing del sink de infraestructura |
| Costes Silo ampliado (tier 4+) | ×2 el tier anterior, sin techo | mantener multiplicador ≥1.8 | Runway total del pool de gasto, ver Formulas 4.5 |
| Umbral desbloqueo Silo | $500 en ventas acumuladas | $300–$700 | Cuándo aparece la primera opción de infraestructura |
| Umbral desbloqueo Almacén de semillas | 50 unidades plantadas (cuenta semillas plantadas, no unidades cosechadas — aclarado en `/design-review` 2026-08-10) | 30–80 | Cuándo aparece la 2ª opción de infraestructura |
| Umbral desbloqueo Refugio | 3 plagas sufridas | 2–5 | Cuándo aparece la mitigación de daño de plaga |
| Umbral desbloqueo Confort | 5 minutos de partida | 3–8 min | Cuándo se ofrecen mejoras de comodidad no esenciales |
| Canalización de venta | fórmula 4.4: 2.0s a 1.0s según tiers de Silo | 1–3s en los extremos | Ventana de vulnerabilidad al vender (mitigada por cancelación, regla 3.4) |
| Límites de decoración | Valla 6× / Bandera 3× / Cartel 1× | mantener límites bajos | Evita clutter visual en el mapa |
| Descanso post-cosecha de Fresa (nuevo, ronda 2) | 3s | 2–5s | Ciclo efectivo de la Fresa y mitigación de monopolio de atención (ver 3.2, Edge Case 5.9) |
| Capacidad base del Silo (nuevo, ronda 2) | $150 | $100–$250 | Cuán pronto se siente el desbordamiento antes de la primera compra de Silo (ver 4.4, Edge Case 5.8) |

## 8. Acceptance Criteria

1. Dada una parcela Vacía, mantener el botón de acción 0.4s cicla entre los tipos de semilla ya
   desbloqueados; soltar planta exactamente el tipo mostrado en ese momento. **(⚠ el valor de 0.4s
   y el mecanismo de ciclado son provisionales, ver regla 3.4 — este AC se revisa tras el spike de
   UX táctil.)**
2. Dado un cultivo en estado Lista, un toque simple lo cosecha y añade al silo compartido
   exactamente las unidades definidas en la tabla 3.2 para ese cultivo.
2b. **(añadido en la ronda 2 de `/design-review` 2026-08-10 — antes sin AC)** Dado un silo cuyo
   valor almacenado sin vender iguala su capacidad actual, un toque simple sobre una parcela Lista
   no cosecha, no descuenta ni suma dinero, y produce el feedback visual de "silo lleno"; la parcela
   permanece en estado Lista. La auto-cosecha de la Cosechadora de radio (regla 9) tampoco se
   dispara mientras el silo esté lleno, y se retoma automáticamente en cuanto haya espacio.
3. Dada una parcela de Trigo o Maíz en pre-alerta de plaga, tras 0.5s se activa el enjambre visual
   y el jugador dispone exactamente de 6.0s (medidos en tiempo del host, ver Dependencies) desde
   ese momento para prevenir (–$15) antes de que la parcela pase a Marchita. Para Fresa, la ventana
   es exactamente 4.0s (regla 3.5). Si el temporizador de tuning cambia estos valores, este AC se
   verifica contra el valor vigente en `plague_config` (o equivalente) en el momento de la prueba,
   no contra el número aquí escrito.
3b. **(añadido en `/design-review` 2026-08-10 — antes sin AC)** Dada una parcela en pre-alerta de
   plaga cuya ventana de reacción expira sin que ningún jugador prevenga, la parcela pasa
   exactamente a Marchita (o a Dañada si hay Refugio comprado y un jugador está dentro del radio),
   se pierde cualquier cosecha pendiente en esa parcela, y se disparan sacudida de cámara (0.2s) +
   partícula de polvo/hojas + sonido grave, en ese orden o simultáneamente, dentro del mismo frame
   de la transición de estado.
4. Dado el punto de venta, un toque simple inicia la canalización de venta (duración según fórmula
   4.4); durante la canalización el jugador no puede moverse. Un segundo toque sobre el punto de
   venta durante la canalización la cancela: no se descuenta ni se suma dinero, y el jugador
   recupera movimiento en el frame siguiente. Si la canalización completa sin cancelar, vende todo
   el silo compartido y suma el dinero correspondiente al pozo compartido.
5. Dado el Taller, un toque simple abre el menú de compra sin pausar la simulación — las plagas
   activas siguen corriendo su temporizador durante la decisión.
6. Dado que dos plagas están próximas a dispararse en parcelas distintas dentro de los 15s del
   cooldown global, solo una se dispara; la segunda espera hasta que el cooldown expire. (Regla de
   desempate entre cuál de las dos se dispara primero: la que haya alcanzado su `intervalo_min`
   individual antes, por orden de tiempo del host — ver Dependencies para la autoridad de red.)
7. Dada una parcela con reja y saldo compartido insuficiente para comprarla, tocarla no descuenta
   dinero ni la desbloquea, y produce el feedback visual de candado temblando.
8. Ningún ítem de infraestructura (Silo, Almacén, Refugio) aparece en el menú de compra antes de
   cumplirse su hito de desbloqueo respectivo (regla 3.10); tras cumplirse, dispara el aviso de
   desbloqueo (regla 3.10) en ambos dispositivos y aparece en la siguiente apertura del menú. Si dos
   hitos se cumplen en el mismo frame, ambos avisos se disparan juntos.
9. Tras comprar la Cosechadora de radio, cosechar una parcela Lista de Trigo o Maíz cosecha
   automáticamente, 1.5s después, cualquier otra parcela de Trigo o Maíz en estado Lista dentro de
   un radio de 1 tile de la parcela objetivo. Una parcela de Fresa en el mismo radio **nunca** se
   auto-cosecha, sin importar su estado.
9b. **(añadido en `/design-review` 2026-08-10 — antes sin AC)** Tras comprar la Sembradora rápida,
   mantener el botón de acción sobre una parcela Vacía planta el cultivo mostrado tras 0.15s de
   sostenido, en vez de los 0.4s por defecto.
9c. **(añadido en la ronda 2 de `/design-review` 2026-08-10 — antes sin AC)** Tras cosechar una
   parcela de Fresa a mano, esa parcela entra en estado Descansando durante exactamente 3.0s,
   durante el cual intentar plantar produce el mismo feedback de "no todavía" que sobre una parcela
   en Creciendo, sin penalización económica.
10. **(añadido en `/design-review` 2026-08-10 — antes sin AC)** Cada ítem de Decoración (Valla,
   Bandera, Cartel) y Confort (Timbre, Mostrador) puede comprarse hasta su límite definido en las
   tablas 3.8/3.9; al alcanzar el límite, la opción de compra se deshabilita visualmente (no solo
   rechaza el toque en silencio) y no se puede volver a comprar esa unidad.

*(El AC anterior sobre paridad de $/s Fresa-Maíz se retira de esta sección — resuelto en Edge Case
5.6 mediante diferenciación por riesgo, no por paridad; no hay un AC de "no debe superar en más de
X" porque ya no es el objetivo de diseño.)*

---

## Apéndice A — Riesgos de balance abiertos (resumen, actualizado tras `/design-review` 2026-08-10, ronda 2)

Ver detalle completo en Edge Cases (sección 5) y Formulas (sección 4). Resumen de seguimiento:

1. ~~Fresa desequilibrada frente a Maíz/Trigo en $/s~~ — **resuelto**: diferenciación por riesgo
   (Edge Case 5.6), no paridad. **Ronda 2**: se identificó que la paridad de $/s no bastaba —
   permitía monopolizar la atención en una sola parcela de Fresa mientras la Cosechadora atendía
   Trigo/Maíz sola (ver ítem 7). Mitigado con el descanso post-cosecha de 3s (Edge Case 5.9).
   Pendiente de confirmar en playtest que 4s de ventana y 3s de descanso se sienten bien en táctil
   real.
2. Solapamiento de plagas con 5-6 parcelas activas — mitigado por diseño (cooldown 15s), con
   comportamiento por defecto explícito si el playtest lo rechaza (Edge Case 5.3).
3. Parálisis de menú con 10+ opciones — mitigado por desbloqueo por hitos + aviso visible (Edge
   Case 5.5, regla 3.10). Riesgo residual identificado en ronda 2: una vez todo desbloqueado, la
   lista plana de opciones no tiene agrupación/pestañas — aceptado como riesgo menor no bloqueante,
   ver Apéndice C ronda 2.
4. ~~Vulnerabilidad durante la canalización de venta~~ — **mitigada**: canal cancelable (Edge Case
   5.4). Pendiente de confirmar en playtest si además hace falta que el compañero la vea (depende
   del spike de UX táctil).
5. Runway total de gasto poco profundo (~$2.539 en contenido de un solo tier) — parcialmente
   extendido con tiers de Silo sin techo (Formulas 4.5). **Ronda 2**: se reconoce explícitamente en
   Overview/Player Fantasy que esta profundidad solo cubre ~20-30 minutos de sesión; más allá de
   eso, el Silo tier 4+ es un sink sin decisión real. La profundidad completa sigue dependiendo del
   futuro sistema de cintas/trabajadores (fuera de alcance de este documento) — no se inventó
   contenido nuevo para tapar el hueco, a propósito.
6. Colisión de acciones simultáneas sobre la misma parcela entre los dos jugadores — sin resolver a
   propósito, depende del spike técnico de red (Edge Case 5.7). **Ronda 2**: se identificó que el
   mismo riesgo aplica a cualquier compra limitada desde el pozo compartido (terreno, máquinas,
   tiers de Silo, decoración/confort) — ampliado en Edge Case 5.7, igualmente sin resolver a
   propósito.
7. **(nuevo, ronda 2)** Cosechadora de radio + Fresa combinadas volvían "manual siempre vale la
   pena" y "decisión cada pocos minutos" simultáneamente falsos — el jugador óptimo dejaba que la
   máquina cultivara Trigo/Maíz y se plantaba en una sola parcela de Fresa el resto de la sesión.
   Mitigado con el descanso post-cosecha de Fresa (Edge Case 5.9, Tuning Knobs) sin reabrir el
   balance de $/s ya resuelto en la ronda 1.
8. **(nuevo, ronda 2)** Silo sin capacidad base ni regla de desbordamiento — resuelto: capacidad
   base $150, desbordamiento bloquea la cosecha manual y automática sin pérdida (Edge Case 5.8).
9. **(nuevo, ronda 2)** Infraestructura (Silo, Almacén, Refugio) sin presencia visual obligatoria,
   a diferencia de las Máquinas — resuelto, columna "Presencia visual" añadida a la tabla 3.7,
   incluyendo el anclaje físico del radio del Refugio.

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
