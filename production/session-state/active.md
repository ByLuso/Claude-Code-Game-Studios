# Session State

## Current Task
Spike de Godot (`prototypes/rincon-compartido-spike-2026-08-11/`) extendido en 3 pasadas seguidas a
petición directa del usuario ("continua haciendo el juego"), sin pausar a esperar el playtest. Todo
comiteado y pusheado. Pendiente: que el usuario lo corra y reporte, o que pida seguir extendiendo.

## Qué existe ahora en el spike

1. **Base** (commit `41343a7`): 2 parcelas de Trigo, 1 jugador local, Amenazas completo (pre-alerta,
   ventana, botón único apunta-a-más-cercana, Prevenir/Reparar, exclusión mutua por secuenciación).
2. **+2º jugador y Refugio** (commit `b98f6ca`): Jugador2 (flechas+Enter, matching el concept
   prototype original), Refugio que protege Parcela1 pero no Parcela2 — permite probar Severo/Reducido
   de verdad, incluyendo el preview de severidad en tiempo real (Core Rule 6).
3. **+3 cultivos** (commit `b5fde28`): Trigo/Maíz/Fresa con números reales de
   `farm-economy-system.md` 3.2, desbloqueo progresivo (umbrales escalados hacia abajo para un spike
   corto, documentado como tal), tope de concurrencia de Fresa (máx. 1 en vuelo en toda la granja).

Controles: J1 = WASD+E, J2 = flechas+Enter, C = ciclar cultivo (compartido), T = forzar amenaza
(debug, evita esperar el intervalo real de 25-90s).

## Progress Checklist
- [x] Spike base construido y pusheado
- [x] 2º jugador + Refugio añadidos y pusheados
- [x] 3 cultivos añadidos y pusheados
- [ ] **El usuario todavía no lo ha corrido** — sigue sin verificación real de ejecución (no hay
      Godot instalado en este entorno; todo el código se revisó a mano, no se ejecutó)
- [ ] Si el usuario pide seguir sin probar primero: candidatos siguientes son Máquinas
      (Sembradora/Cosechadora automáticas), expansión de terreno (más de 2 parcelas), o el Silo con
      capacidad — todos en `farm-economy-system.md` con números reales listos para usar
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
- `prototypes/rincon-compartido-spike-2026-08-11/` — todo el proyecto, 3 pasadas de commits
- `prototypes/index.md`
- `production/session-state/active.md` — este archivo

Todo comiteado y pusheado hasta el commit `b5fde28`.

## Current Phase
Spike en buen punto de pausa natural (base + co-op + severidad + variedad de cultivos, todo
funcionalmente coherente sobre el papel). Esperando que el usuario lo corra, o que pida seguir
extendiendo sin probar primero.
