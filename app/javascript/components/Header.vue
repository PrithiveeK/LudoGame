<template>
  <header>
    <div class="profile">
      <div class="icon" @click="$emit('view-profile')">
        <div class="profile-icon"></div>
      </div>
      <span class="level"></span>
      <div class="user">
        <span class="name">{{ currentUser.username }}</span>
        <span class="level-progress"></span>
      </div>
    </div>
    <div class="empty"></div>
    <div class="icon-container">
      <div class="icon" tabindex="0" @focus="markAsRead">
        <div class="bell-solid">
          <i class="dot" v-if="haveNotifications"></i>
        </div>
      </div>
      <ul class="notification-list noscroll">
        <li class="notification" v-for="notification in allNotifications" :key="notification">{{ notification }}</li>
      </ul>
    </div>
    <div class="icon">
      <div class="search-icon"></div>
    </div>
    <div class="icon" @click="$emit('settings')">
      <div class="gear"></div>
    </div>
  </header>
</template>

<script>
export default {
  data () {
    return {
      haveNotifications: true,
      allNotifications: []
    }
  },
  computed: {
    currentUser() {
      return this.$store.state.User.currentUser
    }
  },
  methods: {
    markAsRead: function() {
      this.haveNotifications = false
      this.$cable.perform({
        channel: "NotificationChannel",
        action: "mark_as_read"
      })
    }
  },
  channels: {
    NotificationChannel: {
      connected() {
        console.log("subscribed to notifications");
      },
      disconnected() {
        console.log("disconnected");
      },
      received(data) {
        console.log(data);
        this.haveNotifications = true
        this.allNotifications.unshift(data.message)
      },
      rejected() {
        console.log("rejected")
      }
    }
  },
  mounted() {
    this.$cable.subscribe({
      channel: "NotificationChannel"
    })
  }
}
</script>

<style scoped>
header {
  width: inherit;
  display: flex;
  height: 3rem;
  gap: 2px;
  border-bottom: 2px solid #ffffff70;
  position: fixed;
  top: 0;
  left: 0;
  color: #4275a7;
  background-color: #2c3e50;
  z-index: 200;
}
.empty {
  flex: 1;
}
.profile {
  width: 15rem;
  height: 100%;
  display: flex;
  position: relative;
}
.level {
  display: block;
  position: absolute;
  width: 1rem;
  height: 1rem;
  bottom: 0;
  left: 2rem;
}
.user {
  display: grid;
  grid-template-rows: 1fr 5px;
  width: 100%;
  gap: 5px;
}
.name {
  justify-self: flex-start;
  font-size: 1.5rem;
  align-self: end;
}
.level-progress {
  width: 100%;
  height: 5px;
  background-color: gold;
}
.notification-list {
  position: absolute;
  top: 100%;
  right: 0;
  width: 250px;
  height: 0;
  overflow: hidden;
  background-color: #4275a7f0;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  transition: height 0.5s;
}
.notification {
  width: 100%;
  min-height: 50px;
  border-bottom: 2px solid #aaa;
  display: flex;
  align-items: center;
  color: white;
  padding: 0 10px;
}
.icon-container {
  height: 100%;
  width: 3em;
  position: relative;
}
.icon-container:focus-within > .notification-list{
  height: 200px;
  overflow: auto;
}
.icon {
  width: 3rem;
  height: 100%;
  position: relative;
  transition: all 0.3s;
  pointer-events: all;
  outline: none;
}
.icon:hover {
  transform: scale(1.2);
}
.icon:active {
  transform: scale(0.95);
}
.profile > .icon {
  float: left;
}
.profile-icon {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translateX(-50%);
  width: 25px;
  height: 10px;
  border-radius: 100% 100% 0 0;
  background-color: currentColor;
}
.profile-icon:before {
  content: "";
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  top: -140%;
  width: 10px;
  height: 10px;
  border-radius: 100%;
  background-color: currentColor;
  border: 1px solid currentColor;
}
.bell-solid {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -70%);
  width: 14px;
  height: 15px;
  border: solid 1px currentColor;
  background-color: currentColor;
  border-radius: 40% 40% 0 0;
}
.bell-solid:before {
  content: "";
  position: absolute;
  bottom: -7px;
  left: 50%;
  transform: translateX(-50%);
  width: 5px;
  height: 5px;
  border-radius: 50%;
  border: solid 1px currentColor;
  background-color: currentColor;
}
.bell-solid:after {
  content: "";
  position: absolute;
  bottom: -2px;
  left: -3px;
  width: 18px;
  height: 0px;
  border-top: solid 1px currentColor;
  border-bottom: solid 1px;
}
i.dot {
  position: absolute;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: yellowgreen;
  top: -5px;
  right: -5px;
}
.search-icon {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-60%, -70%) rotate(-45deg);
  width: 20px;
  height: 20px;
  border: solid 3px currentColor;
  border-radius: 100%;
}
.search-icon:before {
  content: "";
  position: absolute;
  top: 102%;
  left: calc(50% - 1px);
  height: 10px;
  width: 2px;
  background-color: currentColor;
}
.gear {
  position: absolute;
  top: calc(50% - 0.6em);
  left: calc(50% - 0.6em);
  width: 1em;
  height: 1em;
  background: #2c3e50;
  border-radius: 50%;
  border: 4px solid currentColor;
}
.gear:before,
.gear:after {
  content: "+";
  position: absolute;
  z-index: -1;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 2.7em;
}
.gear:after {
  transform: translate(-50%, -50%) rotate(45deg);
}
.show-notification-enter-from,
.show-notification-leave-to {
  height: 0px;
}
.show-notification-enter-active,
.show-notification-leave-active {
  transition: height 0.5s;
}
</style>
