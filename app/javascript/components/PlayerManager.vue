<template>
  <transition-group class="player" tag="div" name="piece-move">
    <span v-for="i in 4" :key="i" :style="piecePositions[i-1]">
      <Piece
        :class="{
          choose:
            choosePiece &&
            (currentDiceValue === 6 || playerState[`piece${i}`].isOut && !playerState[`piece${i}`].isHome)
        }"
        @click.native="moveThisPiece(i)"
      />
    </span>
    <div class="player-info" :class="{ block: !isPlaying }" :key="`playerInfo_${playerId}`">
      <div class="icon">
        <div class="profile-icon"></div>
      </div>
      <Dice :class="{ pe: isPlaying && !choosePiece }" @roll="diceRolled" />
    </div>
  </transition-group>
</template>

<script lang="js">
import Piece from "./Piece.vue";
import Dice from "./Dice.vue";

export default {
  props: ["isPlaying", "playerId"],
  data () {
    return {
      choosePiece: false,
      currentDiceValue: 0,
      piecePositions: [{}, {}, {}, {}]
    }
  },
  mounted() {
    this.piecePositions = this.$store.getters[`${this.playerId}/defaultPiecePositions`];
  },
  computed: {
    playerState() {
      return this.$store.state[this.playerId];
    }
  },
  methods: {
    async diceRolled(event) {
      const result = await this.$store.dispatch(`${this.playerId}/diceRolled`, {
        dice: event
      });
      if (result) {
        this.$store.commit("nextPlayer");
      } else {
        this.choosePiece = true;
        this.currentDiceValue = event;
      }
    },
    async moveThisPiece(i) {
      console.log("moving " + i)
      const result = await this.$store.dispatch(`${this.playerId}/movePiece`, {
        dice: this.currentDiceValue,
        whichPiece: i
      });
      result.forEach(async (position, idx) => {
        // await setTimeout(() => {
        this.piecePositions.splice(i - 1, 1, position);
        console.log(this.piecePositions[i - 1]);
        // }, 500);
      });
      this.$store.commit("updatePieceInGrid", {
        row: this.piecePositions[i - 1]["grid-row"],
        col: this.piecePositions[i - 1]["grid-column"],
        player: this.playerId,
        piece: "piece" + i
      })
      console.log(result)
      this.choosePiece = false;
      if (this.currentDiceValue !== 6) {
        this.$store.commit("nextPlayer");
      }
      this.currentDiceValue = 0;
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
span {
  display: grid;
  place-items: center;
}
.piece-move-move {
  transition: all 0.5s linear;
}
/* span:nth-child(1) {
  grid-row: 1;
  grid-column: 2;
}
span:nth-child(2) {
  grid-row: 2;
  grid-column: 1;
}
span:nth-child(3) {
  grid-row: 2;
  grid-column: 3;
}
span:nth-child(4) {
  grid-row: 3;
  grid-column: 2;
} */
</style>
