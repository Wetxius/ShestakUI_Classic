local T, C, L = unpack(ShestakUI)
if T.client ~= "esES" and T.client ~= "esMX" then return end

----------------------------------------------------------------------------------------
--	Localization for esES and esMX client
--	Translation: eXecrate, Seal
----------------------------------------------------------------------------------------
-- Announce flasks and food
L_ANNOUNCE_FF_NOFOOD = "No Food: " -- Needs review
L_ANNOUNCE_FF_NOFLASK = "No Flask: " -- Needs review
L_ANNOUNCE_FF_ALLBUFFED = "All Buffed!" -- Needs review
L_ANNOUNCE_FF_CHECK_BUTTON = "Check food and flask" -- Needs review

-- Says thanks for some spells
L_ANNOUNCE_SS_THANKS = "Thanks for " -- Needs review
L_ANNOUNCE_SS_RECEIVED = " received from " -- Needs review

-- Pull countdown announce
L_ANNOUNCE_PC_GO = "GO!" -- Needs review
L_ANNOUNCE_PC_MSG = "Pulling %s in %s.." -- Needs review
L_ANNOUNCE_PC_ABORTED = "Pull ABORTED!" -- Needs review

-- Announce feasts and portals
L_ANNOUNCE_FP_PRE = "%s has prepared a %s." -- Needs review
L_ANNOUNCE_FP_PUT = "%s has put down a %s." -- Needs review
L_ANNOUNCE_FP_CAST = "%s is casting %s." -- Needs review
L_ANNOUNCE_FP_CLICK = "%s is casting %s. Click!" -- Needs review
L_ANNOUNCE_FP_USE = "%s used a %s." -- Needs review

-- Announce your interrupts
L_ANNOUNCE_INTERRUPTED = INTERRUPTED

-- Tooltip
L_TOOLTIP_LOADING = "Cargando..."
L_TOOLTIP_ACH_STATUS = "Estado:"
L_TOOLTIP_ACH_COMPLETE = "Estado: Completado "
L_TOOLTIP_ACH_INCOMPLETE = "Estado: Incompleto"
L_TOOLTIP_SPELL_ID = "ID del hechizo:"
L_TOOLTIP_ITEM_ID = "ID del objeto:"
L_TOOLTIP_WHO_TARGET = "Marcado por"
L_TOOLTIP_ITEM_COUNT = "Contador del objeto:"
L_TOOLTIP_INSPECT_OPEN = "Inspect Frame is open" -- Needs review

-- Misc
L_MISC_UNDRESS = "Desvestir"
L_MISC_DRINKING = " esta bebiendo."
L_MISC_BUY_STACK = "Alt-Click para comprar un lote"
L_MISC_UI_OUTDATED = "Tu versión de ShestakUI no está actualizada. Puedes descargar la última versión de https://github.com/Shestak/ShestakUI"
L_MISC_UI_OUTDATED_CLASSIC = "Tu versión de ShestakUI no está actualizada. Puedes descargar la última versión de https://github.com/Wetxius/ShestakUI_Classic"
L_MISC_HEADER_MARK = "Mouseover Raid Icons" -- Needs review
L_MISC_BINDER_OPEN = "Mouse Bindings" -- Needs review
L_MISC_SCROLL = "Pergamino"
L_MISC_HEADER_QUEST = "Auto quest button" -- Needs review

-- Raid Utility
L_RAID_UTIL_DISBAND = "Disolver grupo"

-- Zone name
L_ZONE_ANCIENTDALARAN = "Cráter de Dalaran"

-- WatchFrame Wowhead link
L_WATCH_WOWHEAD_LINK = "Link de WoWhead"

-- Toggle Menu
L_TOGGLE_ADDON = "Complemento "
L_TOGGLE_ADDONS = " complementos"
L_TOGGLE_EXPAND = "Expandir "
L_TOGGLE_COLLAPSE = "Colapsar "
L_TOGGLE_RCLICK = "Click derecho para activar o desactivar "
L_TOGGLE_LCLICK = "Click izquierdo para cambiar de ventana "
L_TOGGLE_RELOAD = " (necesita reiniciar la UI)"
L_TOGGLE_NOT_FOUND = " not found." -- Needs review

