<template>
  <div class="player-container">
    <div class="player-home">
      <div class="piece-holder" v-for="i in 4" :key="i" />
    </div>
    <div class="player-path">
      <i
        v-for="i in 18"
        :key="i"
        :class="{ 'home-path': ~[2, 8, 9, 10, 11, 12].indexOf(i) }"
      >
        <svg
          v-if="i === 7"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          width="75%"
          viewBox="0 0 50 80"
          xml:space="preserve"
        >
          <polyline
            fill="none"
            stroke-width="6"
            stroke-linecap="round"
            stroke-linejoin="round"
            points="45.63,75.8 0.375,38.087 45.63,0.375 "
          />
        </svg>
      </i>
    </div>
  </div>
</template>

<style scoped>
svg {
  transform: rotateZ(180deg) scale(0.6);
}
polyline {
  stroke: currentColor;
}
.player-container {
  display: grid;
  width: 20em;
  height: 32em;
  grid-template-rows: 20em 12em;
  position: relative;
}
.player-container:after {
  content: "";
  position: absolute;
  width: 0;
  height: 0;
  bottom: 0;
  left: 100%;
  border-style: solid;
  border-width: 6em 0 6em 6em;
  border-color: transparent currentColor;
  z-index: -1;
}
.player-home {
  width: 80%;
  height: 80%;
  border-radius: 30%;
  background-color: currentColor;
  place-self: center;
  transform: rotateZ(45deg);
  display: grid;
  grid-template-columns: 1fr 1fr;
  place-items: center;
}
.piece-holder {
  width: 65%;
  height: 65%;
  border-radius: 100%;
  background-color: white;
  display: grid;
  place-items: center;
  transform: rotate(-45deg);
  transition: all 0.3s;
}
.player-path {
  width: 100%;
  height: 100%;
  background-color: #888;
  display: grid;
  grid-template: repeat(3, 1fr) / repeat(6, 1fr);
  gap: 2px;
}
i {
  display: block;
  width: 100%;
  height: 100%;
  background-color: white;
}
.home-path {
  background-color: currentColor;
}
</style>
