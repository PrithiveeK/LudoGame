<template>
  <div class="invite-list-section">
    <h2>All Invites</h2>
    <ul class="invites-list-container noscroll">
      <li class="invites-item" v-for="row in rows" :key="row.id">
        <div>{{ `${row.room} is created, and scheduled for ${new Date(row.scheduled_at).toLocaleString()}` }}</div>
        <div>{{`Players: ${row.players.join(', ')}`}}</div>
        <div>{{`Status: ${row.status}`}}</div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
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
      fetch("/api/game/invites", {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => {
          if(data.code === 200) {
            this.rows = data.invites
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