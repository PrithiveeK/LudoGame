<template>
  <section>
    <div class="edit-part">
      <img :src="currentUser.avatar.url" />
      <input type="file" name="avatar" accept="images/*" value="Change Avatar" @change="changeAvatar" :ref="'avatar'" hidden />
      <button @click="initChangeAvatar" class="game-btn">Change Avatar</button>
      <button @click="logout" class="game-btn">Logout</button>
    </div>
    <div class="profile-part">
      <div class="input-container" :class="{ error: username.error }">
        <label>Username</label>
        <input type="text" v-model="username.value" :disabled="!canIEdit" />
      </div>
      <div class="input-container" :class="{ error: email.error }">
        <label>Email</label>
        <input type="text" v-model="email.value" :disabled="!canIEdit" />
      </div>
      <div class="input-container" :class="{ error: new_password.error }">
        <label>New Password</label>
        <input type="password" v-model="new_password.value" :disabled="!canIEdit" />
      </div>
      <div class="input-container" :class="{ error: confirm_password.error }">
        <label>Confirm Password</label>
        <input type="password" v-model="confirm_password.value" :disabled="!canIEdit" />
      </div>
      <button @click="initUpdateUser" v-if="canIEdit" class="game-btn">Update Profile</button>
      <button @click="canIEdit = true" v-else class="game-btn">Edit Profile</button>
    </div>
    <Popup :showMe="confirmYourPassword" @close="confirmYourPassword = false">
      <form @submit.prevent="updateUser" @keyup:enter.prevent="updateUser" style="display: contents;">
        <div class="input-container" :class="{ error: current_password.error }">
          <label for="">Confirm Your Password</label>
          <input type="password" v-model="current_password.value">
        </div>
        <button type="submit" class="game-btn">Proceed</button>
      </form>
    </Popup>
  </section>
</template>

<script>
import Popup from './Popup.vue'

export default {
  data () {
    return {
      canIEdit: false,
      confirmYourPassword: false,
      username: {
        value: "",
        error: false
      },
      email: {
        value: "",
        error: false
      },
      current_password: {
        value: "",
        error: false
      },
      new_password: {
        value: "",
        error: false
      },
      confirm_password: {
        value: "",
        error: false
      }
    }
  },
  mounted() {
    this.username.value = this.currentUser.username
    this.email.value = this.currentUser.email
  },
  computed: {
    currentUser() {
      return this.$store.state.User.currentUser
    }
  },
  methods: {
    changeAvatar(event) {
      if (!event.target.files[0]) return
      const formData = new FormData()
      formData.append(event.target.name, event.target.files[0])
      fetch(`/api/users/${this.currentUser.id}/avatar`, {
        method: 'PUT',
        body: formData,
        headers: {
          'Authorization': `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => {
          if (data.done) {
            this.$store.commit("User/updateAvatar", data.avatar)
          }
        })
        .catch(err => console.error(err))
    },
    initChangeAvatar() {
      this.$refs.avatar.click()
    },
    logout() {
      this.$cable.connection.disconnect()
      this.$store.dispatch("User/SIGNOUT")
      this.$router.push({ name: 'Login' })
    },
    initUpdateUser() {
      if (this.username.value.trim() === "") this.username.error = true;
      else this.username.error = false;
      if (this.email.value.trim() === "") this.email.error = true;
      else this.email.error = false;
      if (this.new_password.value.trim() === "") this.new_password.error = true;
      else this.new_password.error = false;
      if (this.confirm_password.value.trim() === "") this.confirm_password.error = true;
      else this.confirm_password.error = false;
      if (this.confirm_password.value.trim() !== this.new_password.value.trim()) this.confirm_password.error = true;
      else this.confirm_password.error = false;
      if (!this.email.error && !this.username.error && !this.new_password.error && !this.confirm_password.error) {
        this.canIEdit = false;
        this.confirmYourPassword = true
      }
    },
    updateUser() {
      if (this.current_password.value.trim() === "") {
        this.current_password.error = true;
        return
      }
      this.current_password.error = false;
      this.confirmYourPassword = false;
      const reqBody = {
        username: this.username.value,
        email: this.email.value,
        password: this.new_password.value,
        password_confirmation: this.confirm_password.value,
        current_password: this.current_password.value
      };
      console.log(reqBody)
    }
  },
  components: {
    Popup
  }
}
</script>

<style scoped>
section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  padding: 10px;
  height: 100%;
}
.edit-part,
.profile-part {
  display: grid;
  height: 100%;
  align-items: baseline;
}
.edit-part {
  gap: 20px;
  grid-template-rows: auto 50px 50px;
}
img {
  width: 100%;
  height: 100%;
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
.error > input {
  border-color: red;
}
.error > label {
  color: red;
}
</style>
