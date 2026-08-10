# Game Concept: Rincón Compartido

*Created: 2026-08-10*
*Status: Draft*

---

## Elevator Pitch

> Es un tycoon de automatización cooperativo en el que dos jugadores, conectados por wifi local, transforman un terreno compartido en una operación de cultivos, madera y minerales — cosechando a mano, construyendo cintas transportadoras y contratando trabajadores, mientras defienden juntos lo construido de plagas, derrumbes e incendios.
>
> Test de 10 segundos: "Con tu compañero, convierten un terreno en un imperio de recursos automatizado, y lo protegen juntos cuando la naturaleza ataca." ✅

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Tycoon / Automatización cooperativa (Management Sim + Factory Automation) |
| **Platform** | Móvil (iOS / Android) |
| **Target Audience** | Ver Target Player Profile |
| **Player Count** | Co-op local (2 jugadores, **2 dispositivos**, wifi local) — ideal en pareja, jugable en solitario |
| **Session Length** | Sesiones de 15-60 min típicas (hasta 120 min si el par sigue jugando por gusto), con ciclos internos de ~5 min; progreso perceptible dentro de los primeros 10-15 min — número alineado con Target Player Profile (round 3 `/design-review`: los dos números se contradecían) |
| **Monetización** | Sin definir aún — abierta como pregunta (ver Risks and Open Questions) |
| **Estimated Scope** | Medium (6–9 meses, desarrollador solo) |
| **Comparable Titles** | Junkyard Tycoon, My Time at Sandrock, Techtonica |

---

## Core Fantasy

Junto a tu compañero, transforman un terreno abandonado en un imperio de recursos que crece y se automatiza bajo su cuidado conjunto. La fantasía central es pasar de "recolectores manuales" a "arquitectos de un sistema que casi se sostiene solo" — mientras protegen juntos lo construido de las amenazas periódicas que el mundo les lanza (plagas, derrumbes, incendios).

No es la fantasía de dominar en solitario un imperio: es la fantasía de **construir algo juntos que ninguno de los dos podría sostener igual de bien solo**.

---

## Unique Hook

Como Junkyard Tycoon, Y ADEMÁS diseñado desde cero para que dos personas compartan una sola economía en vivo vía wifi local, enfrentando amenazas periódicas (plagas, derrumbes, incendios) que se resuelven con inversión preventiva y gestión conjunta — nunca con combate directo.

La interdependencia económica real entre los dos jugadores (una sola cuenta, un solo terreno) es lo que distingue esto de un tycoon con "modo cooperativo" añadido encima: el co-op está en el ADN del diseño, no es una capa social opcional.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

*Priority: 1 = máxima prioridad, 7 = mínima.*

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** (sensory pleasure) | 5 | Feedback rápido e inmediato al cosechar (partículas, sonido, contador subiendo) |
| **Fantasy** (make-believe, role-playing) | 7 | Mínima — "somos dueños de un negocio que crece juntos" |
| **Narrative** (drama, story arc) | N/A | Sin narrativa dirigida; el juego es sistémico, no narrativo |
| **Challenge** (obstacle course, mastery) | 2 | Curva de automatización, eventos de amenaza que ponen a prueba el sistema, métricas de eficiencia visibles |
| **Fellowship** (social connection) | 1 | Cuenta y terreno compartidos, decisiones de inversión conjuntas, roles flexibles |
| **Discovery** (exploration, secrets) | 3 | Nuevos tipos de recursos y piezas de automatización desbloqueables |
| **Expression** (self-expression, creativity) | 4 | Libertad de diseño en la disposición de cintas, parcelas y trabajadores |
| **Submission** (relaxation, comfort zone) | 6 | Loop manual rítmico y relajante entre picos de tensión por amenazas |

### Key Dynamics (Emergent player behaviors)

