<template>
  <div>
    <form @submit.prevent="login" @keyup:enter.prevent="login">
      <h2>Login</h2>
      <div class="input-container" :class="{ error: email.error }">
        <input
          type="email"
          id="useremail"
          placeholder="Email"
          autocomplete="off"
          v-model="email.value"
        />
        <label for="useremail">Email</label>
      </div>
      <div class="input-container" :class="{ error: password.error }">
        <input
          type="password"
          id="password"
          placeholder="Password"
          autocomplete="off"
          v-model="password.value"
        />
        <label for="password">Password</label>
      </div>
      <button type="submit">Login</button>
      <div class="change-component">
        Don't have an account? <u @click="$emit('signup')">Signup</u>
      </div>
    </form>
    <div>
      <FacebookLogin :app-id="fbAppId" @login="FBlogin" @sdk-init="handleSDK" />
    </div>
  </div>
</template>

<script lang="js">
import FacebookLogin from 'vue-facebook-login-component'
const FB_APP_ID = process.env.VUE_APP_FB_APP_ID

export default {
  data () {
    return {
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
    login() {
      if (this.email.value.trim() === "") this.email.error = true;
      else this.email.error = false;
      if (this.password.value.trim() === "") this.password.error = true;
      else this.password.error = false;
      const reqBody = {
        email: this.email.value,
        password: this.password.value
      }
      if (!this.email.error && !this.password.error) {
        this.$emit("submit", reqBody)
      }
    },
    FBlogin(event) {
      this.$emit("facebook", event.authResponse?.accessToken)
    },
    handleSDK({FB}) {
      this.$store.commit("User/FBinit", FB)
    }
  },
  computed: {
    fbAppId() {
      return FB_APP_ID
    }
  },
  components: {
    FacebookLogin
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
