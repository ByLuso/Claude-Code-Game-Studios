# Amenazas (framework genérico)

> **Status**: Designed — hallazgos de `/design-review` rondas 1, 2, 3 y 4 (las cuatro NEEDS REVISION)
> aplicados. Ronda 3 corrigió en la MISMA sesión que la revisó (excepción explícita pedida por el
> usuario); ronda 4 se corrió en sesión nueva, independiente, precisamente para recuperar esa
> separación — y encontró huecos reales en 4 de las propias correcciones de ronda 3 (ver abajo),
> confirmando que la independencia revisor/autor detecta defectos que una sesión que se corrige a sí
> misma no puede ver. **Sin embargo, las correcciones de ronda 4 se aplicaron TAMBIÉN en la misma
> sesión que revisó** — segunda vez que ocurre esta excepción, ahora sin que el usuario la pidiera
> explícitamente por adelantado, sino como elección entre opciones presentadas tras el veredicto. El
> `creative-director` de ronda 4 recomendó explícitamente NO tratar esto como norma: si una ronda 5 en
> sesión nueva vuelve a encontrar huecos en las propias correcciones de ronda 4, el problema deja de
> ser el documento y pasa a ser el método de revisión — en ese caso, reescribir desde los invariantes
> en vez de seguir parchando. Una ronda 5 en sesión nueva sigue siendo necesaria antes de dar este
> documento por cerrado.
> **Author**: usuario + agentes
> **Last Updated**: 2026-08-11
> **Implements Pillar**: Pilar 5 (El riesgo empuja a prepararse)
> **Creative Director Review (CD-GDD-ALIGN)**: omitido en autoría — modo Lean; sí consultado como
> revisor senior en las rondas 1-4 de `/design-review` (no es lo mismo que el gate de autoría)
>
> 🚧 **NO implementation-ready** — bloqueado por 2 dependencias igualmente duras, ninguna resuelta
> (corregido en `/design-review` ronda 2 para darles paridad estructural, antes lumped juntas):
> - **Spike de red** (bloquea Core Rule 9, autoridad de host; la ventana de simultaneidad de Core Rule
>   7b — mecanismo aclarado en ronda 4, pero su esquema de wire/atribución sigue pendiente; y el
>   contrato RPC completo de Reparar, declarado explícitamente sin definir en ronda 4): sin ejecutar.
> - **Spike de UX táctil** (bloquea Core Rule 11, coordinación cross-device — canal "yo la tengo" y
>   fallback fuera de pantalla; y, desde ronda 4, también Core Rule 4 — el mecanismo de
>   `tiempo_hasta_asentar_cámara`, ver Dependencias nueva de Cámara/Viewport): sin ejecutar.
> Además, 3 sistemas Foundation (Networking, Input, Economía Compartida) siguen sin GDD propio. Ver
> Dependencies.
>
> **Corregido en ronda 3** (ver `design/gdd/reviews/amenazas-review-log.md` para el detalle completo
> de hallazgos): (1) fila de desconexión de host duplicada/contradictoria eliminada; (2) invariante de
> instanciación acotado a `valor_en_riesgo > 0` (era matemáticamente insatisfacible en 0, defecto que
> sobrevivió 2 rondas de revisión de `systems-designer`) más un segundo requisito de alcanzabilidad de
> t*; (3) nueva Core Rule 7b: ventana de simultaneidad de 150ms para que "yo la tengo" no dependa solo
> de latencia cruda; (4) piso de ventana post-paneo de cámara para amenazas fuera de pantalla; (5)
> barrido de alcance host-local aplicado a AC-2/3/4/5/7 (antes solo AC-6 lo tenía); (6) AC-1 reescrita
> como test determinista de semilla fija (la versión chi-cuadrado de ronda 2 violaba la propia regla
> del proyecto de "sin semillas aleatorias, resultados deterministas"); (7) mitigación de visibilidad
> de free-riding vía el futuro Panel de contribución, reabriendo la decisión de no escalar de ronda 1.
>
> **Corregido en ronda 4** (8 especialistas independientes + síntesis de `creative-director`; ver el
> review log para el detalle completo): (1) Player Fantasy reescrita — ya no promete un reparto de
> tareas estilo Overcooked que la mecánica no produce, describe en su lugar reflejo compartido y
> seguro mutuo; (2) Core Rule 2 redefinida para medir el cooldown desde la RESOLUCIÓN de la amenaza,
> no desde el disparo — la versión anterior era inerte (`intervalo_min`=25s siempre excedía el
> cooldown de 15s) y dejaba la garantía de "nunca 2 amenazas a la vez" sin cota real frente a una
> ventana extendida por cámara; AC-2 reescrita en consecuencia; (3) Core Rule 7b aclarada: el host
> nunca retiene el primer toque válido para esperar un segundo — resuelve al instante, un segundo
> toque tardío se acredita de forma retroactiva; (4) invariante de `coste_no_prevenir` corregido de
> `valor_en_riesgo > 0` (técnicamente no vacío pero prácticamente insatisfacible a valores bajos) a un
> piso relativo de 3× el incremento de costo más pequeño de la instancia; (5) el ejemplo de trigo ya
> no se presenta como "validado"/"plantilla" — el segundo requisito de alcanzabilidad de t*, corrido
> por primera vez contra sus propios números, no se cumple; (6) AC-1 reescrita de nuevo: verifica el
> mecanismo de selección (ensamblaje de pool + mapeo monótono) en vez de una frecuencia empírica cuya
> tolerancia ±1 a N=30 resultó tener ~80% de probabilidad de fallo en código correcto; (7) Reparando
> ahora transiciona explícitamente a Normal (no de vuelta a Creciendo/Lista), con nueva AC-21 cubriendo
> la transición y su efecto en el pool de Core Rule 1; (8) nueva regla de prioridad del botón de acción
> contextual (Amenaza activa siempre gana sobre Dañada) con nueva AC-22; (9) Dependencies ganó 2 filas
> que existían en prosa pero no en la tabla (Cámara/Viewport, Panel de estadísticas de contribución);
> (10) contrato RPC de Reparar, esquema de atribución de 7b, y reconexión a mitad de amenaza declarados
> explícitamente sin resolver (mismo tratamiento que Core Rule 9) en vez de ausentes en silencio; (11)
> mandatos de arte de ronda 3 (separación de luminancia, contraste de íconos) ganaron filas de Open
> Questions con dueño y plazo, que no tenían; (12) latencia de MVP del Panel de contribución (inactivo
> durante todo el MVP) declarada explícitamente.

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

Cuando la amenaza se dispara, el jugador debe sentir una descarga breve de reflejo compartido: ver la
alarma y responder, sabiendo que tu compañero probablemente está haciendo lo mismo al mismo tiempo, y
que eso está bien — no hace falta negociar quién actúa primero. La tensión viene de reaccionar bajo un
reloj corto (4-6s) *para una sola amenaza a la vez* — el cooldown global (Core Rule 2) mantiene
deliberadamente un solo ritmo de alerta en vez de varios simultáneos, así que la fantasía no es
"malabarear amenazas de distinto tipo a la vez" sino "reaccionar juntos, rápido, sin pisarse." Nada en
pantalla amenaza al avatar del jugador, solo el terreno construido con esfuerzo compartido. Resolver
la amenaza a tiempo (prevenir) debe sentirse como un choque de manos silencioso; llegar tarde y tener
que reparar debe sentirse como un "bueno, tocará esperar un poco" — un contratiempo con costo claro y
recuperación garantizada, nunca una pérdida permanente ni una vergüenza. El fallo es fricción
temporal, no castigo.

**Reescrito en ronda 4** (hallazgo de `game-designer`, síntesis de `creative-director`): las tres
rondas anteriores describían esta fantasía como un momento de *reparto de tareas* al estilo
*Overcooked* ("¡yo la tengo!", uno actúa y el otro hace otra cosa) — pero la mecánica real no reparte
nada: es un solo objetivo binario compartido (Core Rule 2 garantiza una sola amenaza a la vez, sin
nada distinto que hacer mientras tanto) y tocar Prevenir preventivamente no cuesta nada bajo ninguna
rama (Core Rule 7b fusiona el cobro si ambos tocan dentro de 150ms; fuera de esa ventana, el segundo
toque simplemente se descarta sin cobro doble). Eso significa que ambos jugadores tocando a la vez no
es una rareza a proteger — es el resultado esperado y correcto cuando los dos están atentos, y el
diseño ya lo trata así (un solo cobro, mismo resultado, sin perdedor). La fantasía correcta no es
"repartirse el trabajo" sino **reflejo compartido y seguro mutuo**: cada jugador puede tocar en cuanto
ve la alarma, sin esperar confirmación del otro ni temer estorbar — si los dos responden, no pasa
nada malo. Esto no es una degradación de la promesa original, es una descripción más honesta de lo
que Core Rule 2 + 7b ya producen por diseño.

> `creative-director` no consultado en la autoría original — modo Lean. Revisado y corregido en
> `/design-review` ronda 1 (2026-08-11): el texto original prometía coordinación entre amenazas
> simultáneas de distinto tipo, que el cooldown global (Core Rule 2) prohíbe estructuralmente —
> corregido para no contradecir la propia regla.
>
> **Corregido en ronda 3** (hallazgo de `game-designer`, sostenido por `creative-director`): "primer
> RPC gana" (Edge Cases, carrera de red) hacía que el jugador con peor latencia perdiera
> sistemáticamente el momento "yo la tengo" en TODAS las amenazas, sin excepción — eso es exclusión
> estructural repetida, no "fricción temporal." Se resolvió con una ventana de simultaneidad de 150ms
> (nueva Core Rule 7b) en vez de reescribir esta sección para bajar la promesa: cuando ambos jugadores
> responden dentro de esa ventana, ninguno "pierde" por latencia. Fuera de esa ventana (una diferencia
> de reacción real, no solo de red) "primer RPC gana" se mantiene sin cambios.
>
> **Nota de ronda 4 sobre el sesgo host/no-host**: fuera de la ventana de 150ms, el jugador que no es
> host sigue en desventaja estructural — sus toques cruzan la red antes de llegar a la autoridad de
> host, mientras que los del host se resuelven localmente. En LAN local esto queda casi siempre
> absorbido por los 150ms de la ventana de fusión (RTT típico de wifi local está muy por debajo de
> ese margen), pero es una asimetría real, ligada a QUIÉN hostea, no a quién reacciona más lento —
> se acepta como trade-off conocido de la arquitectura cliente/host (mismo tratamiento que el resto
> de items ⚠ Provisional sujetos al spike de red), no como una falla de esta sección.

