<script setup>
import { Trash } from '@vicons/ionicons5'
import { NCard, NButton, NSkeleton, NIcon, NPopconfirm } from 'naive-ui'
import { reactive } from 'vue'
import { fetchNui } from '../utils/fetchNui.js'
defineProps({
  chars: {
    type: Array,
    required: false
  }
})
const data = reactive({
  btnText: 'Select a Slot',
  selected: null,
  id: null,
  char: null,
})

const setSelected = ({currentTarget}) => {
  console.log('pressed')
  if (currentTarget.tagName !== 'DIV') return;

  if (data.selected) {
    if (data.disabled) {
      data.disabled = false;
    }
    data.selected.classList.remove("ring-4", "ring-sky-600", "ring-red-600");
    if (data.selected === currentTarget) {
      data.selected = null;
      data.char = null;
      data.btnText = "Select a Slot";
      return;
    }
  }

  data.selected = currentTarget;
  switch (currentTarget.getAttribute("data-char-id")) {
    case "create":
      data.id = "create";
      data.char = null;
      data.btnText = "Create Character";
      break;
    case "blocked":
      data.disabled = true;
      data.id = null;
      data.char = null;
      data.btnText = "Blocked Character";
      currentTarget.classList.add("ring-4", "ring-red-600");
      return;
    default:
      data.id = parseInt(currentTarget.getAttribute("data-char-id"));
      data.char = JSON.parse(currentTarget.getAttribute("data-char"));
      data.btnText = "Select Character";
      break;
  }
  currentTarget.classList.add("ring-4", "ring-sky-600");
}
const clearData = () => {
  data.selected.classList.remove("ring-4", "ring-sky-600", "ring-red-600");
  data.selected = null;
  data.disabled = false;
  data.id = null;
  data.char = null;
  data.btnText = "Select a Slot";
}
const chooseSlot = () => {
  if (data.id === null) return;
  if (data.id === "create") {
    clearData();
    return;
  }
  fetchNui("select_character", data.id);
  clearData();
}
const deleteCharacter = () => {
  console.log('Deleting character')
}
</script>

<template>
  <div class="h-full w-full grid grid-cols-10">
    <div class="h-full overflow-hidden col-span-2">
      <div class="h-5/6 flex flex-col items-center justify-start scrollbar scroll-smooth scrollbar-thin scrollbar-track-slate-800 scrollbar-thumb-slate-700">
        <NCard class="w-5/6 bg-slate-800 mt-6" size="small" :segmented="{ content: true }" v-for="(char, index) in chars" :key="index" :data-char-id="char.char_id" :data-char="JSON.stringify(char)" :title="`${char.firstname} ${char.lastname}`" @click.left="setSelected">
          <template v-if="char.char_id !== 'create' && char.char_id !== 'blocked'" #header-extra>
            <NPopconfirm trigger="hover" @positive-click="deleteCharacter">
              <template #trigger>
                <n-button size="small" tertiary circle type="error">
                  <template #icon>
                    <NIcon>
                      <Trash/>
                    </NIcon>
                  </template>
                </n-button>
              </template>
              <span>Are you sure you want to delete your character? This action is irreversible.</span>
            </NPopconfirm>
          </template>
          {{ char.quote }}
        </NCard>
      </div>
      <div class="h-1/6 flex flex-col items-center justify-end overflow-hidden">
        <NButton @click="chooseSlot" class="w-5/6 h-2/5 text-lg" :focusable="false" ghost strong :disabled="data.disabled" :type="data.disabled ?  'error' : 'info'">{{ data.btnText }}</NButton>
        <NButton @click="$emit('startlogin', 'login')" class="mb-5 mt-2.5 hover:underline" text strong type="error">Go Back</NButton>
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