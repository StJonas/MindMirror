<template>
  <div v-if="visible" class="loading-spinner"></div>
</template>

<script setup>
import { defineProps } from "vue";
const props = defineProps({ visible: Boolean });
</script>

<style scoped>
.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e0e0e0;
  border-top: 4px solid #334d6e;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 16px auto;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>