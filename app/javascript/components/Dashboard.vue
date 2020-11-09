<template>
  <section>
    <Header
      @settings="
        showFW = true;
        which = 'settings';
      "
      @view-profile="
        showFW = true;
        which = 'profile';
      "
    />
    <img src="../assets/ludo_logo_empty_bg.png" alt="" class="logo" />
    <NavBar
      @invite="
        showFW = true;
        which = 'invite';
      "
      @view-invites="
        showFW = true;
        which = 'view-invites';
      "
      @view-saved="
        showFW = true;
        which = 'view-saved';
      "
    />
    <OverAllStats />
    <StartGame
      @start="
        showFW = true;
        which = 'game';
      "
    />
    <FloatingWindow
      v-if="showFW"
      @close="
        showFW = false;
        which = '';
      "
    >
      <Settings v-if="which === 'settings'" />
      <Invite v-else-if="which === 'invite'" />
      <AllGames v-else-if="which === 'view-invites'" :title="'All Invites'" :type="'invites'" />
      <AllGames v-else-if="which === 'view-saved'" :title="'Saved Gamed'" :type="'saved'" />
      <Profile v-else-if="which === 'profile'" />
      <ChooseGame v-else-if="which === 'game'" />
    </FloatingWindow>
  </section>
</template>

<script lang="js">
import NavBar from './NavBar.vue'
import Header from './Header.vue'
import OverAllStats from './OverAllStats.vue'
import StartGame from './StartGame.vue'
import FloatingWindow from './FloatingWindow.vue'
import Settings from './Settings.vue'
import Invite from './Invite.vue'
import Profile from './Profile.vue'
import ChooseGame from './ChooseGame.vue'
import AllGames from './AllGames.vue'

export default {
  data () {
    return {
      showFW: false,
      which: ''
    }
  },
  components: {
    Header,
    NavBar,
    OverAllStats,
    StartGame,
    FloatingWindow,
    Settings,
    Invite,
    Profile,
    ChooseGame,
    AllGames
  }
}
</script>
