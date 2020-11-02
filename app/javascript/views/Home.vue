<template>
  <div class="main noscroll">
    <Dashboard class="home" />
    <Stats class="stats" />
  </div>
</template>

<script lang="js">
import Dashboard from "../components/Dashboard.vue";
import Stats from "../components/Stats.vue";

export default {
  components: {
    Dashboard,
    Stats
  },
  mounted() {
    if (this.$route.query.stats) {
      this.viewStats()
    } else {
      this.hideStats()
    }
  },
  methods: {
    viewStats: function () {
      this.$el.scrollTop = this.$el.scrollHeight
    },
    hideStats: function () {
      this.$el.scrollTop = 0
    }
  },
  watch: {
    $route (to, from) {
      if (to.query.stats) {
        this.viewStats()
      } else {
        this.hideStats()
      }
    }
  }
}
</script>

<style>
.main {
  overflow: hidden;
  width: inherit;
  height: inherit;
  scroll-behavior: smooth;
}
.main > section {
  width: inherit;
  height: inherit;
  padding-top: 3rem;
  overflow: hidden;
}
.home {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-around;
}
img.logo {
  pointer-events: none;
  width: 30rem;
  max-width: 85vw;
}
</style>
