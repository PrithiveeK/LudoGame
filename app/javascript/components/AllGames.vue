<template>
  <div class="invite-list-section">
    <h2>{{title}}</h2>
    <ul class="invites-list-container noscroll">
      <li class="invites-item" v-for="row in rows" :key="row.id">
        <div>{{ `${row.room} is created, and scheduled on ${new Date(row.scheduled_at).toLocaleString()}` }}</div>
        <div>{{`Players: ${row.players.join(', ')}`}}</div>
        <div>{{`Status: ${row.status}`}}</div>
        <button
          v-if="type === 'saved'"
          class="game-btn"
          @click="$router.push({name: 'Game', query: {code: row.code}})"
        >Continue</button>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: ["type", "title"],
  data() {
    return {
      rows: []
    }
  },
  mounted() {
    this.fetchInvites()
  },
  methods: {
    fetchInvites: function() {
      fetch("/api/games?type="+this.type, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => {
          if(data.code === 200) {
            this.rows = data.games
          }
        })
        .catch(err => console.log(err))
    }
   }
}
</script>

<style scoped>
.invite-list-section {
  padding: 20px;
}
h2 {
  text-align: center;
  font-size: 50px;
}
.invites-list-container {
  display: grid;
  overflow: auto;
  gap: 20px;
}
.invites-item {
  border: 2px solid white;
  color: white;
  padding: 10px;
  font-size: 22px;
  border-radius: 8px;
}
</style>