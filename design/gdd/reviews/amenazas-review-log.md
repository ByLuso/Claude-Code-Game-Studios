# Review Log — `design/gdd/amenazas.md`

## Review — 2026-08-11 — Verdict: NEEDS REVISION (ronda 1)
Scope signal: no registrado en esta ronda (introducido como campo formal desde ronda 3)
Specialists: game-designer, systems-designer, qa-lead, art-director, ux-designer, network-programmer, creative-director (síntesis)
Blocking items: 7 | Recommended: 10
Summary: Primera revisión independiente del framework recién extraído. Bloqueantes principales:
invariante de instanciación obligatorio para `coste_no_prevenir` (evita estrategia dominante fija),
techo duro en `amenaza_interval` (el "riesgo futuro" documentado en la autoría era en realidad un
defecto presente a n=30), Core Rule 11 nueva declarando la coordinación cross-device ("yo la tengo")
como dependencia dura y bloqueante del spike de UX táctil, severidad-en-resolución (Core Rule 6)
ampliada para exigir una señal observable en tiempo real (no solo confirmable al final), corrección de
una contradicción cruzada real con `farm-economy-system.md` sobre la forma de la plaga ("triángulos
oscuros" vs. el teardrop/diamante ya aprobado por el art bible), contrato RPC ampliado con
`duracion_ventana` y reloj compartido del host, y AC-1/AC-5/AC-6 reescritas para ser realmente
testables. Tres desacuerdos de especialistas adjudicados por el usuario: cooldown global se mantuvo
(se corrigió el Player Fantasy en su lugar), free-riding se mantuvo como nota no bloqueante, y el
anticlimax de Reparar se resolvió con un arreglo de audio en vez de reabrir Core Rule 8.
Prior verdict resolved: Primera revisión.

## Review — 2026-08-11 — Verdict: NEEDS REVISION (ronda 2)
Scope signal: no registrado en esta ronda
Specialists: mismos 6 especialistas de ronda 1 + creative-director (síntesis) — misma sesión reviewer reutilizada, nunca autoró el documento
Blocking items: 7 | Recommended: 0 nuevos bloqueantes, varios recomendados cerrados como "baratos"
Summary: Segunda ronda, todos los especialistas de acuerdo esta vez (sin desacuerdos que adjudicar).
El diagnóstico del creative-director: todo lo que falló se agrupó en un solo eje — los ítems
diferidos a un spike (red o UX táctil) carecían de la misma visibilidad/rigor en ambos lados. Los 7
bloqueantes: banner de header reescrito con paridad estructural entre los 2 spikes; nueva AC-17
(coordinación cross-device excluida de QA, mismo tratamiento que AC-9/AC-16); default de pérdida de
host aclarado ("sin daño Y sin cobro"); piso de área táctil 44×44pt/48×48dp para el botón de acción;
RNG de selección de entidad declarado inyectable; AC-1 reescrita con umbral estadístico concreto
(chi-cuadrado, p>0.05) en vez de "no sistemáticamente sesgada"; AC-6 con alcance local explícito
(verificado sobre el host, sincronía cross-device diferida al spike de red). También se cerraron
varios recomendados baratos (justificación del piso de 70s, limpieza de Open Question obsoleta,
referencia cruzada de Core Rule 2, nota de diseño deliberado sobre el RPC descartado en silencio,
AC-5 mejorada de muestreo de 3 puntos a cobertura por evento).
Prior verdict resolved: No — ronda 1 seguía NEEDS REVISION antes de esta ronda; las correcciones de
ronda 1 fueron el insumo de esta ronda, confirmadas parcialmente (ver ronda 3: la AC-1 estadística de
esta ronda resultó ser una regresión respecto a la regla de determinismo del proyecto).

## Review — 2026-08-11 — Verdict: NEEDS REVISION (ronda 3)
Scope signal: XL (7 dependencias, 2 fórmulas + 1 invariante cruzado, probable ADR de red dedicado)
Specialists: game-designer, systems-designer, qa-lead, art-director, ux-designer, network-programmer, economy-designer (primera vez en este documento), creative-director (síntesis)
Blocking items: 9 hallazgos individuales, consolidados por el creative-director en 4 causas raíz | Recommended: 12
Summary: Tercera ronda independiente — con ojos frescos, sin asumir que las correcciones de rondas
1-2 fueron suficientes solo por estar documentadas inline. Se verificaron y se encontraron 4 causas
raíz detrás de los 9 hallazgos bloqueantes: (1) una fila de Edge Cases sobre desconexión de host
duplicada y CONTRADICTORIA con otra fila sin tocar desde ronda 1 (encontrada independientemente por
3 especialistas distintos); (2) el invariante de instanciación de `coste_no_prevenir` resultó
matemáticamente insatisfacible en el límite `valor_en_riesgo=0` — un defecto de frontera que sobrevivió
2 rondas de revisión del mismo especialista (`systems-designer`) porque nadie recalculó el invariante
contra el rango que la propia tabla de variables declaraba válido; (3) el Player Fantasy ("yo la
tengo") no sobrevivía a la mecánica real: "primer RPC gana" excluía sistemáticamente al jugador de
peor latencia del momento de mayor tensión del juego, en every single amenaza; (4) varios fixes
locales de rondas 1-2 no se habían propagado a sus hermanos (AC-6 tenía alcance host-local pero
AC-2/3/4/5/7 no; el contrato RPC conflaba evento de disparo y de resolución; AC-1 rota por el propio
método estadístico introducido en ronda 2; el default de desconexión de host no tenía AC de
cobertura). El patrón identificado por el creative-director: las rondas 1-2 corrigieron la frase que
el reviewer citó, no la regla subyacente — de ahí que el mismo tipo de defecto (local, no barrido)
reapareciera 3 veces.

Correcciones aplicadas en esta misma sesión (excepción al patrón de sesiones separadas revisor/autor,
pedida explícitamente por el usuario — ver banner del Status header):
- Fila de desconexión duplicada eliminada; default unificado cubre host y no-host explícitamente (AC-18 nueva).
- Invariante acotado con precondición `valor_en_riesgo > 0`; segundo requisito de alcanzabilidad de t* formalizado (no solo nota).
- Nueva Core Rule 7b: ventana de simultaneidad de 150ms — decisión del usuario entre 3 opciones presentadas (vs. reescribir el Player Fantasy, vs. discutir otra alternativa). Nueva AC-19.
- Piso post-paneo de cámara de 3s para amenazas fuera de viewport (Core Rule 4 ampliada, AC-4 ampliada) — decisión del usuario entre 3 opciones presentadas.
- Barrido de alcance host-local aplicado a AC-2/3/4/5/7 (antes solo AC-6).
- AC-1 reescrita de test estadístico (chi-cuadrado) a test determinista de semilla fija — corrige una regresión de la propia ronda 2 contra la regla de determinismo del proyecto.
- Contrato RPC dividido en mensaje de disparo (sin `resultado`) y mensaje de resolución (con `resultado`); compensación de RTT/reloj declarada explícitamente sin resolver, no implícita.
- Mitigación de visibilidad de free-riding: Amenazas emite qué jugador respondió, para el futuro Panel de contribución — decisión del usuario de reabrir la escalada que ronda 1 había resuelto en contra (el economy-designer aportó el mecanismo concreto que faltaba entonces).
- Nueva AC-20 (pool contado pero sin objetivo elegible por almacenamiento lleno).
- Tabla de variables de `amenaza_interval` corregida (decía "sin tope", contradecía el techo duro documentado a su lado).
- Requisito de contraste para íconos Severo/Reducido; separación mínima de luminancia entre familias de forma elevada de "validar en playtest" a mandato; audio "timbre específico por tipo" reformulado como TBD explícito de `audio-director`.

Prior verdict resolved: Parcialmente — las correcciones de rondas 1-2 sí resolvieron lo que decían
resolver superficialmente, pero no fueron re-derivadas contra el resto del documento, lo que dejó
huecos de consistencia (ítem 1 y 4) y un defecto matemático sin detectar (ítem 2) hasta esta ronda.

**Nota de independencia**: esta ronda 3 fue revisada Y corregida en la misma sesión, rompiendo el
patrón de rondas 1-2 (sesión revisora separada de la sesión que corrige). Se recomienda una ronda 4
en sesión nueva no solo para confirmar las correcciones de ronda 3, sino para recuperar la
independencia revisor/autor que las rondas anteriores sí tuvieron.

## Review — 2026-08-11 — Verdict: NEEDS REVISION (ronda 4)
Scope signal: XL, sin cambios respecto a ronda 3
Specialists: 8 especialistas + creative-director (síntesis) — sesión nueva, recupera la independencia revisor/autor perdida en ronda 3
Blocking items: hallazgos en 4 de las propias correcciones de ronda 3, más defectos nuevos | Recommended: varios, ver commits
Summary: Cuarta ronda, en sesión fresca según lo recomendado al cierre de la ronda 3. Encontró que
varias correcciones de esa ronda no sobrevivían su propia verificación: Core Rule 2 (cooldown global)
medía el intervalo desde el DISPARO, pero el piso de 25s de `amenaza_interval` siempre excede el
cooldown de 15s — la regla nunca era la restricción activa, AC-2 verificaba algo que no podía fallar;
el invariante de instanciación de `coste_no_prevenir` con precondición `valor_en_riesgo > 0` seguía
siendo insuficiente en la práctica (Trigo, el ejemplo "validado" de rondas 1-3, no pasaba su propia
prueba de alcanzabilidad de t* bajo el ritmo real de disparo); el Player Fantasy reescrito en ronda 1
y ajustado en ronda 3 seguía describiendo un reparto de tareas ("yo la tengo") que la Core Rule 7b de
la propia ronda 3 ya no produce — ambos jugadores tocando a la vez es el resultado esperado y
correcto, no una rareza a proteger; y AC-1 (reescrita en ronda 3 a un test de semilla fija) probaba
el mecanismo incorrecto — una tolerancia de frecuencia empírica que ~80% de implementaciones
correctas fallarían por varianza normal, no un defecto real.

Correcciones aplicadas en esta misma sesión (segunda ronda consecutiva de auto-corrección — ver nota
de independencia abajo):
- Core Rule 2 redefinida: el temporizador del próximo disparo cuenta desde la RESOLUCIÓN de la
  amenaza actual, no desde el disparo — hace de AC-2 una restricción real y verificable.
- Core Rule 4: `tiempo_hasta_asentar_camara` declarado explícitamente Provisional pendiente del spike
  de UX táctil; nueva dependencia de Cámara/Viewport.
- Core Rule 7b aclarada: el host nunca retrasa el primer toque; el esquema de wire para atribución de
  cobro queda declarado sin resolver, no silenciosamente ausente.
- Player Fantasy reescrito por tercera vez: de "reparto de tareas" a "reflejo compartido y seguro
  mutuo" — describe honestamente lo que Core Rule 2 + 7b producen por diseño, en vez de prometer una
  coordinación que la mecánica no da.
- Invariante de `coste_no_prevenir`: el piso de `valor_en_riesgo` cambia de ">0" a un piso relativo
  de 3x el incremento más pequeño; se retracta la afirmación de rondas 1-3 de que Trigo estaba
  "validado" como plantilla, tras fallar su propia prueba de alcanzabilidad.
- AC-1 reescrita para probar el mecanismo de selección directamente, no una tolerancia de frecuencia empírica.
- Reparando ahora transiciona explícitamente a Normal; nueva AC-21 (reingreso al pool) y AC-22
  (prioridad del botón contextual).
- Tabla de Dependencies gana filas de Cámara y Panel de contribución que ya existían en prosa pero
  nunca se habían propagado a la tabla.
- Contrato RPC de Reparar, huecos de reconexión/atribución de Core Rule 7b, y varios mandatos de arte
  de ronda 3 quedan con seguimiento explícito en Open Questions en vez de resolverse aquí.

Prior verdict resolved: Parcialmente — las 4 causas raíz de ronda 3 sí se corrigieron en su momento,
pero 4 de esas mismas correcciones no sobrevivieron su propia re-derivación cuando esta ronda las
verificó con ojos frescos.

**Nota de independencia**: segunda ronda consecutiva donde las correcciones se aplicaron en la misma
sesión que revisó — per el `creative-director` de esta ronda, esto no debería volverse la norma. Una
ronda 5 en sesión nueva sigue siendo necesaria para confirmar rondas 3-4 con independencia real
revisor/autor.

## Reconciliación de ramas — 2026-08-11
El usuario lanzó las rondas 1-4 en sesiones separadas de Claude Code Game Studios, cada una en su
propia rama de git en vez de la rama de trabajo principal (`claude/install-claude-code-global-sfpz62`).
Rondas 1-2 se aplicaron directamente en la rama de trabajo por la sesión autora. Una sesión adicional
(rama `claude/amenazas-design-review-oq0jef`) corrió una ronda 1 duplicada desde un commit anterior
al de esta rama, resolvió los mismos 7 bloqueantes de forma independiente, y nunca se actualizó más
allá — se descartó por estar superada (nuestra ronda 1 ya incluía correcciones equivalentes, más las
rondas 2-4 encima). Las rondas 3-4 se aplicaron en la rama `claude/design-review-amenazas-r3-22v8ae`,
que sí partía limpiamente de esta rama de trabajo — su contenido se adoptó aquí después de que el
usuario revisara y aprobara las 4 decisiones de diseño que esas rondas reabrieron o introdujeron
(marco de Player Fantasy, Core Rule 7b, escalada de free-riding, y el punto de medición del cooldown
de Core Rule 2).

## Review — 2026-08-11 — Verdict: MAJOR REVISION NEEDED (ronda 5)
Scope signal: XL, sin cambios respecto a rondas 3-4
Specialists: 8 especialistas (game-designer, systems-designer, qa-lead, art-director, ux-designer, network-programmer, economy-designer, godot-specialist) + creative-director (síntesis) — sesión nueva, revisión pura sin autocorrección
Blocking items: 10 | Recommended: 12 | Desacuerdos: 2 (ambos adjudicados por el usuario a favor de la lectura del creative-director)
Summary: Quinta ronda — verdict escaló de NEEDS REVISION a **MAJOR REVISION NEEDED**. Cada especialista
fue instruido explícitamente para re-derivar reclamos en vez de confiar en las etiquetas "corregido"
de rondas previas, más una semilla de sospechas propias del reviewer para verificar o refutar. Hallazgo
central del `creative-director`: 6 de las 12 correcciones de ronda 4 no sobrevivieron re-derivación
independiente, incluyendo sus dos arreglos principales (Core Rule 2/AC-2, y el piso de
`coste_no_prevenir`) — mismo patrón de rondas 3 y 4, reapareciendo más profundo cada vez. Recomendó
explícitamente DEJAR de parchear y reescribir 5 áreas desde invariantes. **El usuario decidió seguir
parcheando por lotes de todos modos**, con verificación matemática/lógica independiente de cada
hallazgo antes de aplicar el arreglo (no solo aceptar el texto propuesto por el informe).

Los 10 bloqueantes, verificados y corregidos en 6 lotes:
1. **Core Rule 2/AC-2 (modelo de temporización)**: confirmado matemáticamente que `cooldown_global`
   (15s) era redundante en CUALQUIER punto de referencia (25s siempre excede 15s) — se eliminó la
   constante por completo; la exclusión mutua ahora se apoya solo en secuenciación. Barrido en todo
   el documento (Core Rule 10, AC-2/10/12/20, Edge Cases, Tuning Knobs, UI, Visual/Audio, Open
   Questions, registro de entidades).
2. **Invariante de instanciación**: confirmado con contraejemplo propio que el piso de ronda 4 estaba
   anclado a la cantidad equivocada (mínimo entre 3 campos de costo, no el incremento propio de
   `costo_prevenir`) — reanclado correctamente. Segundo requisito de t* fortalecido de "existencia" a
   "≥25% del rango a cada lado".
3. **Máquina de estados Prevenir/Reparar**: Core Rule 7b's "crédito retroactivo" contradecía la tabla
   de States and Transitions (Prevenir no es válido en Normal) — resuelto moviendo el crédito a
   contabilidad de respuesta RPC, no transición de estado. AC-19 ahora prueba el invariante de
   temporización real, no solo el resultado. `resultado=prevenido_automatico` distingue el default de
   desconexión de una acción real (evita misatribución en el futuro Panel de contribución).
4. **Modelo de interacción táctil**: dos modelos incompatibles (botón único vs. hitboxes por entidad)
   escritos en la misma ronda 4 — el usuario eligió botón único, apunta a la entidad más cercana
   (resuelve también la violación de autonomía de la prioridad fija anterior). AC-22, UI Requirements,
   y la nota anti-solape reescritas para coincidir. Core Rule 11 recibió nueva justificación (no
   dependía de la promesa de Player Fantasy como pensaba `ux-designer`).
5. **Visual**: conflicto de color real entre `farm-economy-system.md` (verde/naranja) y el art bible
   (dorado) para Prevenida — corregido en la fuente. Mandato de VFX corregido (rig único global es
   una mejora deliberada sobre el patrón per-entidad de `farm-economy-system.md` §3.1, no "el mismo
   patrón" como afirmaba ronda 4) con preguntas de transform declaradas. Severidad del caso sin acotar
   de Dañada/Reparando reabierta (desacuerdo adjudicado a favor de reabrir) con propuesta técnica
   concreta (`MultiMeshInstance2D` batching).
6. **Testabilidad**: AC-1 y AC-6(a) no eran implementables contra la API real de Godot — se añadieron
   como requisitos explícitos una interfaz de RNG abstracta (sustituible por fake en tests), un pool
   de entidades inyectable como fixture, y un contrato de señal concreto
   (`severidad_pendiente_cambiada`) que antes se referenciaba sin definir.

Prior verdict resolved: Parcialmente — los 4 hallazgos de ronda 4 sí se corrigieron en su momento
(confirmado por esta ronda para el conflicto de forma del enjambre), pero 6 de esas correcciones no
sobrevivieron re-derivación independiente, y 3 más resultaron contradichas por otras adiciones de la
misma ronda 4.

**Nota de independencia**: esta ronda 5 fue una revisión pura, sin autocorrección — el patrón de
rondas 3-4 no se repitió. Los arreglos de esta ronda SÍ se aplicaron en la sesión autora original
(distinta de la sesión reviewer), preservando la separación revisor/autor para esta ronda.

Una **ronda 6** en sesión nueva sigue siendo necesaria para confirmar. Dado el patrón recurrente de
"cada ronda encuentra defectos más profundos en la anterior", no se puede asumir que esta ronda cierre
el documento — debe verificarse, no asumirse.
