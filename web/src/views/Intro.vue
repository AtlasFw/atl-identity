<script setup>
import{ NButton, useDialog } from 'naive-ui'
import { fetchNui } from '../utils/fetchNui'
const dialog = useDialog()
const handleLeave = () => {
  dialog.info({
    title: 'Leave',
    content: 'Are you sure want to leave the server? You will have to go through queue again if you try to join back.',
    positiveText: 'Leave',
    negativeText: 'Cancel',
    onPositiveClick: () => {
      fetchNui('leave_server')
    }
  })
}
</script>

<template>
  <div class="h-full w-full flex items-center justify-end flex-col">
      <NButton @click="$emit('startmulticharacter', 'multicharacter')" class="w-64 h-14 text-lg" :focusable="false" ghost strong type="info">Get Started</NButton>
      <NButton @click="handleLeave" class="mb-5 mt-2.5 hover:underline" text ghost strong type="error">Leave</NButton>
  </div>
</template>