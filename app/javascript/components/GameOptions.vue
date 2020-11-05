<template>
  <div class="options">
    <div class="icon exit" @click="initClose"></div>
    <Popup :showMe="warn">
      <template>
        <span>Save the process?</span>
        <button class="game-btn" @click="saveAndClose">Save</button>
        <button class="game-btn" @click="close">Don't Save</button>
      </template>
    </Popup>
  </div>
</template>

<script>
import Popup from './Popup.vue'

export default {
  data() {
    return {
      warn: false
    }
  },
  computed: {
    isOffline() {
      return !this.$store.state.onlineMode
    }
  },
  methods: {
    initClose() {
      if (this.isOffline) {
        this.warn = true
      } else {
        this.close()
      }
    },
    close() {
      this.$router.push({ name: 'Home' })
    },
    saveAndClose() {
      this.$cable.perform({
        channel: 'my_game_room',
        action: 'save_game'
      })
      this.close()
    }
  },
  components: {
    Popup
  }
}
</script>

<style scoped>
.options {
  position: absolute;
  top: 0;
  right: 0;
  margin: 20px;
  display: grid;
  gap: 5px;
}
.icon {
  width: 50px;
  height: 50px;
  position: relative;
  border-radius: 50%;
  background-color: #4275a7;
  filter: brightness(0.7);
  transition: all 0.2s;
}
.icon:hover {
  transform: scale(1.2);
}
.icon:active {
  transform: scale(0.98);
}
.chat:before {
  content: "";
  position: absolute;
  width: 60%;
  height: 40%;
  border: 2px solid #555;
  background-color: white;
  border-radius: 4px;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -65%);
}
.chat:after {
  content: "";
  position: absolute;
  border-style: solid;
  border-width: 8px;
  border-color: white transparent transparent white;
  top: 50%;
  left: 20%;
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
</style>
