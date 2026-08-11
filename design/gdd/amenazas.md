# Amenazas (framework genérico)

> **Status**: Designed — pendiente de `/design-review` en sesión aparte
> **Author**: usuario + agentes
> **Last Updated**: 2026-08-10
> **Implements Pillar**: Pilar 5 (El riesgo empuja a prepararse)
> **Creative Director Review (CD-GDD-ALIGN)**: omitido — modo Lean (no es phase-gate en este modo)

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
tipo de "¡rápido, alguien la tiene!" de *Overcooked*, no el miedo de un juego de terror ni la ansiedad
de un combate. La tensión viene de la coordinación bajo un reloj corto (4-6s), no del peligro
personal: nada en pantalla amenaza al avatar del jugador, solo el terreno construido con esfuerzo
compartido. Resolver la amenaza a tiempo (prevenir) debe sentirse como un choque de manos silencioso;
llegar tarde y tener que reparar debe sentirse como un "bueno, tocará esperar un poco" — un
contratiempo con costo claro y recuperación garantizada, nunca una pérdida permanente ni una
vergüenza. El fallo es fricción temporal, no castigo.

> `creative-director` no consultado — modo Lean. Revisar manualmente antes de producción.

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
   (equivalente a Refugio) en rango — con protección: Reducido; sin ella: Severo.
7. **Prevenir**: un toque, solo durante la ventana activa, cuesta dinero del pozo compartido, resuelve
   al instante sin estado de daño ni downtime.
8. **Reparar**: un toque, solo disponible en estado de daño, cuesta menos que Prevenir pero incurre
   downtime antes de volver a estar disponible — mayor downtime para Severo que para Reducido.
