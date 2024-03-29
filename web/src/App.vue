<script setup>
import {
  NConfigProvider,
  NDialogProvider,
  NMessageProvider,
  darkTheme,
} from 'naive-ui';
import { reactive, onMounted, onUnmounted } from 'vue';
import Intro from './views/Intro.vue';
import Multicharacter from './views/Multicharacter.vue';

const state = reactive({
  login: false,
  multicharacter: {
    state: true,
    characters: [],
  },
});

const switchState = (type) => {
  if (type === 'login') {
    state.login = true;
    state.multicharacter.state = false;
    return;
  }
  if (state.login) {
    state.login = false;
  }
  state[type].state = !state[type].state;
};

const close = () => {
  state.multicharacter.state = false;
  state.multicharacter.characters = [];
  state.login = false;
};

const messageHandler = (e) => {
  switch (e.data.action) {
    case 'startMulticharacter':
      state.login = true;
      const { MaxSlots, AllowedSlots } = e.data.identity;
      const Jobs = e.data.jobs;
      for (let i = 0; i < MaxSlots; i++) {
        if (e.data.playerData[i]) {
          const player = e.data.playerData[i];
          const identity = JSON.parse(player.identity);
          const accounts = JSON.parse(player.accounts);
          const job = JSON.parse(player.job_data);
          const appearance = JSON.parse(player.appearance);
          state.multicharacter.characters.push({
            char_id: player.char_id,
            firstname: identity.firstname,
            lastname: identity.lastname,
            quote: identity.quote,
            dob: identity.dob,
            sex: identity.sex.charAt(0).toUpperCase() + identity.sex.slice(1).toLowerCase(),
            accounts: {
              money: `$${accounts.cash}`,
              bank: `$${accounts.bank}`,
              black: `$${accounts.black}`,
              tebex: `${accounts.tebex} coins`,
            },
            job: {
              name: Jobs[job.name].name,
              rank: Jobs[job.name].ranks[job.rank - 1].label,
              paycheck: `$${Jobs[job.name].ranks[job.rank - 1].paycheck}`,
              tax: `${Jobs[job.name].ranks[job.rank - 1].taxes}%`,
            },
            appearance: appearance,
          });
          continue;
        }
        if (i >= AllowedSlots) {
          state.multicharacter.characters.push({
            char_id: 'blocked',
            firstname: 'Blocked',
            lastname: 'Character',
            quote: 'Blocked character identity slot.',
          });
          continue;
        }

        if (!e.data.playerData[i]) {
          state.multicharacter.characters.push({
            char_id: 'create',
            firstname: 'Create',
            lastname: 'Character',
            quote: 'Create a new identity and begin your life.',
          });
          continue;
        }
      }
      break;
  }
};

onMounted(() => {
  window.addEventListener('message', messageHandler);
});

onUnmounted(() => {
  window.removeEventListener('message', messageHandler);
});
</script>

<template>
  <div class="w-full h-full">
    <n-config-provider class="w-full h-full" :theme="darkTheme">
      <n-message-provider>
        <n-dialog-provider>
          <transition name="fade">
            <Intro v-if="state.login" @startmulticharacter="switchState" />
          </transition>
          <transition name="fade">
            <Multicharacter
              v-if="state.multicharacter.state"
              @startlogin="switchState"
              :chars="state.multicharacter.characters"
              @close="close"
            />
          </transition>
        </n-dialog-provider>
      </n-message-provider>
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
  height: 100%;
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