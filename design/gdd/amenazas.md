# Amenazas (framework genérico)

> **Status**: Designed — hallazgos de `/design-review` ronda 1 (NEEDS REVISION) aplicados en esta
> sesión; pendiente de re-revisión independiente en sesión nueva para confirmar
> **Author**: usuario + agentes
> **Last Updated**: 2026-08-11
> **Implements Pillar**: Pilar 5 (El riesgo empuja a prepararse)
> **Creative Director Review (CD-GDD-ALIGN)**: omitido — modo Lean (no es phase-gate en este modo)
>
> 🚧 **NO implementation-ready** — depende de 2 spikes técnicos sin ejecutar (red, UX táctil) y de 3
> sistemas Foundation sin GDD propio (Networking, Input, Economía Compartida). Ver Dependencies y
> Core Rules 9/11.

## Overview

Amenazas es el framework compartido que genera, telegrafía y resuelve los eventos de riesgo
periódicos que ponen en juego la inversión de tiempo/dinero puesta en cualquier recurso de la
operación (cultivo, madera, mineral) — nunca al jugador directamente. Funciona como un motor de
eventos genérico: cada recurso lo instancia con sus propios números (frecuencia, ventana de reacción,
severidad), pero la estructura — generar con un cooldown compartido, telegrafiar con doble señal
(visual diegética + texto), y ofrecer la elección entre prevenir (instantáneo, costoso) o reparar
(barato, con downtime) — es una sola pieza de diseño reutilizada tres veces. Para el jugador, cada
disparo de amenaza es el momento de mayor tensión y coordinación del loop: sentir la alarma, decidir
junto a tu compañero quién responde y cómo, y ver la consecuencia (o el alivio de haberla evitado)
reflejada en el terreno compartido — nunca como un ataque personal, siempre como un cuidado colectivo
puesto a prueba.

## Player Fantasy

Cuando la amenaza se dispara, el jugador debe sentir una descarga breve de urgencia compartida — el
tipo de "¡yo la tengo!" de *Overcooked* dentro de un mismo evento, no el miedo de un juego de terror
ni la ansiedad de un combate. La tensión viene de la coordinación bajo un reloj corto (4-6s) *para una
sola amenaza a la vez* — el cooldown global (Core Rule 2) mantiene deliberadamente un solo ritmo de
alerta en vez de varios simultáneos, así que la fantasía no es "malabarear amenazas de distinto tipo a
la vez" sino "resolver esta amenaza juntos, rápido." Nada en pantalla amenaza al avatar del jugador,
solo el terreno construido con esfuerzo compartido. Resolver la amenaza a tiempo (prevenir) debe
sentirse como un choque de manos silencioso; llegar tarde y tener que reparar debe sentirse como un
"bueno, tocará esperar un poco" — un contratiempo con costo claro y recuperación garantizada, nunca
una pérdida permanente ni una vergüenza. El fallo es fricción temporal, no castigo.

> `creative-director` no consultado en la autoría original — modo Lean. Revisado y corregido en
> `/design-review` ronda 1 (2026-08-11): el texto original prometía coordinación entre amenazas
> simultáneas de distinto tipo, que el cooldown global (Core Rule 2) prohíbe estructuralmente —
> corregido para no contradecir la propia regla.

## Detailed Design

> `systems-designer`/especialistas no consultados en esta sección — modo Lean (solo Formulas y
> Acceptance Criteria reciben especialista en este modo).

### Core Rules

1. **Selección de disparo**: cada vez que el temporizador de intervalo cumple (fórmula genérica, ver
   Formulas), el sistema elige aleatoriamente UNA entidad amenazable elegible (parcela en
   Creciendo/Lista, o equivalente futuro en madera/mineral) de entre TODAS las entidades activas de
   cualquier tipo de recurso en la operación compartida — no por tipo de recurso separado.
2. **Cooldown global único**: tras cualquier disparo, ningún otro disparo — de cualquier tipo (plaga,
   derrumbe, incendio) — puede ocurrir hasta que pase el cooldown global (constante, 15s actual). Por
   construcción, esto hace estructuralmente imposible que dos amenazas estén activas a la vez, sin
   necesitar una regla de desempate.
