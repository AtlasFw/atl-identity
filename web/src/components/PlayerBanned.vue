<script setup>
import { Ban } from '@vicons/ionicons5'
</script>

<template>
  <div class="w-[24em] flex flex-col items-center mr-8">
    <div class="w-full flex justify-between items-center mt-2 py-3 px-3 -skew-x-2 rounded shadow shadow-slate-900 border-b-1 border-b-slate-500 bg-[#1E293BE8]">
      <span class="text-lg font-semibold text-white">Banned Character</span>
      <Ban class="w-5 h-5"/>
    </div>
    <div class="w-full mt-2 grid place-items-center rounded shadow shadow-slate-900 border-b-1 border-b-slate-500 bg-[#1E293BE8]">
      <span class="mx-4 mt-4 mb-2 text-left text-[1.1em] font-semibold">This character is banned indefinitely. If you want to play, you may choose try of the following options:</span>
      <ol class="flex flex-col items-start w-full mb-4 font-medium">
        <li class="ml-4">- Contact an admin with the id <span class="font-black">#128</span>.</li>
        <li class="ml-4">- Use another character.</li>
        <li class="ml-4">- Create a new character.</li>
      </ol>
    </div>
  </div>
</template>