-- UnitFrame
L_UF_GHOST = "Fantasma"
L_UF_DEAD = "Muerto"
L_UF_OFFLINE = "Desconectado"
L_UF_MANA = "Mana bajo"

-- Map
L_MAP_CURSOR = "Cursor: "
L_MAP_BOUNDS = "Fuera de los limites!"
L_MAP_FOG = "Fog of War" -- Needs review
L_MAP_COORDS = "Coordinates" -- Needs review

-- Minimap
L_MINIMAP_CALENDAR = "Calendario"
L_MINIMAP_FARM = "Minimap size" -- Need review
L_MINIMAP_TOGGLE = "Toggle action bars" -- Need review

-- Chat
L_CHAT_WHISPER = "De"
L_CHAT_BN_WHISPER = "De"
L_CHAT_AFK = "[AFK]"
L_CHAT_DND = "[NM]"
L_CHAT_GM = "[GM]"
L_CHAT_GUILD = "H"
L_CHAT_PARTY = "G"
L_CHAT_PARTY_LEADER = "LG"
L_CHAT_RAID = "B"
L_CHAT_RAID_LEADER = "LB"
L_CHAT_RAID_WARNING = "AB"
L_CHAT_INSTANCE_CHAT = "I" -- Needs review
L_CHAT_INSTANCE_CHAT_LEADER = "IL" -- Needs review
L_CHAT_OFFICER = "O"
L_CHAT_PET_BATTLE = "PB" -- Needs review
L_CHAT_COME_ONLINE = "se ha |cff298F00conectado|r."
L_CHAT_GONE_OFFLINE = "se ha |cffff0000desconectado|r."

-- Errors frame
L_ERRORFRAME_L = "Click para ver errores."

-- Bags
L_BAG_SHOW_BAGS = "Mostrar Bolsas"
L_BAG_RIGHT_CLICK_SEARCH = "Click derecho para buscar"
L_BAG_STACK_MENU = "Amontonar"
L_BAG_RIGHT_CLICK_CLOSE = "Right-click to open menu" -- Need review

-- Grab mail
L_MAIL_STOPPED = "Sin espacio, inventario lleno."
L_MAIL_UNIQUE = "Abortado. Se encontró un duplicado del objeto único en las bolsas o en el banco."
L_MAIL_COMPLETE = "Todo enviado."
L_MAIL_NEED = "Necesitas un buzón."
L_MAIL_MESSAGES = "mensajes"

-- Loot
L_LOOT_RANDOM = "Jugador aleatorio"
L_LOOT_SELF = "Despojar automáticamente"
L_LOOT_FISH = "Despojar pescado"
L_LOOT_ANNOUNCE = "Anunciar a"
L_LOOT_TO_RAID = "  banda"
L_LOOT_TO_PARTY = "  grupo"
L_LOOT_TO_GUILD = "  hermandad"
L_LOOT_TO_SAY = "  decir"

-- LitePanels AFK module
L_PANELS_AFK = "Estas ausente!"
L_PANELS_AFK_RCLICK = "Botón derecho para ocultar."
L_PANELS_AFK_LCLICK = "Botón izquierdo para retroceder."

-- Cooldowns
L_COOLDOWNS = "TR: "
L_COOLDOWNS_COMBATRESS = "CombatRess" -- Needs review
L_COOLDOWNS_COMBATRESS_REMAINDER = "Combat resurrect: " -- Needs review
L_COOLDOWNS_NEXTTIME = "Next time: " -- Needs review

