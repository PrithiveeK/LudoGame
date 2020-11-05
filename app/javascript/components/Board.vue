<template>
  <div class="board-container">
    <div class="game-home"></div>
    <Player class="red player_1" />
    <Player class="blue player_2" />
    <Player class="green player_3" />
    <Player class="yellow player_4" />
    <MoveBoard v-show="!isOnlineMode || (isStarted && !isFinished)" />
    <transition name="fade">
      <div class="joining-window" v-if="isOnlineMode && !isStarted">Waiting for the Players to Join...</div>
    </transition>
    <div class="score-board" v-if="isFinished">
      <ul class="score-board-list">
        <li v-for="player in scoreBoard" :key="player" class="score-board-item">{{player}}</li>
      </ul>
    </div>
  </div>
</template>

<script lang="js">
import Player from "./Player.vue";
import MoveBoard from "./MoveBoard.vue";

export default {
  computed: {
    isOnlineMode() {
      return this.$store.state.onlineMode
    },
    isStarted() {
      return this.$store.state.isStarted
    },
    isFinished() {
      return this.$store.state.isEnd
    },
    scoreBoard() {
      return this.$store.state.scoreBoard
    }
  },
  components: {
    Player,
    MoveBoard
  }
}
</script>

<style>
.board-container {
  font-size: min(1.3vh, 1.7vw);
  display: grid;
  grid-template: 20em 12em 20em / 20em 12em 20em;
  place-items: center;
  pointer-events: none;
  position: relative;

  --red-player: #ff4020;
  --blue-player: #0075ff;
  --green-player: #00aa00;
  --yellow-player: yellow;
  transition: all 0.3s;
}
.pe {
  pointer-events: all;
}
.red {
  color: var(--red-player);
}
.blue {
  color: var(--blue-player);
}
.green {
  color: var(--green-player);
}
.yellow {
  color: var(--yellow-player);
}
.player_1 {
  transform: rotateZ(0deg);
  grid-row: 1/3;
}
.player_2 {
  transform: rotateZ(90deg);
  grid-column: 2/4;
}
.player_3 {
  transform: rotateZ(180deg);
  grid-row: 2/4;
}
.player_4 {
  transform: rotateZ(-90deg);
  grid-column: 1/3;
}
.player_1 .piece-holder {
  transform: rotateZ(-45deg);
}
.player_2 .piece-holder {
  transform: rotateZ(-135deg);
}
.player_3 .piece-holder {
  transform: rotateZ(135deg);
}
.player_4 .piece-holder {
  transform: rotateZ(45deg);
}
.player-img {
  width: 50px;
  height: 50px;
  background-color: beige;
}
.player_1 .player-info,
.player_3 .player-info {
  bottom: 100%;
  left: 0;
  flex-direction: row;
}
.player_2 .player-info,
.player_4 .player-info {
  top: 0;
  right: 100%;
  flex-direction: column;
}
.player_1 .player-info > * {
  transform: rotateZ(0deg);
}
.player_2 .player-info > * {
  transform: rotateZ(-90deg);
}
.player_3 .player-info > * {
  transform: rotateZ(180deg);
}
.player_4 .player-info > * {
  transform: rotateZ(90deg);
}
.player_1 .start_pos {
  top: 9em;
  left: -7em;
}
.player_2 .start_pos {
  top: -7em;
  left: -9em;
}
.player_3 .start_pos {
  top: -9em;
  left: 7em;
}
.player_4 .start_pos {
  top: 7em;
  left: 9em;
}
.game-home {
  grid-column: 2;
  grid-row: 2;
}
.joining-window{
  pointer-events: all !important;
  position: fixed;
  background-color: #00000090;
  height: 100vh;
  width: 100%;
  top: 0;
  left: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 3rem;
  font-weight: 900;
}
.fade-enter-to,
.fade-leave-from {
  opacity: 0
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 1s ease;
}
.score-board {
  position: fixed;
  width: 100%;
  padding: 20px;
  left: 0;
  bottom: 0;
}
.score-board-list{
  border-radius: 20px 20px 0 0;
  background-color: #0075ff;
}
.score-board-item {
  border-bottom: 2px solid white;
  font-size: 32px;
}
</style>