3. **Pre-alerta**: 0.5s de aviso (parpadeo azul-blanco + contorno de forma engrosado, art bible §7.5)
   antes de que el telegraph físico aparezca — un instante de anticipación que todavía no cuenta como
   ventana de reacción.
4. **Ventana de reacción**: tras la pre-alerta, la amenaza queda "activa" durante N segundos (definido
   por cada instancia de recurso; rango observado hasta ahora en Cultivos: 4-6s). "Prevenir" solo está
   disponible durante esta ventana.
5. **Señal doble obligatoria**: todo evento activo debe mostrar siempre dos señales simultáneas —
   telegraph visual diegético sobre la entidad + texto de refuerzo en HUD indicando qué entidad/lado
   está afectado. Ninguna por sí sola basta (ya exigido en `farm-economy-system.md` tras revisión).
6. **Resolución sin prevención**: al expirar la ventana sin toque de "Prevenir", la entidad pasa a un
   estado de daño. La severidad (Severo vs. Reducido) depende de si hay una estructura protectora
   (equivalente a Refugio) en rango al momento de la resolución — con protección: Reducido; sin ella:
   Severo. **Mientras la ventana está activa, el telegraph debe reflejar en tiempo real cuál sería el
   resultado si expirara AHORA** (p. ej., un cambio de tono/intensidad en el rim-light o el ícono
   cuando una estructura protectora entra o sale de rango) — la regla de "construir bajo presión
   importa" debe ser observable en el momento, no solo confirmable después del hecho (hallazgo de
   `game-designer` en `/design-review`, ronda 1).
7. **Prevenir**: un toque, solo durante la ventana activa, cuesta dinero del pozo compartido, resuelve
   al instante sin estado de daño ni downtime.
8. **Reparar**: un toque, solo disponible en estado de daño, cuesta menos que Prevenir pero incurre
   downtime antes de volver a estar disponible — mayor downtime para Severo que para Reducido.
9. **Autoridad de red** (⚠ Provisional, heredado, pendiente del spike de red): selección de objetivo y
   resolución de prevención se deciden en el host y se replican vía RPC autoritativo — nunca de forma
   independiente en cada cliente.
10. **Disparo cancelado por pool vacío** (nuevo, `/design-review` ronda 1): si al cumplirse el
    temporizador de intervalo no hay ninguna entidad elegible, el intento NO cuenta como "disparo" a
    efectos de Core Rule 2 — el cooldown global no se activa. El temporizador de intervalo se PAUSA
    (no avanza, no se resortea) mientras el pool esté vacío, y se reanuda exactamente donde quedó en
    cuanto vuelve a haber al menos una entidad elegible. Coincide con `farm-economy-system.md` §4.3:
    "el temporizador de plaga se pausa por completo."
11. **Coordinación cross-device declarada bloqueante** (nuevo, `/design-review` ronda 1): ⚠ ninguna
    Core Rule especifica cómo un jugador percibe que su compañero ya está respondiendo a la amenaza
    activa ("yo la tengo") — depende enteramente del glyph de presencia de compañero, todavía sin
    diseñar (spike de UX táctil). Si ambos jugadores dudan y la ventana expira sin que nadie toque
    Prevenir, se aplica Core Rule 6 con normalidad (Dañada) — no hay comportamiento especial de "doble
    duda", es el mismo camino que "nadie respondió". Esta dependencia se declara DURA y BLOQUEANTE:
    Amenazas no debe considerarse implementation-ready hasta que el spike de UX táctil resuelva el
    canal de presencia.

### States and Transitions

| State | Entry Condition | Exit Condition | Behavior |
|---|---|---|---|
| Normal | Estado por defecto de cualquier entidad elegible | Seleccionada por un disparo | Sin señal visible |
| Pre-alerta | Entidad seleccionada por el disparo | Pasan 0.5s | Parpadeo azul-blanco + contorno engrosado |
| Amenaza activa | Termina la pre-alerta | Toque de "Prevenir" (→Normal) o expira la ventana (→Dañada) | Telegraph diegético + texto HUD; "Prevenir" habilitado |
| Dañada (Severo) | Expira la ventana sin protección en rango | Toque de "Reparar" | Entidad inutilizable; "Reparar" habilitado |
| Dañada (Reducido) | Expira la ventana con protección en rango | Toque de "Reparar" | Igual, downtime menor |
| Reparando | Toque de "Reparar" desde cualquier estado Dañada | Termina el downtime | Ícono de herramienta, sin toques adicionales |

