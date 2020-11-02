import LoginSignup from "../views/LoginSignup.vue"

function canIEnter(to) {
  return to.name === "Login" || localStorage.getItem("liu") != null
}

const routes = [
  {
    path: "/",
    beforeEnter(to, from, next) {
      canIEnter(to) ? next() : next({ name: "Login" })
    },
    name: "Home",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/Home.vue")
  },
  {
    path: "/login",
    name: "Login",
    component: LoginSignup
  },
  {
    path: "/game",
    beforeEnter(to, from, next) {
      canIEnter(to) ? next() : next({ name: "Login" })
    },
    name: "Game",
    component: () => import("../views/Game.vue")
  }
];

export default routes
