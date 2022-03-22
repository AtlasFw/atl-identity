<script setup>
import { Trash, PersonAdd } from '@vicons/ionicons5';
import {
  NCard,
  NButton,
  NIcon,
  NPopconfirm,
  NForm,
  NFormItem,
  NInput,
  NDatePicker,
  NSelect,
  useMessage,
} from 'naive-ui';
import { ref, reactive } from 'vue';
import { fetchNui } from '../utils/fetchNui.js';
import DataHolder from '../components/DataHolder.vue';

defineProps({
  chars: {
    type: Array,
    required: false,
  },
});

const message = useMessage();
const emit = defineEmits(['close']);
const formRef = ref(null);
const data = reactive({
  selected: null,
  id: null,
  char: null,
});
const identity = reactive({
  firstname: null,
  lastname: null,
  sex: null,
  dob: null,
  quote: null,
  selectSex: ['male', 'female'].map((v) => ({
    label: `${v.charAt(0).toUpperCase()}${v.slice(1)}`,
    value: v,
  })),
});

const rules = {
  firstname: {
    required: true,
    trigger: 'blur',
    asyncValidator: (_, value) => {
      return new Promise((resolve, reject) => {
        if (/\d/.test(value)) {
          reject('No numbers allowed.');
        }

        if (!value) {
          reject('Please input your last name.');
        }
        if (value.length > 16 || value.length < 2) {
          reject('Min 2 and Max 16 characters.');
        }

        identity.firstname = value
          .toLowerCase()
          .trim()
          .split(' ')
          .map((v) => v[0].toUpperCase() + v.substr(1))
          .join(' ');
        resolve();
      });
    },
  },
  lastname: {
    required: true,
    trigger: 'blur',
    asyncValidator: (_, value) => {
      return new Promise((resolve, reject) => {
        if (!value) {
          reject('Please input your last name.');
        }
        if (value.length > 16 || value.length < 2) {
          reject('Min 2 and Max 16 characters.');
        }
        identity.lastname = value
          .toLowerCase()
          .trim()
          .split(' ')
          .map((v) => v[0].toUpperCase() + v.substr(1))
          .join(' ');
        resolve();
      });
    },
  },
  sex: {
    required: true,
    trigger: 'blur',
    message: 'Please select your sex.',
  },
  dob: {
    type: 'number',
    required: true,
    trigger: 'blur',
    asyncValidator: (_, value) => {
      return new Promise((resolve, reject) => {
        console.log(value)
        if (!value || value < -2177434800000 || value > 1072933200000) {
          reject('Year must be between 1901 and 2003.');
        } else {
          resolve();
        }
      });
    },
  },
  quote: {
    required: true,
    trigger: 'blur',
    asyncValidator: (_, value) => {
      return new Promise((resolve, reject) => {
        if (!value) {
          reject('Please input your quote.');
        }
        if (value.length < 10 || value.length > 30) {
          reject('Min 10 and Max 30 characters.');
        }
        identity.quote =
          value.trim().charAt(0).toUpperCase() + value.trim().slice(1);
        resolve();
      });
    },
  },
};

const setSelected = ({ currentTarget }) => {
  if (currentTarget.tagName !== 'DIV') return;

  if (data.selected) {
    data.selected.classList.remove('ring-4', 'ring-sky-600', 'ring-red-600');
    if (data.selected === currentTarget) {
      fetchNui('update_character', { appearance: false });
      data.selected = null;
      data.id = null;
      data.char = null;
      return;
    }
  }

  data.selected = currentTarget;
  switch (currentTarget.getAttribute('data-char-id')) {
    case 'create':
      data.id = 'create';
      data.char = null;
      fetchNui('update_character', { appearance: false });
      break;
    case 'blocked':
      data.id = null;
      data.char = null;
      currentTarget.classList.add('ring-4', 'ring-red-600');
      return;
    default:
      data.id = parseInt(currentTarget.getAttribute('data-char-id'));
      data.char = JSON.parse(currentTarget.getAttribute('data-char'));
      fetchNui('update_character', { appearance: data.char.appearance });
      break;
  }
  currentTarget.classList.add('ring-4', 'ring-sky-600');
};

const clearData = () => {
  if (data.selected) {
    data.selected.classList.remove('ring-4', 'ring-sky-600', 'ring-red-600');
    data.selected = null;
  }
  emit('close');
  data.id = null;
  data.char = null;
};

const selectCharacter = () => {
  if (data.id && data.char) {
    fetchNui('select_character', { char_id: data.id });
    clearData();
  }
};

const createCharacter = () => {
  formRef.value
    .validate((errors) => {
      if (errors) {
        message.error('Please check your input.');
      } else {
        fetchNui('create_character', { data: identity })
        clearData();
      }
    })
    .catch(() => {
      return;
    });
};

const deleteCharacter = (char_id) => {
  if (char_id) {
    fetchNui('delete_character', { char_id: char_id });
    clearData();
  }
};
</script>