### Interactions with Other Systems

- **Economía Compartida**: Prevenir/Reparar consumen del pozo único — Amenazas no define montos (los
  define cada instancia de recurso), solo exige que ambos usen la misma cuenta sin atribución
  (Pilar 1).
- **Terreno y Parcelas** (y equivalentes futuros): expone la lista de "entidades amenazables
  elegibles" — Amenazas no sabe qué es una parcela, solo itera sobre entidades activas.
- **Networking**: necesita autoridad de host; interfaz: `{entidad_objetivo_id, tipo_amenaza,
  timestamp_disparo_host, duracion_ventana, resultado}` replicado a ambos peers — **ampliado en
  `/design-review` ronda 1**: la versión original no transmitía `duracion_ventana` ni una referencia
  de reloj compartida, obligando al cliente a re-derivar la cuenta atrás localmente, justo lo que
  Core Rule 9 prohíbe. Los clientes calculan el fin de ventana como
  `timestamp_disparo_host + duracion_ventana`, contra el reloj del host, nunca de forma
  independiente.
- **Cultivos** (instancia existente): ya implementa este contrato completo vía plagas — sirve de
  referencia para cómo Madera/Minerales lo instancien.
- **UI/HUD**: consume "Amenaza activa" para el texto de refuerzo; consume "Dañada"/"Reparando" para el
  ícono localizado sobre la entidad.

## Formulas

> `systems-designer` consultado — modo Lean (Formulas es una de las 2 secciones que sí reciben
> especialista en este modo).

### amenaza_interval (intervalo de disparo, generalizado)

`intervalo_min = min(25 + (num_entidades_amenazables * 3), 70)`
`intervalo_max = min(45 + (num_entidades_amenazables * 3), 90)`

