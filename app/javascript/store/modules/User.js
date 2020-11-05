function setToken(token) {
  localStorage.setItem("liu", token.split(" ")[1]);
}

const state = {
  loggedIn: false,
  currentUser: {},
  allUsers: [],
  FB: {
    logout: function() {
      return
    }
  }
}

const getters = {
  allUsersButMe(state) {
    return state.allUsers.filter(user => user.id !== state.currentUser.id)
  }
}

const mutations = {
  signInUser(state, user) {
    state.loggedIn = true
    state.currentUser = user
  },
  signOutUser(state) {
    if (state.currentUser?.provider === 'facebook') {
      state.FB.logout()
    }
    state.loggedIn = false
    state.currentUser = {}
  },
  setAllUsers(state, users) {
    state.allUsers = users
  },
  updateAvatar(state, avatar) {
    state.currentUser.avatar = avatar
  },
  FBinit(state, FB) {
    state.FB = FB
  }
}

const actions = {
  async SIGNIN(ctx, payload) {
    try {
      const response = await fetch("/users/sign_in", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ user: payload })
      })
      const token = response.headers.get("authorization");
      if (token) {
        setToken(token)
        const data = await response.json()
        ctx.commit("signInUser", data)
        return ""
      } else {
        return "Invalid Email or Password"
      }
    } catch (error) {
      console.log(error);
      return "Something went wrong, Please try again!"
    }
  },
  async SIGNUP(ctx, payload) {
    try {
      const response = await fetch("/users", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ user: payload })
      })
      const token = response.headers.get("authorization");
      if (token) {
        setToken(token)
        const data = await response.json()
        ctx.commit("signInUser", data)
        return ""
      } else {
        return "Username OR Email already registered"
      }
    } catch (error) {
      console.log(error);
      return "Something went wrong, Please try again!"
    }
  },
  async UPDATE(ctx, payload) {
    try {
      const response = await fetch("/users", {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${localStorage.getItem("liu")}`
        },
        body: JSON.stringify({ user: payload })
      })
      const data = await response.json()
      // const token = response.headers.get("authorization");
      if (data.id) {
        // setToken(token)
        ctx.commit("signInUser", data)
        return ""
      } else {
        return "Couldn't update user info"
      }
    } catch (error) {
      console.log(error);
      return "Something went wrong, Please try again!"
    }
  },
  async OAUTH(ctx, payload) {
    try {
      const response = await fetch("api/users/auth/facebook?access_token=" + payload)
      const token = response.headers.get("authorization");
      if (token) {
        setToken(token)
        const data = await response.json()
        ctx.commit("signInUser", data)
        return ""
      } else {
        return "Email already registered"
      }
    } catch (error) {
      console.log(error);
      return "Something went wrong, Please try again!"
    }
  },
  SIGNOUT(ctx) {
    fetch("/users/sign_out", {
      method: "DELETE",
      'Authorization': `Bearer ${localStorage.getItem("liu")}`
    }).catch(err => console.log(err))
    localStorage.removeItem("liu")
    ctx.commit("signOutUser")
  },
  async VERIFY(ctx) {
    try {
      const response = await fetch("/api/users/verify", {
        method: "GET",
        headers: {
          "Authorization": `Bearer ${localStorage.getItem("liu")}`
        },
      })
      const data = await response.json()
      if (data.verified) {
        ctx.commit("signInUser", data.user)
        return ""
      } else {
        return "User not verified"
      }
    } catch (error) {
      console.log(error);
      return "Something went wrong, Please try again!"
    }
  },
  async FETCH(ctx) {
    try {
      const response = await fetch("/api/users", {
        method: "GET",
        headers: {
          "Authorization": `Bearer ${localStorage.getItem("liu")}`
        },
      })
      const data = await response.json()
      if (data.code === 200) {
        ctx.commit("setAllUsers", data.users)
        return ""
      } else {
        return "Unable to fetch Users"
      }
    } catch (error) {
      return "Something went wrong, Please try again!"
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}