- Los jugadores tenderán a especializarse de forma natural (uno construye/automatiza, otro cosecha/vende) aunque los roles sean intercambiables sesión a sesión.
- Negociarán activamente en qué invertir primero: crecimiento (más cintas, más terreno) vs. protección (defensas contra amenazas).
- Cuando llega una amenaza, coordinarán una respuesta de emergencia en tiempo real — quién repara, quién sigue produciendo. **Nota de diseño (round 3 `/design-review`)**: esto asume que cada jugador puede percibir la situación del otro pese a estar en dispositivos separados — el mecanismo de UI concreto (aviso compartido, estado del compañero visible) no está definido aún; ver Open Questions y el spike de UX táctil.

### Core Mechanics (Systems we build)

1. Recolección manual rápida y fluida de 3 tipos de recursos base (cultivos, madera, minerales)
2. Automatización mediante cintas transportadoras y trabajadores contratables, colocados en una cuadrícula 2D/isométrica — visión de automatización de **largo plazo**. Una capa de progresión más temprana (Máquinas de compra única, MVP-adyacente/Vertical Slice) la antecede sin reemplazarla; ver `design/gdd/farm-economy-system.md` (decisión tomada en su `/design-review` del 2026-08-10, sección Dependencies)
3. Economía compartida (una sola cuenta bancaria) con venta de recursos
4. Eventos de amenaza periódicos (plagas, derrumbes, incendios) prevenibles con protecciones compradas o resolubles con gestión reactiva
5. Progresión de automatización que desbloquea nuevos tipos de recursos y piezas
6. Panel de estadísticas de contribución individual (cuánto cosechó y gastó cada jugador) — solo visibilidad, no restringe el gasto compartido; profundiza la tensión social del Pilar 1. Validado como deseado en el playtest del prototipo. **Fuera de MVP.**

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | Roles no fijos — cada sesión, ambos jugadores deciden quién cosecha a mano y quién gestiona automatización | Core |
| **Competence** (mastery, skill growth) | Métricas visibles de eficiencia (unidades/min, % automatizado) muestran el crecimiento de habilidad y sistema | Core |
| **Relatedness** (connection, belonging) | Cuenta y terreno compartidos; el progreso de uno depende directamente de las decisiones del otro | Core |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Achievers** (goal completion, collection, progression) — How: automatización creciente y crecimiento visible del negocio compartido
- [x] **Explorers** (discovery, understanding systems, finding secrets) — How: descubrir nuevos recursos y piezas de automatización
- [x] **Socializers** (relationships, cooperation, community) — How: co-op local con interdependencia económica real, no cosmética
- [ ] **Killers/Competitors** (domination, PvP, leaderboards) — No aplica (anti-pilar: sin PvP)

### Flow State Design

- **Onboarding curve**: los primeros 10 minutos enseñan la recolección manual de un solo recurso, luego introducen la primera pieza de automatización.
- **Difficulty scaling**: las amenazas aumentan en frecuencia y variedad conforme crece la operación.
- **Feedback clarity**: un contador de eficiencia (% automatizado, unidades/min) siempre visible en pantalla.
- **Recovery from failure**: una amenaza daña la operación temporalmente, nunca la arruina — reparar es rápido y educativo, no punitivo.

---

## Core Loop

### Moment-to-Moment (30 seconds)
Cosechar/talar/minar a mano con acciones rápidas y fluidas, encadenables entre tipos de recurso, con feedback inmediato (sonido, partícula, contador) en cada acción.

### Short-Term (5-15 minutes)
Cosechar manualmente lo justo → juntar capital → invertir en la siguiente pieza de automatización (cinta, máquina o trabajador) → repetir con el siguiente tipo de recurso. El "one more" viene de estar cerca de poder pagar la próxima pieza que conecta el sistema.

### Session-Level (15-60 minutes típico, hasta 120 si el par se extiende)
Expandir la operación (nuevas cintas, nueva pieza, nuevo trabajador) + gestionar un evento de amenaza (reaccionar o ya estar protegidos) + revisar cuánto del negocio corre ya de forma autónoma. Punto de corte natural: cuando la nueva pieza de automatización queda instalada y funcionando.

### Long-Term Progression
De parcela pequeña y 100% manual → operación mixta → negocio mayormente automatizado con nuevos tipos de recursos desbloqueados. Sin final duro: el jugador decide cuándo su imperio está "completo" a su gusto.