9. **Autoridad de red** (⚠ Provisional, heredado, pendiente del spike de red): selección de objetivo y
   resolución de prevención se deciden en el host y se replican vía RPC autoritativo — nunca de forma
   independiente en cada cliente.

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
  timestamp_disparo, resultado}` replicado a ambos peers.
- **Cultivos** (instancia existente): ya implementa este contrato completo vía plagas — sirve de
  referencia para cómo Madera/Minerales lo instancien.
- **UI/HUD**: consume "Amenaza activa" para el texto de refuerzo; consume "Dañada"/"Reparando" para el
  ícono localizado sobre la entidad.

## Formulas

> `systems-designer` consultado — modo Lean (Formulas es una de las 2 secciones que sí reciben
> especialista en este modo).

### amenaza_interval (intervalo de disparo, generalizado)

`intervalo_min = 25 + (num_entidades_amenazables * 3)`
`intervalo_max = 45 + (num_entidades_amenazables * 3)`

| Variable | Symbol | Type | Range | Description |
|---|---|---|---|---|
| Entidades amenazables activas | num_entidades_amenazables | int | 0–sin tope | Total de entidades elegibles en TODOS los tipos de recurso (parcelas de cultivo en Creciendo/Lista + futuros nodos de madera/mineral), sumadas en un solo pool per Core Rule 1 |
| Intervalo mínimo/máximo | intervalo_min, intervalo_max | float | 25–sin tope, 45–sin tope | Segundos hasta el próximo disparo global |

**Output range**: [25, sin tope] — cambio deliberado respecto al `[25,63]` ya registrado para
`plague_interval`: el 63 original venía del tope duro de 6 parcelas de Cultivos, restricción de esa
instancia, no del framework. Misma expresión, dominio más ancho, no una contradicción silenciosa.

**Ejemplo**: 6 parcelas de cultivo + 4 nodos de madera + 2 de mineral = 12 entidades → intervalo
[61, 81]s.

⚠ **Riesgo marcado para Tuning Knobs**: cuando los 3 recursos maduren, `n` podría llegar a 15-20+,
empujando el intervalo más allá de 90-100s — combinado con el cooldown de 15s podría sentirse
demasiado disperso para "un solo ritmo de alerta." Punto de revalidación explícito para cuando
Madera/Minerales fijen sus propios topes de entidades.

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

## Edge Cases

> Sin especialista consultado en esta sección — modo Lean.

| Escenario | Comportamiento esperado | Justificación |
|---|---|---|
| No hay ninguna entidad amenazable elegible al momento del disparo (p. ej. antes de plantar nada) | El disparo se cancela en silencio; el temporizador se reinicia con el mismo intervalo — no se acumula ni se "guarda" | Evita una amenaza instantánea en cuanto se planta la primera parcela |
| La única entidad elegible ya está en Reparando o Dañada | No es elegible — el pool de selección excluye cualquier entidad fuera de estado "activo normal" | Si eso vacía el pool, aplica el caso anterior |
| Los dos jugadores tocan "Prevenir" en la misma entidad en la misma ventana (carrera de red) | El host procesa el primer RPC válido y descarta el segundo en silencio, sin cobro doble ni error visible | Pilar 3 (fricción cero) — un error visible castigaría al jugador más lento sin motivo |
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
- Plaga (ya diseñada, art bible §3): clúster de gota/diamante suave, movimiento de enjambre en órbita,
  mate oscuro desaturado.
- Derrumbe (madera): fragmentos poligonales angulares con esquinas redondeadas (nunca afiladas/tipo
  arma), movimiento de asentamiento/desmoronamiento lento hacia abajo, mate oscuro desaturado.
- Incendio (mineral): manchas tipo ascua redondeadas (no lenguas de fuego, evita iconografía de
  combate), movimiento de deriva/pulso ascendente, mate oscuro desaturado.

Regla para futuros GDDs (Madera, Minerales): elegir una familia de forma que no sea ni
clúster-orgánico-redondo (plaga), ni fragmentado-angular (derrumbe), ni mancha-flotante (incendio) —
confirmar contra esta tabla antes de finalizar. Las 3 obedecen las reglas ya fijadas en el art bible
sin cambios: rim-light localizado, pre-alerta azul-blanco, cero rojo (reservado a Fresa), nunca efectos
de pantalla completa.

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
- Reparación completa: brillo ascendente suave, espeja el visual menta.

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

📌 **UX Flag — Amenazas**: este sistema tiene requisitos de UI reales. En Fase 4 (Pre-Producción),
correr `/ux-design` para el HUD/telegraph de amenaza antes de escribir épicas. Las historias que
referencien esta UI deben citar `design/ux/[pantalla].md`, no este GDD directamente.

## Acceptance Criteria

> `qa-lead` consultado — modo Lean (Acceptance Criteria es la otra sección que sí recibe especialista
> en este modo).

- **AC-1** (Selección agrupada): DADO que hay entidades activas de varios tipos de recurso, CUANDO se
  dispara una amenaza, ENTONCES la entidad elegida sale del pool combinado de todos los tipos, no de
  un sub-pool de un solo tipo.
- **AC-2** (Cooldown global): DADO que una amenaza se acaba de disparar, CUANDO no han pasado 15s,
  ENTONCES ningún nuevo disparo (de cualquier tipo) ocurre, aunque otra entidad se vuelva elegible de
  forma independiente.
- **AC-3** (Pre-alerta): DADO que se dispara una amenaza, CUANDO se reproduce la pre-alerta de 0.5s,
  ENTONCES "Prevenir" no está disponible y el conteo de la ventana de reacción todavía no empezó.
- **AC-4** (Ventana de reacción): DADO que termina la pre-alerta, CUANDO la ventana específica de la
  instancia está activa (p. ej. 4-6s en cultivos), ENTONCES "Prevenir" solo es tocable dentro de ese
  lapso; tocar después de expirar no tiene efecto.
- **AC-5** (Señal doble): DADO cualquier amenaza activa, CUANDO se observa en cualquier punto de la
  pre-alerta o la ventana, ENTONCES el visual diegético Y el texto de HUD están presentes
  simultáneamente — nunca solo uno.
- **AC-6** (Severidad en resolución): DADO que no hay protección al momento del disparo, CUANDO se
  coloca protección antes de que termine la ventana y no se previene, ENTONCES el daño resuelve como
  Reducido, no Severo (e inversamente: quitar protección a mitad de ventana produce Severo).
- **AC-7** (Prevenir): DADO una ventana activa, CUANDO el jugador toca Prevenir, ENTONCES se descuenta
  dinero, el estado de daño nunca se aplica, y el efecto es instantáneo.
- **AC-8** (Reparar): DADO que la entidad está Dañada, CUANDO se usa Reparar, ENTONCES el costo es
  menor que el de Prevenir, y el downtime de Severo es mayor que el de Reducido.
- **AC-9** (Autoridad de red): **BLOQUEADO** — no verificable hasta que aterrice el spike de red; no
  se escribe un criterio pasa/falla hoy.
- **AC-10** (Fórmula de intervalo): DADO num_entidades_amenazables = N, CUANDO termina un período de
  cooldown, ENTONCES el próximo intervalo de disparo cae en [25+3N, 45+3N]s.
- **AC-11** (Fórmula coste_no_prevenir, con ejemplos concretos): DADO trigo en estado Lista
  (valor_en_riesgo=$15, costo_reparar=$10, costo_reinicio=$2, costo_prevenir=$15), CUANDO
  t_progreso=1.0, ENTONCES coste_no_prevenir=$27 > costo_prevenir → prevenir domina; CUANDO
  t_progreso=0.1, ENTONCES coste_no_prevenir=$13.50 < costo_prevenir → dejar que dañe y reparar es más
  barato — confirma que es una elección genuina, no una estrategia dominante fija.
- **AC-12** (Sin entidad elegible): DADO que no hay ninguna entidad amenazable elegible al momento del
  disparo, CUANDO el sistema lo detecta, ENTONCES el disparo se cancela y el temporizador se reinicia
  con el MISMO intervalo (no se sortea uno nuevo) — distinto de un disparo resuelto (prevenido o
  dañado), que sí sortea un intervalo nuevo vía la fórmula con el N vigente en ese momento.
- **AC-13** (Entidad ya dañada excluida): DADO que la única entidad elegible ya está Reparando o
  Dañada, CUANDO se evalúa el pool de selección, ENTONCES queda excluida y se aplica AC-12 si eso
  vacía el pool.
- **AC-14** (Cosecha durante amenaza): DADO una amenaza activa sobre una entidad, CUANDO el jugador
  cosecha/remueve esa entidad durante la pre-alerta o la ventana, ENTONCES la amenaza se cancela sin
  penalización ni reembolso, y el disparo se da por resuelto (no reciclado).
- **AC-15** (Primer disparo de partida): DADO el inicio de una partida nueva, CUANDO ocurre el primer
  disparo, ENTONCES usa el N real en ese momento (normalmente 1) sin caso especial de gracia.
- **AC-16** (Carrera de red en doble toque): **BLOQUEADO** — depende de la capa de red, igual que
  AC-9.

## Open Questions

| Question | Owner | Deadline | Resolution |
|---|---|---|---|
| ¿El rango recomendado de ventana de reacción (3-8s) se sostiene una vez que derrumbe/incendio fijen sus propios números? | Diseñador de Madera/Minerales | Al autorar esos GDDs | Pendiente |
| Mecanismo de autoridad de red para disparo/resolución | Spike de red | Antes de `/create-architecture` | Pendiente, ⚠ Provisional en todo el documento |
| Riesgo de que N llegue a 15-20+ y el intervalo supere 90-100s | Diseñador de Madera/Minerales | Al fijar los topes de entidades de esos recursos | Pendiente, marcado en Formulas |
| Addendum al art bible con las 3 familias de forma + simplificación del cooldown único | `art-director` | Antes de que Madera/Minerales redacten su Visual/Audio | Pendiente |
| ¿Puede un jugador evitar sistemáticamente responder a amenazas mientras el otro siempre responde? | Sin dueño asignado | Sin fecha — hereda la Open Question de free-riding ya documentada en `game-concept.md`; Amenazas no la resuelve ni la agrava, tampoco la mitiga | Pendiente |
