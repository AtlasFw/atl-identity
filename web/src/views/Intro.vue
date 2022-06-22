<script setup>

</script>

<template>
	<div class="absolute left-1/2 -translate-x-1/2 bottom-0 flex flex-col justify-center items-center mb-2">
		<button @click="$emit('switch')" class="bg-transparent blue border-2 border-sky-400 shadow font-medium shadow-sky-400 text-xl px-16 py-2.5 rounded-sm transition duration-200">Get Started</button>
		<button class="font-semibold text-red-400 mt-1 red hover:text-red-500 hover:underline transition duration-200">Disconnect</button>
	</div>
</template>

<style>
.blue {
	text-shadow: 0 2px 6px rgba(47, 129, 229, 0.9);
	color: rgba(118, 216, 246, 0.7);
}

.blue:hover {
	background-color: #58C2FC19;
}

.red {
	text-shadow: 0 1px 6px rgba(225, 60, 60, 0.5);
}
</style>