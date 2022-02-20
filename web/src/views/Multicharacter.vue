<script setup>
import { Trash, PersonAdd } from '@vicons/ionicons5'
import { NCard, NButton, NSkeleton, NIcon, NPopconfirm, NForm, NFormItem, NInput, NDatePicker, NSelect } from 'naive-ui'
import { ref, reactive, computed } from 'vue'
import { fetchNui } from '../utils/fetchNui.js'
defineProps({
  chars: {
    type: Array,
    required: false
  }
})

const formRef = ref(null)
const data = reactive({
  selected: null,
  id: null,
  char: null
})
const identity = reactive({
  firstname: null,
  lastname: null,
  sex: null,
  dob: null,
  quote: null,
  selectSex: ['male', 'female'].map(
      (v) => ({
        label: `${v.charAt(0).toUpperCase()}${v.slice(1)}`,
        value: v
      })
  ),
})

const dobStatus = computed(() => {
  const year = identity.dob
  if (!year || year < -2177434800000 || year > 1072933200000) {
    return 'error'
  }
  return 'success'
})

const dobFeedback = computed(() => {
  const year = identity.dob
  if (!year || year < -2177434800000 || year > 1072933200000) {
    return 'Year must be between 1991 and 2004.'
  }
  return undefined
})


const rules = {
  firstname: {
    type: 'string',
    required: true,
    message: 'Please input your first name.',
    trigger: 'blur'
  },
  lastname: {
    type: 'string',
    required: true,
    message: 'Please input your last name.',
    trigger: 'blur'
  },
  sex: {
    type: 'string',
    required: true,
    trigger: ['blur', 'change'],
    message: 'Please select your sex.'
  },
  dob: {
    type: 'string',
    required: true,
    message: 'Please input your date of birth.',
    trigger: ['blur', 'change'],
  },
  quote: {
    type: 'string',
    required: true,
    message: 'Please input something interesting about yourself.',
    trigger: 'blur'
  }
}
const setSelected = ({currentTarget}) => {
  console.log('pressed')
  if (currentTarget.tagName !== 'DIV') return;

  if (data.selected) {
    data.selected.classList.remove("ring-4", "ring-sky-600", "ring-red-600");
    if (data.selected === currentTarget) {
      data.selected = null;
      data.id = null;
      data.char = null;
      return;
    }
  }

  data.selected = currentTarget;
  switch (currentTarget.getAttribute("data-char-id")) {
    case "create":
      data.id = "create";
      data.char = null;
      break;
    case "blocked":
      data.id = null;
      data.char = null;
      currentTarget.classList.add("ring-4", "ring-red-600");
      return;
    default:
      data.id = parseInt(currentTarget.getAttribute("data-char-id"));
      data.char = JSON.parse(currentTarget.getAttribute("data-char"));
      break;
  }
  currentTarget.classList.add("ring-4", "ring-sky-600");
}
const clearData = () => {
  data.selected.classList.remove("ring-4", "ring-sky-600", "ring-red-600");
  data.selected = null;
  data.id = null;
  data.char = null;
}
const selectCharacter = () => {
  if (data.id && data.char) {
    fetchNui("select_character", {
      char_id: data.id,
    }).then((resp) => {
      if (resp.done) {

      } else {
        console.log("Error: Could not select character. Data was not received");
      }
    });
  }
}
const createCharacter = () => {
  formRef.value.validate((errors) => {
    if (errors) return;
    fetchNui("create_character", {data: identity}).then((resp) => {
      if (resp.done) {

      } else {
        console.log('Error: Could not go back to multicharacter');
      }
    });
  })
}
const deleteCharacter = () => {
  if (data.id && data.char) {
    fetchNui("select_character", {
      char_id: data.id,
    }).then((resp) => {
      if (resp.done) {

      } else {
        console.log("Error: Could not select character. Data was not received");
      }
    });
  }
}
</script>

<template>
  <div class="h-full w-full grid grid-cols-10">
    <div class="flex flex-col justify-between overflow-hidden col-span-2">
      <div class="mask mt-3 flex flex-col items-center justify-start scrollbar scroll-smooth scrollbar-track-slate-800 scrollbar-thumb-slate-700">
        <NCard class="w-5/6 bg-slate-800 mt-3.5 mb-3.5" size="small" :segmented="{ content: true }" v-for="(char, index) in chars" :key="index" :data-char-id="char.char_id" :data-char="JSON.stringify(char)" :title="`${char.firstname} ${char.lastname}`" @click.left="setSelected">
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
      <NButton @click="$emit('startlogin', 'login')" class="mb-5 mt-4 hover:underline" text strong type="error">Go Back</NButton>
    </div>
    <div class="col-span-5"></div>
    <div class="relative h-full col-span-3 flex justify-center items-center">
      <NCard class="relative w-4/6 h-4/6 rounded-lg bg-slate-800 scrollbar scroll-smooth" n-skeleton size="medium" :segmented="{ content: true, footer: 'soft'}">
        <template #header>
          <n-skeleton v-if="!data.char && data.id !== 'create'" text width="55%"/>
          <template v-else-if="data.id === 'create'">
            Create a New Identity
          </template>
          <template v-else>
            Character Information
          </template>
        </template>
        <template #header-extra>
          <n-skeleton v-if="!data.char && data.id !== 'create'" circle width="20px"/>
          <NIcon size="large" v-else-if="data.id === 'create'">
            <PersonAdd class="h-64 w-64"/>
          </NIcon>
          <template v-else>#{{ data.id }}</template>
        </template>
        <template v-if="!data.char && data.id !== 'create'">
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
          <n-skeleton text />
          <n-skeleton text style="width: 70%;"/>
        </template>
        <template v-else-if="data.id === 'create'">
          <NForm ref="formRef" :rules="rules" :model="identity" size="medium">
            <NFormItem label="First Name" path="firstname">
              <NInput v-model:value="identity.firstname" placeholder="Input first name" maxlength="16" show-count clearable/>
            </NFormItem>
            <NFormItem label="Last Name" path="lastname">
              <NInput v-model:value="identity.lastname" placeholder="Input last name" maxlength="16" show-count clearable/>
            </NFormItem>
            <NFormItem label="Date of Birth" :validation-status="dobStatus" :feedback="dobFeedback" path="dob">
              <NDatePicker type="date" v-model:value="identity.dob"></NDatePicker>
            </NFormItem>
            <NFormItem label="Sex" path="sex">
              <NSelect placeholder="Select sex" :options="identity.selectSex" v-model:value="identity.sex"/>
            </NFormItem>
            <NFormItem label="Quote" path="quote">
              <NInput placeholder="Something interesting about you" v-model:value="identity.quote" type="textarea" maxlength="30" show-count clearable :autosize="{ minRows: 2, maxRows: 2 }"/>
            </NFormItem>
            <NFormItem>
              <NButton class="w-full" @click.prevdient="createCharacter" :focusable="false">Create Character</NButton>
            </NFormItem>
          </NForm>
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
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">Accounts Information</h2>
            <span class="ml-3">Cash on Hand: ${{}}</span><br>
            <span class="ml-3">Bank Account: ${{}}</span><br>
            <span class="ml-3">Counterfeit Money: ${{}}</span><br>
            <span class="ml-3">Special Coins: &#65284;{{}}</span><br>
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">Other Information</h2>
            <span class="ml-3">Last Street: {{}}</span><br>
            <NButton class="w-full mt-4" @click.prevent="selectCharacter" :focusable="false">Select Character</NButton>
          </div>
        </template>
      </NCard>
    </div>
  </div>
</template>

<style scoped>
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