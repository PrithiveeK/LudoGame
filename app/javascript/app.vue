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
button.game-btn {
  font-size: 1.7rem;
  outline: none;
  background-color: #4275a7;
  padding: 5px 10px;
  color: white;
  box-shadow: 0 4px 14px 2px #2c3e50;
  border-radius: 8px;
  transition: all 0.3s;
  border: none;
}
button.game-btn:hover {
  box-shadow: 0 8px 18px 8px #2c3e50;
  transform: scale(1.03);
}
button.game-btn:active {
  box-shadow: 0 1px 8px 1px #2c3e50;
  transform: scale(0.98);
}
</style>
