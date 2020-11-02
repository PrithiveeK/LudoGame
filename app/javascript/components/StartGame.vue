<template>
  <section>
    <img src="../assets/ludo_start_empty_bg.png" alt="" class="logo" />
    <div class="buttons">
      <button @click="$router.push({ name: 'Game' })">Start</button>
      <button>Continue</button>
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
button {
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
button:hover {
  box-shadow: 0 8px 18px 8px #2c3e50;
  transform: scale(1.03);
}
button:active {
  box-shadow: 0 1px 8px 1px #2c3e50;
  transform: scale(0.98);
}
</style>
