<template>
  <transition-group class="player" tag="div" name="piece-move">
    <span key="1" :style="piece1Position" class="piece-container">
      <Piece
        :class="{
          choose:
            playerState.choosePiece &&
            (playerState.dice === 6 ||
              playerState[`piece1`].isOut && !playerState[`piece1`].isHome && playerState[`piece1`].currentPosition + playerState.dice <= 56)
        }"
        @click.native="moveThisPiece(1)"
      />
    </span>
    <span key="2" :style="piece2Position" class="piece-container">
      <Piece
        :class="{
          choose:
            playerState.choosePiece &&
            (playerState.dice === 6 || 
              playerState[`piece2`].isOut && !playerState[`piece2`].isHome && playerState[`piece2`].currentPosition + playerState.dice <= 56)
        }"
        @click.native="moveThisPiece(2)"
      />
    </span>
    <span key="3" :style="piece3Position" class="piece-container">
      <Piece
        :class="{
          choose:
            playerState.choosePiece &&
            (playerState.dice === 6 ||
              playerState[`piece3`].isOut && !playerState[`piece3`].isHome && playerState[`piece3`].currentPosition + playerState.dice <= 56)
        }"
        @click.native="moveThisPiece(3)"
      />
    </span>
    <span key="4" :style="piece4Position" class="piece-container">
      <Piece
        :class="{
          choose:
            playerState.choosePiece &&
            (playerState.dice === 6 ||
              playerState[`piece4`].isOut && !playerState[`piece4`].isHome && playerState[`piece4`].currentPosition + playerState.dice <= 56)
        }"
        @click.native="moveThisPiece(4)"
      />
    </span>
    <div class="player-info" :class="{ block: !isPlaying, 'show-me': isThisMe }" :key="`playerInfo_${playerId}`">
      <div class="icon">
        <div class="profile-icon"></div>
      </div>
      <Dice
        :class="{ pe: isThisMe && isPlaying && !playerState.choosePiece }"
        @roll="rolling"
        :rollDice="playerState.isRolling"
        :diceValue="playerState.dice"
      />
    </div>
  </transition-group>
</template>

<script lang="js">
import Piece from "./Piece.vue";
import Dice from "./Dice.vue";

export default {
  props: ["isPlaying", "playerId"],
  computed: {
    playerState() {
      return this.$store.state[this.playerId];
    },
    isThisMe() {
      return this.$store.state.you === this.playerId;
    },
    piece1Position() {
      return this.$store.getters[`${this.playerId}/piecePosition`]("piece1")
    },
    piece2Position() {
      return this.$store.getters[`${this.playerId}/piecePosition`]("piece2")
    },
    piece3Position() {
      return this.$store.getters[`${this.playerId}/piecePosition`]("piece3")
    },
    piece4Position() {
      return this.$store.getters[`${this.playerId}/piecePosition`]("piece4")
    },
  },
  methods: {
    rolling() {
      console.log("rolling")
      this.$cable.perform({
        channel: 'my_game_room',
        action: 'rolling',
        data: {
          whichPlayer: this.playerId
        }
      })
    },
    async moveThisPiece(i) {
      this.$cable.perform({
        channel: 'my_game_room',
        action: 'move_piece',
        data: {
          whichPlayer: this.playerId,
          dice: this.playerState.dice,
          whichPiece: 'piece' + i
        }
      })
    }
  },
  components: {
    Piece,
    Dice
  }
}
</script>

<style scoped>
.block {
  filter: brightness(0.5);
}
.choose {
  transform: scale(1.15);
  pointer-events: all;
  z-index: 500;
}
.icon {
  width: 50px;
  height: 50px;
  position: relative;
  transition: all 0.3s;
}
.profile-icon {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translateX(-50%);
  width: 25px;
  height: 10px;
  border-radius: 100% 100% 0 0;
  background-color: currentColor;
}
.profile-icon:before {
  content: "";
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  top: -140%;
  width: 10px;
  height: 10px;
  border-radius: 100%;
  background-color: currentColor;
  border: 1px solid currentColor;
}
.player {
  display: contents;
}
span.piece-container {
  display: grid;
  place-items: center;
}
.piece-move-move {
  transition: all 0.5s linear;
}
</style>
