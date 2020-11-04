<template>
  <div class="dice" @click="$emit('roll')" :class="{ roll: rollDice }" :style="{transform: transform}">
    <div class="dice-front">
      <span></span>
      <span></span>
      <span></span>
      <span></span>
      <span></span>
      <span></span>
    </div>
    <div class="dice-back">
      <span></span>
    </div>
    <div class="dice-right">
      <span></span>
      <span></span>
      <span></span>
      <span></span>
      <span></span>
    </div>
    <div class="dice-left">
      <span></span>
      <span></span>
    </div>
    <div class="dice-top">
      <span></span>
      <span></span>
      <span></span>
    </div>
    <div class="dice-bottom">
      <span></span>
      <span></span>
      <span></span>
      <span></span>
    </div>
  </div>
</template>

<script lang="js">
export default {
  props: ['rollDice', 'diceValue'],
  data () {
    return {
      // rollDice: false
    }
  },
  computed: {
    transform() {
      return [
        "rotateX(180deg)",
        "rotateY(90deg)",
        "rotateX(-90deg)",
        "rotateX(90deg)",
        "rotateY(-90deg)",
        "rotate(0deg)"
      ][this.diceValue - 1];
    }
  },
  methods: {
    roll() {
      // this.rollDice = true;
      setTimeout(() => {
        const value = Math.floor((Math.random() * 9876543210) % 6);
        const transform = [
          "rotateX(180deg)",
          "rotateY(90deg)",
          "rotateX(-90deg)",
          "rotateX(90deg)",
          "rotateY(-90deg)",
          "rotate(0deg)"
        ][value];
        this.$el.style.transform = transform;
        // this.rollDice = false;
        this.$emit("roll", value + 1);
      }, 1000);
    }
  }
}
</script>

<style scoped>
.dice {
  width: 50px;
  height: 50px;
  position: relative;
  transform-style: preserve-3d;
  transform: rotateX(0deg) rotateY(0deg) translateX(0);
}
.dice.roll {
  animation: roll 1s forwards infinite;
}
.dice > div {
  height: inherit;
  width: inherit;
  position: absolute;
  background: #f76331;
  border-radius: 8px;
}
.dice span {
  width: 8px;
  height: 8px;
  background: #fff;
  border-radius: 50%;
  display: block;
  position: absolute;
}
.dice .dice-front {
  transform: rotateY(0deg) translateZ(25px);
}
.dice .dice-front span:nth-child(1) {
  top: 10px;
  left: 12px;
}
.dice .dice-front span:nth-child(2) {
  top: 10px;
  right: 12px;
}
.dice .dice-front span:nth-child(3) {
  top: 21px;
  left: 12px;
}
.dice .dice-front span:nth-child(4) {
  top: 21px;
  right: 12px;
}
.dice .dice-front span:nth-child(5) {
  bottom: 10px;
  left: 12px;
}
.dice .dice-front span:nth-child(6) {
  bottom: 10px;
  right: 12px;
}
.dice .dice-back {
  transform: rotateX(180deg) translateZ(25px);
}
.dice .dice-back span {
  top: 21px;
  left: 21px;
}
.dice .dice-right {
  transform: rotateY(90deg) translateZ(25px);
}
.dice .dice-right span:nth-child(1) {
  top: 12px;
  left: 12px;
}
.dice .dice-right span:nth-child(2) {
  top: 12px;
  right: 12px;
}
.dice .dice-right span:nth-child(3) {
  top: 21px;
  left: 21px;
}
.dice .dice-right span:nth-child(4) {
  bottom: 12px;
  left: 12px;
}
.dice .dice-right span:nth-child(5) {
  bottom: 12px;
  right: 12px;
}
.dice .dice-left {
  transform: rotateY(-90deg) translateZ(25px);
}
.dice .dice-left span:nth-child(1) {
  top: 12px;
  right: 12px;
}
.dice .dice-left span:nth-child(2) {
  bottom: 12px;
  left: 12px;
}
.dice .dice-top {
  transform: rotateX(90deg) translateZ(25px);
}
.dice .dice-top span:nth-child(1) {
  top: 12px;
  right: 12px;
}
.dice .dice-top span:nth-child(2) {
  bottom: 12px;
  left: 12px;
}
.dice .dice-top span:nth-child(3) {
  bottom: 21px;
  left: 21px;
}
.dice .dice-bottom {
  transform: rotateX(-90deg) translateZ(25px);
}
.dice .dice-bottom span:nth-child(1) {
  top: 12px;
  right: 12px;
}
.dice .dice-bottom span:nth-child(2) {
  top: 12px;
  left: 12px;
}
.dice .dice-bottom span:nth-child(3) {
  bottom: 12px;
  left: 12px;
}
.dice .dice-bottom span:nth-child(4) {
  bottom: 12px;
  right: 12px;
}

@keyframes roll {
  10% {
    transform: rotate3d(1, 1, 1, 33deg);
  }
  20% {
    transform: rotate3d(4, 4, 2, 133deg);
  }
  30% {
    transform: rotate3d(5, 3, 5, 169deg);
  }
  40% {
    transform: rotate3d(9, 4, 9, 237deg);
  }
  50% {
    transform: rotate3d(10, 7, 8, 331deg);
  }
  60% {
    transform: rotate3d(19, 14, 10, 437deg);
  }
  70% {
    transform: rotate3d(27, 19, 17, 143deg);
  }
  80% {
    transform: rotate3d(39, 45, 18, 243deg);
  }
  90% {
    transform: rotate3d(52, 29, 59, 473deg);
  }
  100% {
    transform: rotate3d(1, 1, 1, 45deg);
  }
}
</style>