-- Bind key
L_BIND_SAVED = "La configuración de las teclas ha sido guardada."
L_BIND_DISCARD = "Se han descartado los cambios en la configuración de las teclas."
L_BIND_INSTRUCT = "Coloca el cursor encima de cualquier botón para asignar una tecla. Presiona la tecla ESC o el botón derecho del ratón para quitar la asignación actual."
L_BIND_CLEARED = "Todas las asignaciones de teclas se han limpiado para"
L_BIND_BINDING = "Asignación"
L_BIND_KEY = "Tecla"
L_BIND_NO_SET = "No tiene asignación"

-- Info text
L_INFO_ERRORS = "Ningún error aun."
L_INFO_INVITE = "Invitación aceptada de "
L_INFO_DUEL = "Duelo rechazado de "
L_INFO_PET_DUEL = "Declined pet duel request from " -- Needs review
L_INFO_DISBAND = "Deshaciendo banda..."
L_INFO_SETTINGS_DBM = "Escribe /settings dbm, para aplicar las preferencias del DBM."
L_INFO_SETTINGS_BIGWIGS = "Escribe /settings bw, para aplicar las preferencias del BigWigs."
L_INFO_SETTINGS_MSBT = "Escribe /settings msbt, para aplicar las preferencias del MSBT."
L_INFO_SETTINGS_SKADA = "Escribe /settings skada, para aplicar las preferencias del Skada."
L_INFO_SETTINGS_ALL = "Escribe /settings all, para aplicar todas las modificaciones."
L_INFO_NOT_INSTALLED = " no esta instalado."
L_INFO_SKIN_DISABLED1 = "Estilizacion para "
L_INFO_SKIN_DISABLED2 = " esta desactivado."

-- Moving elements
L_MOVE_RIGHT_CLICK = "Right-click to reset position" -- Needs review
L_MOVE_MIDDLE_CLICK = "Middle-click to temp hide" -- Needs review

-- Popups
L_POPUP_INSTALLUI = "Es la primera vez que usas ShestakUI con este personaje. Usted debe volver a cargar la interfaz de usuario para configurarlo."
L_POPUP_RESETUI = "¿Estás seguro de que desea restablecer ShestakUI?"
L_POPUP_RESETSTATS = "¿Estás seguro de que quieres reiniciar las estadísticas de tiempo empleado en el juego y oro adquirido?"
L_POPUP_DISBAND_RAID = "¿Estás seguro de que quieres disolver el grupo?"
L_POPUP_DISABLEUI = "ShestakUI no funciona con esta resolución, ¿Quieres desactivar ShestakUI? (Pulsa cancelar si quieres probar otra resolución)"
L_POPUP_SETTINGS_ALL = "¿Aplicar modificaciones para todos los addons? (DBM, BigWigs, Skada o MSBT)"
L_POPUP_SETTINGS_DBM = "Necesito cambiar la posición de los elementos del DBM."
L_POPUP_SETTINGS_BW = "Necesito cambiar la posición de los elementos del BigWigs."
L_POPUP_ARMORY = "Arsenal"

-- Welcome message
L_WELCOME_LINE_1 = "Bienvenido a ShestakUI "
L_WELCOME_LINE_2_1 = "Escribe /cfg para configurar la interfaz, o visita https://github.com/Wetxius/ShestakUI_Help/wiki/English"
L_WELCOME_LINE_2_2 = "para más información."
L_WELCOME_LINE_1_CLASSIC = "Bienvenido a ShestakUI (Classic) "
L_WELCOME_LINE_2_1_CLASSIC = "Escribe /cfg para configurar la interfaz, o visita https://github.com/Wetxius/ShestakUI_Classic"
L_WELCOME_LINE_2_2_CLASSIC = "para más información."

