<script setup>
import { defineProps } from 'vue'
defineProps({
  title: {
    type: String,
    default: 'Title',
  },
  sub1: {
    type: Object,
    default: {
      header: 'Sub1',
      body: 'Sub1 body',
    },
  },
  sub2: {
    type: Object,
    default: {
      header: 'Sub1',
      body: 'Sub1 body',
    },
  },
  sub3: {
    type: Object,
    default: {
      header: 'Sub1',
      body: 'Sub1 body',
    },
  },
  sub4: {
    type: Object,
    default: {
      header: 'Sub1',
      body: 'Sub1 body',
    },
  }
})
</script>

<template>
  <div class="text-gray-300 flex flex-col lg:text-[12px] 2xl:text-[14px] w-full bg-slate-800 mt-2 rounded border-r-2 border-b-2 border-t-1 border-l-1 border-slate-700 font-medium">
    <span class="lg:text-[15px] 2xl:text-[17px] text-white lg:ml-3 2xl:ml-5 underline lg:mt-2 2xl:mt-3 font-semibold">{{ title }}</span>
    <span class="lg:ml-4 lg:mt-0.5 2xl:ml-7 2xl:mt-1">- {{ sub1.header }}: {{ sub1.body }}</span>
    <span class="lg:ml-4 lg:mt-2 2xl:ml-7 2xl:mt-3">- {{ sub2.header }}: {{ sub2.body }}</span>
    <span class="lg:ml-4 lg:mt-2 2xl:ml-7 2xl:mt-3">- {{ sub3.header }}: {{ sub3.body }}</span>
    <span class="lg:ml-4 lg:mt-2 lg:mb-2 2xl:ml-7 2xl:mt-3 2xl:mb-3">- {{ sub4.header }}: {{ sub4.body }}</span>
  </div>
</template>