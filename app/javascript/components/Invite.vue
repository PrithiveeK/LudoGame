<template>
  <section>
    <form @submit.prevent="createInvite" @keyup:enter.prevent="createInvite">
      <div class="input-container">
        <label for="user" class="required">
          Players
          <i class="add-player" @click="addPlayer" :class="{ 'noshow-icon': !canIAddPlayer }" />
        </label>
        <transition-group name="appear">
          <div
            class="player-selector"
            v-for="(player, i) in inviteData.players"
            :key="'player_' + i"
          >
            <input
              type="text"
              name="user"
              placeholder="Choose Player"
              :value="player.username"
              autocomplete="off"
            />
            <i class="remove-player" @click="removePlayer(i)" :class="{ 'noshow-icon': !canIRemovePlayer }" />
            <ul class="noscroll">
              <li
                v-for="user in unInvitedUsers"
                :key="user.id"
                @click="inviteUser(i, user)"
              >{{user.username}}</li>
            </ul>
          </div>
        </transition-group>
      </div>
      <div class="input-container">
        <label for="room_name" class="required">Room Name</label>
        <input
          type="text"
          name="room_name"
          placeholder="Room name"
          v-model="inviteData.roomName"
          autocomplete="0"
        />
      </div>
      <div class="input-container">
        <label for="schedule">Schedule At</label>
        <input
          type="datetime-local"
          name="schedule"
          v-model="inviteData.scheduledAt"
          autocomplete="0"
        />
      </div>
      <div class="input-container">
        <label for="schedule">Join Window(in minutes)</label>
        <input
          type="number"
          name="join_window"
          v-model="inviteData.joinWindow"
          autocomplete="0"
          min="15"
        />
      </div>
      <button type="submit" class="game-btn">Create Invite</button>
    </form>
    <Error :errorObj="isError" v-if="isError" />
  </section>
</template>

<script lang="js">
import Error from './Error.vue'

export default {
  data () {
    return {
      inviteData: {
        players: [{id: 0, username: ""}],
        roomName: "",
        scheduledAt: new Date().toISOString().substr(0, 16),
        joinWindow: 15
      },
      isError: {
        has: false,
        msg: "",
        color: ""
      }
    }
  },
  mounted() {
    this.$store.dispatch("User/FETCH")
  },
  computed: {
    allUsers() {
      return this.$store.getters["User/allUsersButMe"]
    },
    canIAddPlayer() {
      return this.inviteData.players.length < 3 
    },
    canIRemovePlayer() {
      return this.inviteData.players.length > 1
    },
    unInvitedUsers() {
      return this.allUsers.filter(user => this.inviteData.players.findIndex(player => player.id === user.id) === -1)
    }
  },
  methods: {
    addPlayer() {
      this.inviteData.players.push({id: 0, username: ""});
    },
    removePlayer(i) {
      this.inviteData.players.splice(i, 1);
    },
    createInvite() {
      const game = {
        room_name: this.inviteData.roomName,
        scheduled_at: this.inviteData.scheduledAt,
        join_window: this.inviteData.joinWindow,
        player1_id: this.$store.state.User.currentUser.id,
        player2_id: this.inviteData.players[0].id,
        player3_id: this.inviteData.players[1]?.id ?? null,
        player4_id: this.inviteData.players[2]?.id ?? null,
      }
      fetch("/api/games", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        },
        body: JSON.stringify({game})
      }).then(res => res.json())
        .then(data => {
          if (data.done) {
            this.isError = {has: true, msg: 'Successfully Created', color: 'green'}
          } else {
            this.isError = {has: true, msg: "Couldn't create invite. Please try again", color: 'red'}
          }
        })
        .catch(err => {
            this.isError = {has: true, msg: "Something went wrong. Please try again", color: 'red'}
        }).finally(() => {
          setTimeout(() => {
            this.isError = {has: false, msg: "", color: ''}
          }, 3000);
        })
    },
    inviteUser(i, user) {
      this.inviteData.players.splice(i, 1, {
        id: user.id,
        username: user.username
      })
    }
  },
  components: {
    Error
  }
}
</script>

<style scoped>
section {
  padding: 20px;
  height: 100%;
  width: 100%;
}
form {
  display: flex;
  gap: 10px;
  /* width: 50%; */
  height: 100%;
  flex-direction: column;
  justify-content: space-around;
}
.input-container {
  display: flex;
  color: #ffffff;
  gap: 5px;
  flex-direction: column;
}
label {
  font-size: 24px;
  width: 100%;
  position: relative;
}
label.required::after {
  content: "*";
  color: red;
  margin-left: 5px;
}
input {
  color: #ffffff;
  outline: none;
  border: none;
  background: none;
  border-bottom: 2px solid currentColor;
  height: 40px;
  width: 100%;
  font-size: 20px;
}
.player-selector {
  width: 100%;
  position: relative;
  display: flex;
  align-items: center;
  background-color: #2c3e50;
}
.player-selector:focus-within > ul {
  padding: 10px 0;
  max-height: 150px;
  overflow: auto;
}
.player-selector > ul {
  position: absolute;
  width: calc(100% - 30px);
  top: 100%;
  left: 0;
  border-radius: 0 0 4px 4px;
  background-color: #4275a7;
  z-index: 2;
  max-height: 0px;
  overflow: hidden;
  transition: all 0.5s ease;
}
.player-selector li {
  line-height: 25px;
  padding: 0 5px;
  font-size: 20px;
  cursor: pointer;
}
.player-selector li:hover {
  background-color: inherit;
  filter: brightness(1.5);
}
.add-player,
.remove-player {
  float: right;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  position: relative;
  transition: all 0.3s;
}
.add-player:hover,
.remove-player:hover {
  background-color: #2c3e50;
  filter: brightness(1.5);
}
.add-player:before {
  content: "";
  position: absolute;
  width: 70%;
  height: 2px;
  background-color: green;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
.add-player:after {
  content: "";
  position: absolute;
  width: 2px;
  height: 70%;
  background-color: green;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
.remove-player:before {
  content: "";
  position: absolute;
  width: 70%;
  height: 2px;
  background-color: red;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
.appear-enter-active,
.appear-leave-active {
  transition: all 0.3s ease-in-out;
}
.appear-enter-from,
.appear-leave-to {
  z-index: 0;
  opacity: 0;
  transform: translateY(-100%);
}
.noshow-icon {
  visibility: hidden;
  pointer-events: none
}
</style>
