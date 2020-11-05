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
    for (let j = 0; j < 16; j++) {
      const canKill = !( (i === 7 && j === 2) || (i === 2 && j === 9) || (i === 9 && j === 14) || (i === 14 && j === 7) )
      inGrid.push({count: 0, canKill, pieces: []}); //pieces: {player: "", piece: ""}
    }
    grid.push(inGrid);
  }
  return grid;
}

function findNextPlayer(state, i) {
  if (state[`Player${i}`].noOfPiecesHome !== 4) return i
  return findNextPlayer(state, (i % 4) + 1)
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
    noOfPlayers: 4,
    noOfPlayersFinished: 0,
    you: "Player1",
    isStarted: false,
    isEnd: false,
    scoreBoard: [],
    onlineMode: false
  },
  mutations: {
    startGame(state) {
      state.isStarted = true
    },
    setPlayerInfo(state, payload) {
      state.you = payload.you
      state.noOfPlayers = payload.noOfPlayers
      state.noOfPlayersFinished = payload.noOfPlayersFinished
      state.currentPlayer = payload.currentPlayer
      state.onlineMode = payload.onlineMode
    },
    incrementFinishedPlayers(state, who) {
      state.scoreBoard.push(who)
      ++state.noOfPlayersFinished
    },
    endGame(state) {
      state.isEnd = true
    },
    nextPlayer(state, nxtPlayer) {
      state.currentPlayer = nxtPlayer
    },
    //payload contains => {row: number, col: number, player: string, piece: string}
    updatePieceInGrid(state, payload) {
      ++state.boardGrid[payload.row][payload.col].count;
      state.boardGrid[payload.row][payload.col].pieces.push({
        player: payload.player,
        piece: payload.piece
      });
      console.log("updated");
    },
    removePieceInGrid(state, payload) {
      const position = state.boardGrid[payload.row][payload.col]
      const idx = position.pieces.findIndex(piece => piece.player === payload.player && piece.piece === payload.piece)
      if (idx !== -1) {
        ++position.count;
        position.pieces.splice(idx, 1);
        console.log("removed");
      }
    }
  },
  actions: {
    setGame(ctx, payload) {
      ctx.commit("startGame")
      for (let [key, value] of Object.entries(payload)) {
        ctx.commit(`${key}/setPiecePositions`, value)
      }
    },
    nextPlayer(ctx, whichPlayer) {
      let nxtPlayer = 0
      switch(whichPlayer) {
        case "Player1": nxtPlayer = findNextPlayer(ctx.state, 2); break;
        case "Player2": nxtPlayer = findNextPlayer(ctx.state, 3); break;
        case "Player3": nxtPlayer = findNextPlayer(ctx.state, 4); break;
        case "Player4": nxtPlayer = findNextPlayer(ctx.state, 1); break;
      }
      ctx.commit("nextPlayer", nxtPlayer)
    },
    async movePiece(ctx, payload) {
      const piecePosition = ctx.getters[`${payload.whichPlayer}/piecePositionRaw`](payload.whichPiece)
      ctx.commit("removePieceInGrid", {
        row: piecePosition.row,
        col: piecePosition.col,
        player: payload.whichPlayer,
        piece: payload.whichPiece
      })
      const result = await ctx.dispatch(`${payload.whichPlayer}/movePiece`, payload)
      ctx.commit("updatePieceInGrid", {
        row: result.row,
        col: result.col,
        player: payload.whichPlayer,
        piece: payload.whichPiece
      })
      const position = ctx.state.boardGrid[result.row][result.col]
      if (position.count !== 0 && position.canKill) {
        position.pieces.filter(piece => piece.player !== payload.whichPlayer).forEach(piece => {
          console.log(`${payload.whichPlayer} killed ${piece.player}'s ${piece.piece}`)
          Vue.prototype.$cable.perform({
            channel: 'my_game_room',
            action: 'kill_piece',
            data: {
              whichPlayer: piece.player,
              whichPiece: piece.piece
            }
          })
        })
      }
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
