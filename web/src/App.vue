<script setup>
import { NConfigProvider, NDialogProvider, darkTheme } from 'naive-ui'
import { reactive } from "vue";
import Intro from './views/Intro.vue'
import Multicharacter from './views/Multicharacter.vue'

const state = reactive({
  login: false,
  multicharacter: {
    state: true,
    characters: [
      {
        char_id: '120',
        firstname: 'Mauricio',
        lastname: 'Gonzalez',
        dob: '01/01/2000',
        sex: 'female',
        quote: 'I am a very cool person with a very cool name!'
      },
      {
        char_id: 'create',
        firstname: 'Create',
        lastname: 'Character',
        quote: 'Create a new identity and begin your life.'
      },
      {
        char_id: 'blocked',
        firstname: 'Blocked',
        lastname: 'Character',
        quote: 'Blocked character identity slot.'
      }
    ]
  }
})
const switchState = (type) => {
  if (type === 'login') {
    state.login = true
    state.multicharacter.state = false
    return;
  }
  if (state.login) {
    state.login = false
  }
  state[type].state = !state[type].state
}

</script>

<template>
    <div class="bg-black w-full h-full">
      <n-config-provider class="bg-black w-full h-full" :theme="darkTheme">
        <n-dialog-provider>
          <transition name="fade">
            <Intro v-if="state.login" @startmulticharacter="switchState"/>
          </transition>
          <transition name="fade">
            <Multicharacter v-if="state.multicharacter.state" @startlogin="switchState" :chars="state.multicharacter.characters"/>
          </transition>
        </n-dialog-provider>
      </n-config-provider>
    </div>
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