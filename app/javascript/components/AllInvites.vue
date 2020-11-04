<template>
  <div>
    <h2>All Invites</h2>
    <ul class="invites-list-container">
      <li class="invites-item"></li>
    </ul>
  </div>
</template>

<script>
export default {
  mounted() {
    this.fetchInvites()
  },
  methods: {
    fetchInvites: function() {
      fetch("/api/invites", {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => console.log(data))
        .catch(err => console.log(err))
    }
   }
}
</script>