<template>
  <i :class="pieceName" />
</template>

<script>
export default {
  computed: {
    pieceName() {
      return this.$store.state.User.currentUser.piece
    }
  }
}
</script>

<style scoped>
@import "./pieces.css";
</style>
