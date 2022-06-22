<script setup>
import Intro from './views/Intro.vue'
import Multicharacter from './views/Multicharacter.vue'
import { NMessageProvider, NDialogProvider, NGlobalStyle } from "naive-ui";
import { onMounted, onUnmounted, ref, reactive } from "vue";

const state = reactive({
	login: false,
	multicharacter: true,
})

const switchState = (page) => {
	page === 'login' ? state.login = true : state.login = false;
	page === 'multicharacter' ? state.multicharacter = true : state.multicharacter = false;
}
</script>

<template>
	<NMessageProvider>
			<NDialogProvider>
				<transition name="fade">
					<Intro v-if="state.login" @switch="switchState('multicharacter')"/>
				</transition>
				<transition name="fade">
					<Multicharacter v-if="state.multicharacter" @switch="switchState('login')"/>
				</transition>
			</NDialogProvider>
	</NMessageProvider>
	<NGlobalStyle/>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;300;400;500;600;700;800;900&display=swap');

body {
	background: transparent !important;
}

#app {
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	text-align: center;
	height: 100vh;
	margin: 0 auto;
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