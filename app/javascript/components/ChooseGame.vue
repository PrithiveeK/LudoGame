<template>
  <div class="start-game-container">
    <div class="left-part">
      <h2>Play by yourself</h2>
    <button class="game-btn" @click="$router.push({name: 'Game'})">Play</button>
    </div>
    <div class="right-part">
      <h2>Your Invites</h2>
      <button @click="fetchInvites" v-if="retry">Retry</button>
      <div class="invites-list" v-else>
        <div v-if="loading === 0">Looking for Invites...</div>
        <div v-else-if="loading === -1">No Invite at the moment</div>
        <div v-else>
          <span>Invite By {{ game.created_by }} starts at {{ new Date(game.scheduled_at).toLocaleString() }}</span>
          <button v-if="canEnterGame || true" class="game-btn" @click="$router.push({name: 'Game', query: {code: game.code}})">Enter</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      loading: 0,
      retry: false,
      game: {},
      canEnterGame: false
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
      fetch("/api/invites/today", {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => {
          if (data.code === 200) {
            this.loading = 1
            this.game = data.invite
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
    }
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