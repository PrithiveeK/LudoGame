<template>
  <div id="app">
    <slot></slot>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  created() {
    if (!this.$store.state.User.loggedIn && localStorage.getItem("liu") != null) {
      this.$store.dispatch("User/VERIFY").then(result => {
        if (result !== "") {
          this.$router.push({ name: "Login" })
        }
      })
    }
  },
  destroyed() {
    this.$cable.connection.disconnect();
  }
}
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  user-select: none;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  background-color: #2c3e50;
  background-image: radial-gradient(circle, #4275a7, #2c3e50 60%);
  transition: all 0.3s;
}
ul {
  list-style: none;
}
.noscroll {
  scrollbar-width: none;
}
.noscroll::-webkit-scrollbar {
  display: none;
}
</style>
