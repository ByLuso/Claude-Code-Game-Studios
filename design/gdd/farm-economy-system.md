# System GDD: Farm Economy — Cultivos, Terreno, Máquinas e Infraestructura

*Created: 2026-08-10*
*Status: Draft — reformateado a partir de una especificación externa para cumplir el estándar de 8 secciones de `design/CLAUDE.md`*
*Origen: Sesión de diseño con ENGRANAJE (arquitecto de mecánicas), a partir de la hipótesis confirmada
en `prototypes/rincon-compartido-concept/REPORT.md` (Concept Prototype Report — Economía Compartida + Amenazas)*
*Propósito: especificación de sistemas lista para pasar a un agente de código que va a ampliar el
concept prototype confirmado con multi-cultivo, expansión de terreno, máquinas, infraestructura,
decoración y confort.*

> **Nota de integración (añadida al reformatear, ver Dependencies)**: este documento reemplaza la
> descripción de automatización de `game-concept.md` (cintas transportadoras + trabajadores en
> cuadrícula) por un mecanismo distinto (Máquinas de compra única). Esta divergencia no está
> resuelta todavía — ver sección Dependencies antes de tratar este documento como fuente de verdad
> definitiva para `/map-systems`.

---

## 1. Overview

Este sistema define la capa de contenido y progresión económica del terreno compartido de Rincón
Compartido: multi-cultivo con estados discretos, expansión de terreno por compra, el evento de
amenaza (plaga) escalado al número de parcelas activas, máquinas de compra única, infraestructura
de eficiencia, decoración cosmética y confort/QoL — todo construido encima del core loop ya
validado por el concept prototype (economía compartida de un solo pozo de dinero, tecla de acción
única y contextual, patrón de decisión prevenir-instantáneo-caro vs. reparar-barato-con-downtime).
El prototipo confirmó que ese core loop genera negociación real entre los dos jugadores; su único
punto débil fue la falta de variedad de contenido en qué invertir, que es exactamente lo que este
sistema añade.

## 2. Player Fantasy

Construir, junto a tu compañero, una operación agrícola que cada pocos minutos les da una decisión
de inversión nueva y visible — otro tipo de cultivo, otra parcela, una máquina que cambia el ritmo,
una mejora de eficiencia — sin que ninguna de esas compras vuelva irrelevante la cosecha manual
(Pilar 2: Manual siempre vale la pena) y siempre representada físicamente en el terreno (Pilar 4:
Crecimiento visible). La sensación de "aburrimiento por falta de opciones" que reportó el playtest
del prototipo debe desaparecer sin introducir parálisis por exceso de opciones — de ahí la
progresión de desbloqueo por hitos (sección 9 de la fuente, ver Detailed Rules).

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

### 3.2 Tabla de cultivos

| Cultivo | Coste semilla | Duración Creciendo | Unidades al cosechar | Precio venta/unidad | Desbloqueo |
|---|---|---|---|---|---|
| Trigo | $2 | 6s | 3 | $5 | Disponible desde el inicio |
| Maíz | $5 | 12s | 5 | $8 | Tras vender 100 unidades acumuladas de trigo |
| Fresa | $8 (candidato a subir a $10-11, ver Edge Cases 6.5 y Formulas 4.1) | 4s | 2 | $12 | Tras comprar la 4ª parcela |

### 3.3 Terreno y expansión

Parcelas no desbloqueadas se ven como tierra gris con textura de "reja" semitransparente y un
icono de candado — no se puede plantar en ellas. Costes en la tabla de Formulas 4.2.

### 3.4 La interacción (tecla de acción única, contextual)

Sigue habiendo una **sola tecla de acción**, contextual según el objeto y estado con el que se
interactúa:

- **Sobre parcela Vacía, mantener 0.4s** (no toque simple, para evitar plantar por accidente al
  pasar corriendo): cicla el tipo de semilla disponible con toques repetidos antes de soltar;
  soltar planta el tipo mostrado en ese momento. Solo aparecen en el ciclo los cultivos ya
  desbloqueados.
