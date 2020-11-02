<template>
  <div class="options">
    <div class="icon exit" @click="$router.push({ name: 'Home' })"></div>
    <div class="icon chat"></div>
  </div>
</template>

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
