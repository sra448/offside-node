React = require \react
{ h1, div, ul, li, img, a } = React.DOM

store = require "../main/store.ls"

kicker-image = require "./field-img-white.png"

require "./style.scss"


ui = ({ players, slot1, slot2, slot3, slot4 }) ->
  div { class-name: "offside-main" },
    start-match-ui { slot1, slot2, slot3, slot4 }
    game-buttons { slots: [slot1, slot2, slot3, slot4] }
    player-chooser { players, selected-players: [slot1, slot2, slot3, slot4] } if players?


start-match-ui = ({ slot1, slot2, slot3, slot4 }) ->
  div { class-name: "start-match-ui" },
    div { class-name: "red" },
      player-slot { id:1, player:slot1 }
      player-slot { id:2, player:slot2 }
    div { class-name: "field"},
     img { src:kicker-image }
    div { class-name: "blue" },
      player-slot { id:3, player:slot3 }
      player-slot { id:4, player:slot4 }


game-buttons = ({ slots }) ->
  class-name = "button #{'active' if (slots.filter (x) -> x).length == 4}"
  div { class-name: "game-buttons" },
    a { class-name, on-click: dispatch-game-start }, "Start Game"
    a { class-name }, "Shuffle Teams"


dispatch-game-start = ->
  store.dispatch type: \start-game


player-chooser = ({ players, selected-players }) ->
  div { class-name: "player-chooser" },
    players.map (player) ->
      class-name = "selectable-player" unless player in selected-players
      div { class-name: "player" },
        img { src: player.image_url, on-click: (dispatch-select-player player), class-name }


dispatch-select-player = (player) ->
  ->
    store.dispatch do
      type: \set-player
      payload: player.id


player-icon = ({ player, class-name }) ->
  img { src:player.image_url, id: player.id, class-name: class-name }


player-slot = ({ id, player }) ->
  div { id: name, class-name: "slot" },
    if player
      img { src: player.image_url, class-name: "selected-player", on-click: (dispatch-free-slot id) }
    else
      id


dispatch-free-slot = (id) ->
  ->
    store.dispatch do
      type: \free-slot
      payload: "slot#{id}"

module.exports = ui