- **Sobre parcela Lista, toque simple:** cosecha, añade las unidades correspondientes al silo
  compartido.
- **Sobre parcela en alerta de plaga, toque simple:** previene, –$15 del dinero compartido.
- **Sobre parcela Marchita, toque simple:** repara/replanta, –$10.
- **Sobre parcela con reja (no comprada), toque simple:** si hay saldo suficiente, la compra al
  instante (sin canalización — es decisión "antes de la partida", no "en caliente"). Sin saldo:
  el candado tiembla, sin penalización (ver Edge Cases).
- **Sobre el punto de venta, toque simple:** vende todo el silo, con **2s de canalización**
  (1s si el Silo ampliado está al máximo, ver 3.6) durante los cuales el jugador no puede moverse
  ni defender ninguna parcela.
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
- Ventana de reacción: 6s desde que el enjambre es visible (tras los 0.5s de pre-alerta). Ver
  Edge Cases 6.5 para el candidato de reducir esta ventana a 4s específicamente en parcelas de
  Fresa.
- Prevenir a tiempo: –$15 compartido, flash verde 0.3s, la parcela vuelve a su estado previo sin
  pérdidas.
- No prevenir: pasa a Marchita (o Dañada si hay Refugio y el jugador está dentro), se pierde
  cualquier cosecha que hubiera, sacudida de cámara 0.2s + partícula de polvo/hojas rotas + sonido
  grave.

### 3.6 Máquinas (Taller — compra única, efecto permanente)

| Máquina | Coste | Efecto |
|---|---|---|
| Sembradora rápida | $200 | Reduce el mantener-tecla de plantar de 0.4s a 0.15s |
| Cosechadora de radio | $350 | Al cosechar una parcela Lista, cosecha automáticamente cualquier otra parcela Lista en radio de 1 tile |

### 3.7 Infraestructura (eficiencia, no cosmética — compra en Taller o estructura dedicada)

| Estructura | Coste | Límite | Efecto | Desbloqueo |
|---|---|---|---|---|
| Silo ampliado | $80 → $200 → $400 (3 compras, $680 acumulado) | 3× | Cada compra suma +$200 a la cantidad vendible sin canalización extra; con silo máximo, canalización de venta baja de 2s a 1s | Tras acumular $500 en ventas totales |
| Almacén de semillas | $120 | 1× | Desbloquea 5 slots de semilla precargada — plantar pasa de mantener 0.4s a toque simple 0.1s si el slot ya tiene semilla | Tras plantar 50 unidades totales |
| Abrigo/Refugio | $150 | 1× | Estar dentro de la zona (1 tile) cuando llega una plaga reduce el daño: la parcela pasa a "Dañada" (recuperable por $5) en vez de "Marchita" (rota, $10) | Tras sufrir 3 plagas |

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

## 4. Formulas

### 4.1 Rentabilidad por cultivo ($/segundo de crecimiento)

`beneficio_por_segundo = (unidades_al_cosechar × precio_venta − coste_semilla) / duración_creciendo`

| Cultivo | Cálculo | Beneficio/s |
|---|---|---|
| Trigo | (3×$5 − $2) / 6s = $13/6s | **$2.17/s** |
| Maíz | (5×$8 − $5) / 12s = $35/12s | **$2.92/s** |
| Fresa (precio actual $8) | (2×$12 − $8) / 4s = $16/4s | **$4.00/s** |
| Fresa (precio candidato $10) | (2×$12 − $10) / 4s = $14/4s | $3.50/s |
| Fresa (precio candidato $11) | (2×$12 − $11) / 4s = $13/4s | $3.25/s |

