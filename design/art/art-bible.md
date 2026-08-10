# Art Bible: Rincón Compartido

## Document Status
- **Version**: 1.0
- **Last Updated**: 2026-08-10
- **Owned By**: art-director
- **Status**: Completo — las 9 secciones autoradas y aprobadas por el usuario en esta sesión
- **AD-ART-BIBLE (Art Director Sign-Off)**: omitido — modo de revisión `lean` (no hay
  `production/review-mode.txt`, por defecto lean; en modo lean el gate AD-ART-BIBLE no es
  PHASE-GATE y se salta, per `.claude/docs/director-gates.md`)

## Referencias de partida (de `game-concept.md` + añadidas en esta sesión)
- Junkyard Tycoon — vista 2D/isométrica, sensación de "chatarra a imperio"
- My Time at Sandrock — economía + co-op
- Techtonica — automatización + co-op
- My Little Universe — añadida en esta sesión

---

## 1. Visual Identity Statement

**Regla visual (una línea)**: Rincón Compartido se lee como un diorama de juguete despertando: formas
redondeadas, cálidas y de borde suave, donde el salto de tierra vacía a una operación conjunta y
próspera se lee de un vistazo — tomamos el arco de transformación de Junkyard Tycoon pero lo
renderizamos con la suavidad de juguete de My Little Universe, nunca con su crudeza industrial.

**Principio 1 — Cambio de material crudo→construido** (Pilar 4, Crecimiento visible). Los elementos
sin transformar (parcelas vacías, terreno sin tocar) se mantienen mate, desaturado, de bajo detalle;
cada nivel de construcción o mejora añade saturación, brillo y volumen redondeado, para que el ojo
distinga "construido" de "sin construir" sin tener que leer un número.
*Test de diseño*: si una mejora puede mostrarse solo como cambio de estadística o como un cambio
visible de material/color, elegimos el cambio visible.

**Principio 2 — Un solo lienzo compartido, sin territorio de color por jugador** (Pilar 1, Compartido
no dividido). La parcela, el Silo y el Refugio se leen como una sola estructura unificada con un solo
lenguaje de color — sin teñido por jugador, paneles divididos, ni señales de "mi lado/tu lado".
*Test de diseño*: si un layout puede visualmente separar las contribuciones de los dos jugadores o
fundirlas en una sola construcción compartida, elegimos fundirlas.

**Principio 3 — Silueta clara sobre detalle fino** (Pilar 3, Fricción cero, decisión sí). Todo objeto
interactivo (máquinas, cultivos listos, telegraphs de amenaza) debe ser identificable por silueta y
color solos a tamaño miniatura en pantalla de móvil; el detalle de superficie es secundario y
prescindible.
*Test de diseño*: si el detalle fino compite con la claridad de silueta a primer vistazo, elegimos la
silueta.

*(Resuelve la tensión entre referencias explícitamente en vez de promediarlas: el arco narrativo de
transformación viene de Junkyard Tycoon —crudo → construido como la historia visual central—, pero el
lenguaje de forma/color/material se compromete por completo con la suavidad de juguete de My Little
Universe — sin suciedad de chatarra, sin paleta de wasteland árida. Esto mantiene la estética coherente
con Fellowship (1) y Discovery (3) como prioridades MDA más altas, y con el anti-pilar contra el
combate — no hace falta un registro visual de "supervivencia dura".)*

> **Aprobado por el usuario, 2026-08-10.**

## 2. Mood & Atmosphere

*Nota de forma*: juego 2D top-down para móvil — "iluminación" aquí significa grading de color/tinte
ambiental/tratamiento de highlights sobre sprites, no iluminación 3D real.

**1. Loop cotidiano de construcción/cosecha** (la mayoría del tiempo de juego)
Emoción: contento, orgullo suave, "trastear en el jardín."
Tratamiento: tinte ambiental cálido neutro (lavado suave crema/ámbar sobre los sprites), parejo y de
bajo contraste — sin sombras compitiendo por atención, highlights solo en elementos "construidos"
brillantes (Principio 1).
Adjetivos: acogedor, soleado, sin prisa, táctil, sano.
Energía: medida / contemplativa. Es la línea base de la que todo lo demás se desvía.

