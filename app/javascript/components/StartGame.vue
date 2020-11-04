<template>
  <section>
    <img src="../assets/ludo_start_empty_bg.png" alt="" class="logo" />
    <div class="buttons">
      <button @click="$emit('start')" class="game-btn">Start</button>
      <button class="game-btn">Continue</button>
    </div>
  </section>
</template>

<style scoped>
section {
  position: relative;
}
.buttons {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translateX(-50%) rotateY(-10deg);
  display: flex;
  gap: 10px;
}
</style>
