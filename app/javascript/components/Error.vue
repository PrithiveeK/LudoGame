<template>
  <div class="error-container" :style="{'background-color': errorObj.color}">
    {{ errorObj.msg }}
  </div>
</template>

<script lang="js">
export default {
  props: ["errorObj"]
}
</script>

<style scoped>
.error-container {
  position: fixed;
  padding: 10px 20px;
  bottom: 10px;
  left: 50%;
  transform: translateX(-50%);
  color: white;
  border-radius: 4px;
  font-size: 20px;
  animation: appear 0.5s linear;
}

@keyframes appear {
  0% {
    transform: translate(-50%, 100%);
  }
  100% {
    transform: translate(-50%, 0);
  }
}
</style>