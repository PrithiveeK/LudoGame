<template>
  <div class="game-component">
    <GameOptions />
    <Board />
  </div>
</template>

<script lang="js">
import Board from "../components/Board.vue";
import GameOptions from "../components/GameOptions.vue";

export default {
  components: {
    Board,
    GameOptions
  }
}
</script>

<style scoped>
.game-component {
  width: inherit;
  height: inherit;
  display: grid;
  place-items: center;
}
</style>