### Retention Hooks
- **Curiosity**: la siguiente pieza de automatización o tipo de recurso por desbloquear.
- **Investment**: la operación compartida que ambos construyeron — perderla ante una amenaza no gestionada duele.
- **Social**: la sesión solo tiene sentido completo con la otra persona conectada.
- **Mastery**: el porcentaje de automatización y la eficiencia del sistema como métrica de dominio.

---

## Game Pillars

### Pillar 1: Compartido, no dividido
El progreso pertenece a los dos: terreno compartido, cuenta compartida, decisiones conjuntas.

*Design test*: Si dudamos entre una feature que separa a los jugadores en economías paralelas o una que los mantiene interdependientes, elegimos la interdependencia.

### Pillar 2: Manual siempre vale la pena
Nunca dejamos que la automatización reemplace del todo la diversión — siempre debe existir algo que premie hacerlo a mano. Mecanismo concreto (a formalizar con números en `/design-system`): cada nivel de automatización debe dejar un margen — de velocidad, calidad o rareza de recurso — que solo lo manual puede alcanzar, para que "¿lo hago a mano o dejo que la máquina lo haga?" siga siendo una decisión real y no una ilusión resuelta a favor de automatizar en cuanto esté disponible.

*Design test*: Si dudamos entre que la automatización sustituya por completo una acción o que la versión manual siga pagando mejor / dando más calidad, elegimos mantener la manual relevante.

### Pillar 3: Fricción cero, decisión sí
La ejecución (moverse, cosechar, construir) se siente rápida y sin estorbos; la tensión real viene de las decisiones económicas y de gestión, no de pelear con los controles — incluyendo cómo se resuelven las amenazas.

*Design test*: Si dudamos entre añadir complejidad a la ejecución física/de combate o a la capa de gestión/decisión, elegimos la capa de decisión.

### Pillar 4: Crecimiento visible
El jugador siempre debe poder VER el crecimiento en el mundo — más cintas, más trabajadores, más terreno transformado — no solo un número en un menú.

*Design test*: Si una mejora no se puede representar físicamente en el terreno, buscamos la forma de que sí se vea.

### Pillar 5: El riesgo empuja a prepararse
Amenazas periódicas (plagas, derrumbes, incendios) ponen a prueba la operación; se enfrentan con inversión preventiva (comprar protecciones) o reacción de gestión (reparar, reasignar), nunca con combate directo.

**Patrón validado por el prototipo** (base de este pilar, confirmado divertido en playtest): prevenir cuesta más pero es instantáneo y sin downtime; reparar cuesta menos pero incluye tiempo de inactividad. Cualquier amenaza nueva que se diseñe debe ofrecer una decisión con esa misma estructura de trade-off, no solo "paga o pierde".

**Salvaguarda contra softlock**: si el dinero compartido es insuficiente para prevenir o reparar, la amenaza se resuelve automáticamente al final de su ventana de tiempo, sin cobro — el costo es la pérdida temporal de producción, nunca un bloqueo permanente ni una deuda. Ningún diseño de amenaza debe poder dejar a los jugadores sin salida.

Esta salvaguarda es un piso anti-softlock, no una vía económica viable: el tiempo de inactividad de la resolución automática debe ser, en valor esperado, siempre peor que el costo de prevenir o reparar. De lo contrario, "dejar que se resuelva sola" se vuelve la estrategia dominante y el trade-off de este pilar — validado como divertido en el prototipo — deja de importar. **Forma de la regla requerida antes de `/design-system`** (round 3 `/design-review`: la relación cualitativa sola no basta — sin forma no se puede verificar en los extremos de la curva de dinero): el costo de inactividad debe expresarse como una función del output esperado de la operación en ese momento (p. ej. % del ingreso esperado durante esa ventana), no como un valor fijo — así la desigualdad se sostiene tanto en early game (poco capital) como en late game (mucho automatizado). El valor exacto de esa función se define en `/design-system`, pero la forma (relativa al output, no fija) debe fijarse ya.

