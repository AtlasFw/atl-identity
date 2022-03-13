<script setup>
import { Trash, PersonAdd } from '@vicons/ionicons5';
import {
  NCard,
  NButton,
  NSkeleton,
  NIcon,
  NPopconfirm,
  NForm,
  NFormItem,
  NInput,
  NDatePicker,
  NSelect,
  useMessage,
} from 'naive-ui';
import { ref, reactive, computed } from 'vue';
import { fetchNui } from '../utils/fetchNui.js';
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
    asyncValidator: (rule, value) => {
      return new Promise((resolve, reject) => {
        if (/\d/.test(value)) {
          reject('No numbers allowed');
        }

        if (!value) {
          reject('Please input your last name');
        }
        if (value.length > 16 || value.length < 2) {
          reject('Max 16 chars, min 2 chars');
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
    asyncValidator: (rule, value) => {
      return new Promise((resolve, reject) => {
        if (!value) {
          reject('Please input your last name');
        }
        if (value.length > 16 || value.length < 2) {
          reject('Max 16 chars, min 2 chars');
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
    asyncValidator: (rule, value) => {
      return new Promise((resolve, reject) => {
        if (!value || value < -2177434800000 || value > 1072933200000) {
          reject('Year must be between 1991 and 2004.');
        } else {
          resolve();
        }
      });
    },
  },
  quote: {
    required: true,
    trigger: 'blur',
    asyncValidator: (rule, value) => {
      return new Promise((resolve, reject) => {
        if (!value) {
          reject('Please input your quote.');
        }
        if (value.length < 10 || value.length > 30) {
          reject('Max 30 chars, min 10 chars');
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
  data.id = null;
  data.char = null;
};
const selectCharacter = () => {
  if (data.id && data.char) {
    fetchNui('select_character', {
      char_id: data.id,
    }).then((resp) => {
      if (resp.done) {
        message.success('Selected character.');
        clearData();
        emit('close');
      } else {
        message.error('Could not select character.');
        console.log('Error: Could not select character. Data was not received');
      }
    });
  }
};
const createCharacter = () => {
  formRef.value
    .validate((errors) => {
      if (errors) {
        message.error('Please check your input.');
      } else {
        fetchNui('create_character', { data: identity }).then((resp) => {
          if (resp.done) {
            message.success('Created character successfully.');
            clearData();
            emit('close');
          } else {
            message.error('Error creating character.');
            console.log('Error: Could not create character');
          }
        });
      }
    })
    .catch(() => {
      return;
    });
};
const deleteCharacter = (char_id) => {
  if (char_id) {
    fetchNui('delete_character', {
      char_id: char_id,
    }).then((resp) => {
      if (resp.done) {
        message.success('Character deleted successfully.');
        clearData();
        emit('close');
      } else {
        message.error('Error deleting character.');
        console.log('Error: Could not delete character. Data was not received');
      }
    });
  }
};
</script>

<template>
  <div class="h-full w-full grid grid-cols-10">
    <div class="flex flex-col justify-between overflow-hidden col-span-2">
      <div
        class="mask mt-3 flex flex-col items-center justify-start scrollbar scroll-smooth"
      >
        <NCard
          class="w-5/6 bg-slate-800 mt-3.5 mb-3.5"
          size="small"
          :segmented="{ content: true }"
          v-for="(char, index) in chars"
          :key="index"
          :data-char-id="char.char_id"
          :data-char="JSON.stringify(char)"
          :title="`${char.firstname} ${char.lastname}`"
          @click.left="setSelected"
        >
          <template
            v-if="char.char_id !== 'create' && char.char_id !== 'blocked'"
            #header-extra
          >
            <NPopconfirm
              trigger="click"
              @positive-click="deleteCharacter(char.char_id)"
            >
              <template #trigger>
                <n-button size="small" tertiary circle type="error">
                  <template #icon>
                    <NIcon>
                      <Trash />
                    </NIcon>
                  </template>
                </n-button>
              </template>
              <span
                >Are you sure you want to delete your character? This action is
                irreversible.</span
              >
            </NPopconfirm>
          </template>
          {{ char.quote }}
        </NCard>
      </div>
      <NButton
        @click="$emit('startlogin', 'login')"
        class="mb-5 mt-4 hover:underline"
        text
        strong
        type="error"
        >Go Back</NButton
      >
    </div>
    <div class="col-span-5"></div>
    <div class="relative h-full col-span-3 flex justify-center items-center">
      <NCard
        class="relative w-4/6 h-4/6 rounded-lg bg-slate-800 scrollbar scroll-smooth"
        n-skeleton
        size="medium"
        :segmented="{ content: true, footer: 'soft' }"
      >
        <template #header>
          <n-skeleton
            v-if="!data.char && data.id !== 'create'"
            text
            width="55%"
          />
          <template v-else-if="data.id === 'create'">
            Create a New Identity
          </template>
          <template v-else> Character Information </template>
        </template>
        <template #header-extra>
          <n-skeleton
            v-if="!data.char && data.id !== 'create'"
            circle
            width="20px"
          />
          <NIcon size="large" v-else-if="data.id === 'create'">
            <PersonAdd class="h-64 w-64" />
          </NIcon>
          <template v-else>#{{ data.id }}</template>
        </template>
        <template v-if="!data.char && data.id !== 'create'">
          <n-skeleton text />
          <n-skeleton text style="width: 60%" />
          <n-skeleton text style="width: 80%" />
          <n-skeleton text style="width: 45%" />
          <n-skeleton text style="width: 60%" />
          <n-skeleton text />
          <n-skeleton text style="width: 95%" />
          <n-skeleton text style="width: 80%" />
          <n-skeleton text style="width: 45%" />
          <n-skeleton text style="width: 82%" />
          <n-skeleton text />
          <n-skeleton text style="width: 60%" />
          <n-skeleton text style="width: 72%" />
          <n-skeleton text style="width: 45%" />
          <n-skeleton text style="width: 65%" />
          <n-skeleton text />
          <n-skeleton text style="width: 60%" />
          <n-skeleton text style="width: 80%" />
          <n-skeleton text style="width: 45%" />
        </template>
        <template v-else-if="data.id === 'create'">
          <NForm ref="formRef" :rules="rules" :model="identity" size="medium">
            <NFormItem label="First Name" path="firstname">
              <NInput
                v-model:value="identity.firstname"
                placeholder="Input first name"
                clearable
              />
            </NFormItem>
            <NFormItem label="Last Name" path="lastname">
              <NInput
                v-model:value="identity.lastname"
                placeholder="Input last name"
                maxlength="16"
                clearable
              />
            </NFormItem>
            <NFormItem label="Date of Birth" path="dob">
              <NDatePicker
                type="date"
                v-model:value="identity.dob"
              ></NDatePicker>
            </NFormItem>
            <NFormItem label="Sex" path="sex">
              <NSelect
                placeholder="Select sex"
                :options="identity.selectSex"
                v-model:value="identity.sex"
              />
            </NFormItem>
            <NFormItem label="Quote" path="quote">
              <NInput
                placeholder="Something interesting about you"
                v-model:value="identity.quote"
                maxlength="48"
                clearable
              />
            </NFormItem>
            <NFormItem>
              <NButton
                class="w-full"
                @click.prevdient="createCharacter"
                :focusable="false"
                >Create Character</NButton
              >
            </NFormItem>
          </NForm>
        </template>
        <template v-else>
          <div class="relative">
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">
              Personal Information
            </h2>
            <span class="ml-3">First Name: {{ data.char.firstname }}</span
            ><br />
            <span class="ml-3">Last Name: {{ data.char.lastname }}</span
            ><br />
            <span class="ml-3"
              >Date of Birth:
              {{ new Date(data.char.dob).toLocaleDateString() }}</span
            ><br />
            <span class="ml-3">Sex: {{ data.char.sex }}</span
            ><br />
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">
              Job Information
            </h2>
            <span class="ml-3">Job Name: {{ data.char.job.name }}</span><br />
            <span class="ml-3">Job Grade: {{ data.char.job.rank }}</span><br />
            <span class="ml-3">Job Paycheck: ${{ data.char.job.paycheck }}</span><br />
            <span class="ml-3">Job Taxes: {{ data.char.job.tax }}%</span><br />
            <h2 class="text-lg font-medium border-b-1 text-center mb-4">
              Accounts Information
            </h2>
            <span class="ml-3"
              >Cash on Hand: ${{ data.char.accounts.money }}</span
            ><br />
            <span class="ml-3"
              >Bank Account: ${{ data.char.accounts.bank }}</span
            ><br />
            <span class="ml-3"
              >Counterfeit Money: ${{ data.char.accounts.black }}</span
            ><br />
            <span class="ml-3"
              >Special Coins: &#65284;{{ data.char.accounts.tebex }}</span
            ><br />
            <NButton
              class="w-full mt-4"
              @click.prevent="selectCharacter"
              :focusable="false"
              >Select Character</NButton
            >
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
