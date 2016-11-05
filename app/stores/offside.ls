{ create-store } = require \redux

game-state =
  players: []
  slot1: undefined
  slot2: undefined
  slot3: undefined
  slot4: undefined
  match:
    running:false
    red:
      team: []
      score: 0
    blue:
      team: []
      score: 0


update-state = (state, { type, payload }) ->
  switch type
    case \get-players
      state.players = payload
      state
    case \set-player
      player-id = payload
      slot = find-available-slot state
      state[slot] = state.players.find (p) -> p.id == +player-id
      state
    case \free-slot
      slot-id = payload
      state[slot-id] = undefined
      state
    case \start-game
      state.match.red.team = [state.slot1, state.slot2]
      state.match.blue.team = [state.slot3, state.slot4]
      state.match.running = true
      state
    case \goal
      if state.game.running
        team = payload
        state.match[team].score = state.match[team].score + 1
      state
    case \end-game
      state.match =
        running:false
        red:
          team: []
          score: 0
        blue:
          team: []
          score: 0
      state
    default state


find-available-slot = (state) ->
  "slot" + [1 to 4].find (i) ->
    !state["slot#{i}"]

store = create-store update-state, game-state

module.exports = store