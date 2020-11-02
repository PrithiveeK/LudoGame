<template>
  <section class="floating-window-container">
    <div class="floating-window">
      <div class="close" @click="$emit('close')"></div>
      <slot></slot>
    </div>
  </section>
</template>

<style scoped>
.floating-window-container {
  width: inherit;
  height: inherit;
  pointer-events: all;
  position: fixed;
  top: 0;
  left: 0;
  background-color: #00000090;
  display: grid;
  place-items: center;
  z-index: 500;
}
.floating-window {
  width: 65vw;
  height: 70vh;
  border: 14px double blue;
  background-color: #2c3e50;
  animation: drop 0.4s;
  position: relative;
}
.close {
  position: absolute;
  top: 0;
  right: 0;
  margin: 10px;
  width: 30px;
  height: 30px;
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

@keyframes drop {
  0% {
    transform: translateY(-100%);
  }
  100% {
    transform: translateY(0);
  }
}
</style>
