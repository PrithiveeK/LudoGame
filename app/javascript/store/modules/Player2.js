/* eslint-disable */

const moveGrid = [
  [2, 9], [3, 9], [4, 9], [5, 9], [6, 9],
  [7, 10], [7, 11], [7, 12], [7, 13], [7, 14], [7, 15],
  [8, 15],
  [9, 15], [9, 14], [9, 13], [9, 12], [9, 11], [9, 10],
  [10, 9], [11, 9], [12, 9], [13, 9], [14, 9], [15, 9],
  [15, 8],
  [15, 7], [14, 7], [13, 7], [12, 7], [11, 7], [10, 7],
  [9, 6], [9, 5], [9, 4], [9, 3], [9, 2], [9, 1],
  [8, 1],
  [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6],
  [6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7],
  [1, 8], [2, 8], [3, 8], [4, 8], [5, 8], [6, 8], [7, 8]
];

const state = {
  piece1: {
    currentPosition: -1,
    defaultPosition: ["2", "-3/-5"],
    isOut: false,
    isHome: false
  },
  piece2: {
    currentPosition: -1,
    defaultPosition: ["3/5", "-5/-6"],
    isOut: false,
    isHome: false
  },
  piece3: {
    currentPosition: -1,
    defaultPosition: ["3/5", "-2/-3"],
    isOut: false,
    isHome: false
  },
  piece4: {
    currentPosition: -1,
    defaultPosition: ["5", "-3/-5"],
    isOut: false,
    isHome: false
  },
  choosePiece: false,
  dice: 6,
  isRolling: false,
  noOfPiecesHome: 0,
  noOfPiecesOut: 0
};

const getters = {
  piecePosition: (state) => (piece) => {
    const pos = state[piece].currentPosition;
    return {
      "grid-row": pos === -1 ? state[piece].defaultPosition[0] : moveGrid[pos][0],
      "grid-column": pos === -1 ? state[piece].defaultPosition[1] : moveGrid[pos][1]
    }
  },
  piecePositionRaw: (state) => (piece) => {
    const pos = state[piece].currentPosition;
    return {
      row: pos === -1 ? 0 : moveGrid[pos][0],
      col: pos === -1 ? 0 : moveGrid[pos][1]
    }
  }
};

const mutations = {
  setPiecePositions(state, payload) {
    for(let [key, value] of Object.entries(payload)) {
      state[key].currentPosition = value
      if (value > -1) {
        state[key].isOut = true
        ++state.noOfPiecesOut
      }
      if (value === 56) {
        state[key].isHome = true
        ++state.noOfPiecesHome
      }
    }
  },
  choosePiece(state, choose) {
    state.choosePiece = choose
  },
  roll(state, isRolling) {
    state.isRolling = isRolling
  },
  rollDice(state, dice) {
    state.isRolling = false
    state.dice = dice
  },
  startPiece(state, whichPiece) {
    console.log(whichPiece + " entered");
    state[whichPiece].currentPosition = 0;
    state[whichPiece].isOut = true;
    ++state.noOfPiecesOut;
  },
  movePiece(state, payload) {
    if (state[payload.whichPiece].currentPosition + payload.dice <= 56)
      state[payload.whichPiece].currentPosition += payload.dice
    if (state[payload.whichPiece].currentPosition === 56) {
      state[payload.whichPiece].isHome = true
      ++state.noOfPiecesHome
    }
  },
  killPiece(state, whichPiece) {
    state[whichPiece].currentPosition = -1;
    state[whichPiece].isOut = false;
    --state.noOfPiecesOut;
  }
};

const actions = {
  async diceRolled(ctx, payload) {
    console.log("Player2 rolled");
    if (ctx.state.noOfPiecesOut === 0 && payload.dice !== 6) return true;
    return false;
  },
  async movePiece(ctx, payload) {
    console.log("Player2 moved");
    if (payload.dice === 6 && !ctx.state[payload.whichPiece].isOut) {
      ctx.commit("startPiece", payload.whichPiece);
    } else {
      ctx.commit("movePiece", {
        whichPiece: payload.whichPiece,
        dice: payload.dice
      })
    }
    return ctx.getters.piecePositionRaw(payload.whichPiece);
  }
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
};
