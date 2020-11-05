<template>
  <div class="board-overlay">
    <PlayerManager
      class="red"
      id="Player1"
      :isPlaying="currentPlayer === 1"
      :playerId="'Player1'"
    />
    <PlayerManager
      class="blue"
      id="Player2"
      :isPlaying="currentPlayer === 2"
      :playerId="'Player2'"
    />
    <PlayerManager
      class="green"
      id="Player3"
      :isPlaying="currentPlayer === 3"
      :playerId="'Player3'"
    />
    <PlayerManager
      class="yellow"
      id="Player4"
      :isPlaying="currentPlayer === 4"
      :playerId="'Player4'"
    />
  </div>
</template>

<script lang="js">
import PlayerManager from "./PlayerManager.vue";
import Piece from "./Piece.vue"

export default {
  components: {
    PlayerManager,
    Piece
  },
  channels: {
    my_game_room: {
      connected() {
        console.log("subscribed to Game")
      },
      disconnected() {
        console.log("disconnected from Game")
      },
      received(data) {
        console.log(data)
        switch(data.action) {
          case "rolling": this.rolling(data.payload);break;
          case "dice_rolled": this.diceRolled(data.payload);break;
          case "move_piece": this.movePiece(data.payload);break;
          case "kill_piece": this.killPiece(data,payload);break;
          case "next_player": this.nextPlayer(data.payload);break;
          case "player_info": this.setPlayerInfo(data.payload);break;
          case "player_home": this.setPlayerHome(data.payload);break;
          case "start": this.startGame(data.payload);break;
          case "end": this.endGame();break;
        }
      },
      rejected() {
        console.log("You don't belong here")
      }
    }
  },
  computed: {
    currentPlayer() {
      return this.$store.state.currentPlayer;
    }
  },
  methods: {
    subscribeToGame() {
      const game_code = this.$route.query.code
      this.$cable.subscribe({
        channel: "GameChannel",
        room: game_code
      }, 'my_game_room')
    },
    rolling(payload) {
      this.$store.commit(`${payload.whichPlayer}/roll`, true)
    },
    diceRolled(payload) {
      setTimeout(() => {
        this.$store.commit(`${payload.whichPlayer}/rollDice`, payload.dice)
        this.$store.dispatch(`${payload.whichPlayer}/diceRolled`, {
          dice: payload.dice
        }).then(result => {
          if (result) {
            this.$cable.perform({
              channel: 'my_game_room',
              action: 'next_player',
              data: {
                currentPlayer: payload.whichPlayer
              }
            })
          } else {
            this.$store.commit(`${payload.whichPlayer}/choosePiece`, true)
          }
        })
      }, 1000);
    },
    movePiece(payload) {
      console.log("moving " + payload.whichPiece)
      this.$store.dispatch(`movePiece`, payload).then(() => {
        if (payload.dice !== 6) {
          this.$cable.perform({
            channel: 'my_game_room',
            action: 'next_player',
            data: {
              currentPlayer: payload.whichPlayer
            }
          })
        }
      });
      this.$store.commit(`${payload.whichPlayer}/choosePiece`, false)
    },
    killPiece(payload) {
      this.$store.commit(`${payload.whichPlayer}/killPiece`, payload.whichPiece)
    },
    nextPlayer(payload) {
      this.$store.commit("nextPlayer", payload.nextPlayer);
    },
    setPlayerInfo(payload) {
      this.$store.commit("setPlayerInfo", payload)
    },
    setPlayerHome(payload){
      this.$store.commit('incrementFinishedPlayers', payload.whichPlayer)
    },
    startGame(payload) {
      this.$store.dispatch("setGame", payload)
    },
    endGame() {
      this.$store.commit("endGame")
    }
  },
  mounted() {
    this.subscribeToGame()
  },
  destroyed() {
    this.$cable.unsubscribe('my_game_room')
  }
}
</script>

<style>
.board-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: grid;
  grid-template: repeat(15, 1fr) / repeat(15, 1fr);
  /* background-color: #12345680; */
  gap: 1em;
}
.path {
  background-color: chocolate;
  display:flex;
  align-items: center;
  justify-content: space-around;
}
#Player1 {
  grid-row: 1/7;
  grid-column: 1/7;
}
#Player2 {
  grid-row: 1/7;
  grid-column: -1/-7;
}
#Player3 {
  grid-row: -1/-7;
  grid-column: -1/-7;
}
#Player4 {
  grid-row: -1/-7;
  grid-column: 1/7;
}
.empty-home {
  grid-row: 7/span 3;
  grid-column: 7/span 3;
}
.player-info {
  position: absolute;
  border: 4px solid currentColor;
  display: flex;
  border-radius: 12px;
}
.show-me:after {
  content: "YOU";
  position: absolute;
  padding: 10px;
  font-size: 20px;
  background-color: white;
  border-radius: 8px;
  margin: 10px;
}
#Player1 .player-info {
  bottom: 100%;
  left: 0;
  flex-direction: row;
}
#Player1 .show-me:after {
  bottom: 100%;
  left: 0;
}
#Player2 .player-info {
  bottom: 100%;
  right: 0;
  flex-direction: row-reverse;
}
#Player2 .show-me:after {
  bottom: 100%;
  right: 0;
}
#Player3 .player-info {
  top: 100%;
  right: 0;
  flex-direction: row-reverse;
}
#Player3 .show-me:after {
  top: 100%;
  right: 0;
}
#Player4 .player-info {
  top: 100%;
  left: 0;
  flex-direction: row;
}
#Player4 .show-me:after {
  top: 100%;
  left: 0;
}
</style>
