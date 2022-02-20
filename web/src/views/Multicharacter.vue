<script setup>
import { NCard, NButton, NSkeleton } from 'naive-ui'
import { ref, defineProps } from 'vue'
defineProps({
  active: {
    type: Boolean,
    default: true
  },
  chars: {
    type: Array,
    required: false
  }
})
</script>

<template>
  <div class="h-full w-full grid grid-cols-10">
    <div class="h-full overflow-hidden col-span-2">
      <div class="h-5/6 flex flex-col items-center justify-start scrollbar scroll-smooth scrollbar-thin scrollbar-track-slate-800 scrollbar-thumb-slate-700">
        <NCard class="w-5/6 bg-slate-800 mt-6" size="small" :segmented="{ content: true }" v-for="(char, index) in chars" :key="index" :title="`${char.firstname} ${char.lastname}`">
          <template #header-extra>#{{ char.char_id }}</template>
          {{ char.quote }}
        </NCard>
      </div>
      <div class="h-1/6 flex justify-center items-center overflow-hidden">
        <NButton class="w-5/6 h-2/5 text-lg" :focusable="false" color="#215F96" ghost strong type="info">Create Character</NButton>
      </div>
    </div>
    <div class="h-full col-span-5"></div>
    <div class="relative h-full col-span-3 flex justify-center items-center">
      <NCard class="relative w-4/6 h-4/6 rounded-lg bg-slate-800 scrollbar scroll-smooth" n-skeleton size="medium" :segmented="{ content: true, footer: 'soft'}">
        <template #header>
          <n-skeleton v-if="!active" text width="55%"/>
          <template v-else>
            Character Information
          </template>
        </template>
        <template #header-extra v-if="!active">#</template>
        <template #header-extra v-else>#120</template>
        <n-skeleton v-if="!active" text width="60%"/>
        <template v-else>
          <div class="relative">
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">Personal Information</h2>
            <span class="ml-3">First Name: {{}}</span><br>
            <span class="ml-3">Last Name: {{}}</span><br>
            <span class="ml-3">Date of Birth: {{}}</span><br>
            <span class="ml-3">Sex: {{}}</span><br>
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">Job Information</h2>
            <span class="ml-3">Job: {{}}</span><br>
            <span class="ml-3">Job Grade: {{}}</span><br>
            <span class="ml-3">Job Payment: {{}}</span><br>
            <span class="ml-3">Job Payment Cut: {{}}</span>
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">Accounts Information</h2>
            <span class="ml-3">Cash on Hand: ${{}}</span><br>
            <span class="ml-3">Bank Account: ${{}}</span><br>
            <span class="ml-3">Counterfeit Money: ${{}}</span><br>
            <span class="ml-3">Special Coins: &#65284;{{}}</span><br>
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">Other Information</h2>
            <span class="ml-3">Last Street: {{}}</span><br>
            <span class="ml-3">Quote: {{}}</span><br>
          </div>
        </template>
      </NCard>
    </div>
  </div>
</template>