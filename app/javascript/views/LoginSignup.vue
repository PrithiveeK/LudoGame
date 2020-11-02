<template>
  <div class="page">
    <div class="page-component" :class="{ 'flip-component': signup }">
      <Login class="component front" @signup="signup = true" @submit="loginUser" @facebook="oauthSignin" />
      <Signup class="component back" @login="signup = false" @submit="signupUser" />
    </div>
    <Error :errorObj="isError" v-if="isError.has" />
  </div>
</template>

<script lang="js">
import Login from "../components/Login.vue";
import Signup from "../components/Signup.vue";
import Error from "../components/Error.vue";

export default {
  data () {
    return {
      signup: false,
      isError: {
        has: false,
        msg: "",
        color: ""
      }
    }
  },
  methods: {
    error(msg) {
      this.isError = { has: true, msg, color: "red" };
      setTimeout(() => {
        this.isError = { has: false, msg: "", color: "" };
      }, 3000);
    },
    success() {
      this.$router.push({ name: 'Home' })
    },
    loginUser(user) {
      this.$store.dispatch("User/SIGNIN", user).then(result => {
        if (result === "") {
          this.success()
        } else {
          this.error(result)
        }
      })
    },
    signupUser(user) {
      this.$store.dispatch("User/SIGNUP", user).then(result => {
        if (result === "") {
          this.success()
        } else {
          this.error(result)
        }
      })
    },
    oauthSignin(accessToken) {
      this.$store.dispatch("User/OAUTH", accessToken).then(result => {
        if (result === "") {
          this.success()
        } else {
          this.error(result)
        }
      })
    }
  },
  components: {
    Login,
    Signup,
    Error
  }
}
</script>

<style>
.page {
  width: inherit;
  height: inherit;
  display: grid;
  place-items: center;
  perspective: 1000px;
}
.page-component {
  width: 600px;
  height: 300px;
  position: relative;
  transform-style: preserve-3d;
  transition: transform 0.3s;
}
.flip-component {
  transform: rotateX(-180deg);
}
.component {
  width: inherit;
  height: inherit;
  border-radius: 8px;
  position: absolute;
  background-image: url("../assets/login_background_image.jpg");
  background-size: cover;
  background-position: center;
  box-shadow: 0 0 24px 2px #ffffff70;
  display: grid;
  grid-template-columns: 1fr 1fr;
  place-items: center;
  color: whitesmoke;
}
.front {
  pointer-events: all;
}
.back {
  transform: rotateX(180deg);
  pointer-events: none;
}
.flip-component > .front {
  pointer-events: none;
}
.flip-component > .back {
  pointer-events: all;
}
.change-component {
  color: #ffffff;
  padding: 0 10px;
}
.change-component > u {
  color: #2c3e50;
  cursor: pointer;
}
.error > input {
  border-color: red;
}
.error > label {
  color: red;
}
</style>