**Nota de diseño (round 3 `/design-review`)**: esta salvaguarda resuelve "pagar vs. dejar que se resuelva sola", no "quién de los dos paga". El riesgo de que un jugador cargue sistemáticamente el peso económico mientras el otro se beneficia sin contribuir (free-riding) queda fuera de su alcance — ver Open Questions.

**Techo de frecuencia**: la frecuencia/severidad de las amenazas debe crecer con la operación hasta un techo definido, no indefinidamente — de lo contrario el sistema nunca se siente "autosuficiente" (contradice la Core Fantasy), solo exige atención manual creciente para siempre. El valor exacto del techo se define en `/design-system`.

*Design test*: Si dudamos entre resolver una amenaza con una mecánica de acción/combate o con una decisión de inversión/gestión, elegimos la gestión.

### Anti-Pillars (What This Game Is NOT)

- **NO combate directo ni armas**: las amenazas se resuelven gestionando (comprando protección, reparando, reasignando), no peleando — comprometería el Pilar 3 y 5.
- **NO modo competitivo/PvP entre los dos jugadores**: comprometería el Pilar 1 (Compartido, no dividido).
- **NO automatización 100% desatendida** ("déjalo correr y hazte rico sin jugar"): comprometería el Pilar 2 — las amenazas son parte de por qué siempre conviene seguir prestando atención.
- **NO micromanagement de decenas de unidades individuales estilo RTS**: comprometería el Pilar 3 y el alcance viable para un primer juego.

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| Junkyard Tycoon | Vista 2D/isométrica, sensación de "chatarra a imperio" | Añadimos co-op local real (no solo single-player) y amenazas de gestión periódicas | Valida que el género tycoon 2D top-down es viable y atractivo en móvil |
| My Time at Sandrock | Economía + co-op | Nuestro foco es automatización pura (cintas/trabajadores), no crafting narrativo | Valida demanda real de economía cooperativa |
| Techtonica | Automatización + co-op | Simplificamos la complejidad de fábrica para un formato móvil/casual | Valida demanda de automatización jugada en compañía |

**Non-game inspirations**: La sensación de "montar un negocio familiar" (ferretería, huerto, taller) donde cada quien tiene su rol pero comparten la caja registradora.

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 16-35 |
| **Gaming experience** | Casual a Mid-core |
| **Time availability** | Sesiones de 15-60 min, normalmente jugadas junto a una pareja/amigo en la misma red wifi |
| **Platform preference** | Móvil |
| **Current games they play** | Junkyard Tycoon, Stardew Valley, Township, Two Point County |
| **What they're looking for** | La satisfacción de un tycoon de gestión, pero compartida con otra persona en tiempo real |
| **What would turn them away** | Controles táctiles torpes, exigir internet en vez de solo wifi local, sesiones que necesiten más de una hora para sentir progreso |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | **Decidido — Godot 4.7.1, GDScript** (vía `/setup-engine`, 2026-08-10). Versión con riesgo de conocimiento ALTO — ver `docs/engine-reference/godot/VERSION.md` antes de sugerir cualquier API de motor |
| **Key Technical Challenges** | Descubrimiento de red local (peer discovery) entre 2 dispositivos móviles — Godot no trae esto integrado, hay que implementarlo a mano; colocación de cintas transportadoras con un solo botón de acción contextual táctil (patrón validado en teclado, evaluar `VirtualJoystick` de Godot 4.7 para el movimiento); balancear frecuencia de amenazas vs. progreso de automatización con un techo definido (ver Pilar 5) |
| **Art Style** | 2D top-down / isométrico estilizado (estilo Junkyard Tycoon) |
| **Art Pipeline Complexity** | Low-Medium (2D custom) |
| **Audio Needs** | Moderate (feedback de cosecha, alertas de amenaza, música ambiental relajante) |
| **Networking** | **Cliente/host vía ENet** (API de multiplayer de alto nivel de Godot) — **NO es P2P puro**, un dispositivo actúa como host. Godot no incluye descubrimiento de red local (sin mDNS/broadcast integrado) — hay que implementarlo. Riesgos de plataforma sin validar: iOS requiere permiso de Red Local + declarar servicio Bonjour; Android puede tener multicast-lock o aislamiento de AP en algunos routers. **No probado aún** — el prototipo usó hotseat en 1 dispositivo, no red real. Pendiente de spike técnico dedicado antes de comprometer arquitectura. |
| **Content Volume** | MVP: 2 parcelas (1 inicial + 1 comprable), 3 tipos de recurso base con diferenciación normal/exótico, **1 amenaza recurrente en total** (aplica a la operación compartida, no una por cada tipo de recurso — ver MVP Definition) con protección + reparación comprables, automatización básica. Techo de entidades activas (cintas/trabajadores simultáneos) sin definir aún — pendiente de spike de rendimiento antes de que `/map-systems` fije el tamaño de la cuadrícula. Visión completa: recursos "exóticos" adicionales, tech tree extenso, variedad de amenazas (una por tipo de recurso). **Contenido MVP-adyacente/Vertical Slice** (multi-cultivo dentro del recurso "cultivo", expansión de terreno hasta 6 parcelas, Máquinas, infraestructura, decoración, confort) detallado en `design/gdd/farm-economy-system.md` — no sustituye este MVP, lo extiende para tiers posteriores. **Cobertura de spike resuelta (round 4)**: el spike de rendimiento de Next Steps se amplió para incluir una escena de prueba combinada (automatización a techo + contenido completo de `farm-economy-system.md` a tier Vertical Slice) — ver Next Steps. |
| **Procedural Systems** | Ninguno confirmado — posible generación aleatoria de amenazas (tipo, timing), no de terreno |

