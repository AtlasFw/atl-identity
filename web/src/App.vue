<script setup>
import { NConfigProvider, NDialogProvider, darkTheme } from 'naive-ui'
import { reactive } from "vue";
import Intro from './views/Intro.vue'
import Multicharacter from './views/Multicharacter.vue'
import Identity from './views/Identity.vue'

const state = reactive({
  login: true,
  multicharacter: {
    state: false,
  },
  identity: {
    state: false
  }
})

const switchState = (type) => {
  if (state.login) {
    state.login = false
  }
  state[type].state = !state[type].state
}
</script>

<template>
  <n-config-provider class="bg-black w-full h-full" :theme="darkTheme">
      <div class="bg-black w-full h-full">
        <n-dialog-provider :theme="darkTheme">
          <transition name="fade">
            <Intro v-if="state.login" @startmulticharacter="switchState"/>
          </transition>
          <Multicharacter v-if="state.multicharacter.state"/>
          <Identity v-if="state.identity.state"/>
        </n-dialog-provider>
      </div>
  </n-config-provider>
</template>

<style>
body {

  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  font-size: 20px;
  margin: 0;
  padding: 0;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

#app {
  height: 100%
}

.fade-enter-active {
  transition: all 0.15s ease-out;
}
.fade-leave-active {
  transition: all 0.15s cubic-bezier(1, 0.5, 0.8, 1);
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>