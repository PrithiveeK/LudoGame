<template>
  <nav>
    <div class="right-part"></div>
    <ul>
      <li class="empty"></li>
      <li title="My Stats" @click="$router.push({name: 'Home', query: {stats: 'me'}})">
        <span>My Stats</span>
        <i></i>
      </li>
      <li title="Leader Board" @click="$router.push({name: 'Home', query: {stats: 'all'}})">
        <span>Leader Board</span>
        <i></i>
      </li>
      <li title="Invite" @click="$emit('invite')">
        <span>Invite</span>
        <i></i>
      </li>
      <li title="Manage Invites" @click="$emit('view-invites')">
        <span>Manage Invites</span>
        <i></i>
      </li>
      <li title="Saved Games">
        <span>Saved Games</span>
        <i></i>
      </li>
    </ul>
  </nav>
</template>

<style scoped>
nav {
  width: 15rem;
  position: absolute;
  top: 50%;
  right: 0;
  transform: translateY(-50%);
  z-index: 100;
}
ul {
  list-style: none;
}
li {
  text-align: right;
  position: relative;
  margin: 2px 0;
  height: 3rem;
  transition: all 0.3s;
  pointer-events: all;
}
li.empty {
  height: 20px;
}
span {
  display: block;
  height: 100%;
  line-height: 20px;
  padding: 15px 0;
  font-size: 1.3rem;
  transition: all 0.3s;
  color: #788aaa;
}
i {
  position: absolute;
  right: 0;
  top: 0;
  margin: 0 1px;
  display: block;
  width: 3rem;
  height: 100%;
  background-color: green;
  border-radius: 40%;
}
.right-part {
  width: 90px;
  height: 300px;
  border-left: 5px solid blue;
  border-radius: 100%;
  float: right;
  shape-outside: ellipse();
  pointer-events: none;
}
li:not(.empty):hover {
  transform: scale(1.1) translateX(-10px);
}
li:not(.empty):hover ~ * {
  transform: translateY(10px);
}
li:not(.empty):active {
  transform: scale(0.97) translateX(5px);
}
@media (max-width: 500px) {
  span {
    display: none;
  }
}
</style>
