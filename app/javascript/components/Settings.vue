<template>
  <section>
    <h2>Settings</h2>
    <div class="options">
      <div class="sound">
        <h4>Sound</h4>
        <span
          class="toggle"
          @click="$event.target.classList.toggle('toggled')"
        />
      </div>
      <div class="vibration">
        <h4>Vibration</h4>
        <span
          class="toggle"
          @click="$event.target.classList.toggle('toggled')"
        />
      </div>
      <div class="game-pieces">
        <h4>Game Pieces</h4>
        <ul class="piece-list">
          <li class="loading" v-if="loading"></li>
          <template v-else>
            <li
              v-for="piece in pieces"
              :key="piece.id" class="piece-item"
              :class="{purchase: piece.status === 'PURCHASE'}"
              @click="clickedProduct(piece)"
            >
              <i :class="piece.name" v-for="i in 4" :key="i"></i>
            </li>
          </template>
        </ul>
      </div>
    </div>
    <Popup :showMe="payForProduct" @close="payForProduct = false">
      <template>
        <span>Price: Re.1</span>
        <Paypal />
      </template>
    </Popup>
  </section>
</template>

<script>
import Paypal from './PayPal.vue'
import Popup from './Popup.vue'

export default {
  data() {
    return {
      payForProduct: false,
      loading: true,
      pieces: [],
      selectedPiece: {},
      setDefault: false
    }
  },
  methods: {
    fetchPieces: function() {
      this.loading = true
      fetch("/api/products", {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => {
          if (data.code === 200) {
            this.pieces = data.products
            this.loading = false
          }
        })
        .catch(err => console.log(err))
    },
    clickedProduct: function(piece) {
      this.selectedPiece = piece
      if (piece.status === "PURCHASE"){
        this.payForProduct = true
      } else {
        this.setDefault = true
      }
    }
  },
  components: {
    Paypal,
    Popup
  },
  mounted() {
    this.fetchPieces()
  }
}
</script>

<style scoped>
@import "./pieces.css";
h2 {
  text-align: center;
  margin: 20px 0;
  font-size: 40px;
}
.options {
  display: grid;
  margin: 20px;
  gap: 20px;
}
.sound,
.vibration {
  display: flex;
}
h4 {
  flex: 1;
}
.toggle {
  display: block;
  width: 40px;
  height: 20px;
  background-color: #4275a7;
  border-radius: 10px;
  position: relative;
}
.toggle:after {
  content: "";
  position: absolute;
  width: 50%;
  height: 100%;
  border-radius: 50%;
  background-color: white;
  transition: all 0.3s;
}
.toggled {
  filter: brightness(1.5);
}
.toggled:after {
  transform: translateX(100%);
}
.piece-list {
  display: flex;
  margin: 10px 0;
  gap: 20px;
}
.piece-item {
  width: 200px;
  height: 200px;
  background-color: #4275a7f0;
  border-radius: 8px;
  filter: brightness(1.5);
  display: flex;
  align-items: center;
  justify-content: space-evenly;
  font-size: 12px;
  position: relative;
  overflow: hidden;
}
.piece-item > i:nth-child(1) {
  color: red;
}
.piece-item > i:nth-child(2) {
  color: blue;
}
.piece-item > i:nth-child(3) {
  color: green;
}
.piece-item > i:nth-child(4) {
  color: yellow;
}
.piece-item.purchase::after {
  content: 'Purchase';
  position: absolute;
  width: 70%;
  height: 20px;
  background-color: lawngreen;
  top: 15%;
  left: 50%;
  transform: rotateZ(45deg);
  z-index: 700;
  font-size: 20px;
  text-align: center;
}
.loading {
  animation: loading 1s infinite;
}
span {
  font-size: 32px;
  color: white;
}
@keyframes loading {
  from {
    filter: brightness(0.5);
  }
  to {
    filter: brightness(1.5);
  }
}
</style>