---

## Risks and Open Questions

### Design Risks
- El balance entre "recolectar a mano siempre vale la pena" y el atractivo de automatizar podría inclinarse hacia un extremo y romper el Pilar 2.
- Las amenazas podrían sentirse injustas o frustrantes si no se comunican con suficiente anticipación antes de golpear.
- **(Round 3 `/design-review`) Runway de gasto corto**: el MVP tiene un único sink comprable más allá de prevenir/reparar (la 2ª parcela) — una vez comprada, no queda nada más en qué invertir hasta el tier de Vertical Slice. Esto reproduce directamente el hallazgo del concept prototype ("se me ha hecho aburrido... echo de menos una tienda con más semillas"). Vigilar en el primer playtest de MVP: si el dinero deja de tener destino dentro de la misma sesión de prueba, considerar adelantar un sink barato desde Vertical Slice (mejora simple, no una parcela completa) al alcance del MVP.

### Technical Risks
- Sincronización de estado compartido (economía, inventario, posiciones) entre 2 dispositivos móviles vía wifi local en tiempo real, sobre una arquitectura cliente/host (ENet), no P2P puro.
- Descubrimiento de red local sin librería integrada en Godot, más permisos de iOS (Red Local/Bonjour) y restricciones de Android (multicast lock/aislamiento de AP) — sin validar.
- Pérdida del dispositivo host (desconexión, o suspensión por el sistema operativo móvil al pasar a segundo plano) no tiene comportamiento definido — la arquitectura cliente/host implica que esto es una posible falla total de sesión, no solo un estado degradado. Ver Open Questions.
- Rendimiento de la simulación de automatización (muchas cintas/trabajadores activos) en hardware móvil de gama media/baja, combinado con la carga de sincronización de red — el dispositivo host simula, serializa y renderiza dentro del mismo presupuesto de 16.6ms, un riesgo compuesto no evaluado aún.

### Market Risks
- El género tycoon móvil está dominado por juegos F2P con monetización agresiva; posicionar este juego con otro modelo puede ser un reto de descubribilidad.
- El co-op local (2 dispositivos, misma wifi) es un modelo más difícil de descubrir/promocionar que el single-player estándar.

### Scope Risks
- Incluso el MVP definido (networking local + automatización + amenazas) implica varios sistemas interdependientes no triviales para un primer juego en solitario.
- El diseño de UI táctil para gestión (paneles de economía, colocación de piezas) puede requerir más iteración de la anticipada.

