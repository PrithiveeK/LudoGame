<template>
  <div class="start-game-container">
    <div class="left-part">
      <h2>Play by yourself</h2>
    <button class="game-btn" @click="startSelfGame">Play</button>
    </div>
    <div class="right-part">
      <h2>Your Invites</h2>
      <button @click="fetchInvites" v-if="retry" class="game-btn">Retry</button>
      <div class="invites-list" v-else>
        <div v-if="loading === 0">Looking for Invites...</div>
        <div v-else-if="loading === -1">No Invite at the moment</div>
        <div v-else>
          <span>Invite By {{ game.created_by }} starts at {{ new Date(game.scheduled_at).toLocaleString() }}</span>
          <button v-if="canEnterGame || true" class="game-btn" @click="$router.push({name: 'Game', query: {code: game.code}})">Enter</button>
        </div>
      </div>
    </div>
    <Error v-if="isError.has" :errorObj="isError" />
  </div>
</template>

<script>
import Error from './Error.vue'

export default {
  data () {
    return {
      loading: 0,
      retry: false,
      game: {},
      canEnterGame: false,
      isError: {has: false, msg: '', color: ''}
    }
  },
  mounted() {
    this.fetchInvites()
  },
  methods: {
    canEnter() {
      this.canEnterGame = (Date.now() >= new Date(this.game.scheduled_at).getTime() && Date.now() <= new Date(this.game.joinWindow).getTime())
    },
    fetchInvites() {
      fetch("/api/games/now", {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => {
          if (data.code === 200) {
            this.loading = 1
            this.game = data.game
            this.canEnter()
          } else {
            this.loading = -1
          }
          this.retry = false
        })
        .catch(err => {
          console.log(err)
          this.retry = true
        })
    },
    startSelfGame() {
      const game = {
        room_name: "self",
        scheduled_at: new Date().toISOString().substr(0, 16),
        join_window: 15,
        player1_id: this.$store.state.User.currentUser.id,
        player2_id: this.$store.state.User.currentUser.id,
        player3_id: this.$store.state.User.currentUser.id,
        player4_id: this.$store.state.User.currentUser.id
      }
      fetch("/api/games", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        },
        body: JSON.stringify({game})
      }).then(res => res.json())
        .then(data => {
          if (data.done) {
            this.$router.push({name: 'Game', query: {code: data.code}})
          } else {
            this.isError = {has: true, msg: "Couldn't Start game. Please try again", color: 'red'}
          }
        })
        .catch(err => {
            this.isError = {has: true, msg: "Something went wrong. Please try again", color: 'red'}
        }).finally(() => {
          setTimeout(() => {
            this.isError = {has: false, msg: "", color: ''}
          }, 3000);
        })
    }
  },
  components: {
    Error
  }
}
</script>

<style scoped>
.start-game-container {
  height: 100%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  place-items: center;
  padding: 20px;
  gap: 20px;
  font-size: 24px;
  color: white;
}
.left-part,
.right-part {
  display: grid;
  gap: 20px;
  text-align: center;
}
.invites-list {
  padding: 5px;
  border: 2px solid currentColor;
  border-radius: 8px;
}
</style>