**Hallazgo del reformateo**: incluso con el precio de semilla subido al extremo alto del rango
candidato ($11), la Fresa ($3.25/s) sigue por encima del Maíz ($2.92/s) — la mitigación de precio
por sí sola no cierra completamente la brecha. Ver Edge Cases 6.5 para el resto de la decisión
abierta (posiblemente haga falta combinar con la reducción de ventana de reacción, o aceptar
conscientemente que la Fresa sea la opción de mayor riesgo/recompensa en vez de buscar paridad
exacta de $/s con el Maíz — decisión de diseño pendiente, no resuelta en este documento).

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

### 4.4 Silo ampliado — capacidad y canalización de venta

- Capacidad extra acumulada: $200 por compra × hasta 3 compras = +$600 de capacidad total, por
  $680 de inversión acumulada ($80+$200+$400).
- Canalización de venta: 2s por defecto → 1s con las 3 compras de Silo ampliado completas.

## 5. Edge Cases

1. **Toque en el momento equivocado** (p. ej. cosechar sobre una parcela en Creciendo): el brote
   tiembla una vez, sin penalización económica ni de tiempo.
2. **Compra de parcela sin saldo suficiente**: el candado tiembla, no se descuenta dinero, la
   parcela permanece bloqueada — no hay reintento automático ni cola de compra.
3. **Plagas en parcelas distintas próximas a dispararse a la vez**: el cooldown global de 15s
   (regla 3.5) impide que dos plagas se disparen con menos de 15s de diferencia entre sí,
   independientemente de lo que indique la fórmula 4.3 para cada parcela individual. **Pendiente
   de validar en playtest con 5-6 parcelas activas** si esto sigue sintiéndose tenso o se vuelve
   injusto por acumulación de alertas pendientes.
4. **Vulnerabilidad durante la venta**: durante los 2s (o 1s) de canalización de venta, el jugador
   no puede moverse ni defender ninguna parcela — si llega una plaga durante ese lapso, no hay
   forma de reaccionar hasta que termine. Con más parcelas compradas, esta ventana de indefensión
   cubre proporcionalmente más superficie de mapa sin vigilancia. **Pendiente de confirmar en
   playtest** a partir de 4+ parcelas si sigue siendo una decisión de timing interesante o se
   vuelve una penalización injusta — no resuelto en este documento.
5. **Menú con 10+ opciones de gasto desde el minuto 1**: mitigado por la progresión de desbloqueo
   por hitos (regla 3.10) — parálisis por análisis mitigada, pero pendiente de confirmar en
   playtest.
6. **Fresa desequilibrada frente a Maíz y Trigo en $/segundo** (ver Formulas 4.1): mitigación NO
   decidida en este documento. Dos candidatos sobre la mesa, no mutuamente excluyentes: (a) subir
   coste de semilla a $10-11 (cierra parte de la brecha pero no toda, ver 4.1), (b) reducir la
   ventana de reacción a plaga específicamente en parcelas de Fresa de 6s a 4s (añade riesgo, no
   cambia el $/s nominal). Debe resolverse antes de `/design-system` de balance final — puede
   requerir combinar (a) y (b), o aceptar conscientemente que la Fresa es la opción "alto
   riesgo/alta recompensa" del set de cultivos en vez de buscar paridad exacta.

## 6. Dependencies

- **Extiende** `design/gdd/game-concept.md`: reutiliza el core loop validado por el concept
  prototype — economía compartida de un solo pozo de dinero (Pilar 1), tecla de acción única y
  contextual, patrón de decisión prevenir (instantáneo, caro) vs. reparar (barato, con downtime)
  (Pilar 5), sin combate directo (Anti-Pilar).