### Open Questions
- ¿Qué modelo de monetización tendrá el juego (pago único, F2P, aún sin decidir)? — Resolver **antes del `/design-system` de economía**, ya que afecta retroactivamente el diseño de sinks/faucets, no solo antes de `/create-architecture`.
- ¿Es viable el descubrimiento de red local (peer discovery) entre 2 dispositivos móviles sin librerías de terceros complejas, dados los permisos de iOS (Red Local + Bonjour) y las restricciones de Android (multicast lock / aislamiento de AP)? — Godot no lo trae integrado. Resolver con un **spike técnico dedicado** antes de comprometer arquitectura de red — no alcanza con "durante /setup-engine", ya que el prototipo no llegó a probar red real.
- ¿El patrón de botón de acción único y contextual (validado en teclado/escritorio en el prototipo) se sostiene en pantalla táctil real? — Validar con un `/prototype` o spike de UX táctil dedicado antes de que `/create-architecture` fije decisiones de input que sean costosas de cambiar después. El spike debe responder específicamente: tamaño mínimo de objetivo táctil en la cuadrícula (riesgo de "dedo gordo"), auto-oclusión de la celda por el propio dedo al colocar, si la colocación de cintas es de un toque o de arrastre (y si eso choca con la cosecha, que es de un toque, o con paneo/zoom de cámara), **y (añadido en round 3 `/design-review`) qué mecanismo de UI muestra el estado/aviso del compañero en el otro dispositivo** (ver Open Question de arriba sobre percepción cross-device).
- ¿Qué pasa si el dispositivo host se desconecta, se suspende (pasa a segundo plano) o falla a mitad de sesión — migración de host, guardado periódico para poder reanudar, o la sesión simplemente termina con el último estado sincronizado guardado localmente? — Resolver como parte del spike técnico de red, antes de `/create-architecture`. La reconexión en <10s (ver MVP) solo aplica a caídas de red transitorias; si el fallo es estructural (p. ej. aislamiento de punto de acceso, host perdido), debe dar un mensaje de error claro con causa y acción concreta, no reintentar indefinidamente. **(Round 3 `/design-review`)** El caso más común en la práctica no es la caída de red ni el aislamiento de AP — es que el teléfono del host se bloquee o pase a segundo plano (notificación, llamada, cambio de app), lo cual suspende sockets en iOS/Android en segundos. El spike debe tratar este caso como el escenario principal a resolver, no como uno más dentro de "fallo estructural" genérico, y debe definir un disparador concreto y detectable (p. ej. N intentos de keepalive fallidos + confirmación de la capa de red del SO) para distinguir "transitorio, seguir reintentando" de "estructural, mostrar error" — sin ese disparador, el criterio de MVP "<10s" no es verificable por QA.
- ¿Cómo funciona mecánicamente el "modo solo" (un jugador controla ambos roles, o se simplifica el loop)? — Resolver en `/map-systems` o un `/design-system` dedicado.
- **(Round 3 `/design-review`)** ¿Cómo se mitiga el riesgo de free-riding en juego normal (fuera de ventanas de amenaza) — que un jugador cargue sistemáticamente más el peso económico mientras el otro se beneficia del fondo compartido sin contribuir proporcionalmente? La salvaguarda anti-softlock del Pilar 5 solo resuelve "pagar vs. dejar que se resuelva sola", no "quién de los dos paga". El panel de estadísticas de contribución (Core Mechanics #6) era la única mitigación planeada para esto y quedó fuera del MVP — este riesgo queda sin mitigación explícita en MVP. Resolver en `/map-systems` o `/design-system` de economía: o se acepta conscientemente el riesgo para MVP, o se adelanta alguna mitigación ligera.
- **(Round 3 `/design-review`)** ¿Qué mecanismo de UI permite que un jugador perciba la situación de su compañero en el otro dispositivo (p. ej. que está bajo una amenaza, o ya está actuando) — dado que son 2 dispositivos separados, no una pantalla compartida? Key Dynamics y la hipótesis del MVP asumen que ambos jugadores pueden coordinar una respuesta en tiempo real, pero ningún mecanismo de aviso/estado-del-compañero está definido aún. Incluir esta pregunta dentro del alcance del spike de UX táctil (ver pregunta de botón de acción único arriba), no como un spike separado.

---

## MVP Definition

**Core hypothesis**: Dos jugadores, cada uno en su propio dispositivo conectado por wifi local, encuentran satisfactorio cosechar manualmente y automatizar progresivamente una operación compartida de 3 recursos — **lo sabremos si, dentro de una misma sesión y tras un evento de amenaza, ambos jugadores intercambian explícitamente una propuesta sobre cómo responder (prevenir, reparar, esperar, priorizar otra compra) *antes* de que cualquiera de los dos gaste del fondo compartido para ese evento — en vez de que uno gaste unilateralmente mientras el otro no participa de la decisión.** Esto se observa directamente por quien facilita el playtest (o se revisa en una grabación/log de chat de voz si aplica) — no requiere telemetría, encuestas ni instrumentación adicional, y no depende de retorno del mismo par en sesiones futuras.

*Nota (revisado en round 3 `/design-review`): este es el mismo criterio ya observado y confirmado en el concept prototype — ver `prototypes/rincon-compartido-concept/REPORT.md` ("esta bien planteado para poder debatir con tu amigo"), que probó negociación explícita en una sola sesión, no un patrón de retorno multi-sesión. Una versión anterior de esta hipótesis pedía retorno del mismo par en 3 sesiones a lo largo de 7 días más una encuesta 1-5 — un criterio de retención tipo live-ops que (a) no encajaba con el timeline de 4-8 semanas del MVP, (b) exigía telemetría/instrumentación no incluida en el alcance del MVP, y (c) medía co-presencia ("cada quien gastó algo"), no negociación real. Se reemplazó por el criterio de una sola sesión de arriba, que sí es lo que el prototipo demostró. Preguntas de retención a más largo plazo (¿vuelve la pareja a jugar?) quedan fuera del Core hypothesis del MVP — son una pregunta de `/playtest-report` o de una fase de live-ops posterior, no de esta validación. El MVP real debe evitar reproducir la configuración de contenido mínimo que ese prototipo encontró aburrida tras unos ciclos.*

**Required for MVP**:
1. 2 parcelas por operación compartida (1 inicial + 1 comprable) con 3 tipos de recurso base (cultivo, árbol, mineral), cada uno con variante normal y exótica (exótica: menor rendimiento/ciclo más lento, mayor valor por unidad). **Forma de la regla requerida antes de `/design-system`** (round 3 `/design-review`: la dirección sola no evita un resultado degenerado): el $/tiempo de la variante exótica debe quedar dentro de una banda relativa al $/tiempo de la normal (ej. entre X% y Y% de más valor por tiempo invertido) — la banda exacta se define en `/design-system`, pero debe expresarse como banda, no solo como dirección. Queda también sin definir si las piezas de automatización pueden cosechar la variante exótica o si esta es manual-only — resolver en `/design-system`, ya que interactúa directamente con el mecanismo del Pilar 2.
2. 1 pieza de automatización por recurso (cinta transportadora O trabajador, no ambos aún)
3. Cuenta bancaria compartida y venta de recursos
4. 1 evento de amenaza recurrente, con **ambas** respuestas disponibles: prevenir (pago mayor, instantáneo) y reparar (pago menor, con tiempo de inactividad) — ver salvaguarda contra softlock en Pilar 5
5. Compra de la segunda parcela como sink de inversión
6. Conexión wifi local funcional entre 2 dispositivos reales (no hotseat): reconexión en menos de 10 segundos tras una caída de red transitoria; si la reconexión falla por una causa estructural (p. ej. aislamiento de punto de acceso, host perdido/en segundo plano), un mensaje de error claro que indique la causa detectada y ofrezca una acción concreta (reintentar / cancelar) — nunca un reintento indefinido. Ver Open Questions para el comportamiento ante pérdida del host.

**Explicitly NOT in MVP** (defer to later):
- Más de 2 parcelas / expansión de terreno adicional
- Trabajadores y cintas transportadoras combinados en la misma pieza (solo una de las dos por MVP)
- Eventos de mercado con fluctuación de precios
- Tech tree extenso de automatización
- Panel de estadísticas de contribución (ver Core Mechanics — deseado pero no bloqueante para probar la hipótesis)

### Scope Tiers (if budget/time shrinks)

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 2 parcelas (1 inicial + 1 comprable), 3 recursos base (normal + exótico) | Cosecha manual + automatización parcial (1 tipo) + amenaza con prevenir/reparar + compra de 2ª parcela + wifi local real (2 dispositivos) | 4-8 semanas |
| **Vertical Slice** | 2+ parcelas completas | + cintas y trabajadores combinados en la misma pieza, panel de estadísticas de contribución | 2-3 meses |
| **Alpha** | Todas las parcelas/recursos, sin pulir | Todas las features de la visión completa, en bruto | 4-6 meses |
| **Full Vision** | Contenido completo, pulido | Tech tree completo, eventos de mercado, variedad de amenazas, arte pulido | 6-9 meses |

---

## Next Steps

- [x] Get concept approval from creative-director — ver síntesis en `/design-review` (2026-08-10): NEEDS REVISION → revisado en esta misma sesión
- [x] Run `/setup-engine` — Godot 4.7.1, GDScript decidido y configurado
- [x] Run `/prototype` — concept prototype de economía compartida + amenazas construido y jugado, veredicto PROCEED (ver `prototypes/rincon-compartido-concept/REPORT.md`). Nota: no probó red real (hotseat), ni sensación táctil, ni topología de 2 dispositivos — quedan como spikes/prototipos pendientes.
- [ ] `/art-bible` antes de escribir cualquier GDD
- [ ] Spike técnico dedicado (añadido en round 3 `/design-review`, **alcance ampliado en round 4** — ver `design/gdd/farm-economy-system.md` Apéndice A #11 y Dependencies): techo de entidades activas de automatización (cintas/trabajadores simultáneos) y carga compuesta del dispositivo host — simular + serializar estado de red + renderizar, todo dentro de 16.6ms en hardware móvil de gama media/baja — **bloqueante antes de `/map-systems`**, ya que fija el tamaño de la cuadrícula. **Alcance ampliado**: el spike original solo cubría entidades de automatización; no cubría el contenido de `farm-economy-system.md` (hasta 6 parcelas animando de forma independiente vía `AnimationPlayer`, enjambre de plaga vía `MultiMeshInstance2D`, 2 Máquinas, hasta 6 segmentos visibles de Silo, Almacén, Refugio, y hasta 10 ítems de Decoración/Confort simultáneos). En vez de programar un segundo spike separado, se amplía este mismo spike para incluir una **escena de prueba combinada**: automatización a techo de entidades + el contenido completo de `farm-economy-system.md` al tier de Vertical Slice, ambos simultáneos en pantalla — es el escenario de carga real que el juego produce una vez que Vertical Slice añade la capa de granja sobre la automatización del MVP, y es más exigente (y más honesto de medir) que cualquiera de los dos por separado. Un spike que solo probara automatización, o solo granja, podría pasar individualmente y aun así reventar el presupuesto de 16.6ms/<100 draw calls en el caso combinado real
- [ ] Decompose concept into systems (`/map-systems`)
- [ ] Spike técnico dedicado: descubrimiento de red local entre 2 dispositivos reales (peer discovery, permisos iOS Red Local/Bonjour, multicast lock/aislamiento de AP en Android, comportamiento ante pérdida del host) — **bloqueante antes de `/create-architecture`**
- [ ] Spike técnico dedicado: patrón de botón de acción único y contextual en pantalla táctil real (tamaño de objetivo, auto-oclusión, toque vs. arrastre, paneo/zoom de cámara, aviso/estado del compañero cross-device) — **bloqueante antes de `/create-architecture`**
- [ ] Design each system (`/design-system [system-name]`) — usar aprendizajes del prototipo en Tuning Knobs y Formulas
- [ ] Run `/create-architecture` — solo después de que los tres spikes técnicos de arriba resuelvan sus preguntas abiertas
- [ ] Build vertical slice in Pre-Production (`/vertical-slice`) — validar el loop completo antes de comprometerse a Producción
- [ ] Validate core loop with playtest (`/playtest-report`)
- [ ] Plan first milestone (`/sprint-plan new`)
