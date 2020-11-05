<template>
  <section>
    <div class="icon exit" @click="$router.push({ name: 'Home' })"></div>
    <div class="heading">
      <span @click="display = 'me'" :class="{highlight: display === 'me'}" >My Stats</span>
      <span class="seperator"></span>
      <span @click="display = 'all'" :class="{highlight: display === 'all'}">Leaderboard</span>
    </div>
    <transition-group name="fade" tag="div" class="table-container">
      <Table
        v-if="display === 'me'"
        :tHead="['S.No', 'Room Name', 'Result']"
        :lookUp="'my_stats'"
        key="me"
      />
      <Table
        v-if="display === 'all'"
        :tHead="['Rank', 'Name', 'Points']"
        :lookUp="'leaderboard'"
        key="all"
      />
    </transition-group>
  </section>
</template>

<script lang="js">
import Table from "./Table.vue";

export default {
  data () {
    return {
      display: 'me'
    }
  },
  components: {
    Table
  },
  watch: {
    $route (to, from) {
      this.display = to.query.stats ?? 'me'
    }
  }
}
</script>

<style scoped>
section {
  padding: 20px 20px 0;
  display: grid;
  grid-template-rows: 30% 70%;
  position: relative;
}
.heading {
  color: #a0a0a0;
  border-bottom: 2px solid currentColor;
  display: grid;
  grid-template-columns: 1fr 2px 1fr;
  width: 100%;
  height: 70px;
  padding: 5px;
  place-self: center;
  place-items: center;
}
.heading > span {
  height: 100%;
  font-size: 40px;
  transition: all 0.3s;
}
.highlight {
  color: yellowgreen;
}
span.seperator {
  width: 2px;
  height: 100%;
  background-color: currentColor;
}
.heading > span:hover {
  transform: scale(1.12);
}
.heading > span:active {
  transform: scale(0.97);
}
.table-container {
  width: 100%;
}
.icon {
  width: 50px;
  height: 50px;
  position: absolute;
  top: 70px;
  right: 10px;
  border-radius: 50%;
  background-color: #4275a7;
  filter: brightness(0.7);
  transition: all 0.2s;
  z-index: 2;
}
.icon:hover {
  transform: scale(1.2);
}
.icon:active {
  transform: scale(0.98);
}
.exit:before {
  content: "";
  position: absolute;
  height: 60%;
  width: 2px;
  background-color: white;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotateZ(45deg);
}
.exit:after {
  content: "";
  position: absolute;
  height: 60%;
  width: 2px;
  background-color: white;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotateZ(-45deg);
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
.fade-enter-active,
.fade-leave-active {
  transition: all 1s ease-in-out;
}
</style>
