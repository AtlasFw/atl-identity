<script setup>
import PlayerCard from '../components/PlayerCard.vue'
import PlayerInfo from '../components/PlayerInfo.vue'
import PlayerEmpty from '../components/PlayerEmpty.vue'
defineProps({
	characters: {
		type: Array,
		default: [
			{
				name: '',
				class: '',
				level: '',
				health: '',
				mana: '',
				strength: '',
				dexterity: '',
			},
			{

			},
			{

			},
			{

			},
			{

			},
			{

			},
		]
	}
})
</script>

<template>
	<div class="h-full w-full absolute flex justify-between items-center">
		<div class="h-full flex flex-col justify-between items-center">
			<div class="h-full mt-4 mb-4 ml-4 scrollbar scroll-smooth mask">
				<PlayerCard v-for="char in characters"/>
			</div>
			<button type="button" @click="$emit('switch')" class="font-semibold text-red-400 mt-2 red hover:text-red-500 hover:underline transition mb-2 duration-200">Go Back</button>
		</div>
		<PlayerInfo/>
		<PlayerEmpty/>
	</div>
</template>

<style scoped>
.slide-fade-enter-active {
  transition: all 0.25s;
}
.slide-fade-leave-active {
  transition: all 0.25s;
}
.slide-fade-enter-from,
.slide-fade-leave-to {
  transform: translateX(80px);
  opacity: 0;
}

.mask {
  mask-image: linear-gradient(to bottom, #000000 95%, transparent 100%);
}

::-webkit-scrollbar {
  width: 5px;
}

::-webkit-scrollbar-track {
  border-radius: 8px;
}

::-webkit-scrollbar-thumb {
  border-radius: 8px;
}
</style>