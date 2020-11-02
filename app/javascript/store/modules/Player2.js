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

function convertToGrid([row, col]) {
  return {
    "grid-row": row,
    "grid-column": col
  };
}

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
  isEnd: false,
  noOfPiecesOut: 0
};

const getters = {
  piecePosition: (state) => (piece) => {
    const pos = state[piece].currentPosition;
    if (pos === -1) {
      return {
        "grid-row": state[piece].defaultPosition[0],
        "grid-column": state[piece].defaultPosition[1]
      }
    }
    return convertToGrid(moveGrid[pos]);
  },
  defaultPiecePositions: (state, getters) => {
    return [
      getters.piecePosition("piece1"),
      getters.piecePosition("piece2"),
      getters.piecePosition("piece3"),
      getters.piecePosition("piece4")
    ]
  },
  tracePath: (state, getters) => (piece, prevI, dice) => {
    if (prevI === -1) {
      return [getters.piecePosition(piece)];
    }
    return moveGrid.slice(prevI + 1, prevI + dice + 1).map(pos => convertToGrid(pos))
  }
};

const mutations = {
  startPiece(state, whichPiece) {
    state[whichPiece].currentPosition = 0;
    state[whichPiece].isOut = true;
    ++state.noOfPiecesOut;
  },
  movePiece(state, payload) {
    state[payload.whichPiece].currentPosition += payload.dice;
  }
};

const actions = {
  diceRolled(ctx, payload) {
    console.log("Player2 rolled");
    if (ctx.state.noOfPiecesOut === 0 && payload.dice !== 6) return true;
    return false;
  },
  movePiece(ctx, payload) {
    console.log("Player2 moved");
    const currPiece = "piece" + payload.whichPiece;
    const prevI = ctx.state[currPiece].currentPosition;
    if (payload.dice === 6 && !ctx.state[currPiece].isOut) {
      ctx.commit("startPiece", currPiece);
    } else {
      ctx.commit("movePiece", {
        whichPiece: currPiece,
        dice: payload.dice
      })
    }
    return ctx.getters.tracePath(currPiece, prevI, payload.dice);
  }
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
};