## Detailed Rules

> `systems-designer`/especialistas no consultados en esta sección — modo Lean (solo Formulas y
> Acceptance Criteria reciben especialista en este modo). **Corregido en ronda 4**: encabezado
> renombrado de "Detailed Design" a "Detailed Rules" para coincidir con el nombre de sección exacto
> que exige `design/CLAUDE.md` — el contenido ya era completo, solo la etiqueta no coincidía.

### Core Rules

1. **Selección de disparo**: cada vez que el temporizador de intervalo cumple (fórmula genérica, ver
   Formulas), el sistema elige aleatoriamente UNA entidad amenazable elegible (parcela en
   Creciendo/Lista, o equivalente futuro en madera/mineral) de entre TODAS las entidades activas de
   cualquier tipo de recurso en la operación compartida — no por tipo de recurso separado.
2. **Cooldown global único** (**redefinido en ronda 4** — hallazgo de `systems-designer`: la versión
   de rondas 1-3 medía el cooldown desde el DISPARO, pero `intervalo_min` tiene un piso de 25s que
   siempre excede el cooldown de 15s, así que el cooldown nunca llegaba a ser la restricción activa —
   era una regla inerte, y AC-2 la verificaba de forma vacía. Peor: con la ventana efectiva de Core
   Rule 4 sin cota superior conocida todavía, dos amenazas podían solaparse en teoría si una ventana
   se extendía más allá del margen entre disparos): el temporizador de intervalo para el PRÓXIMO
   disparo no empieza a contar hasta que la amenaza ACTUAL se resuelve por completo (Prevenida,
   Dañada, o Cancelada — cualquier salida de "Amenaza activa"), no desde el momento del disparo. Una
   vez resuelta, deben pasar además `cooldown_global` (15s) antes de que el siguiente disparo pueda
   ocurrir. Por construcción, esto hace estructuralmente imposible que dos amenazas estén activas a la
   vez — **la garantía ya no depende de que ninguna ventana individual (incluida la extendida por el
   piso post-paneo de Core Rule 4) se mantenga por debajo de ningún valor concreto**: sin importar
   cuánto dure la resolución de la amenaza actual, el siguiente disparo simplemente no puede empezar
   hasta después. Esto también hace que AC-2 deje de ser vacía: ahora cooldown_global es una
   restricción real que se mide desde un punto (resolución) distinto de disparo, verificable
   independientemente del piso de `intervalo_min`. *(Cooldown global único en sí — la decisión de que
   solo un tipo de amenaza esté activo a la vez — sigue declarado como trade-off revisable; ver Open
   Questions, fila "Cooldown global único... declarado como trade-off revisable". Lo que cambia en
   ronda 4 es SOLO desde qué momento se mide, no si existe.)*
3. **Pre-alerta**: 0.5s de aviso (parpadeo azul-blanco + contorno de forma engrosado, art bible §7.5)
   antes de que el telegraph físico aparezca — un instante de anticipación que todavía no cuenta como
   ventana de reacción.
4. **Ventana de reacción**: tras la pre-alerta, la amenaza queda "activa" durante N segundos (definido
   por cada instancia de recurso; rango observado hasta ahora en Cultivos: 4-6s). "Prevenir" solo está
   disponible durante esta ventana. **Piso post-paneo para entidades fuera de pantalla (nuevo,
   `/design-review` ronda 3 — hallazgo de `ux-designer`)**: si la entidad amenazada no está en el
   viewport de un jugador al iniciar la ventana, el indicador de borde/nudge de cámara (ver UI
   Requirements) la señala, pero notar + panear la cámara consume tiempo real del reloj de N segundos
   que la versión anterior de esta regla no contemplaba. El sistema debe garantizar que, en el momento
   en que la cámara termina de asentarse sobre la entidad, queden al menos `piso_post_camara` = 3s de
   ventana visible restantes (ver Tuning Knobs); si el N base de la instancia no lo garantiza dado el
   tiempo típico de paneo, `duracion_ventana` para ESE disparo se extiende lo necesario:
   `duracion_ventana_efectiva = max(N, tiempo_hasta_asentar_cámara + piso_post_camara)`. Esta extensión
   se decide en el host (Core Rule 9) y se comunica como parte de `duracion_ventana` en el RPC de
   disparo — nunca se calcula de forma independiente en cada cliente.

   **⚠ Provisional, sujeto al spike de UX táctil (declarado explícitamente en ronda 4 — hallazgos
   convergentes de `systems-designer`, `ux-designer`, `network-programmer`, `godot-specialist`,
   `qa-lead`)**: `tiempo_hasta_asentar_cámara` no tiene todavía fórmula, fuente de datos, ni entrada en
   Tuning Knobs — y no puede tenerla hasta que el spike de UX táctil (`game-concept.md`, ya bloqueante,
   ya cubre explícitamente "paneo/zoom de cámara") resuelva dos preguntas previas que esta GDD no
   puede responder por sí sola: (1) ¿el paneo hacia la entidad amenazada es automático (la cámara se
   mueve sola, con una curva/duración conocible de antemano) o manual (el jugador arrastra, con un
   tiempo de reacción humana que por definición no se puede conocer antes de que ocurra)? Si es manual,
   `tiempo_hasta_asentar_cámara` no es calculable en el momento en que el RPC de Disparo debe enviarse
   (justo tras la pre-alerta, antes de que exista ningún paneo que medir) — el spike debe decidir un
   mecanismo que sí sea calculable en ese momento, no solo calibrar un valor. (2) Con 2 dispositivos y
   2 cámaras independientes, ¿de qué jugador se toma el tiempo cuando solo uno tiene la entidad fuera
   de pantalla? (recomendación no vinculante para el spike: tomar el máximo entre ambos jugadores,
   consistente con el resto del documento — nunca dejar a un jugador con menos margen del piso
   garantizado). Ninguna de las dos preguntas cambia si dos amenazas pueden solaparse (ver Core Rule 2,
   redefinido en ronda 4 para no depender de ninguna cota sobre `duracion_ventana_efectiva`) — quedan
   acotadas estrictamente a la UX del paneo en sí. Cámara/Viewport se declara ahora como dependencia
   formal de Amenazas (ver Dependencies) precisamente por este requisito.
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
7b. **Ventana de simultaneidad (nueva, `/design-review` ronda 3 — hallazgo de `game-designer`,
    sostenido por `creative-director`)**: si el host recibe toques válidos de "Prevenir" de AMBOS
    jugadores sobre la misma entidad dentro de una ventana de `ventana_simultaneidad` = 150ms (ver
    Tuning Knobs), los trata como una única acción coordinada — se cobra una sola vez (nunca doble
    cobro), ambos jugadores reciben el mismo resultado (prevenido), y ninguno de los dos "pierde" por
    ser el segundo RPC. Fuera de esa ventana de 150ms, se mantiene "primer RPC gana, segundo se
    descarta en silencio" (Edge Cases) sin cambios — esta regla corrige específicamente el caso de
    respuesta genuinamente simultánea, no el caso de un jugador objetivamente más lento. Depende de la
    misma autoridad de host que Core Rule 9 — ⚠ Provisional, sujeto al spike de red.

    **Mecanismo aclarado en ronda 4 (hallazgo convergente de `game-designer` y `network-programmer`:
    "los trata como una única acción coordinada" era ambiguo entre dos implementaciones, y solo una de
    ellas no rompe Core Rule 7)**: el host NUNCA retiene ni retrasa la resolución del primer toque
    válido que recibe para esperar a ver si llega un segundo — Core Rule 7 sigue aplicando sin cambios
    al primer toque, que se cobra y resuelve al instante como siempre. La ventana de 150ms se evalúa
    de forma retroactiva: solo determina si un SEGUNDO toque que llega después del primero, sobre una
    entidad ya resuelta, se acredita como parte de la acción coordinada (sin cobro adicional, mismo
    resultado "prevenido" comunicado a ese jugador) en vez de descartarse en silencio como fuera de la
    ventana. Ningún Prevenir — solo ni coordinado — incurre jamás en un retraso artificial de hasta
    150ms; eso sería una regresión directa contra Core Rule 7 y el Pilar 3 (fricción cero) para la
    interacción más repetida del juego, y no es lo que esta regla especifica.

    **Alcance del canal de atribución (aclarado en ronda 4 — hallazgo de `network-programmer`: el
    contrato RPC de dos mensajes no tiene ningún campo que distinga el caso coordinado del caso base,
    ni que cargue qué jugador(es) actuaron)**: el mensaje `Resolución` (ver Interactions with Other
    Systems, Networking) no necesita un `resultado` distinto para el caso coordinado — `prevenido` ya
    es el mismo resultado observable para ambos jugadores en ambos casos, y esta regla no depende de
    que el spike de red esté resuelto para ser válida como regla de fusión de toques (ver AC-19). Lo
    que SÍ queda fuera de este documento, declarado explícitamente y no de forma implícita, es el
    esquema concreto del canal de atribución por jugador que Interactions with Other Systems
    (Economía Compartida) exige para el futuro Panel de contribución — ese esquema (qué mensaje lo
    transporta, si va en `Resolución` o es un canal aparte) se resuelve como parte del mismo ADR de
    red que ya cubre el resto de la superficie de decisiones de este sistema (ver Open Questions).
