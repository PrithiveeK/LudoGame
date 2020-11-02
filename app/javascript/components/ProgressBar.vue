<template>
  <div id="cont" :data-points="points">
    <svg id="svg" xmlns="http://www.w3.org/2000/svg">
      <circle fill="transparent" r="1.6em" cx="50%" cy="50%"></circle>
      <circle id="bar" fill="transparent" r="1.6em" cx="50%" cy="50%" :stroke-dashoffset="progress + 'em'"></circle>
    </svg>
  </div>
</template>

<script>
export default {
  props: ["points"],
  computed: {
    progress() {
      return ((20 - (this.points % 20)) / 20) * (Math.PI * 3.2);
    }
  }
}
</script>

<style scoped>
#cont {
  height: 4em;
  width: 4em;
  margin: 0.5em;
  position: relative;
}
#cont::after {
  content: attr(data-points);
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
#svg {
  width: 100%;
  height: 100%;
  transform: rotate(-90deg);
}
circle {
  transition: stroke-dashoffset 1s ease;
  stroke: #666;
  stroke-width: 0.5em;
  stroke-dasharray: calc(3.2em * 3.14);
}
#bar {
  stroke: yellowgreen;
}
</style>