- **Conflicto sin resolver con `game-concept.md` Core Mechanics #2**: el concept doc describe la
  automatización como "cintas transportadoras y trabajadores contratables, colocados en una
  cuadrícula 2D/isométrica"; este documento la reemplaza por "Máquinas" de compra única y efecto
  permanente (Sembradora rápida, Cosechadora de radio), sin cuadrícula de colocación ni cintas.
  Esto afecta directamente al Pilar 4 (Crecimiento visible — las cintas eran la representación
  física de la automatización) y a la sección "Long-Term Progression" del concept doc (que
  describe una "operación mayormente automatizada" con piezas visibles en el terreno). **No se
  resuelve en este documento** — debe decidirse si las Máquinas reemplazan la visión de
  automatización del concept doc, o si son una capa previa/complementaria (p. ej. Máquinas primero
  en MVP, cintas/trabajadores después en una fase posterior). Recomendado: escalar a
  `creative-director` antes de `/map-systems`, según Coordination Rules (conflicto de diseño entre
  documentos = escalar al director creativo).
  - `game-concept.md` debe actualizarse para referenciar este documento una vez resuelto
    (dependencia bidireccional, según regla de `design-docs.md`) — actualmente sus secciones
    "Content Volume" y "MVP Definition" (`Required for MVP` #1, #2) no mencionan este sistema.
- **Depende de** una decisión de `/design-system` de economía para el mecanismo de mitigación del
  riesgo de free-riding (documentado como Open Question en `game-concept.md` tras el round 3 de
  `/design-review`) — este documento no lo aborda; el gasto sigue siendo libre del pozo compartido
  sin atribución.

## 7. Tuning Knobs

| Knob | Valor actual | Rango seguro sugerido | Afecta |
|---|---|---|---|
| Coste semilla Fresa | $8 | $8–$12 (decisión pendiente, ver Edge Cases 6.5) | Balance de $/s entre cultivos |
| Ventana de reacción a plaga (general) | 6s | 4–8s | Dificultad de proteger cultivos a tiempo |
| Ventana de reacción a plaga (Fresa, candidato) | — (no aplicado aún) | 4–6s | Riesgo específico de la Fresa, mitigación candidata |
| Cooldown global entre plagas | 15s | 10–20s | Densidad de alarmas simultáneas al escalar parcelas |
| Constante base intervalo plaga | 25s (min) / 45s (max) | ±10s | Ritmo de tensión temprano |
| Constante de escalado por parcela | +3s por parcela | +2 a +5s por parcela | Cómo crece la frecuencia total de alarmas con el mapa |
| Costes de expansión de terreno (3ª–6ª parcela) | $50 / $120 / $250 / $450 | mantener progresión creciente, no bajar por debajo de ×1.5 por paso | Cadencia de decisión terreno vs. máquinas |
| Coste Sembradora rápida | $200 | $150–$250 | Ritmo de la primera inversión en Taller |
| Coste Cosechadora de radio | $350 | $300–$450, siempre > Sembradora | Ritmo de la segunda inversión, debe doler comprarla pronto |
| Costes Silo ampliado (3 tiers) | $80 / $200 / $400 | mantener progresión creciente | Pacing del sink de infraestructura |
| Umbral desbloqueo Silo | $500 en ventas acumuladas | $300–$700 | Cuándo aparece la primera opción de infraestructura |
| Umbral desbloqueo Almacén de semillas | 50 unidades plantadas | 30–80 | Cuándo aparece la 2ª opción de infraestructura |
| Umbral desbloqueo Refugio | 3 plagas sufridas | 2–5 | Cuándo aparece la mitigación de daño de plaga |
| Umbral desbloqueo Confort | 5 minutos de partida | 3–8 min | Cuándo se ofrecen mejoras de comodidad no esenciales |
| Canalización de venta | 2s (1s con Silo máximo) | 1–3s | Ventana de vulnerabilidad al vender |
| Límites de decoración | Valla 6× / Bandera 3× / Cartel 1× | mantener límites bajos | Evita clutter visual en el mapa |

## 8. Acceptance Criteria

1. Dada una parcela Vacía, mantener el botón de acción 0.4s cicla entre los tipos de semilla ya
   desbloqueados; soltar planta exactamente el tipo mostrado en ese momento.
2. Dado un cultivo en estado Lista, un toque simple lo cosecha y añade al silo compartido
   exactamente las unidades definidas en la tabla 3.2 para ese cultivo.
3. Dada una parcela en pre-alerta de plaga, tras 0.5s se activa el enjambre visual y el jugador
   dispone de 6s (o el valor tuneado) desde ese momento para prevenir (–$15) antes de que la
   parcela pase a Marchita.
4. Dado el punto de venta, un toque simple inicia una canalización de 2s (o 1s con Silo ampliado
   al máximo) durante la cual el jugador no puede moverse; al completarse, vende todo el silo
   compartido y suma el dinero correspondiente al pozo compartido.
5. Dado el Taller, un toque simple abre el menú de compra sin pausar la simulación — las plagas
   activas siguen corriendo su temporizador durante la decisión.
6. Dado que dos plagas están próximas a dispararse en parcelas distintas dentro de los 15s del
   cooldown global, solo una se dispara; la segunda espera hasta que el cooldown expire.
7. Dada una parcela con reja y saldo compartido insuficiente para comprarla, tocarla no descuenta
   dinero ni la desbloquea, y produce el feedback visual de candado temblando.
8. Ningún ítem de infraestructura (Silo, Almacén, Refugio) aparece en el menú de compra antes de
   cumplirse su hito de desbloqueo respectivo (regla 3.10); tras cumplirse, aparece en la siguiente
   apertura del menú.
9. Tras comprar la Cosechadora de radio, cosechar una parcela Lista cosecha automáticamente
   cualquier otra parcela en estado Lista dentro de un radio de 1 tile de la parcela objetivo.
10. **[Bloqueado hasta resolver Edge Case 6.5]** Una vez decidida la mitigación de balance de la
    Fresa, su beneficio por segundo no debe superar al del Maíz en más del [rango a definir tras la
    decisión] — no verificable todavía porque la mitigación no está decidida.

---

## Apéndice A — Riesgos de balance abiertos (resumen)

Ver detalle completo en Edge Cases (sección 5) y Formulas (sección 4.1). Resumen de seguimiento:

1. Fresa desequilibrada frente a Maíz/Trigo en $/s — mitigación no decidida.
2. Solapamiento de plagas con 5-6 parcelas activas — mitigado por diseño (cooldown 15s), pendiente
   de confirmar en playtest.
3. Parálisis de menú con 10+ opciones — mitigado por desbloqueo por hitos, pendiente de playtest.
4. Vulnerabilidad durante la canalización de venta a partir de 4+ parcelas — no mitigado, pendiente
   de playtest para saber si hace falta.

## Apéndice B — Orden de implementación sugerido

1. Implementar multi-cultivo (sección 3.1–3.2) sobre el prototipo confirmado, sin tocar el core
   loop validado (plantar/crecer/cosechar/vender/prevenir/reparar).
2. Añadir expansión de terreno (sección 3.3) — validar en playtest si el jugador entiende el coste
   creciente sin explicación adicional en pantalla.
3. Añadir Taller y las dos máquinas (sección 3.6) — es el gancho de progresión con más impacto en
   ritmo, priorizar sobre infraestructura/decoración.
4. Añadir infraestructura con desbloqueo por hitos (secciones 3.7 y 3.10).
5. Añadir decoración y confort al final (secciones 3.8 y 3.9) — son las de menor riesgo de balance.
6. Playtest de 1 sesión con los pasos 1-2 implementados antes de añadir máquinas, para aislar si
   la variedad de cultivo + expansión ya resuelve el aburrimiento reportado, o si hace falta llegar
   hasta máquinas para sostener el interés.

> Nota: este documento no rediseña el core loop confirmado (economía compartida, tecla contextual
> única, patrón prevenir/reparar) — lo da por bueno y construye la capa de contenido/progresión que
> el propio playtest del concept prototype identificó como la pieza que faltaba.
