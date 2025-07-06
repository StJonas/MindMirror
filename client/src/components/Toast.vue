<template>
  <div v-if="isVisible" :class="['toast', type]">{{ message }}</div>
</template>

<script>
export default {
  props: {
    message: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      default: "success",
    },
  },
  data() {
    return {
      isVisible: false,
    };
  },
  methods: {
    show() {
      this.isVisible = true;
      setTimeout(() => {
        this.isVisible = false;
      }, 3000);
    },
  },
};
</script>

<style>
.toast {
  display: flex;
  align-items: center;
  justify-content: center;
  position: fixed;
  top: 10px;
  left: 50%;
  transform: translateX(-50%);
  padding: 10px 20px;
  border-radius: 5px;
  color: white;
  font-size: 14px;
  z-index: 1000;
  animation: fade-in 0.3s ease, fade-out 0.3s ease 2.7s;
  min-width: 200px;
  max-width: 95vw;
  text-align: center;
}
.toast.success {
  background-color: #4caf50;
}
.toast.error {
  background-color: #f44336;
}
.toast.info {
  background-color: #3678f4;
}
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateX(-50%) translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
}
@keyframes fade-out {
  from {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
  to {
    opacity: 0;
    transform: translateX(-50%) translateY(10px);
  }
}
@media (max-width: 600px) {
  .toast {
    width: 90vw;
    font-size: 16px;
    padding: 14px 10px;
    border-radius: 8px;
    min-width: unset;
    max-width: 95vw;
  }
}
</style>
