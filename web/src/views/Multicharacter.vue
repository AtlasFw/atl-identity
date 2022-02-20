<script setup>
import { NCard, NButton, NSkeleton } from 'naive-ui'
import { ref, reactive, defineProps } from 'vue'
defineProps({
  chars: {
    type: Array,
    required: false
  }
})

const charBtnText = ref('Select a slot')
const data = reactive({
  selected: null,
  id: null,
  char: null,
})
const setSelected = ({currentTarget}) => {
  if (currentTarget.tagName !== 'DIV') return;

  if (data.selected) {
    if (data.disabled) {
      data.disabled = false;
    }
    data.selected.classList.remove("ring-4", "ring-sky-600", "ring-red-600");
    if (data.selected === currentTarget) {
      data.selected = null;
      data.char = null;
      charBtnText.value = "Select a Slot";
      return;
    }
  }

  data.selected = currentTarget;
  switch (currentTarget.getAttribute("data-char-id")) {
    case "create":
      data.id = "create";
      data.char = null;
      charBtnText.value = "Create Character";
      break;
    case "blocked":
      data.disabled = true;
      data.id = null;
      data.char = null;
      charBtnText.value = "Blocked Character";
      currentTarget.classList.add("ring-4", "ring-red-600");
      return;
    default:
      data.id = parseInt(currentTarget.getAttribute("data-char-id"));
      data.char = currentTarget.getAttribute("data-char");
      charBtnText.value = "Select Character";
      break;
  }
  currentTarget.classList.add("ring-4", "ring-sky-600");
}

</script>

<template>
  <div class="h-full w-full grid grid-cols-10">
    <div class="h-full overflow-hidden col-span-2">
      <div class="h-5/6 flex flex-col items-center justify-start scrollbar scroll-smooth scrollbar-thin scrollbar-track-slate-800 scrollbar-thumb-slate-700">
        <NCard class="w-5/6 bg-slate-800 mt-6" size="small" :segmented="{ content: true }" v-for="(char, index) in chars" :key="index" :data-char-id="char.char_id" :data-char="char" :title="`${char.firstname} ${char.lastname}`" @click="setSelected">
          <template v-if="char.char_id !== 'create' && char.char_id !== 'blocked'" #header-extra>#{{ char.char_id  }}</template>
          {{ char.quote }}
        </NCard>
      </div>
      <div class="h-1/6 flex flex-col items-center justify-end overflow-hidden">
        <NButton class="w-5/6 h-2/5 text-lg" :focusable="false" ghost strong :disabled="data.disabled" :type="data.disabled ?  'error' : 'info'">{{ charBtnText }}</NButton>
        <NButton @click="$emit('startlogin', 'login')" class="mb-5 mt-2.5 text-gray-600 hover:underline" text ghost strong type="error">Go Back</NButton>
      </div>
    </div>
    <div class="h-full col-span-5"></div>
    <div class="relative h-full col-span-3 flex justify-center items-center">
      <NCard class="relative w-4/6 h-4/6 rounded-lg bg-slate-800 scrollbar scroll-smooth" n-skeleton size="medium" :segmented="{ content: true, footer: 'soft'}">
        <template #header>
          <n-skeleton v-if="!data.char" text width="55%"/>
          <template v-else>
            Character Information
          </template>
        </template>
        <template #header-extra>
          <n-skeleton v-if="!data.char" circle width="20px"/>
          <template v-else>#120</template>
        </template>
        <template v-if="!data.char">
          <n-skeleton text/>
          <n-skeleton text style="width: 60%;"/>
          <n-skeleton text style="width: 80%;"/>
          <n-skeleton text style="width: 45%;"/>
          <n-skeleton text style="width: 60%;"/>
          <n-skeleton text/>
          <n-skeleton text style="width: 95%;"/>
          <n-skeleton text style="width: 80%;"/>
          <n-skeleton text style="width: 45%;"/>
          <n-skeleton text style="width: 82%;"/>
          <n-skeleton text/>
          <n-skeleton text style="width: 60%;"/>
          <n-skeleton text style="width: 72%;"/>
          <n-skeleton text style="width: 45%;"/>
          <n-skeleton text style="width: 65%;"/>
          <n-skeleton text/>
          <n-skeleton text style="width: 60%;"/>
          <n-skeleton text style="width: 80%;"/>
          <n-skeleton text style="width: 45%;"/>
          <n-skeleton text style="width: 90%;"/>
          <n-skeleton text/>
          <n-skeleton text style="width: 70%;"/>
        </template>
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