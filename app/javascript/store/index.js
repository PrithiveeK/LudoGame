import Vue from 'vue'
import Vuex from 'vuex'
import Player1 from "./modules/Player1";
import Player2 from "./modules/Player2";
import Player3 from "./modules/Player3";
import Player4 from "./modules/Player4";
import User from "./modules/User";

function createBoardGrid() {
  const grid = [];
  for (let i = 0; i < 16; i++) {
    const inGrid = [];
    for (let j = 0; j < 16; j++) inGrid.push({count: 0, pieces: []});
    grid.push(inGrid);
  }
  return grid;
}

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    players:{
      Player1: "red",
      Player2: "blue",
      Player3: "green",
      Player4: "yellow"
    },
    currentPlayer: 1,
    boardGrid: createBoardGrid(),
    socket: {
      isConnected: false
    }
  },
  mutations: {
    nextPlayer(state) {
      if (state.currentPlayer === 4) state.currentPlayer = 1;
      else ++state.currentPlayer;
    },
    //payload contains => {row: number, col: number, player: string, piece: string}
    updatePieceInGrid(state, payload) {
      ++state.boardGrid[payload.row][payload.col].count;
      state.boardGrid[payload.row][payload.col].pieces.push({
        player: payload.player,
        piece: payload.piece
      });
      console.log("updated");
    }
  },
  actions: {
    setPiecePositions() {
      //... Yet to complete
    }
  },
  modules: {
    User,
    Player1,
    Player2,
    Player3,
    Player4
  }
})
