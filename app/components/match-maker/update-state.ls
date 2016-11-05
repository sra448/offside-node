get-players = (state, players) ->
  state.players = players
  state

set-player = (state, player-id) ->
  player = state.players.find (p) -> p.id == +player-id
  unless player in get-selected-players state
    slot = find-available-slot state
    state[slot] = state.players.find (p) -> p.id == +player-id
  state

shuffle-players = (state) ->
  { slot1, slot2, slot3, slot4 } = state
  state.slot1 = slot4
  state.slot2 = slot3
  state.slot3 = slot1
  state.slot4 = slot2
  state

free-slot = (state, slot-id) ->
  state[slot-id] = undefined
  state

start-game = (state) ->
  player-count = (get-selected-players state).length
  if player-count == 4
    state.match.red.players = [state.slot1, state.slot2]
    state.match.blue.players = [state.slot3, state.slot4]
    state.match.running = true
  state

get-selected-players = (state) ->
  { slot1, slot2, slot3, slot4 } = state
  [slot1, slot2, slot3, slot4].filter (x) -> x

find-available-slot = (state) ->
  "slot" + [1 to 4].find (i) ->
    !state["slot#{i}"]

module.exports = (state, { type, payload }) ->
  switch type
    case \PLAYERS_SET then get-players state, payload
    case \PLAYER_CHOOSE then set-player state, payload
    case \PLAYERS_SHUFFLE then shuffle-players state
    case \SLOT_FREE then free-slot state, payload
    case \GAME_START then start-game state
    default state