**2. Pre-alerta de amenaza (0.5s)**
Emoción: un parpadeo de alerta, no miedo — "¿se movió algo?"
Tratamiento: un pulso de desaturación rápido sobre todo el lienzo (el tinte cálido se drena hacia gris
neutro por un instante) más un parpadeo de contorno azul-blanco frío solo en la parcela amenazada. Sin
rojo todavía — el rojo se reserva para el estado 3.
Adjetivos: silencioso, punzante, con la respiración contenida, breve.
Energía: pico agudo pero de menos de un segundo — un respingo, no un estado en el que se instala.

**3. Ventana de amenaza activa**
Emoción: urgencia hacia un objeto compartido, no peligro personal — "protegerlo", no "sobrevivir".
Tratamiento: luz de borde pulsante localizada, de frío a ámbar, en la parcela afectada (el resto del
lienzo se mantiene cálido/normal para que la amenaza se lea como espacialmente contenida, nunca como un
lavado de peligro a pantalla completa — esto preserva el Pilar 5: "riesgo a la inversión, no al
jugador"). El ritmo del pulso se acelera conforme se acaba el tiempo.
Adjetivos: urgente, que se estrecha, zumbante, contenido, accionable.
Energía: frenética pero acotada — el pico de energía es local, el resto del lienzo se mantiene en calma
para no saturar de pánico un juego táctil.

**4. Amenaza prevenida**
Emoción: alivio, pequeño triunfo, "lo logramos juntos."
Tratamiento: destello-bloom brillante y totalmente saturado en la parcela (sobreexposición breve de
highlight, dorado cálido), que vuelve a la línea base en ~1s.
Adjetivos: brillante, ágil, gratificante, resuelto.
Energía: pico rápido y liberación — un "pop" satisfactorio, no una celebración prolongada (eso se
reserva para hitos).

**5. Amenaza NO prevenida / parcela dañada**
Emoción: un encogimiento de hombros, no vergüenza — "bueno, pasó, a arreglarlo."
Tratamiento: la parcela se desatura a un gris-marrón apagado (coincide con la paleta de "material
crudo" del Principio 1 pero a la inversa — regresión, no castigo), sacudida de cámara suave (2-3
frames, amplitud pequeña), sin flash rojo, sin pico de contraste duro.
Adjetivos: apagado, decaído-pero-suave, sobrio, temporal.
Energía: baja hacia lo contemplativo — un amortiguamiento, nunca un golpe negativo brusco.

**6. Reparación / recuperación**
Emoción: anticipación paciente, "se está sanando."
Tratamiento: degradado de frío a cálido que va subiendo durante unos segundos (brillo "sanador"
verde-azulado pálido superpuesto que se funde con el ambiente cálido normal al completarse),
resplandor de progreso pulsante suave.
Adjetivos: gradual, calmante, esperanzador, restaurador.
Energía: medida, subiendo con suavidad — refleja el regreso de la calma del loop.

**7. Hito desbloqueado**
Emoción: deleite, orgullo, impulso hacia adelante.
Tratamiento: estallido de chispas doradas + subida breve de brillo de pantalla completa solo en el
aviso/toast (el lienzo debajo se mantiene normal para no interrumpir el juego).
Adjetivos: chispeante, generoso, afirmativo, momentáneo.
Energía: un pico feliz, más corto y suave que el flash del estado 4 — celebratorio, no urgente.

> **Aprobado por el usuario, 2026-08-10.**

## 3. Shape Language

**1. Avatares.** Proporciones chibi de juguete (cabeza grande, extremidades redondeadas y cortas,
contorno grueso de 3-4px) — silueta lo bastante marcada para leerse como "una persona" a escala
miniatura, coherente con el diorama-figurita del Principio 1. Distintivo entre J1/J2: **no color** —
el Principio 2 reserva la paleta para señalizar el estado compartido del mundo, no la identidad del
jugador; sobrecargarla con un tinte por jugador difuminaría ese lenguaje. En su lugar, un accesorio a
nivel de silueta distingue a cada uno (p. ej. J1 = sombrero redondeado, J2 = pañuelo redondeado) —
identidad basada en forma, no en tono, que se mantiene legible (incluido para daltonismo) sin competir
con la gramática de color del entorno.

**2. Geometría del entorno.** Vocabulario dominante: primitivas geométricas suaves (rectángulos
redondeados, círculos, cápsulas), con curvatura orgánica reservada solo para el follaje de los
cultivos en pleno florecimiento. Primitivas limpias mantienen nítido el contraste crudo→construido del
Principio 1 — ruido orgánico por todas partes diluiría la legibilidad de cambio de estado de la que
depende todo el juego.
- *Cultivos:* siluetas distintas, no solo colores distintos — Trigo = racimo de espigas verticales
  finas, Maíz = tallo único alto con copete redondeado, Fresa = racimo bajo de montículos redondeados.
  Sirve al Pilar 3 (lectura a escala miniatura).
- *Silo:* segmentos de tambor apilados y redondeados — crecimiento literalmente visible por tier,
  Pilar 4.
- *Máquinas:* cuerpos geométricos robustos (sembradora = embudo superior tipo caja; cosechadora =
  brazo giratorio redondeado), colocadas de forma permanente junto al Taller — nunca íconos de menú
  abstractos, según el Pilar 4.
- *Enjambre de plaga (requiere cuidado)*: se recomienda apartarse de los "triángulos oscuros"
  literales del GDD — los triángulos afilados se leen como flechas/colmillos, lo cual roza la
  iconografía de combate. Se propone en su lugar formas suaves de gota/diamante redondeado, en tono
  oscuro mate desaturado, moviéndose como una nube dispersa y arremolinada (movimiento de enjambre de
  mosquitos) en vez de una falange que converge. Se lee como "molestia ambiental a la cosecha", nunca
  como "enemigo" — protege el Pilar 5 (Anti-Combate) a nivel de forma, no solo de animación.

**3. Gramática de forma de la UI.** La UI ecoa el lenguaje de juguete de esquinas redondeadas y borde
grueso del mundo (reforzando "un solo objeto compartido", Pilares 1/2), pero se mantiene más plana y
simple — siluetas de ícono sólidas, sin bisel ni degradado — para que los objetivos táctiles se lean al
instante. Misma familia, menos ornamento, al servicio del requisito de fricción cero del Pilar 3.

**4. Formas protagonistas vs. formas de apoyo.** Loop en calma: los cultivos creciendo y el Silo son
las formas protagonistas (las más grandes, más saturadas, más animadas). Evento de amenaza: el borde
pulsante de la *parcela amenazada únicamente* se convierte en la única forma protagonista, todo lo
demás retrocede visualmente — coherente con "riesgo a la inversión, no al jugador" (Pilar 5). La
decoración (vallas, banderas, carteles) se mantiene de línea fina, escala pequeña, baja saturación —
siempre subordinada visualmente a las formas rellenas y robustas de los objetos funcionales.

> **Aprobado por el usuario, 2026-08-10.**

## 4. Color System

**Conflicto resuelto (documentado, no elegido en silencio)**: el texto del GDD dice "parpadeo rojo
tenue" para la pre-alerta de plaga. La Sección 2 (ya aprobada) lo había cambiado a azul-blanco frío
para que nunca se lea como combate/peligro (Pilar 5). Se mantiene esa decisión aquí — además resuelve
un problema en cascada: libera el **rojo** por completo para la identidad de la Fresa (ver abajo),
dándole al cultivo de mayor riesgo una lectura visual "caliente" sin que choque nunca con un estado de
amenaza. Si en el futuro se prefiere volver a rojo para la pre-alerta, hay que revisar también la
identidad de color de la Fresa.

**Paleta primaria — 7 roles**
1. **Crema/Ámbar cálido** — línea base. Lavado ambiental del loop cotidiano; "todo está bien."
2. **Gris-marrón mate (umbra desaturada)** — crudo/regresado. Marchita, Dañada, y (por el Principio 1)
   cualquier cosa sin construir/sin comprar en la UI.
3. **Dorado saturado** — éxito/finalización. Pulso de Lista, flash-bloom de Prevenida, destello de
   hito. Un solo tono, reusado en todo momento de victoria compartida — entrena al jugador a leer
   "dorado = resultado económico bueno", punto.
4. **Azul-blanco frío** — atención, no peligro. Solo el parpadeo de pre-alerta.
5. **Verde-azulado pálido (menta)** — recuperación en curso. Estado Reparando; distinto del dorado
   (recuperándose ≠ ya logrado).
6. **Rojo Fresa (rojo cálido)** — reservado exclusivamente para la identidad del cultivo de fresa.
   Deliberadamente el *único* rojo del sistema, con su lectura "especial/riesgosa" propia sin significar
   nunca peligro.
7. **Pizarra neutra** — utilitario. Máquinas (Sembradora, Cosechadora), carcasas de infraestructura
   (Silo, Almacén, anillo del Refugio). Emocionalmente inerte a propósito, para que nunca compita con
   las señales de estado.

**Cultivos**: Trigo = tostado/ocre apagado; Maíz = amarillo-naranja soleado y brillante; Fresa = rojo
cálido (arriba). La decoración se mantiene dentro de la familia pizarra/crema, baja saturación,
subordinada a todo lo anterior.

**Vocabulario semántico**: dorado=recompensa, crema=calma, azul-blanco=alerta-no-peligro,
menta=sanando, gris-marrón=regresado-no-avergonzado, rojo=solo-Fresa. El HUD de dinero usa la familia
dorado/crema como un solo tratamiento compartido — nunca chips de color por jugador (Pilar 1).

**Paleta de UI**: reutiliza los tonos del mundo a mayor saturación/contraste para legibilidad táctil,
en vez de inventar tonos nuevos — dorado=asequible/confirmar, gris-marrón=todavía-no-asequible (de
nuevo, metáfora de material crudo, no un "no" rojo alarmante). Un solo vocabulario consistente entre
mundo e interfaz.

**Seguridad para daltonismo — riesgos reales**:
- Trigo vs. Maíz (ambos de familia amarilla): respaldo = siluetas de cultivo distintas (ya exigido en
  la Sección 3).
- Rojo Fresa vs. gris-marrón de Marchita/Dañada (el rojo puede desaturarse hacia marrón en deficiencia
  rojo-verde): respaldo = silueta (fresa madura vs. parcela agrietada/marchita) + animación (pulso de
  brillo de la Fresa vs. textura de grieta estática).
- Dorado vs. menta (recuperación vs. éxito): respaldo = overlay de ícono de herramienta de Reparando +
  ritmo de pulso distinto (suave vs. destello).

> **Aprobado por el usuario, 2026-08-10** (incluyendo la resolución del conflicto rojo/azul-blanco de
> pre-alerta documentada arriba).

## 5. Character Design Direction

**5.1 Arquetipo y vibra.** Los dos avatares se leen como figuritas de juguete talladas en madera —
mismo lenguaje material de "diorama de juguete" que el mundo (Sección 1), pero los avatares se quedan
en un acabado cálido, mate y constante en vez de seguir el arco de saturación crudo→construido (ese
arco pertenece a la granja, no a los jugadores). Piénsalo como Fisher-Price robusto encontrándose con
la suavidad de Animal Crossing: panzas redondas, manos tipo manopla rechonchas, sin articulaciones
visibles — los cuerpos se leen como una sola forma continua y suave. La personalidad viene de la
postura, no del detalle: una leve inclinación hacia adelante transmite entusiasmo/disposición, no
rigidez de reposo.

**5.2 Rasgos distintivos.** Mantener el intercambio de accesorio (sombrero/pañuelo) como el *único*
eje de identidad por ahora — deliberadamente mínimo. Se recomienda NO añadir un sistema de
personalización en este alcance: suma costo de multiplicación de assets (cada accesorio necesita
variantes de silueta en reposo/sosteniendo/plantando/cosechando) sin servir directamente a Fellowship
(prioridad 1) ni Sensation (prioridad 5). Se marca como idea de "lote de estacionamiento": un accesorio
desbloqueable por hito (p. ej. un segundo estilo de sombrero) podría funcionar más adelante como
recompensa de progresión co-op, pero está fuera de alcance para el presupuesto de arte del MVP.

**5.3 Objetivo de expresión/pose: exagerado, no rígido ni realista.** Con solo 2 avatares en pantalla
en todo momento, el presupuesto permite fidelidad de pose generosa por personaje: squash-and-stretch en
las acciones de plantar/cosechar, una pose distinta de "alerta" (brazos arriba) para eventos de
amenaza, y una pose compartida de "hito" (salto + accesorio inclinado) — estos son los momentos de
Fellowship donde la expresividad vende el momento cooperativo.

**5.4 Filosofía de LOD.** A la escala de cámara de granja (avatar de ~48-64px en pantalla, distancia
tipo Stardew/My Little Universe), solo sobreviven silueta + accesorio + un acento de tono de piel +
ojos grandes tipo punto. Sin detalle facial renderizado — la expresión se comunica por la pose de todo
el cuerpo, no por la cara.

> **Aprobado por el usuario, 2026-08-10.**

## 6. Environment Design Language

**1. Historia implícita.** El entorno se lee como un *terreno recuperado, no una ruina*. Nada aquí está
roto sin remedio — está dormido, descuidado, a la espera. Señales visuales: superficies desteñidas por
el sol (no agrietadas), parches de maleza crecida pero ordenada, un único cartel tipo "SE VENDE"
inclinado, repintado con el tiempo. Conforme suben los tiers, aparecen detalles de parche-y-remiendo
(veta de madera nueva sobre un poste viejo, borde de pintura fresca sobre gris) en vez de reemplazo —
contándole al jugador *este lugar se arregló*, no se demolió y reconstruyó. Coincide directamente con
la Core Fantasy: el trabajo cooperativo convirtiendo el descuido en orgullo.

**2. Filosofía de textura: pintado plano (flat-shaded).** Campos de color pintados a mano con 1-2
bandas de degradado suave horneadas por superficie (aspecto tipo juguete/gouache) — sin mapas PBR, sin
texturas de normal/roughness, sin iluminación dinámica en tiempo real sobre los props.
- *Encaje de presupuesto*: los materiales unlit de sombreado plano se agrupan limpiamente en atlas
  compartidos, mantienen bajos los draw calls, y evitan el costo de iluminación por píxel — crítico
  para el presupuesto móvil de 16.6ms/<100 draw calls.
- *Encaje de estilo*: coincide con "diorama de juguete" — los objetos deben verse como juguetes
  pintados de madera/resina bajo luz de día real, no materiales simulados físicamente.

**3. La densidad de props escala con la saturación.** La densidad es la gemela física de la regla de
paleta crudo→construido de la Sección 1:
- **Inicio de 2 parcelas**: disperso — tierra desnuda, 1-2 props gris-marrón desaturados, suelo
  expuesto, silencio en la composición.
- **6 parcelas construidas del todo**: denso — vallas en capas, banderas, Silo de 6 segmentos completo,
  ambas Máquinas colocadas, acentos de menta/dorado dispersos. Nunca caótico — la densidad aumenta en
  tiers discretos ligados a compras, dejando siempre libres los caminos de paso compartidos (es un
  espacio co-op caminable, no un menú).

**4. Narrativa ambiental (sin texto)**:
- *Señal de crecimiento*: los parches de tierra ganan franja de hierba y piedritas pintadas pequeñas
  solo después de su primera cosecha exitosa — prueba visual de "esta tierra se ha trabajado."
- *Parcelas bloqueadas*: gris pizarra mate, con reja prolija (no rota/quebrada), con una "silueta
  fantasma" de contorno suave de una parcela sin plantar debajo del ícono de candado — se lee como
  *potencial*, no castigo, coherente con el tono no punitivo del juego.
- *Anillo del Refugio*: círculo `Line2D` en menta suave, animando un pulso gentil solo cuando está
  protegiendo activamente — causa y efecto visibles sin texto de UI.

> **Aprobado por el usuario, 2026-08-10.**

## 7. UI/HUD Visual Direction

**1. Diegético vs. pantalla-fija.** Todo lo que sea *señal de estado del mundo* (brillo de cultivo,
borde de amenaza, anillo del Refugio) permanece diegético — ya resuelto en Secciones 2/6, no se
duplica en HUD salvo el refuerzo de texto que ya exige el GDD ("señal doble siempre"). Solo tres
elementos necesitan capa de pantalla-fija real: el contador de dinero compartido (visible siempre,
esquina superior, sin atribución por jugador — Pilar 1), los menús de compra (Taller), y los toasts de
hito. El botón de acción contextual NO es HUD — vive anclado al mundo/pulgar, no a un panel de
pantalla, para que nunca compita visualmente con el objeto que está tocando.

**2. Tipografía.** Familia redondeada de trazo grueso y bajo contraste (tipo "toy/rounded sans", peso
Bold/ExtraBold para cifras y etiquetas de botón) — ecoa el borde grueso de la Sección 3 sin ser
infantil-descuidada. Jerarquía de 3 niveles: dinero y precios de compra (más grande, siempre Bold),
etiquetas de ítem/hito (medio, Semibold), texto de apoyo/descripciones en menú de compra (más pequeño,
Regular, uso mínimo). Mínimo 14pt efectivo en pantalla táctil de referencia — nunca sacrificar
legibilidad por estética.

**3. Iconografía.** Siluetas sólidas planas, un solo color de relleno + contorno grueso opcional, sin
bisel/degradado/sombra — extensión directa de la regla de la Sección 3. Los íconos de máquinas/
infraestructura en el menú de compra son versiones simplificadas y frontales de sus sprites de mundo
(mismo objeto, menos detalle), nunca un pictograma abstracto genérico — refuerza el Pilar 4 (el ítem
que compras es el que ves construirse).

**4. Animación de UI.** Rebote corto y contenido (overshoot pequeño, ~150-200ms) en confirmaciones de
compra y aparición de toasts — transmite "sí, funcionó" sin fricción de espera; el menú de compra
abre/cierra con deslizamiento+fundido rápido (~120ms), nunca instantáneo-seco (se sentiría frío) ni
lento (rompe Fricción Cero). Toast de hito: entra con rebote suave, sale con fundido simple — sin
fanfarria que bloquee.

**5. Conflicto encontrado y resuelto en esta sección (hallazgo de `ux-designer`, no resuelto en
silencio)**: la regla de "sin bisel/degradado/glow" de la Sección 3, aplicada a la alerta de amenaza,
dejaba el aviso dependiendo *solo* de color (azul-blanco) — arriesgado dado que la ventana de reacción
es corta (0.5s de pre-alerta, hasta apenas 4s en Fresa) y no todos los jugadores perciben el color
igual. **Resuelto**: la pre-alerta añade un cambio de *forma*, no solo de color — el ícono/silueta de
la parcela pulsa con un contorno que se engrosa brevemente (grosor, no brillo/bisel, para no romper la
regla plana), sincronizado con el parpadeo azul-blanco. Esto da una señal redundante forma+color+tiempo
sin añadir un nuevo lenguaje visual.

**6. Trade-off documentado explícitamente (no implícito)**: reservar el rojo exclusivamente para la
Fresa (Sección 4) rompe la convención casi universal de "rojo = peligro/alto". Se acepta este trade-off
a propósito — el Pilar 5 exige que ninguna amenaza se lea como peligro personal, así que el vocabulario
de alerta de este juego (azul-blanco + cambio de forma, punto 5 arriba) reemplaza intencionalmente al
rojo convencional. Cualquier futura adición de UI que "necesite rojo" para alertar debe primero
confirmar que no está reintroduciendo una lectura de peligro/combate que el juego evita a propósito.

**7. Estado "silo lleno"**: requiere un tratamiento de ícono/movimiento dedicado, distinto de los 7
colores de estado del mundo (reutilizar cualquiera de ellos causaría colisión de significado) —
localizado exactamente sobre la parcela tocada, no solo en un ícono de esquina de HUD (ya exigido por
el GDD tras una ronda de revisión anterior que encontró el ícono de esquina insuficiente).

**8. Menús no bloqueantes**: los menús de compra (Taller) deben ser no-modales — parcialmente
transparentes o anclados a un borde de pantalla, nunca a pantalla completa — porque las amenazas siguen
corriendo mientras el menú está abierto.

**9. Placeholder para el estado del compañero (pendiente del spike de UX táctil, no se diseña aquí)**:
se reserva desde ya un único hueco visual persistente y pequeño — un glyph de "presencia del
compañero" (ícono + un color de estado) que sea agnóstico de significado respecto a la paleta de la
Sección 4, para no precomprometer qué va a significar antes de que el spike de UX táctil decida el
mecanismo real. Nada de chrome de pantalla compartida ni marcado de propiedad — coherente con el
Pilar 1.

> **Aprobado por el usuario, 2026-08-10** (incluyendo la resolución del conflicto de señal
> forma+color en el punto 5 y el trade-off documentado en el punto 6).

## 8. Asset Standards

### Estándares de dirección artística

**1. Formatos de archivo.** PNG (8-bit, indexado o RGBA según haga falta) para todos los sprites — el
estilo pintado plano no tiene degradados que requieran precisión de 16-bit, y no hay mapas PBR (nunca
exportar normal/roughness/metallic). Los anillos de suelo (`Line2D`) y decoraciones vectoriales se
autoran como datos de escena, no texturas. Sin formatos con pérdida (JPG) para nada con bordes de
silueta duros — el estilo diorama-de-juguete depende de contornos nítidos.

**2. Convención de nombres** (adaptada del patrón base `[categoría]_[nombre]_[variante]_[tamaño]`):
- Cultivos: `crop_[trigo|maiz|fresa]_stage[0-3]_[keyframe].png`
- Estructuras: `struct_[silo|refugio|shed|sembradora|cosechadora]_[estado]_[variante].png`
- Avatares: `char_avatar[01|02]_[accesorio]_[pose].png`
- Decoración: `deco_[fence|flag|sign]_[variante].png`
- UI: `ui_icon_[nombreobjeto]_[estado].png` (los íconos de menú de compra comparten nombre base con el
  objeto de mundo que reflejan, p. ej. `struct_silo` → `ui_icon_silo`)
- VFX: `vfx_pest_[forma]_[frame].png`

**3. Tiers de resolución (objetivo, antes de aplicar el techo técnico de abajo)**:
- Tier A (héroe/escalado frecuente): avatares, máquinas — el más alto
- Tier B (frecuencia media, escala de parcela): cultivos, segmentos de silo, cobertizo, anillo de
  refugio — un escalón abajo
- Tier C (pequeño/decorativo): vallas, banderas, carteles, partículas de plaga — el más pequeño
- Tier D (íconos de UI): cuadrado fijo, pipeline distinto de los sprites de mundo (se leen a escala de
  UI, no de mundo)

**4. LOD.** Sin LOD 3D tradicional — cámara fija top-down, sin zoom. "LOD" aquí significa cantidad de
keyframes por animación, siguiendo el precedente de crecimiento de la Sección 1: cultivos con 3-4
keyframes por etapa, máquinas con 2-3 frames de reposo, enjambre de plaga con el mínimo de frames
posible (pooled, así que consciente del presupuesto).

**5. Filosofía de exportación.** Empaquetado en atlas/sprite-sheet por categoría (un atlas: cultivos,
uno: estructuras, uno: UI) — el arte plano de paleta limitada comprime bien y el atlas sirve al
presupuesto móvil de <100 draw calls. Archivos individuales solo durante la autoría; el empaquetado en
atlas ocurre en la exportación vía el pipeline de importación de Godot.

### Techos técnicos (`technical-artist`, verificar contra Godot 4.7.1 antes de implementar)

**⚠ Riesgo de versión**: la 4.7 cambió el comportamiento de velocidad angular de partículas y añadió
`process_time_residual` a `GPUParticles2D.request_particles_process()` (afecta el movimiento exacto del
enjambre pooled), y la 4.6 rehizo el sistema de Glow. Ambos puntos marcados para verificación, no
afirmados como hecho — ver `docs/engine-reference/godot/VERSION.md`.

**1. Techos de sprite/animación**:
- Atlas de mundo compartido: una sola hoja de 2048×2048 comprimida ETC2/ASTC por categoría mayor
  (cultivos+parcelas, estructuras, personajes, UI) — 4096 funciona en muchos dispositivos pero no está
  garantizado en GPUs Android de gama baja, así que 2048 es el techo seguro.
- Nodos `AnimationPlayer` animando a la vez: parcelas(6) + máquinas(2) + avatares(2) = 10 nodos
  activamente animados es el techo real; la decoración debe ser estática/solo-reposo.
- Enjambre pooled: tope de 6 nodos `GPUParticles2D` en total (uno por slot de parcela, reutilizado/
  alternado, nunca instanciado por evento), cada uno con tope de ~32-64 partículas → peor caso ~384
  partículas en vuelo. Recomendado perfilar en el dispositivo de referencia de gama baja real antes de
  fijar el número, dado el cambio de API de partículas de la 4.7 mencionado arriba.

**2. Memoria de texturas** (del techo de 512MB, sin assets 3D compitiendo):
- Recomendado ~35-40% (≈180-200MB) como presupuesto de textura VRAM comprimida, dejando margen para
  audio, renderizado de texto de UI, y datos en tiempo de ejecución. Es un techo a validar contra
  perfilado real en dispositivo, no una restricción física dura.

**3. Restricciones del renderer Compatibility/Mobile** (aviso a dirección de arte):
- Sin SSAO, sin SSR, sin niebla volumétrica (solo Forward+). Si algún concept art implica alguno de
  estos, es un conflicto a resolver ahora, no en producción.
- Las sombras de Light2D son costosas en móvil — recomendado tope de 0-2 luces con sombra en pantalla.
- Glow está soportado pero se rehizo en la 4.6; tratar cualquier concepto de VFX con glow intenso como
  necesitado de reajuste/verificación, posiblemente un fake-bloom por sprite más barato en su lugar.

**4. <100 draw calls — el riesgo real**: el batching 2D solo fusiona draws consecutivos de la misma
textura/material — **el Y-sort rompe el batching** por nodo intercalado. Requisito concreto: todas las
parcelas/máquinas/silo/decoración/avatares deben compartir un atlas + un material de canvas (sin
materiales únicos por nodo) para que el batching sea posible; la UI en su propio `CanvasLayer`,
presupuestada aparte (~15-20 draws). **Recomendado como historia de seguimiento**: una escena de prueba
de batching antes de escalar la producción de arte — ver `farm-economy-system.md` Apéndice A #11 y
Dependencies, que ya identifican que el spike de rendimiento combinado (automatización + contenido de
granja) todavía no se ha ejecutado; este requisito de batching debería formar parte de ese mismo spike.

> **Aprobado por el usuario, 2026-08-10.**

## 9. Reference Direction

**1. My Little Universe** — *elemento*: legibilidad de silueta a escala miniatura. En pantalla de
móvil, los objetos de MLU se leen al instante porque el bloque de color hace el trabajo, no el
lineart interno — crítico porque esto fija la restricción táctil-móvil que las Secciones 1/3/4/6 ya
asumían pero nunca nombraron directamente. Úsalo para probar cada asset: ¿se sigue leyendo a 1cm en un
teléfono? *Evitar*: su tileado procedural de terreno voxel/blob — nuestro terreno es un espacio fijo,
autorado a mano, no una cuadrícula generada.

**2. Junkyard Tycoon** — *elemento*: el arco de transformación crudo→construido (Sección 1) como
lenguaje *material*, no como mood. Se reafirma aquí solo como el hilo conductor que todos los estados
de assets deben obedecer. *Evitar*: su mugre, sus overlays de manchas de óxido, y su grading de color
industrial de chatarrería por completo — tomamos el arco, no la textura.

**3. My Time at Sandrock** — *elemento*: narrativa de remiendo visible — parches acolchados, veta de
madera nueva puesta sobre una forma vieja deformada, un objeto reparado que conserva su silueta
anterior. Esta es la técnica concreta para el principio de la Sección 6 "terreno recuperado, no
ruina". *Evitar*: las proporciones semi-realistas de Sandrock y su paleta apagada y polvorienta fuera
de nuestras zonas de desaturación de material crudo — el remiendo se muestra por contraste de color
(viejo/apagado vs. nuevo/parche), no por un mundo entero en gris.

**4. Techtonica** — gana su lugar solo por poco. Es un juego 3D sci-fi voxel, tonalmente opuesto a
nosotros — pero su única idea transferible es real: las máquinas comunican estado (en reposo/
trabajando/bloqueada) mediante pulsos visibles sobre el propio objeto, no un ícono flotante. Esto sirve
directamente al mandato de UI diegética de la Sección 7. *Evitar*: todo lo demás — paleta fría, encuadre
en primera persona, materiales industriales. Tratar esto como una sola técnica prestada, no como
referencia de mood.

**5. Propuesta añadida — Overcooked (la serie)** — *elemento*: legibilidad a pantalla compartida bajo
caos visual; los dos personajes deben seguir siendo distinguibles al instante por silueta/accesorio
incluso cuando el cuadro está ocupado, reforzando la regla de accesorio-no-color de la Sección 3 para
nuestro único lienzo compartido. *Evitar*: su sacudida de cámara slapstick y su renderizado cómico
hipersaturado — nosotros nos mantenemos contemplativos y cálidos, nunca frenéticos.

> **Aprobado por el usuario, 2026-08-10.**