-- Combat text
L_COMBATTEXT_KILLING_BLOW = "Golpe de gracia"
L_COMBATTEXT_TEST_DISABLED = "Modo Texto de combate deshabilitado."
L_COMBATTEXT_TEST_ENABLED = "Modo Texto de combate habilitado."
L_COMBATTEXT_TEST_USE_MOVE = "Escribe /xct move para mover y cambiar el tamaño del marco de texto de combate."
L_COMBATTEXT_TEST_USE_TEST = "Escribe /xct test para probar el modo Texto de combate."
L_COMBATTEXT_TEST_USE_RESET = "Type /xct reset to restore default positions." -- Need review
L_COMBATTEXT_POPUP = "Para guardar la posición de la ventana de texto de combate necesitas recargar tu UI."
L_COMBATTEXT_UNSAVED = "La posición de la ventana de texto de combate no está guardada, no olvides recargar la UI."
L_COMBATTEXT_UNLOCKED = "Texto de combate desbloqueado."

-- LiteStats
L_STATS_AUTO_REPAIR = "Reparación auto."
L_STATS_GUILD_REPAIR = "Reparar con dinero de la hermandad"
L_STATS_AUTO_SELL = "Auto-vender basura"
L_STATS_BANDWIDTH = "Ancho de banda:"
L_STATS_DOWNLOAD = "Descarga:"
L_STATS_CURRENCY_RAID = "Raid Seals" -- Need review
L_STATS_MEMORY_USAGE = "Blizzard UI Memory Usage:" -- Needs review
L_STATS_TOTAL_MEMORY_USAGE = "Uso total de la memoria:"
L_STATS_TOTAL_CPU_USAGE = "Total CPU Usage:" -- Need review
L_STATS_GARBAGE_COLLECTED = "Basura recogida"
L_STATS_HIDDEN = "Oculto"
L_STATS_JUNK_ALREADY_ADDITIONS = "is already in additions list." -- Need review
L_STATS_JUNK_ITEMLINK = "enlace del objeto"
L_STATS_JUNK_ADDITIONS = "Junk additions" -- Need review
L_STATS_JUNK_LIST = "Lista de basura"
L_STATS_JUNK_PROFIT = "Ganancia con la basura"
L_STATS_JUNK_CLEARED = "Junk list cleared." -- Need review
L_STATS_JUNK_CLEAR_ADDITIONS = "Clear additions list." -- Need review
L_STATS_JUNK_ADDED = "Added junk additions" -- Need review
L_STATS_JUNK_ADD_ITEM = "Add/remove items." -- Need review
L_STATS_JUNK_REMOVED = "Removed junk additions" -- Need review
L_STATS_JUNK_ITEMS_LIST = "List for sell items." -- Need review
L_STATS_NO_GUILD = "No Guild" -- Needs review
L_STATS_KILLS = "A"
L_STATS_XP_RATE = "EXP en este nivel"
L_STATS_HR = "hr"
L_STATS_INF = "inf"
L_STATS_ON = "ON"
L_STATS_PLAYED_LEVEL = "Jugado este nivel"
L_STATS_PLAYED_SESSION = "Jugado esta sesión"
L_STATS_ACC_PLAYED = "Jugado"
L_STATS_PLAYED_TOTAL = "Total jugado"
L_STATS_QUEST = "M"
L_STATS_QUESTS_TO = "Misiones/Muertes para %s"
L_STATS_CURRENT_XP = "Actual/Max EXP"
L_STATS_REMAINING_XP = "EXP Restante"
L_STATS_RESTED_XP = "EXP de descanso"
L_STATS_SERVER_GOLD = "Oro del servidor"
L_STATS_SESSION_GAIN = "Sesion ganado/perdido"
L_STATS_SESSION_XP = "EXP en esta sesion"
L_STATS_SORTING_BY = "Ordenado por"
L_STATS_SEALS = "Seals this week" -- Needs review
L_STATS_SPEC = "Spec" -- Need review
L_STATS_TIPS = "consejos:"
L_STATS_OPEN_CALENDAR = "Click-Izquierdo abre el calendario."
L_STATS_RC_TIME_MANAGER = "Click-Derecho abre el administrador de tiempo."
L_STATS_TOGGLE_TIME = "Hora Local/Reino y el reloj de 24hr se pueden activar desde el administrador de tiempo."
L_STATS_MEMORY = "Memoria"
L_STATS_RC_COLLECTS_GARBAGE = "Click-Derecho recolecta basura de Lua."
L_STATS_VIEW_NOTES = "Manten pulsada la tecla Alt para ver rangos, notas y notas de oficiales."
L_STATS_CHANGE_SORTING = "[Hermandad] Click-Derecho para cambiar la clasificacion, Shift-Click-Derecho para invertir el orden."
L_STATS_OPEN_CHARACTER = "Click-Izquierdo abre la pestana de personaje."
L_STATS_RC_AUTO_REPAIRING1 = "Click-Derecho activa el Auto-Reparar."
L_STATS_RC_AUTO_REPAIRING2 = "Middle-Click toggles Guild AutoRepairing." -- Need review
L_STATS_EQUIPMENT_CHANGER = "Shift-Click o Alt-Click para el cambiador de equipamiento."
L_STATS_RC_EXPERIENCE = "Clic derecho para alternar experiencia, tiempo jugado y facciones."
L_STATS_WATCH_FACTIONS = "Mirar facciones desde la herramienta de facciones."
L_STATS_TOOLTIP_EXPERIENCE = "Cuando no estes a nivel max, la descripcion mostrara detalles de la experiencia."
L_STATS_TOOLTIP_TIME_PLAYED = "Cuando estes a nivel max, la descripcion mostrara detalles del tiempo jugado de la cuenta."
L_STATS_OPEN_TALENT = "Click-Izquierdo activa tu especializacion de talentos."
L_STATS_RC_TALENT = "Right-Click toggles your loot specialization." -- Need review
L_STATS_LOCATION = "Situación/Coordenadas"
L_STATS_WORLD_MAP = "Clickeando abres el Mapa del Mundo."
L_STATS_INSERTS_COORDS = "Shift-Click en los modulos de localizacion o coordenadas inserta las coords en el chat."
L_STATS_OPEN_CURRENCY = "Click-Izquierdo abre la pestana de dinero."
L_STATS_RC_AUTO_SELLING = "Click-Derecho activa el Auto-Vender."
L_STATS_NEED_TO_SELL = "Use /junk to configure which items need to sell." -- Need review
L_STATS_WATCH_CURRENCY = "Elementos vistos en la pestana de dinero se reflejaran en la descripcion."
L_STATS_OTHER_OPTIONS = "Otras opciones se pueden configurar en %s"

