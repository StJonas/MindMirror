import { ref } from 'vue';

export function useToast(toastRef = ref(null)) {
  const toastMessage = ref('');
  const toastType = ref('success');

  function showToast(message, type = 'success') {
    toastMessage.value = message;
    toastType.value = type;
    toastRef.value?.show?.();
  }

  return {
    toastRef,
    toastMessage,
    toastType,
    showToast,
  };
}