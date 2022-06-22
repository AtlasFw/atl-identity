<script setup>
import { NPopconfirm, NButton, NIcon } from "naive-ui";
import { Trash } from '@vicons/ionicons5';

const deleteChar = () => {
	console.log('test');
}

const reduceText = (length, name) => name.length > length ? name.substring(0, length) + '...' : name;
</script>

<template>
	<button type="button" class="w-[22em] h-28 bg-[#1E293BE8] border-b-1 border-r-1 border-slate-500 shadow-md flex flex-col mb-4 items-center rounded overflow-hidden">
		<div class="w-full flex items-center justify-between w-[90%] pb-0.5 mt-1.5 pb-1 border-b border-b-slate-500">
			<span class="font-semibold text-white text-sm">{{ reduceText(20, 'Germancity Developer With Ops') }}</span>
			<NPopconfirm trigger="click" @positive-click="deleteChar">
				<template #trigger>
					<NButton size="small" tertiary circle :focusable="false" type="error">
						<template #icon>
							<NIcon>
								<Trash/>
							</NIcon>
						</template>
					</NButton>
				</template>
				<span>Are you sure you want to delete your character? <br/>This action cannot be undone.</span>
			</NPopconfirm>
		</div>
		<span class="text-left font-light w-[90%] text-[0.9em] text-slate-200 break-all mt-1 mb-1">{{ reduceText(100, 'Liberis sunt eleatess de rusticus coordinatae.Vae, lotus lamia! Liberis sunt eleatess de rusticus coordinatae.Vae, lotus lamia! Liberis sunt eleatess de rusticus coordinatae.Vae, lotus lamia!') }}</span>
	</button>
</template>