-- Slash commands
L_SLASHCMD_HELP = {
	"Lista de comandos disponibles:",
	"/rl - Recargar interfaz.",
	"/rc - Realizar una comprobación.",
	"/gm - Abrir marco del MH.",
	"/dis ADDON_NAME - Desactiva el addon.",
	"/en ADDON_NAME - Activa el addon.",
	"/rd - Rompe el grupo o la banda.",
	"/toraid - Convierte el grupo a bandaConvert to party or raid.",
	"/teleport - Teleportarse desde una mazmorra aleatoria.",
	"/ss - Cambia entre especializaciones de talentos.",
	"/tt - Susurrar objetivo.",
	"/farmmode - Incrementa el tamaño del minimapa.",
	"/resetui - Reinicia la configuración general a la por defecto.",
	"/resetuf - Reinicia los marcos de unidades a su posición por defecto.",
	"/resetconfig - Reinicia la configuración de ShestakUI_Config.",
	"/resetstats - Reinicia las estadísticas de oro y tiempo empleado.",
	"/settings - Aplica la configuración a msbt, dbm, skada, o a todos los addons (con 'all').",
	"/ls - Ayuda para LiteStats.",
	"/xct - Gestiona el texto de combate.",
	"/raidcd - Prueba de los enfriamientos de la banda.",
	"/enemycd - Prueba de los enfriamientos del enemigo.",
	"/pulsecd - Prueba de tus propios enfriamientos.",
	"/threat - Prueba del medidor de amenaza.",
	"/testuf - Prueba de los marcos de unidades.",
	"/moveui - Permite mover los elementos de la interfaz.", -- Need review
	"/cfg - Abre la configuración de la interfaz.",
}
