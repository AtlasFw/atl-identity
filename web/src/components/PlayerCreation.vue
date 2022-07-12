<script setup>
import { reactive } from 'vue'
import { PersonAdd } from '@vicons/ionicons5'
import { NForm, NFormItem, NInput, NDatePicker, NSelect } from 'naive-ui'

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
          reject('Min 2 and max 16 characters.');
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
          reject('Min of 2 and max of 16.');
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
          reject('Please input something interesting.');
        }
        if (value.length < 10 || value.length > 40) {
          reject('Min of 10 and max 30 characters.');
        }
        identity.quote = value
          .trim()
          .charAt(0)
          .toUpperCase() + value
          .trim()
          .slice(1);
        resolve();
      });
    },
  },
};
</script>

<template>
  <div class="w-[24em] flex flex-col items-center mr-8">
    <div class="w-full flex justify-between items-center mt-2 py-3 px-3 -skew-x-2 rounded shadow shadow-slate-900 border-b-1 border-b-slate-500 bg-[#1E293BE8]">
      <span class="text-lg font-semibold text-white">Character Creation</span>
      <PersonAdd class="w-5 h-5"/>
    </div>
    <div class="w-full flex flex-col items-center rounded shadow shadow-slate-900 border-b-1 border-b-slate-500 bg-[#1E293BE8] mt-2">
      <div class="w-[90%] mt-4 text-left mb-1">
        <NForm ref="formRef" :rules="rules" :model="identity" size="medium">
          <NFormItem class="font-semibold" label="First Name" path="firstname">
            <NInput v-model:value="identity.firstname" placeholder="Input first name" clearable/>
          </NFormItem>
          <NFormItem class="font-semibold" label="Last Name" path="lastname">
            <NInput v-model:value="identity.lastname" placeholder="Input last name" maxlength="16" clearable/>
          </NFormItem>
          <NFormItem class="font-semibold" label="Quote" path="quote">
            <NInput placeholder="Input an interest quote" v-model:value="identity.quote" maxlength="48" clearable/>
          </NFormItem>
          <NFormItem class="font-semibold" label="Sex" path="sex">
            <NSelect placeholder="Select sex" :options="identity.selectSex" v-model:value="identity.sex"/>
          </NFormItem>
          <NFormItem class="font-semibold" label="Date of Birth" path="dob">
            <NDatePicker type="date" v-model:value="identity.dob"/>
          </NFormItem>
        </NForm>
      </div>
    </div>
    <button class="h-12 w-full rounded bg-[#1E293BE8] shadow font-bold text-xl transition duration-200 shadow shadow-slate-900 border-b-1 border-b-slate-500 hover:bg-slate-600 mt-2">Create Character</button>
  </div>
</template>