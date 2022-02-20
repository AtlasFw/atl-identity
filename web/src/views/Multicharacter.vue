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
    <div class="h-full col-span-3 flex justify-center items-center">
      <NCard class="w-3/4 h-4/6 rounded-lg bg-slate-800 overflow-hidden" n-skeleton size="medium" :segmented="{ content: true, footer: 'soft'}">
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
          <div class="h-95% scrollbar scroll-smooth scrollbar-thin scrollbar-track-slate-800 scrollbar-thumb-slate-700 overflow-hidden">
            <h2 class="text-lg font-medium border-b-1 text-center mb-4 w-90%">Personal Information</h2>
            <span class="ml-3 w-90%">First Name: {{}}</span><br>
            <span class="ml-3 w-90%">Last Name: {{}}</span><br>
            <span class="ml-3 w-90%">Date of Birth: {{}}</span><br>
            <span class="ml-3 w-90%">Sex: {{}}</span><br>
            <h2 class="text-lg font-medium border-b-1 text-center mb-4 w-90%">Job Information</h2>
            <span class="ml-3 w-90%">Job: {{}}</span><br>
            <span class="ml-3 w-90%">Job Grade: {{}}</span><br>
            <span class="ml-3 w-90%">Job Payment: {{}}</span><br>
            <span class="ml-3 w-90%">Job Payment Cut: {{}}</span>
            <h2 class="text-lg font-medium border-b-1 text-center mb-4 w-90%">Accounts Information</h2>
            <span class="ml-3 w-90%">Cash on Hand: {{}}</span><br>
            <span class="ml-3 w-90%">Bank Account: {{}}</span><br>
            <span class="ml-3 w-90%">Counterfeit Money: {{}}</span><br>
            <span class="ml-3 w-90%">Special Coins: {{}}</span><br>
            <h2 class="text-lg font-medium border-b-1 text-center mb-4 w-90%">Other Information</h2>
            <span class="ml-3 w-90%">Last Street: {{}}</span><br>
            <span class="ml-3 w-90%">Something Else: {{}}</span><br>
            <span class="ml-3 w-90%">Something Else: {{}}</span><br>
            <span class="ml-3 w-90%">Quote: {{}}</span><br>
          </div>
        </template>
      </NCard>
    </div>
  </div>
</template>