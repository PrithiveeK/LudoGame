<template>
  <div class="confirm-action-container" v-show="showMe">
    <transition name="zoom-in">
      <div class="confirm-action" v-if="showMe">
        <i class="close" @click="$emit('close')"></i>
        <slot></slot>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  props: ["showMe"]
}
</script>

<style scoped>
.confirm-action-container {
  background-color: #00000090;
  pointer-events: all;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  display: grid;
  place-items: center;
}
.confirm-action {
  width: 400px;
  min-height: 200px;
  background-color: #4275a7f0;
  border-radius: 8px;
  display: grid;
  place-items: center;
  position: relative;
}
.close {
  position: absolute;
  top: 0;
  right: 0;
  margin: 5px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background-color: #2c3e5050;
  filter: brightness(0.6);
  transition: all 0.2s;
  z-index: 1;
}
.close:hover {
  transform: scale(1.2);
}
.close:active {
  transform: scale(0.98);
}
.close:before {
  content: "";
  position: absolute;
  height: 70%;
  width: 2px;
  background-color: white;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotateZ(45deg);
}
.close:after {
  content: "";
  position: absolute;
  height: 70%;
  width: 2px;
  background-color: white;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotateZ(-45deg);
}
.zoom-in-enter-from,
.zoom-in-leave-to {
  transform: scale(0);
}
.zoom-in-enter-active,
.zoom-in-leave-active {
  transition: transform 1s;
}
</style>