# Session State

## Current Task
Spike de Godot (`prototypes/rincon-compartido-spike-2026-08-11/`) extendido en 4 pasadas seguidas a
petición directa del usuario ("continua haciendo el juego" → "sigue agregando, máquinas y expansión
de terreno"), sin pausar a esperar el playtest. Todo comiteado y pusheado. Pendiente: que el usuario
lo corra y reporte, o que pida seguir extendiendo.

## Qué existe ahora en el spike

1. **Base** (commit `41343a7`): 2 parcelas de Trigo, 1 jugador local, Amenazas completo (pre-alerta,
   ventana, botón único apunta-a-más-cercana, Prevenir/Reparar, exclusión mutua por secuenciación).
2. **+2º jugador y Refugio** (commit `b98f6ca`): Jugador2 (flechas+Enter, matching el concept
   prototype original), Refugio que protege Parcela1 pero no Parcela2 — permite probar Severo/Reducido
   de verdad, incluyendo el preview de severidad en tiempo real (Core Rule 6).
3. **+3 cultivos** (commit `b5fde28`): Trigo/Maíz/Fresa con números reales de
   `farm-economy-system.md` 3.2, desbloqueo progresivo (umbrales escalados hacia abajo para un spike
   corto, documentado como tal), tope de concurrencia de Fresa (máx. 1 en vuelo en toda la granja).
4. **+Máquinas y expansión de terreno** (commit `989ee14`): 6 parcelas totales (4 empiezan
   Bloqueadas, costos reales `farm-economy-system.md` 4.2: $50/$120/$250/$450), estado `BLOQUEADA`
   con candado dibujado a mano (formas primitivas, sin emoji — riesgo de fuente descartado antes de
   comitear). Nuevo Taller (`scripts/taller.gd`, grupo `interactuables`) vende Sembradora ($200,
   auto-replanta al quedar Vacía — divergencia documentada del efecto real de "reducir mantener-para-
   plantar", que este spike nunca modeló) y Cosechadora ($350, cadena de auto-cosecha Chebyshev-1
   disparada solo por cosecha manual, nunca Fresa, nunca se auto-encadena — respeta el Anti-Pilar de
   no automatización 100% desatendida). `jugador.gd` ahora busca en el grupo compartido
   `interactuables` (antes solo `parcelas`) para que el Taller use la misma lógica de objetivo-más-
   cercano.

Controles: J1 = WASD+E, J2 = flechas+Enter, C = ciclar cultivo (compartido), T = forzar amenaza
(debug, evita esperar el intervalo real de 25-90s). Sin teclas nuevas en esta pasada — compra de
terreno/máquinas usa la misma tecla de acción contextual.

## Progress Checklist
- [x] Spike base construido y pusheado
- [x] 2º jugador + Refugio añadidos y pusheados
- [x] 3 cultivos añadidos y pusheados
- [x] Máquinas (Sembradora/Cosechadora) + expansión de terreno (6 parcelas) añadidas y pusheadas
- [ ] **El usuario todavía no lo ha corrido** — sigue sin verificación real de ejecución (no hay
      Godot instalado en este entorno; todo el código se revisó a mano, no se ejecutó)
- [ ] Si el usuario pide seguir sin probar primero: candidatos siguientes son el Silo con capacidad
      de venta, Decoración/Confort, o el spike de UX táctil para el gesto de mantener-para-plantar —
      todos mencionados como explícitamente NO probados en el README actual
- [ ] Escribir `SPIKE-NOTE.md` una vez el usuario reporte un resultado real
- [ ] Actualizar `prototypes/index.md` con el veredicto final

## Key Decisions Carried Forward
- El usuario prefiere que se siga construyendo directamente en vez de pausar a cada rato a pedir
  confirmación — mientras el trabajo se quede dentro de `prototypes/` (desechable, bajo riesgo,
  reversible), tiene sentido seguir el ritmo sin AskUserQuestion por cada pieza añadida.
- Ningún código de este spike se ha ejecutado nunca — revisar con cuidado antes de seguir apilando
  más funcionalidad encima, el riesgo de un bug oculto crece con cada pasada sin verificación real.
- Reusar patrones ya probados (del concept prototype original) sigue siendo la estrategia para
  minimizar riesgo dado que no puedo ejecutar Godot aquí.

## Files Modified This Session
- `prototypes/rincon-compartido-spike-2026-08-11/` — todo el proyecto, 4 pasadas de commits
- `prototypes/index.md`
- `production/session-state/active.md` — este archivo

Todo comiteado y pusheado hasta el commit `989ee14`.

## Current Phase
Spike en buen punto de pausa natural (base + co-op + severidad + variedad de cultivos + máquinas +
expansión de terreno, todo funcionalmente coherente sobre el papel). Esperando que el usuario lo
corra, o que pida seguir extendiendo sin probar primero.