8. **Reparar**: un toque, solo disponible en estado de daño, cuesta menos que Prevenir pero incurre
   downtime antes de volver a estar disponible — mayor downtime para Severo que para Reducido. Al
   terminar el downtime, la entidad pasa a **Normal** (ver States and Transitions) — no directamente
   de vuelta a Creciendo o Lista. **Aclarado en ronda 4** (hallazgo de `qa-lead`, contradicción cruzada
   detectada contra `farm-economy-system.md` §3.4, que describe la reparación de una parcela de
   Cultivos volviendo a "Vacía" y requiriendo replantar desde cero): "Vacía" en esa instancia ES el
   nombre concreto que le da al estado genérico **Normal** de este framework — no hay contradicción de
   contenido, pero la relación nunca estaba escrita explícitamente aquí, y la consecuencia mecánica
   tampoco: Normal NO es un estado elegible para Core Rule 1 (solo Creciendo/Lista lo son), así que
   una entidad reparada **sale del pool de amenazas elegibles** hasta que una acción propia del
   recurso (replantar, para Cultivos) la reintroduzca en Creciendo. Si esa salida vacía el pool
   compartido por completo, aplica Core Rule 10 (el temporizador de intervalo se pausa) con
   normalidad — el mismo mecanismo genérico que ya cubre cualquier otra forma de quedarse sin
   entidades elegibles, sin necesitar una regla nueva. Ver AC-21 (nueva) para la verificación de esta
   transición y su efecto en el pool.
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
| Reparando | Toque de "Reparar" desde cualquier estado Dañada | Termina el downtime (→**Normal**) | Ícono de herramienta, sin toques adicionales |

### Interactions with Other Systems