**Techo duro añadido en `/design-review` ronda 1** — el riesgo marcado en la autoría original ("a
n=30, más de 2 minutos entre disparos") era un defecto presente, no un riesgo futuro
([systems-designer]). El techo se activa en n=15 (donde `45+3·15=90`), manteniendo el mismo spread
de 20s entre min/max que la fórmula sin techo tenía en todo su rango.

**Nota sobre elegibilidad vs. conteo** (nuance heredada de `farm-economy-system.md` §4.3, no
capturada en la generalización original): una entidad Lista pero bloqueada por almacenamiento lleno
(silo/equivalente) cuenta hacia `num_entidades_amenazables` pero NO es objetivo válido de selección
(evita doble castigo) — "cuenta como activa" y "elegible como objetivo" no son estrictamente lo
mismo. Madera/Minerales deben replicar esta distinción si tienen un mecanismo de almacenamiento
análogo.

| Variable | Symbol | Type | Range | Description |
|---|---|---|---|---|
| Entidades amenazables activas | num_entidades_amenazables | int | 0–sin tope | Total de entidades elegibles en TODOS los tipos de recurso (parcelas de cultivo en Creciendo/Lista + futuros nodos de madera/mineral), sumadas en un solo pool per Core Rule 1 |
| Intervalo mínimo/máximo | intervalo_min, intervalo_max | float | 25–sin tope, 45–sin tope | Segundos hasta el próximo disparo global |

**Output range**: [25, 90] con techo duro (corregido en `/design-review` ronda 1) — cambio deliberado
respecto al `[25,63]` ya registrado para `plague_interval`: el 63 original venía del tope duro de 6
parcelas de Cultivos, restricción de esa instancia; el nuevo techo de 90 es una restricción del
framework mismo, no de una instancia particular.

**Ejemplo**: 6 parcelas de cultivo + 4 nodos de madera + 2 de mineral = 12 entidades → intervalo
[61, 81]s (bajo el techo, sin efecto todavía). A 15+ entidades, el intervalo se satura en [70, 90]s.

### coste_no_prevenir (EV parcial de Prevenir vs. Reparar)

`coste_no_prevenir = (valor_en_riesgo * t_progreso) + costo_reparar + costo_reinicio`

| Variable | Symbol | Type | Range | Description |
|---|---|---|---|---|
| Costo de prevenir | costo_prevenir | float | >0 $ | Costo instantáneo de Prevenir |
| Valor en riesgo | valor_en_riesgo | float | ≥0 $ | Valor máximo de producción en juego |
| Progreso al disparo | t_progreso | float | 0–1 | Fracción del ciclo de producción completada al momento del disparo |
| Costo de reparar / reinicio | costo_reparar, costo_reinicio | float | ≥0 $ | Costo de reparar + costo de reinicio (reinicio=0 para recursos que no re-crecen) |
| Costo total si no se previene | coste_no_prevenir | float | ≥0, sin tope | — |

**Output range**: ≥0 $, sin tope superior definido — depende de los valores de cada instancia de
recurso.
**Ejemplo** (trigo, Lista): 15·1 + 10 + 2 = 27 > 15 → prevenir domina monetariamente (coincide con el
Apéndice D.2 ya aprobado en `farm-economy-system.md`).

**Decisión explícita**: el downtime de Reparar queda fuera de esta fórmula a propósito —
monetizarlo exigiría inventar una constante $/s de "valor del tiempo" que no existe en ningún lado del
diseño. El downtime sigue siendo un eje cualitativo separado que cada instancia valida en su propia
tabla de Tuning Knobs/Edge Cases, igual que hizo la instancia de Cultivos.

**Invariante de instanciación obligatorio (nuevo, `/design-review` ronda 1 — hallazgo de
`systems-designer`)**: nada en la fórmula por sí sola impide que una instancia mal calibrada cree una
estrategia dominante fija. Para que Prevenir vs. Reparar sea una elección genuina, toda instancia DEBE
satisfacer:

`costo_reparar + costo_reinicio < costo_prevenir < valor_en_riesgo + costo_reparar + costo_reinicio`

Es decir, la curva de `coste_no_prevenir` debe cruzar `costo_prevenir` en algún punto de
t_progreso ∈ (0,1) — barato reparar temprano, caro no prevenir tarde. Contraejemplo que este
invariante prohíbe: reparar=$20, reinicio=$10, prevenir=$15 → 30 > 15, prevenir domina para todo
t_progreso, violando AC-11. Ejemplo que sí cumple (trigo, ya validado): 10+2=12 < 15 < 15+12=27 ✓ —
plantilla para que Madera/Minerales lo copien al instanciar.

## Edge Cases

> Sin especialista consultado en esta sección — modo Lean.

| Escenario | Comportamiento esperado | Justificación |
|---|---|---|
| No hay ninguna entidad amenazable elegible al momento del disparo (p. ej. antes de plantar nada) | El intento se descarta sin consumir el cooldown global (Core Rule 10); el temporizador de intervalo se pausa y se reanuda donde quedó al volver a haber una entidad elegible — nunca se resortea ni se pierde progreso | Coincide con `farm-economy-system.md` §4.3 ("se pausa por completo"); corregido en `/design-review` ronda 1 — antes decía "se reinicia con el mismo intervalo", inconsistente con esa fuente |
| La única entidad elegible ya está en Reparando o Dañada | No es elegible — el pool de selección excluye cualquier entidad fuera de estado "activo normal" | Si eso vacía el pool, aplica el caso anterior |
| Los dos jugadores tocan "Prevenir" en la misma entidad en la misma ventana (carrera de red) | El host procesa el primer RPC válido y descarta el segundo en silencio, sin cobro doble ni error visible. ⚠ Sesgo declarado (ronda 1): "primer RPC gana" no es neutral — el jugador con peor RTT hacia el host pierde sistemáticamente esta carrera; se acepta como trade-off conocido, sin mitigación diseñada, revisar en playtesting | Pilar 3 (fricción cero) — un error visible castigaría al jugador más lento sin motivo |
| Un jugador (el host) se desconecta mientras hay una amenaza activa (nuevo, ronda 1) | Default provisional: la amenaza se resuelve como Prevenida automáticamente (sin daño), nunca como Dañada por abandono | Espeja el principio anti-softlock del Pilar 5 — un problema de conectividad no debe traducirse en castigo. Sigue ⚠ Provisional/sujeto a lo que decida el spike de red, pero ya no queda como comportamiento indefinido |
| La entidad objetivo es cosechada/removida por el jugador durante la pre-alerta o la ventana activa | La amenaza se cancela para esa entidad, sin penalización ni reembolso; el disparo se da por resuelto | No debe existir una "amenaza huérfana" apuntando a algo que ya no existe |
| Se coloca o destruye una estructura protectora durante la ventana de reacción activa | La severidad (Severo/Reducido) se evalúa en el momento de la RESOLUCIÓN, no del disparo | Premia la construcción reactiva bajo presión, no solo la preparación anticipada |
| Un jugador se desconecta mientras hay una amenaza activa | ⚠ Provisional, heredado — sin resolver hasta que el spike de red defina migración de host | No se decide aquí a propósito; marcado como pendiente explícito, no implícito |
| Primer disparo de la partida | Se sortea igual que cualquier otro, usando `num_entidades_amenazables` real al momento de empezar (normalmente 1) | Sin caso especial de "gracia" — el n bajo ya produce un intervalo naturalmente generoso |

## Dependencies

| System | Direction | Nature of Dependency |
|---|---|---|
| Economía Compartida | Amenazas depende de | Necesita el pozo único para cobrar Prevenir/Reparar — dura |
| Terreno y Parcelas (y equivalentes futuros) | Amenazas depende de | Necesita la lista de entidades amenazables elegibles — dura |
| Networking | Amenazas depende de | Necesita autoridad de host para disparo/resolución — dura, ⚠ Provisional (spike de red pendiente) |
| Cultivos | Cultivos depende de Amenazas | Ya instancia el framework para plagas — dura |
| Madera | Madera depende de Amenazas | Instanciará el framework para derrumbes — dura, sistema aún no diseñado |
| Minerales | Minerales depende de Amenazas | Instanciará el framework para incendios — dura, sistema aún no diseñado |
| UI/HUD | UI/HUD depende de Amenazas | Consume estado activo/dañado para el telegraph — blanda |

## Tuning Knobs

| Parameter | Current Value | Safe Range | Effect of Increase | Effect of Decrease |
|---|---|---|---|---|
| cooldown_global | 15s | 10-20s (heredado) | Menos amenazas simultáneas percibidas, más calma entre picos — puede sentirse vacío si sube mucho | Amenazas más frecuentes entre tipos distintos, riesgo de fatiga de alerta |
| pre_alert_duration | 0.5s | 0.3-1.0s | Más anticipación, pero acorta la ventana de reacción percibida si se confunde con ella | Menos aviso, arriesga que el jugador no note el cambio de fase |
| reaction_window (por instancia de recurso) | 4-6s observado en Cultivos | 3-8s recomendado para el framework | Más manejable, reduce la tensión objetivo del Pilar 5 | Bajo 3s arriesga sentirse injusto en táctil móvil |
| ratio downtime_severo : downtime_reducido | 4.0s : 2.0s (Cultivos) = 2:1 | Mantener severo > reducido siempre; ratio 1.5:1 a 3:1 recomendado | Castiga desproporcionadamente no tener protección | Cerca de 1:1 anula el incentivo de construir estructuras protectoras |

## Visual/Audio Requirements

> `art-director` consultado (sección requerida para esta categoría, no opcional).

**1. Familias de forma por tipo de amenaza** (para que las 3 nunca choquen entre sí):
- Plaga (ya diseñada, art bible §3): clúster de gota/diamante suave, en nube dispersa y arremolinada
  (vocabulario restaurado en `/design-review` ronda 1 — "movimiento en órbita" se descartó por poder
  reintroducir la lectura de acecho/rodeo), mate oscuro desaturado.
- Derrumbe (madera): fragmentos poligonales angulares con esquinas redondeadas (nunca afiladas/tipo
  arma), **restricción de proporción añadida en ronda 1: fragmentos chatos/tipo bloque, nunca cuñas
  finas, para evitar lectura de metralla**, movimiento de asentamiento/desmoronamiento lento hacia
  abajo, mate oscuro desaturado.
- Incendio (mineral): manchas tipo ascua redondeadas (no lenguas de fuego, evita iconografía de
  combate), movimiento de deriva/pulso ascendente, mate oscuro desaturado.

Regla para futuros GDDs (Madera, Minerales): elegir una familia de forma que no sea ni
clúster-orgánico-redondo (plaga), ni fragmentado-angular (derrumbe), ni mancha-flotante (incendio) —
confirmar contra esta tabla antes de finalizar. Las 3 obedecen las reglas ya fijadas en el art bible
sin cambios: rim-light localizado, pre-alerta azul-blanco, cero rojo (reservado a Fresa), nunca efectos
de pantalla completa.

⚠ **Callout de legibilidad/daltonismo** (nuevo, `/design-review` ronda 1): las 3 familias comparten el
mismo color "mate oscuro desaturado" — la distinción recae solo en forma+movimiento, no en color.
Validar en playtesting con jugadores daltónicos que la diferenciación por silueta sola es suficiente
a la escala de cámara del juego; si no lo es, considerar un acento de tono sutil por familia dentro
del rango permitido (nunca rojo).

**2. Gramática compartida Severo/Reducido** (re-skinneable por instancia de recurso):
- **Severo**: desaturación total a gris-marrón apagado + ícono fijo de "anillo roto" (marcador
  genérico de "inutilizable", reemplaza el marchitado literal de Cultivos).
- **Reducido**: desaturación parcial (60%, conserva algo de color cálido) + ícono fijo de "media
  pantalla/muesca" señalando "protegido pero reducido." El ícono es fijo en todo el sistema; solo el
  arte de la entidad debajo cambia por recurso.

**3. Audio** (nuevo — sin pase previo de `audio-director` en el proyecto, marcado como seguimiento
futuro):
- Pre-alerta: campanada suave de 2 notas ascendentes, registro medio, no urgente.
- Amenaza activa: zumbido/textura ambiental grave (timbre específico por tipo), en loop, sin sting.
- Prevenida: acorde mayor corto y cálido de confirmación.
- Dañada: golpe/suspiro grave único y suave, sin disonancia, sin sting en tono menor.
- Reparación completa: brillo ascendente cálido con un pequeño acorde de alivio — misma familia
  tonal que la confirmación de Prevenir pero más suave ("ya está resuelto", no "lo evitamos a
  tiempo") — **fortalecido en `/design-review` ronda 1** para que Reparar tenga un payoff positivo
  propio, no solo la ausencia de más negatividad tras el golpe de Dañada; refuerza que Reparar es
  una resolución igual de válida, no un premio de consolación (resuelve el desacuerdo entre
  `game-designer` y `creative-director` sobre si Reparar se siente anticlimático — se optó por el
  arreglo de audio, sin reabrir Core Rule 8).

**4. Implicación del cooldown global único**: como solo un telegraph de amenaza puede estar visible a
la vez (Core Rule 2), esto simplifica el art bible — no hace falta diseñar reglas para amenazas
simultáneas/superpuestas, ni en visual ni en audio. 📌 Pendiente: añadir un addendum corto a
`design/art/art-bible.md` con las 3 familias de forma de este punto y esta simplificación, una vez el
GDD completo esté aprobado.

## UI Requirements

| Information | Display Location | Update Frequency | Condition |
|---|---|---|---|
| Texto de refuerzo de amenaza activa (qué entidad/lado) | HUD, cerca de la entidad afectada | Al dispararse, se limpia al resolverse | Solo mientras hay una amenaza activa (nunca más de una a la vez, per cooldown global) |
| Ícono "anillo roto" (Severo) / "muesca protegida" (Reducido) | Overlay diegético sobre la entidad, no HUD de esquina | Aparece al pasar a Dañado, desaparece al completar Reparando | Solo sobre la entidad afectada específica |
| Botón de acción contextual (Prevenir/Reparar) | Anclado al mundo/pulgar, no HUD fijo (art bible §7.1) | Cambia de verbo según el estado de la entidad bajo el jugador | Solo cuando el jugador está sobre/cerca de una entidad en Amenaza activa o Dañada |
| Placeholder "presencia del compañero" | Glyph pequeño persistente, ya reservado en art bible §7.9 | — | Reservado para cuando el spike de UX táctil decida el mecanismo — Amenazas hereda el hueco, no lo diseña |
| Indicador de borde / nudge de cámara hacia la entidad amenazada (nuevo, `/design-review` ronda 1) | Borde de pantalla, apunta hacia la entidad | Aparece si la entidad amenazada está fuera del viewport del jugador | Solo mientras hay amenaza activa y la entidad no es visible — sin esto, "texto cerca de la entidad" degenera a cero señal (hallazgo de `ux-designer`) |

📌 **UX Flag — Amenazas**: este sistema tiene requisitos de UI reales. En Fase 4 (Pre-Producción),
correr `/ux-design` para el HUD/telegraph de amenaza antes de escribir épicas. Las historias que
referencien esta UI deben citar `design/ux/[pantalla].md`, no este GDD directamente.

## Acceptance Criteria

> `qa-lead` consultado — modo Lean (Acceptance Criteria es la otra sección que sí recibe especialista
> en este modo).

- **AC-1** (Selección agrupada, con cláusula de muestra — corregido ronda 1): DADO que hay entidades
  activas de varios tipos de recurso, CUANDO se ejecutan N≥30 disparos independientes, ENTONCES la
  distribución de entidades seleccionadas muestra representación de cada tipo de recurso presente
  (no sistemáticamente sesgada hacia uno solo) — criterio probabilístico, no verificable en un solo
  disparo.
- **AC-2** (Cooldown global): DADO que una amenaza se acaba de disparar, CUANDO no han pasado 15s,
  ENTONCES ningún nuevo disparo (de cualquier tipo) ocurre, aunque otra entidad se vuelva elegible de
  forma independiente.
- **AC-3** (Pre-alerta): DADO que se dispara una amenaza, CUANDO se reproduce la pre-alerta de 0.5s,
  ENTONCES "Prevenir" no está disponible y el conteo de la ventana de reacción todavía no empezó.
- **AC-4** (Ventana de reacción): DADO que termina la pre-alerta, CUANDO la ventana específica de la
  instancia está activa (p. ej. 4-6s en cultivos), ENTONCES "Prevenir" solo es tocable dentro de ese
  lapso; tocar después de expirar no tiene efecto.
- **AC-5** (Señal doble, con método de observación — corregido ronda 1): DADO cualquier amenaza
  activa, CUANDO se capturan 3 momentos aleatorios del estado del juego durante la pre-alerta o la
  ventana (método: captura de estado + verificación de que ambos canales —sprite de mundo y texto
  HUD— son simultáneamente no-nulos), ENTONCES ambos están presentes en las 3 capturas — nunca solo
  uno.
- **AC-6** (Severidad en resolución, con frontera de tiempo y señal observable — corregido ronda 1):
  DADO que no hay protección al momento del disparo, CUANDO se coloca protección en el segundo T
  (0<T<duración_ventana), ENTONCES (a) el telegraph cambia observablemente de tono/intensidad dentro
  de los 200ms siguientes a T (Core Rule 6 enmendada), y (b) si no se previene después de T, el daño
  resuelve como Reducido, no Severo. El cambio debe ser detectable ANTES de que expire la ventana, no
  solo confirmable en el estado final.
- **AC-7** (Prevenir): DADO una ventana activa, CUANDO el jugador toca Prevenir, ENTONCES se descuenta
  dinero, el estado de daño nunca se aplica, y el efecto es instantáneo.
- **AC-8** (Reparar): DADO que la entidad está Dañada, CUANDO se usa Reparar, ENTONCES el costo es
  menor que el de Prevenir, y el downtime de Severo es mayor que el de Reducido.
- **AC-9** (Autoridad de red): **EXCLUIDO explícitamente** del alcance de QA de este GDD (reforzado
  ronda 1, no es un TBD silencioso) — seguimiento en Open Questions bajo "Mecanismo de autoridad de
  red", propietario: spike de red, sin fecha hasta que ese spike entregue una interfaz concreta que
  verificar.
- **AC-10** (Fórmula de intervalo, corregido ronda 1 con techo duro): DADO num_entidades_amenazables
  = N, CUANDO termina un período de cooldown, ENTONCES el próximo intervalo de disparo cae en
  [min(25+3N,70), min(45+3N,90)]s — nunca por encima de 90s sin importar N.
- **AC-11** (Fórmula coste_no_prevenir, parametrizada — corregido ronda 1, trigo queda solo como
  ilustración): DADO cualquier instancia de recurso que satisfaga el invariante de instanciación
  (`costo_reparar + costo_reinicio < costo_prevenir < valor_en_riesgo + costo_reparar +
  costo_reinicio`), CUANDO se calcula coste_no_prevenir en t_progreso=0 y en t_progreso=1, ENTONCES
  coste_no_prevenir(0) < costo_prevenir < coste_no_prevenir(1) — existe un punto de equilibrio en
  (0,1) donde la decisión óptima cambia. *Ilustración con trigo*: equilibrio en t_progreso=0.2
  (15·0.2+12=15=costo_prevenir); antes de ese punto reparar es más barato, después prevenir domina.
- **AC-12** (Sin entidad elegible, corregido en revisión ronda 1): DADO que no hay ninguna entidad
  amenazable elegible al momento del disparo, CUANDO el sistema lo detecta, ENTONCES el intento se
  descarta SIN consumir el cooldown global (Core Rule 10), y el temporizador de intervalo se PAUSA
  (no avanza) hasta que vuelva a haber al menos una entidad elegible, reanudándose exactamente donde
  quedó — distinto de un disparo resuelto (prevenido o dañado), que sí sortea un intervalo nuevo vía
  la fórmula con el N vigente en ese momento.
- **AC-13** (Entidad ya dañada excluida): DADO que la única entidad elegible ya está Reparando o
  Dañada, CUANDO se evalúa el pool de selección, ENTONCES queda excluida y se aplica AC-12 si eso
  vacía el pool.
- **AC-14** (Cosecha durante amenaza): DADO una amenaza activa sobre una entidad, CUANDO el jugador
  cosecha/remueve esa entidad durante la pre-alerta o la ventana, ENTONCES la amenaza se cancela sin
  penalización ni reembolso, y el disparo se da por resuelto (no reciclado).
- **AC-15** (Primer disparo de partida): DADO el inicio de una partida nueva, CUANDO ocurre el primer
  disparo, ENTONCES usa el N real en ese momento (normalmente 1) sin caso especial de gracia.
- **AC-16** (Carrera de red en doble toque): **EXCLUIDO explícitamente** del alcance de QA de este
  GDD, mismo tratamiento que AC-9 — no es un TBD silencioso, es scope documentado pendiente del spike
  de red.

## Open Questions

| Question | Owner | Deadline | Resolution |
|---|---|---|---|
| ¿El rango recomendado de ventana de reacción (3-8s) se sostiene una vez que derrumbe/incendio fijen sus propios números? | Diseñador de Madera/Minerales | Al autorar esos GDDs | Pendiente |
| Mecanismo de autoridad de red para disparo/resolución | Spike de red | Antes de `/create-architecture` | Pendiente, ⚠ Provisional en todo el documento |
| Riesgo de que N llegue a 15-20+ y el intervalo supere 90-100s | Diseñador de Madera/Minerales | Al fijar los topes de entidades de esos recursos | Pendiente, marcado en Formulas |
| Addendum al art bible con las 3 familias de forma + simplificación del cooldown único | `art-director` | Antes de que Madera/Minerales redacten su Visual/Audio | Pendiente |
| ¿Puede un jugador evitar sistemáticamente responder a amenazas mientras el otro siempre responde? | Sin dueño asignado | Sin fecha — hereda la Open Question de free-riding ya documentada en `game-concept.md`; Amenazas no la resuelve ni la agrava, tampoco la mitiga. Reconfirmado en `/design-review` ronda 1: se queda como nota, no se escala a bloqueante (desacuerdo `game-designer` vs. `creative-director`, resuelto a favor de no escalar) | Pendiente |
| Cooldown global único (Core Rule 2) declarado como trade-off revisable | Sin dueño asignado | Al diseñar el canal de presencia de compañero (spike de UX táctil) | Añadido en ronda 1: `game-designer` sostiene que aplana las 3 identidades de amenaza en un solo interrupt; `creative-director` sostiene que es correcto sin canal de presencia. Se mantuvo la regla, se corrigió el Player Fantasy — revisar esta decisión si el canal de presencia cambia el cálculo |
| Autoridad de red requerirá probablemente su propio ADR tras el spike | `technical-director` (implícito) | Tras el spike de red | Señal de alcance de `/design-review` ronda 1: la superficie de decisiones de red de este GDD (interfaz RPC, sesgo de latencia, default de pérdida de host) es lo bastante grande para un ADR dedicado, no solo notas inline |
