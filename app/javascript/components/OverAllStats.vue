<template>
  <section>
    <article>
      <ProgressBar :points="level" />
      <span>Level</span>
    </article>
    <article>
      <ProgressBar :points="points" />
      <span>Points</span>
    </article>
  </section>
</template>

<script>
import ProgressBar from './ProgressBar.vue'

export default {
  components: {
    ProgressBar
  },
  computed: {
    level() {
      return this.$store.state.User.currentUser?.level
    },
    points() {
      return this.$store.state.User.currentUser?.points
    }
  }
}
</script>

<style scoped>
section {
  margin: 10px;
  display: flex;
  gap: 10px;
  position: absolute;
  flex-direction: column;
  top: 50%;
  left: 0;
  transform: translateY(-50%);
  z-index: 100;
}
article {
  width: 13rem;
  border-radius: 8px;
  background-color: #4275a780;
  display: flex;
  align-items: center;
  color: aliceblue;
}
span {
  font-size: 24px;
}
</style>