- **Economía Compartida**: Prevenir/Reparar consumen del pozo único — Amenazas no define montos (los
  define cada instancia de recurso), solo exige que ambos usen la misma cuenta sin atribución
  (Pilar 1). **Nuevo en ronda 3** (mitigación de free-riding, hallazgo de `economy-designer` —
  ver Open Questions): aunque el MONTO sigue sin atribución (Pilar 1 no se toca), Amenazas debe
  emitir, para consumo del futuro Panel de estadísticas de contribución (`systems-index.md` #16),
  qué jugador ejecutó cada toque de Prevenir/Reparar — visibilidad de participación, no penalización
  económica. No resuelve el sesgo de fondo (Reparar más barato que Prevenir por construcción, Core
  Rule 8, abarata sistemáticamente la opción de no responder) — ese sesgo se deja para la sesión de
  `/design-system economia-compartida`, ver Open Questions. **Latencia de MVP declarada (nuevo en
  ronda 4 — hallazgo de `economy-designer`)**: esta mitigación está **inactiva durante todo el período
  de MVP**, no solo "sin resolver del todo" — `systems-index.md` #16 marca el Panel de contribución
  como Vertical Slice / Not Started, y `game-concept.md` lo lista explícitamente fuera de MVP. Amenazas
  emite el dato desde ahora, pero nada lo consume ni lo muestra a los jugadores hasta que el Panel
  exista; el riesgo de free-riding documentado en `game-concept.md` queda sin mitigación activa
  durante todo el MVP, no parcialmente mitigado.
- **Terreno y Parcelas** (y equivalentes futuros): expone la lista de "entidades amenazables
  elegibles" — Amenazas no sabe qué es una parcela, solo itera sobre entidades activas.
- **Networking**: necesita autoridad de host. **Corregido en ronda 3** (hallazgo de
  `network-programmer`: el contrato de ronda 1 conflaba dos eventos distintos bajo un solo mensaje —
  `resultado` no puede conocerse en el momento del disparo, solo en la resolución). El contrato ahora
  se divide en dos mensajes:
  - **Disparo**: `{entidad_objetivo_id, tipo_amenaza, timestamp_disparo_host, duracion_ventana}` —
    enviado al seleccionar la entidad (tras la pre-alerta). `duracion_ventana` puede ser mayor que el N
    base de la instancia si aplica el piso post-paneo (Core Rule 4).
  - **Resolución**: `{entidad_objetivo_id, resultado}` (`resultado` ∈ {prevenido, dañado_severo,
    dañado_reducido, cancelado}) — enviado cuando el host determina el desenlace (toque de Prevenir,
    ventana expirada, o cosecha/remoción de la entidad).
  Los clientes calculan el fin de ventana como `timestamp_disparo_host + duracion_ventana`, contra el
  reloj del host, nunca de forma independiente — esto sigue sin cambios de ronda 1. **Sin resolver
  (declarado explícitamente, no implícito, mismo tratamiento que Core Rule 9)**: el mecanismo de
  compensación de RTT/offset de reloj entre host y cliente no está especificado en este GDD; la
  afirmación de ronda 1 de que el cliente hace "aritmética simple" describe el CÁLCULO, no garantiza
  que ambos relojes estén sincronizados — eso es responsabilidad del spike de red, igual que Core
  Rule 9 y 7b.

  **Contrato de Reparar sin definir (declarado explícitamente en ronda 4, no implícito — hallazgo de
  `network-programmer`)**: el contrato de dos mensajes de arriba (Disparo/Resolución) solo cubre el
  ciclo de vida de Prevenir. Dañada y Reparando son estados tan host-autoritativos como Amenaza activa
  (Core Rule 9 aplica igual), pero ningún mensaje RPC está definido para la solicitud de Reparar
  (cliente→host) ni para la confirmación de reparación completa (host→ambos, transición
  Reparando→Normal). Tampoco está definido si la ventana de simultaneidad de Core Rule 7b aplica al
  caso análogo de ambos jugadores tocando Reparar sobre la misma entidad a la vez, o si ese caso
  revierte sin más al "primer RPC gana" sin mitigar de rondas 1-2. Mismo tratamiento que Core Rule 9
  y 7b: ⚠ Provisional, pendiente del spike de red — se declara aquí como superficie de decisión
  faltante del mismo ADR de red (ver Open Questions), no se inventa un esquema sin revisar.

  **Reconexión durante una amenaza activa — sin resolver (nuevo en ronda 4, hallazgo de
  `network-programmer`)**: `game-concept.md` exige reconexión en <10s tras una caída transitoria como
  requisito de MVP, pero ningún Edge Case de este documento cubre qué recibe un cliente que se
  reconecta a mitad de una amenaza activa (¿el Disparo original, con cuánto tiempo de ventana
  restante? ¿una Resolución que ya ocurrió mientras estaba desconectado?). Mismo tratamiento: ⚠
  Provisional, pendiente del spike de red.
- **Cultivos** (instancia existente): ya implementa la versión de ronda 1-2 de este contrato (mensaje
  único) vía plagas — Madera/Minerales deben instanciar el contrato de DOS mensajes de ronda 3, no el
  de una instancia previa a esta corrección.
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

**Justificación del piso de 70s** (añadido en ronda 2, el 90 ya tenía justificación pero el 70 no):
el piso `intervalo_min=70` no es arbitrario — preserva el mismo spread de 20s que
`intervalo_max-intervalo_min` tiene en todo el rango sin techo. Si solo se limitara el máximo a 90
sin tocar el mínimo, el spread se comprimiría a medida que n crece, cambiando el ritmo de
variabilidad percibida justo en la zona de mayor población de entidades.

**Nota sobre elegibilidad vs. conteo** (nuance heredada de `farm-economy-system.md` §4.3, no
capturada en la generalización original): una entidad Lista pero bloqueada por almacenamiento lleno
(silo/equivalente) cuenta hacia `num_entidades_amenazables` pero NO es objetivo válido de selección
(evita doble castigo) — "cuenta como activa" y "elegible como objetivo" no son estrictamente lo
mismo. Madera/Minerales deben replicar esta distinción si tienen un mecanismo de almacenamiento
análogo.

| Variable | Symbol | Type | Range | Description |
|---|---|---|---|---|
| Entidades amenazables activas | num_entidades_amenazables | int | 0–sin tope | Total de entidades elegibles en TODOS los tipos de recurso (parcelas de cultivo en Creciendo/Lista + futuros nodos de madera/mineral), sumadas en un solo pool per Core Rule 1 |
| Intervalo mínimo/máximo | intervalo_min, intervalo_max | float | 25–70, 45–90 (corregido en ronda 3 — hallazgo de `systems-designer`: decía "sin tope", contradiciendo el techo duro descrito 2 párrafos arriba y AC-10; un desarrollador que solo mirara esta tabla habría implementado la fórmula sin techo) | Segundos hasta el próximo disparo global |

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
| Valor en riesgo | valor_en_riesgo | float | **≥ 3 × el incremento de costo más pequeño usado por la instancia (corregido en ronda 4 — antes ">0 $"; ver invariante de instanciación abajo, ">0" era técnicamente no vacío pero prácticamente insatisfacible)** | Valor máximo de producción en juego |
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
t_progreso, violando AC-11. Ejemplo que satisface el invariante ALGEBRAICO (trigo): 10+2=12 < 15 <
15+12=27 ✓. **Corregido en ronda 4 (hallazgo de `economy-designer`: este ejemplo se citaba como "ya
validado" y "plantilla para que Madera/Minerales lo copien" sin que nadie hubiera corrido el segundo
requisito — alcanzabilidad de t* — contra él)**: satisfacer el invariante algebraico NO implica que
trigo pase el segundo requisito. `economy-designer` corrió el chequeo con los números que ya existen
(intervalo de disparo a n=1: [28,48]s; ciclo de crecimiento de trigo: 6s, `farm-economy-system.md`) y
encontró que t*=0.2 (1.2s de un ciclo de 6s) es alcanzable solo en una fracción minoritaria del tiempo
incluso bajo el supuesto más generoso (replantado instantáneo, ciclo continuo) — corroborado
independientemente por el Apéndice D.2 ya aprobado de `farm-economy-system.md`, que concluye que
Prevenir "gana claramente" en Lista y cerca de completar. Este ejemplo ya NO se presenta como
"validado" ni como plantilla a copiar — es una ilustración del álgebra del invariante únicamente. Si
Madera/Minerales lo usan como referencia, deben correr su propio segundo requisito (ver arriba y Open
Questions) contra sus propios números, no asumir que trigo ya lo demostró.

**Precondición añadida en ronda 3, corregida en ronda 4 (defecto de frontera — hallazgo original de
`systems-designer`, sobrevivió 2 rondas previas de revisión del mismo especialista; la corrección de
ronda 3 sobrevivió solo una ronda antes de que `economy-designer` encontrara que tampoco cerraba el
caso)**: el invariante de arriba se vuelve matemáticamente insatisfacible cuando `valor_en_riesgo = 0`
— el límite inferior y el superior colapsan al mismo valor (`X < costo_prevenir < X`, conjunto vacío),
y AC-11 queda permanentemente insatisfecha para esa instancia. Ronda 3 corrigió esto a
`valor_en_riesgo > 0`, pero el ancho del intervalo satisfacible es exactamente `valor_en_riesgo` — a
`valor_en_riesgo = $0.01` el intervalo es `(X, X+0.01)`, un centavo de ancho y ABIERTO (excluye ambos
extremos), es decir, matemáticamente no vacío pero sin ningún valor de centavo real dentro (todo costo
en este documento y en `farm-economy-system.md` usa incrementos de dólar entero). El defecto no se
cerró, se reubicó de "vacío en 0" a "vacío en la práctica cerca de 0". Corrección de ronda 4:
`valor_en_riesgo` debe ser al menos 3 veces el incremento de costo más pequeño que use esa instancia
(p. ej. para Trigo, con costos en dólares enteros, `valor_en_riesgo ≥ $3`) — un piso relativo, no un
valor fijo global, consistente con que este es un framework genérico y no una instancia concreta.
Ninguna instancia de recurso puede definir una entidad amenazable con valor de producción por debajo
de ese piso (si una entidad no tiene suficiente en juego para que exista una elección real, no debería
estar en el pool de objetivos elegibles de Core Rule 1 en absoluto).

**Segundo requisito de instanciación, no solo el algebraico (nuevo, ronda 3 — hallazgo de
`economy-designer`)**: satisfacer el invariante de arriba solo garantiza que existe un punto de
equilibrio t* en (0,1) — no garantiza que t* caiga dentro del rango de t_progreso en el que las
amenazas realmente se disparan dado el ritmo de `amenaza_interval` frente al ciclo de crecimiento de
esa instancia. Si t* cae, por ejemplo, en 0.05 pero los disparos reales ocurren casi siempre con
t_progreso entre 0.7 y 1.0 (plausible cuando n crece y el intervalo se alarga), Prevenir domina de
facto en la práctica aunque el invariante algebraico se cumpla en papel — un invariante que aprueba
diseños degenerados es peor que no tener invariante, porque genera falsa confianza. Toda instancia
DEBE, además del invariante algebraico, verificar dónde cae t* respecto al rango real de t_progreso al
momento del disparo para su propio ritmo de crecimiento — este segundo requisito no se puede calcular
aquí porque Madera/Minerales todavía no existen; queda formalizado como obligación de instanciación
(ver Open Questions), no como una nota informal descartable.

**No es una verificación de una sola vez (aclarado en ronda 4 — hallazgo de `systems-designer`)**: la
cantidad que este chequeo evalúa (qué tan tarde en su propio ciclo de crecimiento cae un disparo)
depende de `amenaza_interval`, que a su vez depende de `num_entidades_amenazables` — el total
COMPARTIDO entre los tres tipos de recurso (Core Rule 1), no una propiedad fija de la instancia que se
está verificando. Una instancia puede pasar este chequeo al momento de instanciarse (con pocas
entidades activas en el mundo) y dejar de cumplirlo más tarde en la misma sesión, cuando Cultivos y/o
Minerales hagan crecer el pool compartido y `amenaza_interval` se alargue hacia su techo — empujando
los disparos reales hacia t_progreso más alto para TODAS las instancias a la vez, no solo la que
creció el pool. La obligación de instanciación (ver Open Questions) debe re-verificarse cuando el
rango práctico de `num_entidades_amenazables` cambie de forma significativa (p. ej. al diseñar un
nuevo recurso que amplíe el pool compartido), no solo una vez al momento de crear cada instancia.

## Edge Cases

> Sin especialista consultado en esta sección — modo Lean.

| Escenario | Comportamiento esperado | Justificación |
|---|---|---|
| No hay ninguna entidad amenazable elegible al momento del disparo (p. ej. antes de plantar nada) | El intento se descarta sin consumir el cooldown global (Core Rule 10); el temporizador de intervalo se pausa y se reanuda donde quedó al volver a haber una entidad elegible — nunca se resortea ni se pierde progreso | Coincide con `farm-economy-system.md` §4.3 ("se pausa por completo"); corregido en `/design-review` ronda 1 — antes decía "se reinicia con el mismo intervalo", inconsistente con esa fuente |
| La única entidad elegible ya está en Reparando o Dañada | No es elegible — el pool de selección excluye cualquier entidad fuera de estado "activo normal" | Si eso vacía el pool, aplica el caso anterior |
| Los dos jugadores tocan "Prevenir" en la misma entidad en la misma ventana (carrera de red) | **Corregido en ronda 3** (antes contradecía el Player Fantasy — ver esa sección): si ambos toques llegan al host dentro de 150ms uno del otro, Core Rule 7b los trata como una única acción coordinada — un solo cobro, mismo resultado para los dos, sin ganador de latencia. Fuera de esa ventana de 150ms, el host procesa el primer RPC válido y descarta el segundo en silencio, sin cobro doble ni error visible — **el silencio del RPC descartado es diseño deliberado (ronda 2), no un vacío de la interfaz sin especificar**. Ver AC-19 para el caso ≤150ms (verificable hoy) y AC-16 para el caso >150ms (excluido, pendiente del spike de red). ⚠ Sesgo declarado (ronda 1), ahora acotado a diferencias >150ms: "primer RPC gana" no es neutral entre respuestas que no son simultáneas — el jugador con peor RTT sigue en desventaja fuera de la ventana de 150ms; se acepta como trade-off conocido para ese caso, revisar en playtesting | Pilar 3 (fricción cero) — un error visible castigaría al jugador más lento sin motivo; la ventana de 150ms evita que la fricción normal de red decida el "yo la tengo" cuando ambos respondieron genuinamente a la vez |
| Un jugador (el host) se desconecta mientras hay una amenaza activa (nuevo, ronda 1; precisado en ronda 2; **fila duplicada/contradictoria de ronda 1-2 eliminada en ronda 3** — hallazgo independiente de `game-designer`, `network-programmer` y `qa-lead`: existía una segunda fila genérica "un jugador se desconecta..." que decía lo opuesto, "sin resolver hasta que el spike de red defina migración de host"; round 2 solo editó esta fila y nunca reconció ni borró la otra) | Default provisional: la amenaza se resuelve como Prevenida automáticamente, **sin daño y sin cobro al pozo compartido** — no hereda el costo de una Prevención normal, ya que el jugador no eligió activamente prevenir. Este default cubre TANTO la desconexión del host como la de cualquier no-host durante una amenaza activa — no hay un comportamiento separado sin resolver para el caso no-host (ver AC-18) | Espeja el principio anti-softlock del Pilar 5 — un problema de conectividad no debe traducirse en castigo NI en gasto no elegido. Escalado a bloqueante en ronda 2: el backgrounding móvil ocurre en la misma escala de segundos que la ventana de 4-6s, es el camino esperado, no el raro. Sigue ⚠ Provisional/sujeto a lo que decida el spike de red (el DEFAULT está decidido; el MECANISMO de migración de host no). **Matiz de ronda 4** (hallazgo de `network-programmer`): el default está decidido de forma simétrica para host y no-host, pero su APLICABILIDAD no lo es — si es el NO-host quien se desconecta, el host sigue vivo y puede aplicar/difundir el default sin ambigüedad; si es el HOST quien se desconecta, no queda ninguna entidad con la autoridad que Core Rule 9 asume para aplicar y difundir ese mismo default, a menos que exista una migración de host — que es precisamente el mecanismo que sigue sin definir. El caso host-desconectado no es "default decidido, mecanismo de detección pendiente" de forma limpia como el caso no-host; está entrelazado con la migración de host, no solo con la latencia de detección. Se mantiene ⚠ Provisional, mismo dueño (spike de red), pero con esta distinción declarada explícitamente en vez de dejarla implícita en el caveat genérico |
| La entidad objetivo es cosechada/removida por el jugador durante la pre-alerta o la ventana activa | La amenaza se cancela para esa entidad, sin penalización ni reembolso; el disparo se da por resuelto | No debe existir una "amenaza huérfana" apuntando a algo que ya no existe |
| Se coloca o destruye una estructura protectora durante la ventana de reacción activa | La severidad (Severo/Reducido) se evalúa en el momento de la RESOLUCIÓN, no del disparo | Premia la construcción reactiva bajo presión, no solo la preparación anticipada |
| Todas las entidades elegibles cuentan hacia `num_entidades_amenazables` pero ninguna es objetivo válido (p. ej. todas Listas pero bloqueadas por almacenamiento lleno — ver Formulas, "Nota sobre elegibilidad vs. conteo") (aclarado en ronda 3 — hallazgo de `systems-designer`) | Mismo tratamiento que "no hay ninguna entidad amenazable elegible": el intento se descarta sin consumir el cooldown global, el temporizador se pausa (Core Rule 10) — "cuenta como activa" no implica "hay un objetivo elegible" | Cierra el hueco entre `num_entidades_amenazables > 0` y pool-de-objetivos vacío que la Nota de Formulas describe pero que antes solo tenía AC de cobertura para el caso Reparando/Dañada (AC-13), no para el caso de bloqueo por almacenamiento |
| Primer disparo de la partida | Se sortea igual que cualquier otro, usando `num_entidades_amenazables` real al momento de empezar (normalmente 1) | Sin caso especial de "gracia" — el n bajo ya produce un intervalo naturalmente generoso |

## Dependencies

| System | Direction | Nature of Dependency |
|---|---|---|
| Economía Compartida | Amenazas depende de | Necesita el pozo único para cobrar Prevenir/Reparar — dura |
| Terreno y Parcelas (y equivalentes futuros) | Amenazas depende de | Necesita la lista de entidades amenazables elegibles — dura |
| Networking | Amenazas depende de | Necesita autoridad de host para disparo/resolución — dura, ⚠ Provisional (spike de red pendiente) |
| Cámara / Viewport (nuevo en ronda 4 — hallazgo convergente de `ux-designer`, `systems-designer`, `network-programmer`, `godot-specialist`) | Amenazas depende de | Core Rule 4 (piso post-paneo) necesita conocer el estado de cámara de cada jugador para calcular `tiempo_hasta_asentar_cámara` — dura, ⚠ Provisional (sujeto al spike de UX táctil, sistema aún no diseñado) |
| Cultivos | Cultivos depende de Amenazas | Ya instancia el framework para plagas — dura |
| Madera | Madera depende de Amenazas | Instanciará el framework para derrumbes — dura, sistema aún no diseñado |
| Minerales | Minerales depende de Amenazas | Instanciará el framework para incendios — dura, sistema aún no diseñado |
| UI/HUD | UI/HUD depende de Amenazas | Consume estado activo/dañado para el telegraph — blanda |
| Panel de estadísticas de contribución (nuevo en ronda 4 — hallazgo de `qa-lead`/`economy-designer`: edge introducida por Interactions with Other Systems en ronda 3, nunca propagada a esta tabla) | Panel depende de Amenazas | Necesita qué jugador ejecutó cada toque de Prevenir/Reparar (ver Interactions with Other Systems, Economía Compartida) — blanda, sistema aún no diseñado; mitigación inactiva durante todo el MVP (ver esa misma sección) |

**Requisito de testabilidad (nuevo, `/design-review` ronda 2 — hallazgo de `qa-lead`)**: el generador
de números aleatorios usado para la selección de entidad (Core Rule 1) debe ser inyectable (no un
singleton global) — permite a los tests fijar una semilla determinista, requisito de AC-1 y coherente
con la regla del proyecto de "sin semillas aleatorias en tests, resultados deterministas".

## Tuning Knobs

| Parameter | Current Value | Safe Range | Effect of Increase | Effect of Decrease |
|---|---|---|---|---|
| cooldown_global | 15s | 10-20s (heredado) | Menos amenazas simultáneas percibidas, más calma entre picos — puede sentirse vacío si sube mucho | Amenazas más frecuentes entre tipos distintos, riesgo de fatiga de alerta |
| pre_alert_duration | 0.5s | 0.3-1.0s | Más anticipación, pero acorta la ventana de reacción percibida si se confunde con ella | Menos aviso, arriesga que el jugador no note el cambio de fase |
| reaction_window (por instancia de recurso) | 4-6s observado en Cultivos | 3-8s recomendado para el framework | Más manejable, reduce la tensión objetivo del Pilar 5 | Bajo 3s arriesga sentirse injusto en táctil móvil |
| ratio downtime_severo : downtime_reducido | 4.0s : 2.0s (Cultivos) = 2:1 | Mantener severo > reducido siempre; ratio 1.5:1 a 3:1 recomendado | Castiga desproporcionadamente no tener protección | Cerca de 1:1 anula el incentivo de construir estructuras protectoras |
| ventana_simultaneidad (nuevo, ronda 3 — Core Rule 7b) | 150ms | 100-250ms | Más toques "casi simultáneos" se tratan como coordinados — reduce el sesgo de latencia, pero acerca la ventana a la percepción humana de reacción y podría fusionar toques que en realidad no fueron una decisión conjunta | Menos casos cubiertos — más cerca del "primer RPC gana" puro de rondas 1-2, sesgo de latencia más frecuente |
| piso_post_camara (nuevo, ronda 3 — Core Rule 4) | 3s | 2-4s | Más margen garantizado tras el paneo de cámara, pero puede alargar `duracion_ventana_efectiva` más allá del N base de la instancia con más frecuencia | Menos margen — riesgo de que el caso fuera-de-pantalla se sienta tan injusto como el <3s que este mismo Tuning Knobs ya marca como riesgoso para el caso visible |
| separación mínima de luminancia entre familias de forma (nuevo, ronda 3 — hallazgo de `art-director`/`creative-director`) | Sin definir todavía — mandato cualitativo: debe existir una separación de valor/luminancia perceptible entre Plaga/Derrumbe/Incendio, no solo silueta+movimiento | A calibrar en producción de arte | Mejor legibilidad bajo presión y para jugadores daltónicos, sin necesitar romper la paleta "mate oscuro desaturado" compartida | Si se deja en 0 (las 3 al mismo valor exacto), reabre el hallazgo de `art-director` de ronda 3: distinción solo por silueta en una interacción frecuente y cronometrada |

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
confirmar contra ESTA TABLA (no contra el addendum del art bible, todavía pendiente — ver punto 4)
antes de finalizar. Las 3 obedecen las reglas ya fijadas en el art bible sin cambios: rim-light
localizado, pre-alerta azul-blanco, cero rojo (reservado a Fresa), nunca efectos de pantalla completa.

⚠ **Callout de legibilidad/daltonismo** (nuevo, `/design-review` ronda 1; **elevado de "validar en
playtest" a mandato en ronda 3** — hallazgo de `art-director`/`creative-director`: a escala móvil, con
pre-alerta de solo 0.5s, la diferenciación por silueta+movimiento entre 3 formas del mismo valor de
color es un problema de legibilidad Gestalt básica para CUALQUIER jugador bajo presión de tiempo, no
solo un caso límite de accesibilidad daltónica — dejarlo pendiente de playtest posterior a la
producción de arte es tarde): las 3 familias comparten el mismo color "mate oscuro desaturado" — la
distinción recae solo en forma+movimiento, no en color. Se exige ahora una separación mínima de
valor/luminancia perceptible entre las 3 familias (ver Tuning Knobs, "separación mínima de luminancia
entre familias de forma") ANTES de que se congele la producción de arte, no como ajuste opcional
post-hoc si el playtest lo revela insuficiente. El valor exacto de esa separación se calibra en
producción de arte; lo que ronda 3 fija es que la separación es obligatoria, no condicional.

**2. Gramática compartida Severo/Reducido** (re-skinneable por instancia de recurso):
- **Severo**: desaturación total a gris-marrón apagado + ícono fijo de "anillo roto" (marcador
  genérico de "inutilizable", reemplaza el marchitado literal de Cultivos).
- **Reducido**: desaturación parcial (60%, conserva algo de color cálido) + ícono fijo de "media
  pantalla/muesca" señalando "protegido pero reducido." El ícono es fijo en todo el sistema; solo el
  arte de la entidad debajo cambia por recurso.

**Requisito de contraste añadido en ronda 3** (hallazgo de `art-director`: los íconos fijos se
superponen sobre 3 estilos de arte de entidad muy distintos — cultivo, madera, mineral — sin ninguna
garantía de legibilidad): ambos íconos (anillo roto, muesca) DEBEN llevar un tratamiento de contraste
garantizado (p. ej. placa de fondo, contorno/stroke de contraste, o sombra proyectada) independiente
del arte de la entidad debajo — no basta con el ícono solo, que puede perderse contra texturas claras
o visualmente ocupadas. El tratamiento exacto se define en producción de arte; el requisito de que
exista alguno es obligatorio desde ahora.

**3. Audio** (nuevo — sin pase previo de `audio-director` en el proyecto; **reformulado en ronda 3**
como placeholder explícito, no como spec decidida — hallazgo de `art-director`: la frase "timbre
específico por tipo" se leía como ya resuelta sin que ningún especialista de audio la hubiera
definido):
- Pre-alerta: campanada suave de 2 notas ascendentes, registro medio, no urgente.
- Amenaza activa: zumbido/textura ambiental grave, en loop, sin sting. **TBD por `audio-director`**:
  registro/familia de instrumento/tratamiento espacial específico por tipo de amenaza — la
  diferenciación tonal entre Plaga/Derrumbe/Incendio está prevista pero no especificada todavía.
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
simultáneas/superpuestas, ni en visual ni en audio. **Alcance acotado en ronda 4** (hallazgo de
`godot-specialist`): esta simplificación cubre únicamente el telegraph de Amenaza activa (pre-alerta +
ventana) — NO cubre los overlays de Dañada/Reparando (ícono "anillo roto"/"muesca"), que no están
acotados por el cooldown y pueden acumularse en varias entidades a la vez si el jugador se atrasa en
reparar. Ese caso queda fuera de esta simplificación y su presupuesto de draw calls debe validarse
junto con el resto de la escena de prueba combinada del spike de rendimiento (ver
`design/gdd/game-concept.md`, Next Steps). 📌 Pendiente: añadir un addendum corto a
`design/art/art-bible.md` con las 3 familias de forma de este punto y esta simplificación, una vez el
GDD completo esté aprobado.

**5. Mandato de reutilización de VFX pooled (nuevo en ronda 4 — hallazgo de `godot-specialist`)**: dado
que Core Rule 2 garantiza que nunca hay más de un telegraph de amenaza activo a la vez, las 3 familias
de forma (Plaga/Derrumbe/Incendio) deben compartir un único rig de VFX pooled (mismo patrón
`GPUParticles2D`/`MultiMeshInstance2D` reutilizado ya establecido para el enjambre de Plaga en
`farm-economy-system.md` §3.1), intercambiando forma/material según `tipo_amenaza`, en vez de que cada
recurso futuro (Madera, Minerales) reinvente su propio sistema de partículas. Se fija aquí para que
Madera/Minerales lo hereden directamente, sin tener que redescubrirlo.

**6. Nota de contraste Reducido/Fresa (nuevo en ronda 4 — hallazgo de `art-director`, nice-to-have no
bloqueante)**: la desaturación parcial de Reducido ("conserva algo de color cálido") aplicada sobre
Fresa — el único cultivo con rojo permitido (art bible §7.6 reserva el rojo exclusivamente a Fresa
para evitar la asociación "rojo = alarma" en el resto del sistema) — es el único caso del juego donde
"todavía tiene rojo visible" y "está en un estado de daño" coinciden. No es una violación de regla,
pero queda como nota para el addendum del art bible: confirmar en producción de arte o playtest que
una Fresa en Reducido no se lee accidentalmente como una alarma más urgente de lo que es.

## UI Requirements

| Information | Display Location | Update Frequency | Condition |
|---|---|---|---|
| Texto de refuerzo de amenaza activa (qué entidad/lado) | HUD, cerca de la entidad afectada | Al dispararse, se limpia al resolverse | Solo mientras hay una amenaza activa (nunca más de una a la vez, per cooldown global) |
| Ícono "anillo roto" (Severo) / "muesca protegida" (Reducido) | Overlay diegético sobre la entidad, no HUD de esquina | Aparece al pasar a Dañado, desaparece al completar Reparando | Solo sobre la entidad afectada específica |
| Botón de acción contextual (Prevenir/Reparar) | Anclado al mundo/pulgar, no HUD fijo (art bible §7.1) | Cambia de verbo según el estado de la entidad bajo el jugador | Solo cuando el jugador está sobre/cerca de una entidad en Amenaza activa o Dañada. **Regla de prioridad (nueva en ronda 4 — hallazgo de `ux-designer`, decisión del usuario)**: si una entidad en Amenaza activa Y una entidad Dañada distinta están ambas en rango al mismo tiempo, el botón siempre muestra "Prevenir" para la entidad en Amenaza activa — es la que expira en un reloj de 4-8s; Dañada no tiene expiración y puede esperar. Esta regla resuelve cualquier ambigüedad de "cuál entidad" sin necesitar un radio de prioridad configurable |
| Placeholder "presencia del compañero" | Glyph pequeño persistente, ya reservado en art bible §7.9 | — | Reservado para cuando el spike de UX táctil decida el mecanismo — Amenazas hereda el hueco, no lo diseña |
| Indicador de borde / nudge de cámara hacia la entidad amenazada (nuevo, `/design-review` ronda 1; piso de tiempo añadido en ronda 3) | Borde de pantalla, apunta hacia la entidad | Aparece si la entidad amenazada está fuera del viewport del jugador | Solo mientras hay amenaza activa y la entidad no es visible — sin esto, "texto cerca de la entidad" degenera a cero señal (hallazgo de `ux-designer`). Depende del mismo spike de UX táctil que Core Rule 11. **Corregido en ronda 3**: el tiempo de notar+panear ya no se descuenta silenciosamente de la ventana de reacción — ver Core Rule 4 (piso post-paneo de 3s) y `piso_post_camara` en Tuning Knobs |
| Botón de acción contextual — área táctil mínima (nuevo, `/design-review` ronda 2; espacio de coordenadas aclarado en ronda 3) | Overlay invisible sobre el botón visual | Constante, no cambia con el estado | 44×44pt / 48×48dp mínimo (convención iOS HIG / Material Design), independiente del tamaño visual del ícono — el loop entero depende de un toque preciso en 4-6s; sin este piso declarado, el spike de UX táctil no tiene de dónde partir. **Aclarado en ronda 3** (hallazgo de `ux-designer`: el botón está anclado al mundo/pulgar — sin esto, el overlay podría encogerse por debajo de 44pt al alejar la cámara): el overlay se define en ESPACIO DE PANTALLA, no en espacio de mundo — su tamaño en píxeles de pantalla se mantiene fijo en 44×44pt/48×48dp sin importar el zoom de cámara o el tamaño visual de la entidad debajo. El rango de zoom de cámara permitido en sí (mín/máx) queda pendiente de Tuning Knobs cuando exista una spec de cámara — hasta entonces, esta regla de espacio-de-pantalla es la garantía, no un rango de zoom específico. Sujeto a confirmación en el futuro `/ux-design` |

**Notas para el futuro `/ux-design` (añadidas en ronda 4 — hallazgo de `ux-designer`, no bloqueantes
para este GDD pero deben resolverse antes de que la UI se considere lista)**: (1) sin cooldown que lo
impida, pueden existir varias entidades Dañada simultáneamente en pantalla (Core Rule 2 solo acota
Amenaza activa a una a la vez) — el `/ux-design` debe definir una separación mínima entre entidades o
un mecanismo anti-solape para sus overlays táctiles de 44×44pt; (2) el botón anclado a mundo/pulgar
debe reconciliarse con las zonas de exclusión de gestos del sistema operativo (home indicator de iOS,
gesto de retroceso de Android) para entidades cercanas al borde de pantalla.

📌 **UX Flag — Amenazas**: este sistema tiene requisitos de UI reales. En Fase 4 (Pre-Producción),
correr `/ux-design` para el HUD/telegraph de amenaza antes de escribir épicas. Las historias que
referencien esta UI deben citar `design/ux/[pantalla].md`, no este GDD directamente.

## Acceptance Criteria

> `qa-lead` consultado — modo Lean (Acceptance Criteria es la otra sección que sí recibe especialista
> en este modo).

- **AC-1** (Selección agrupada — **reescrita en ronda 4**, reescrita en ronda 3 y corregida en rondas 1
  y 2 antes: hallazgo de `qa-lead` en ronda 4, cálculo multinomial exacto — con N=30 y probabilidades
  {0.5, 0.333, 0.167}, un selector CORRECTO y justo pasa la tolerancia ±1 en las 3 categorías
  simultáneamente solo ~19.7% de las veces con una semilla arbitraria; exigir que 5 semillas
  arbitrarias pasen todas tiene probabilidad ≈0.03% — es decir, "deterministic" [reproducible] no es
  lo mismo que "calibrado" [con un umbral de paso/fallo estadísticamente sólido], y la única forma en
  que "5 semillas catalogadas" tenga sentido es que alguien las haya curado a mano contra una
  implementación de referencia, un requisito que ninguna versión anterior de este AC declaraba):
  en vez de verificar la FRECUENCIA empírica de una corrida con semilla fija (frágil ante cualquier
  refactor que cambie el orden de consumo del RNG, incluso en código correcto), se verifica el
  MECANISMO de selección directamente. DADO un fixture fijo de 3 sub-pools de tamaños {6,4,2}
  (total=12) y un RNG inyectado (ver Dependencies) configurado para devolver una secuencia de valores
  cubriendo todo su rango de salida (p. ej. 0.0, 0.1, ..., 0.9 más los bordes exactos de cada sub-pool
  acumulado: justo antes/después de 6/12 y de 10/12), ENTONCES (a) el pool combinado se ensambla
  correctamente como los 3 sub-pools concatenados sin pérdida ni duplicación de entidades (verificar
  tamaño total = 12 y pertenencia de cada entidad a su sub-pool de origen), y (b) el mapeo de
  valor-de-RNG → entidad-seleccionada es monótono y cubre cada sub-pool en proporción exacta a su
  tamaño (un valor de RNG en `[0, 6/12)` siempre selecciona del sub-pool de 6; en `[6/12, 10/12)`
  siempre del de 4; en `[10/12, 1)` siempre del de 2) — verificación determinista Y diagnóstica: prueba
  el código de selección directamente en vez de inferir su corrección de una distribución de frecuencia
  ruidosa a N=30.
- **AC-2** (Cooldown global — **reescrita en ronda 4**, alcance aclarado en ronda 3: hallazgo de
  `systems-designer` — medir el cooldown desde el disparo lo volvía inerte, porque `intervalo_min`
  [25s] siempre excede 15s, así que la versión anterior de este AC era verificable de forma vacía por
  cualquier implementación, con o sin lógica de cooldown real; ver Core Rule 2, redefinida en ronda 4):
  DADO que una amenaza activa se acaba de RESOLVER (Prevenida, Dañada, o Cancelada), CUANDO no han
  pasado 15s desde ese momento de resolución, ENTONCES ningún nuevo disparo (de cualquier tipo)
  ocurre, aunque otra entidad se vuelva elegible de forma independiente y aunque ya hayan pasado más
  de 15s desde el DISPARO original. **Verificado localmente sobre el estado del host** — mismo alcance
  que AC-6/AC-9; la replicación de este estado hacia el cliente no es parte de este AC.
- **AC-3** (Pre-alerta — alcance aclarado en ronda 3): DADO que se dispara una amenaza, CUANDO se
  reproduce la pre-alerta de 0.5s, ENTONCES "Prevenir" no está disponible y el conteo de la ventana de
  reacción todavía no empezó. **Verificado localmente sobre el estado del host**, mismo alcance que
  AC-6/AC-9.
- **AC-4** (Ventana de reacción — alcance aclarado y piso post-paneo añadido en ronda 3): DADO que
  termina la pre-alerta, CUANDO la ventana específica de la instancia está activa (p. ej. 4-6s en
  cultivos, o `duracion_ventana_efectiva` si la entidad inició fuera de viewport — Core Rule 4),
  ENTONCES "Prevenir" solo es tocable dentro de ese lapso; tocar después de expirar no tiene efecto.
  CUANDO la entidad amenazada no está en el viewport al iniciar la ventana, ENTONCES la duración
  efectiva garantiza `piso_post_camara` = 3s restantes desde el momento en que la cámara termina de
  asentarse sobre la entidad — no se asume que toda la ventana base está disponible para el toque en
  ese caso (antes un hallazgo de `ux-designer`: la versión anterior de este AC no distinguía el caso
  fuera-de-pantalla del caso visible). **Verificado localmente sobre el estado del host**, mismo
  alcance que AC-6/AC-9. **Nota de testabilidad (nueva en ronda 4 — hallazgo de `qa-lead`)**: este AC
  requiere que `tiempo_hasta_asentar_cámara` sea inyectable/simulable para poder probarse sin una
  integración de cámara en vivo, igual que Dependencies exige RNG inyectable para AC-1 — pendiente de
  que el spike de UX táctil defina el mecanismo real (ver Core Rule 4), momento en el que este
  requisito de inyectabilidad debe añadirse formalmente al párrafo de "Requisito de testabilidad" en
  Dependencies.
- **AC-5** (Señal doble, con cobertura por evento — corregido rondas 1 y 2, alcance aclarado en ronda
  3): DADO cualquier amenaza activa, CUANDO se suscribe a la señal `visibility_changed` (o
  equivalente) de ambos canales —sprite de mundo y texto HUD— durante toda la duración de la
  pre-alerta + ventana, ENTONCES ningún intervalo entre eventos deja ambos canales simultáneamente
  ausentes. *(Ronda 2: reemplaza el muestreo de 3 momentos aleatorios — mismo costo, cierra el hueco
  entre muestras que el muestreo discreto no podía garantizar.)* **Mecanismo de verificación (añadido
  en ronda 3, hallazgo de `qa-lead`)**: fusionar los timestamps de eventos de ambos canales en una
  única línea de tiempo ordenada; afirmar que al menos un canal está en `true` entre cada par
  consecutivo de eventos. **Verificado localmente sobre el estado del host**, mismo alcance que
  AC-6/AC-9.
- **AC-6** (Severidad en resolución, con frontera de tiempo, señal observable y alcance local —
  corregido rondas 1 y 2): DADO que no hay protección al momento del disparo, CUANDO se coloca
  protección en el segundo T (0<T<duración_ventana), ENTONCES (a) el telegraph cambia observablemente
  de tono/intensidad dentro de los 200ms siguientes a T (Core Rule 6 enmendada), y (b) si no se
  previene después de T, el daño resuelve como Reducido, no Severo. (a) y (b) se **verifican
  localmente sobre el estado de protección en el host** — la sincronización cross-device de este
  cambio queda diferida al spike de red, mismo tratamiento que AC-9; no se afirma sincronía entre
  dispositivos hoy. El cambio debe ser detectable ANTES de que expire la ventana, no solo confirmable
  en el estado final. **Tipos de evidencia distinguidos (aclarado en ronda 4 — hallazgo de
  `qa-lead`)**: (b) es Lógica pura (cambio de estado de severidad según T) y se cubre con test
  automatizado, evidencia BLOCKING per `.claude/docs/coding-standards.md`. (a) — que el telegraph
  "cambie observablemente de tono/intensidad" — es una afirmación Visual/Feel; un test automatizado
  puede verificar que se EMITE la señal de cambio (evento/flag), pero que el resultado se LEA como un
  cambio de tono/intensidad perceptible es evidencia de captura de pantalla + sign-off de
  `art-director`, tipo ADVISORY, no un sustituto de (b) ni viceversa.
- **AC-7** (Prevenir — alcance aclarado en ronda 3): DADO una ventana activa, CUANDO el jugador toca
  Prevenir, ENTONCES se descuenta dinero, el estado de daño nunca se aplica, y el efecto es
  instantáneo. **Verificado localmente sobre el estado del host**, mismo alcance que AC-6/AC-9 — la
  latencia de replicación hacia el segundo cliente no es parte de este AC (ver AC-19 para el caso de
  doble toque simultáneo).
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
  ilustración; **precondición y segundo requisito añadidos en ronda 3, precondición corregida y
  ejemplo re-etiquetado en ronda 4**): DADO cualquier instancia de recurso con `valor_en_riesgo ≥ 3 ×
  el incremento de costo más pequeño que use esa instancia` (precondición corregida en ronda 4 — la
  versión de ronda 3, `valor_en_riesgo > 0`, era técnicamente no vacía pero prácticamente
  insatisfacible a valores bajos; ver Formulas) que satisfaga el invariante de instanciación
  (`costo_reparar + costo_reinicio < costo_prevenir < valor_en_riesgo + costo_reparar +
  costo_reinicio`), CUANDO se calcula coste_no_prevenir en t_progreso=0 y en t_progreso=1, ENTONCES
  coste_no_prevenir(0) < costo_prevenir < coste_no_prevenir(1) — existe un punto de equilibrio t* en
  (0,1) donde la decisión óptima algebraica cambia. *Ilustración con trigo*: equilibrio en
  t_progreso=0.2 (15·0.2+12=15=costo_prevenir); antes de ese punto reparar es más barato, después
  prevenir domina. **Esta ilustración satisface el invariante ALGEBRAICO únicamente — corregido en
  ronda 4 (hallazgo de `economy-designer`)**: NO se presenta como "validada" ni como plantilla a
  copiar (así se etiquetaba en rondas 1-3); al correr el segundo requisito de abajo contra los números
  reales de trigo, t*=0.2 resultó ser alcanzable solo en una fracción minoritaria de los disparos
  reales — ver Formulas para el detalle. **No suficiente por sí solo (ronda 3, hallazgo de
  `economy-designer`; verificado y encontrado insuficiente para el propio ejemplo de trigo en ronda
  4)**: pasar este AC no garantiza que t* sea alcanzable en la práctica — cada instancia debe además
  verificar que t* cae dentro del rango real de t_progreso al que sus disparos ocurren dado su propio
  ritmo de crecimiento vs. `amenaza_interval` (ver Formulas y Open Questions), y re-verificarlo si el
  rango práctico de `amenaza_interval` cambia (ver Formulas, nota de no-staleness); ese segundo
  chequeo no es formalizable como AC único aquí porque depende del ritmo de crecimiento de cada
  instancia y del tamaño del pool compartido en cada momento de la sesión, no solo de constantes
  fijas.
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
- **AC-17** (Coordinación cross-device, nuevo en ronda 2 — paridad con AC-9/AC-16): **EXCLUIDO
  explícitamente** del alcance de QA de este GDD — el canal "yo la tengo" y el fallback fuera de
  pantalla (Core Rule 11) dependen enteramente del spike de UX táctil. Mismo tratamiento que AC-9/
  AC-16: scope documentado, no TBD silencioso.
- **AC-18** (Default de desconexión durante amenaza activa, nuevo en ronda 3 — cierra un hueco de
  cobertura encontrado por `qa-lead`: el Edge Case tenía un default concreto sin AC que lo
  verificara, y no estaba en la lista de exclusiones AC-9/16/17 tampoco): DADO una amenaza activa
  (Pre-alerta o Ventana), CUANDO cualquier jugador (host o no-host) se desconecta, ENTONCES la
  amenaza se resuelve como Prevenida, sin cobro al pozo compartido y sin aplicar estado de daño.
  **EXCLUIDO explícitamente** el MECANISMO de detección de desconexión/migración de host en sí —
  eso sigue pendiente del spike de red; lo que este AC cubre es el resultado ya decidido (ver Edge
  Cases), no la implementación de red que lo dispara.
- **AC-19** (Ventana de simultaneidad, nuevo en ronda 3 — Core Rule 7b, hallazgo de `game-designer`):
  DADO que el host recibe toques válidos de Prevenir de ambos jugadores sobre la misma entidad,
  CUANDO la diferencia entre ambos timestamps de llegada al host es ≤150ms, ENTONCES se cobra una
  sola vez y ambos jugadores reciben resultado "prevenido" — sin un ganador de latencia distinguible.
  **Verificado localmente sobre el estado del host** (mismo alcance que AC-6/AC-9): esta lógica de
  fusión de toques es independiente del transporte de red real y no depende de que el spike de red
  esté resuelto para ser válida como regla — solo su timing exacto en condiciones de red reales queda
  fuera de alcance, igual que AC-16.
- **AC-20** (Pool con entidades contadas pero sin objetivo elegible, nuevo en ronda 3 — hallazgo de
  `systems-designer`: la Nota de elegibilidad-vs-conteo en Formulas no tenía AC de cobertura más allá
  del caso Reparando/Dañada de AC-13): DADO que todas las entidades que cuentan hacia
  `num_entidades_amenazables` están bloqueadas por almacenamiento lleno (ninguna es objetivo válido),
  CUANDO se evalúa el pool de selección al cumplirse el temporizador, ENTONCES se aplica AC-12 (se
  descarta sin consumir el cooldown global, el temporizador se pausa) — el conteo mayor a cero no
  implica que exista un objetivo elegible.
- **AC-21** (Salida de Reparando y re-entrada al pool, nuevo en ronda 4 — hallazgo de `qa-lead`: el
  proyecto clasifica las transiciones de máquina de estados como cobertura de test BLOQUEANTE per
  `.claude/docs/coding-standards.md`, y esta transición no tenía ninguna): DADO una entidad en estado
  Reparando, CUANDO termina su downtime, ENTONCES (a) la entidad pasa a estado Normal (no
  directamente a Creciendo/Lista — ver Core Rule 8 y States and Transitions), y (b) mientras esté en
  Normal, esa entidad NO cuenta hacia `num_entidades_amenazables` ni es elegible para Core Rule 1,
  hasta que una acción propia del recurso (p. ej. replantar) la reintroduzca en Creciendo. Si esa
  salida deja el pool compartido vacío, se verifica adicionalmente que se aplique Core Rule 10/AC-12
  con normalidad (el temporizador de intervalo se pausa).
- **AC-22** (Prioridad del botón de acción contextual, nuevo en ronda 4 — hallazgo de `ux-designer`,
  Core Rule de UI Requirements): DADO que una entidad en Amenaza activa y una entidad distinta en
  estado Dañada están ambas en rango del jugador al mismo tiempo, CUANDO se evalúa qué verbo mostrar
  en el botón de acción contextual, ENTONCES el botón siempre muestra "Prevenir" apuntando a la
  entidad en Amenaza activa — nunca "Reparar" mientras exista una entidad en Amenaza activa en rango.

## Open Questions

| Question | Owner | Deadline | Resolution |
|---|---|---|---|
| ¿El rango recomendado de ventana de reacción (3-8s) se sostiene una vez que derrumbe/incendio fijen sus propios números? | Diseñador de Madera/Minerales | Al autorar esos GDDs | Pendiente |
| Mecanismo de autoridad de red para disparo/resolución | Spike de red | Antes de `/create-architecture` | Pendiente, ⚠ Provisional en todo el documento |
| Addendum al art bible con las 3 familias de forma + simplificación del cooldown único | `art-director` | Antes de que Madera/Minerales redacten su Visual/Audio | Pendiente |
| Criterio de salience/legibilidad del preview de severidad + pregunta de playtest: ¿ver "ya está en Reducido" se lee como permiso para no correr? | `ux-designer`/`game-designer` | En playtest de Amenazas | Añadido en ronda 2 — "pequeño/atenuado" no garantiza percepción bajo presión, sin verificar todavía |
| ¿Es t* (punto de equilibrio de `coste_no_prevenir`) alcanzable dado el ritmo real de disparo, o las amenazas llegan casi siempre con t_progreso≈1 (Prevenir domina de facto)? | Diseñador de Madera/Minerales | Al instanciar cada recurso | Añadido en ronda 2 ([systems-designer]); **formalizado en ronda 3 como segundo requisito obligatorio de instanciación** (ver Formulas y AC-11, hallazgo de `economy-designer`) — ya no es solo una pregunta abierta, es una verificación que toda instancia debe hacer explícitamente, aunque el valor numérico siga pendiente hasta que Madera/Minerales existan |
| Formalizar el sesgo de downtime (severo > reducido) como invariante/AC, no solo advertencia textual en Tuning Knobs | Sin dueño asignado | Sin fecha | Añadido en ronda 2 — rigor inconsistente con el resto de la sección, no bloqueante |
| ADR stub o task ID externo para AC-9/AC-16/AC-17 (más allá de esta tabla de Open Questions) | `technical-director` (implícito) | Al correr `/create-architecture` | Añadido en ronda 2 ([qa-lead]) — el seguimiento actual solo apunta a esta misma tabla, no a un artefacto externo referenciable |
| ¿Puede un jugador evitar sistemáticamente responder a amenazas mientras el otro siempre responde? | Sin dueño asignado | Sin fecha — hereda la Open Question de free-riding ya documentada en `game-concept.md` | **Reabierto en ronda 3** — revierte la decisión de ronda 1 de no escalar. `economy-designer` encontró el mecanismo concreto que faltaba en el desacuerdo original de ronda 1 (`game-designer` vs. `creative-director`): Reparar es más barato que Prevenir por construcción (Core Rule 8), lo que abarata sistemáticamente la opción de no responder dentro de un pozo compartido sin atribución (Pilar 1) — no es neutral al free-riding, lo favorece. Mitigación parcial aplicada ya en este GDD (ver Interactions with Other Systems, Economía Compartida): Amenazas ahora emite qué jugador respondió, para alimentar el futuro Panel de estadísticas de contribución — visibilidad, no penalización económica. El sesgo económico de fondo (Core Rule 8 en sí) NO se toca aquí; queda para `/design-system economia-compartida` decidir si amerita una mitigación económica más fuerte |
| Cooldown global único (Core Rule 2) declarado como trade-off revisable | Sin dueño asignado | Al diseñar el canal de presencia de compañero (spike de UX táctil) | Añadido en ronda 1: `game-designer` sostiene que aplana las 3 identidades de amenaza en un solo interrupt; `creative-director` sostiene que es correcto sin canal de presencia. Se mantuvo la regla, se corrigió el Player Fantasy — revisar esta decisión si el canal de presencia cambia el cálculo |
| Autoridad de red requerirá probablemente su propio ADR tras el spike | `technical-director` (implícito) | Tras el spike de red | Señal de alcance de `/design-review` ronda 1: la superficie de decisiones de red de este GDD (interfaz RPC, sesgo de latencia, default de pérdida de host) es lo bastante grande para un ADR dedicado, no solo notas inline — **ampliado en ronda 3**: la ventana de simultaneidad (Core Rule 7b) y el mensaje RPC dividido disparo/resolución también son superficie de ese mismo ADR |
| Rango de zoom de cámara (mín/máx) — necesario para que el piso de 44×44pt del botón de acción sea verificable end-to-end, no solo declarado como regla de espacio-de-pantalla | `ux-designer` | Al correr `/ux-design` para el HUD de Amenazas | Añadido en ronda 3 (hallazgo de `ux-designer`) — la regla de espacio-de-pantalla ya está fijada en este GDD (UI Requirements); el rango de zoom concreto es una decisión de cámara que este GDD no posee |
| Mecanismo de `tiempo_hasta_asentar_cámara` (Core Rule 4): ¿paneo automático (curva/duración conocible de antemano) o manual (tiempo de reacción humana, no calculable antes del hecho)? Y con 2 dispositivos/cámaras independientes, ¿de qué jugador se toma el tiempo cuando solo uno tiene la entidad fuera de pantalla? | `ux-designer` (spike de UX táctil) | Antes de `/create-architecture` | Añadido en ronda 4 (hallazgo convergente de `systems-designer`, `ux-designer`, `network-programmer`, `godot-specialist`) — bloqueaba implementación porque el RPC de Disparo debe llevar `duracion_ventana` ya calculada antes de que exista ningún paneo que medir; ver Core Rule 4. Recomendación no vinculante para el spike: si es manual, considerar un modelo que no requiera predicción (p. ej. extensión que arranca cuando la entidad entra al viewport, en vez de calcularse por adelantado); si hay 2 cámaras, tomar el máximo entre ambos jugadores |
| Esquema del canal de atribución por jugador (qué mensaje transporta "qué jugador ejecutó cada toque de Prevenir/Reparar", ver Interactions with Other Systems/Economía Compartida y Core Rule 7b) | `network-programmer` (spike de red) | Antes de `/create-architecture` | Añadido en ronda 4 — declarado explícitamente en Core Rule 7b como sin resolver, parte de la misma superficie de decisiones que el ADR de red dedicado (ver fila de abajo) |
| Contrato RPC de Reparar (solicitud + confirmación de reparación completa) y si la ventana de simultaneidad de Core Rule 7b aplica al caso análogo de doble-toque en Reparar | `network-programmer` (spike de red) | Antes de `/create-architecture` | Añadido en ronda 4 (hallazgo de `network-programmer`) — el contrato de dos mensajes de ronda 3 solo cubre Prevenir; Dañada/Reparando son igual de host-autoritativas y no tienen ningún mensaje definido |
| Estado de reconexión a mitad de una amenaza activa (qué recibe un cliente que se reconecta: ¿Disparo original con tiempo restante? ¿Resolución ya ocurrida?) | `network-programmer` (spike de red) | Antes de `/create-architecture` | Añadido en ronda 4 — `game-concept.md` exige reconexión &lt;10s como requisito de MVP, pero ningún Edge Case de este documento cubre el caso de reconexión durante una amenaza activa específicamente |
| Valor concreto de separación mínima de luminancia entre las 3 familias de forma (ver Tuning Knobs) + verificación de que se aplicó antes de congelar arte | `art-director` | Antes de congelar la producción de arte de las 3 familias | Añadido en ronda 4 (hallazgo de `art-director`) — el mandato ya existe en Tuning Knobs y Visual/Audio Requirements desde ronda 3, pero no tenía fila propia en esta tabla ni AC de cobertura; nada forzaba que la calibración realmente ocurriera antes de esta corrección |
| Tratamiento de contraste concreto para los íconos Severo/Reducido (placa de fondo / stroke / sombra — ver Visual/Audio Requirements) + verificación contra los 3 estilos de arte de entidad (cultivo/madera/mineral) | `art-director` | Antes de congelar la producción de arte de las 3 familias | Añadido en ronda 4 (hallazgo de `art-director`), mismo patrón que la fila de luminancia — mandato "obligatorio" desde ronda 3 sin mecanismo de verificación hasta ahora |
| Re-validación del presupuesto de &lt;100 draw calls / 512MB contra la composición de escena de 3 tipos de recurso combinados (Dañada/Reparando sin acotar por cooldown, hasta 15+ entidades) | Spike de rendimiento combinado (`game-concept.md`) | Antes de `/map-systems` (ya bloqueante) | Añadido en ronda 4 (hallazgo de `godot-specialist`) — el spike combinado ya cubre Cultivos a nivel Vertical Slice + automatización; no está confirmado que también contemple el escenario de 3 recursos + amenazas simultáneas Dañada/Reparando sin cooldown que este GDD genera al generalizarse |