<template>
  <div class="h-full w-full grid grid-cols-10">
    <div class="flex flex-col justify-between overflow-hidden col-span-2">
      <div class="mask mt-3 flex flex-col items-center justify-start scrollbar scroll-smooth">
        <NCard
          class="w-5/6 bg-slate-800 mt-3.5 mb-3.5 opacity-95"
          size="small"
          :segmented="{ content: true }"
          v-for="(char, index) in chars"
          :key="index"
          :data-char-id="char.char_id"
          :data-char="JSON.stringify(char)"
          :title="`${char.firstname} ${char.lastname}`"
          @click.left="setSelected"
        >
          <template v-if="char.char_id !== 'create' && char.char_id !== 'blocked'" #header-extra>
            <NPopconfirm trigger="click" @positive-click="deleteCharacter(char.char_id)">
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
      <NButton @click="$emit('startlogin', 'login')" class="mb-5 mt-4 hover:underline" text strong type="error" >Go Back</NButton>
    </div>
    <div class="col-span-5"></div>
    <div class="relative h-full col-span-3 flex justify-center items-center">
      <transition name="slide-fade">
        <div v-if="data.id === 'create'" class="w-3/5">
          <div class="flex items-center justify-between text-white lg:text-[15px] 2xl:text-[17px] lg:pt-3 lg:pb-3 2xl:pt-4 2xl:pb-4 bg-slate-800 rounded border-r-2 border-b-2 border-slate-700 opacity-95 border-t-1 border-l-1">
            <span class="lg:ml-3 xl:ml-4 font-medium">Create Identity</span>
            <NIcon class="lg:mr-3 lg:text-[16px] 2xl:mr-4 2xl:text-xl">
              <PersonAdd/>
            </NIcon>
          </div>
          <div class="rounded bg-slate-800 lg:mt-2 2xl:mt-3 flex flex-col items-center justify-evenly h-full border-t-1 border-l-1 border-r-2 border-b-2 border-slate-700">
            <div class="w-[90%] lg:mt-2 2xl:mt-4">
              <NForm ref="formRef" :rules="rules" :model="identity" size="medium">
                <NFormItem class="font-medium" label="First Name" path="firstname">
                  <NInput v-model:value="identity.firstname" placeholder="Input first name" clearable/>
                </NFormItem>
                <NFormItem class="font-medium" label="Last Name" path="lastname">
                  <NInput v-model:value="identity.lastname" placeholder="Input last name" maxlength="16" clearable/>
                </NFormItem>
                <NFormItem class="font-medium" label="Sex" path="sex">
                  <NSelect placeholder="Select sex" :options="identity.selectSex" v-model:value="identity.sex"/>
                </NFormItem>
                <NFormItem class="font-medium" label="Quote" path="quote">
                  <NInput placeholder="Something interesting about you" v-model:value="identity.quote" maxlength="48" clearable/>
                </NFormItem>
                <NFormItem class="font-medium" label="Date of Birth" path="dob">
                  <NDatePicker type="date" v-model:value="identity.dob"/>
                </NFormItem>
              </NForm>
            </div>
          </div>
          <button class="lg:text-[16px] 2xl:text-[19px] bg-slate-800 mt-2 w-full pt-2 pb-2 rounded text-white font-medium border-t-1 border-l-1 border-r-2 border-b-2 border-t-1 border-l-1 border-slate-700 transition hover:bg-blue-600 hover:scale-105" @click.prevent="createCharacter">Select Character</button>
        </div>
        <div v-else-if="data.char && data.id !== 'create'" class="w-3/5">
          <div class="flex items-center justify-between text-white lg:text-[15px] 2xl:text-[17px] lg:pt-3 lg:pb-3 2xl:pt-4 2xl:pb-4 bg-slate-800 rounded border-r-2 border-b-2 border-slate-700 opacity-95">
            <span class="lg:ml-3 2xl:ml-4 font-medium">Character Information</span>
            <span class="lg:mr-3 2xl:mr-4">#{{ data.id }}</span>
          </div>
          <div class="flex flex-col items-center rounded">
            <DataHolder title="Personal Information" :sub1="{ header: 'First Name', body: data.char.firstname}" :sub2="{ header: 'Last Name', body: data.char.lastname }" :sub3="{ header: 'Date of Birth', body: new Date(data.char.dob).toLocaleDateString() }" :sub4="{ header: 'Sex', body: data.char.sex }"/>
            <DataHolder title="Job Information" :sub1="{ header: 'Job Name', body: data.char.job.name}" :sub2="{ header: 'Job Grade', body: data.char.job.rank}" :sub3="{ header: 'Job Payment', body: data.char.job.paycheck}" :sub4="{ header: 'Job Taxes', body: data.char.job.tax}"/>
            <DataHolder title="Accounts Information" :sub1="{ header: 'Cash on Hand', body: data.char.accounts.money}" :sub2="{ header: 'Bank Account', body: data.char.accounts.bank}" :sub3="{ header: 'Counterfeit Money', body: data.char.accounts.black}" :sub4="{ header: 'Special Coins', body: data.char.accounts.tebex}"/>
            <button class="lg:text-[16px] 2xl:text-[19px] bg-slate-800 mt-2 w-full pt-2 pb-2 rounded text-white font-medium border-r-2 border-b-2 border-slate-700 transition hover:bg-blue-600 hover:scale-105" @click.prevent="selectCharacter">Select Character</button>
          </div>
        </div>
      </transition>
    </div>
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