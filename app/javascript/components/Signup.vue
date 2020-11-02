<template>
  <div>
    <form @submit.prevent="signup" @keyup:enter.prevent="signup">
      <h2>Signup</h2>
      <div class="input-container" :class="{ error: username.error }">
        <input
          type="text"
          id="username"
          placeholder="Username"
          autocomplete="off"
          v-model="username.value"
        />
        <label for="username">Username</label>
      </div>
      <div class="input-container" :class="{ error: email.error }">
        <input
          type="email"
          id="new-email"
          placeholder="Email"
          autocomplete="off"
          v-model="email.value"
        />
        <label for="new-email">Email</label>
      </div>
      <div class="input-container" :class="{ error: password.error }">
        <input
          type="password"
          id="new-password"
          placeholder="Password"
          autocomplete="off"
          v-model="password.value"
        />
        <label for="new-password">Password</label>
      </div>
      <button type="submit">Signup</button>
      <div class="change-component">
        Already have an account? <u @click="$emit('login')">Login</u>
      </div>
    </form>
  </div>
</template>

<script lang="js">
export default {
  data () {
    return {
      username: {
        value: "",
        error: false
      },
      email: {
        value: "",
        error: false
      },
      password: {
        value: "",
        error: false
      }
    }
  },
  methods: {
    signup() {
      if (this.username.value.trim() === "") this.username.error = true;
      else this.username.error = false;
      if (this.email.value.trim() === "") this.email.error = true;
      else this.email.error = false;
      if (this.password.value.trim() === "") this.password.error = true;
      else this.password.error = false;
      const reqBody = {
        username: this.username.value,
        email: this.email.value,
        password: this.password.value,
        password_confirmation: this.password.value
      }
      if (!this.email.error && !this.password.error && !this.username.error) {
        this.$emit("submit", reqBody)
      }
    }
  }
}
</script>

<style scoped>
.input-container {
  color: #ffffffc0;
  display: flex;
  flex-direction: column;
  position: relative;
  margin: 20px 0;
  height: 40px;
  justify-content: flex-end;
  font-size: 20px;
}
label {
  position: absolute;
  transition: all 0.4s ease-in-out;
  color: #ffffff80;
  padding: 3px 5px;
}
input {
  color: #ffffff;
  outline: none;
  border: none;
  background: none;
  border-bottom: 2px solid #fff;
  height: 24px;
  font-size: 18px;
}
input:not(:placeholder-shown) ~ label,
input:focus ~ label {
  transform: translateY(-24px);
  padding: 0;
  color: #ffffff;
}
input::placeholder {
  color: transparent;
}
button {
  float: right;
  border: none;
  outline: none;
  padding: 5px 15px;
  border-radius: 4px;
  background-color: #ffffffc0;
  font-size: 20px;
}
</style>
