<template>
  <v-overlay :model-value="isLoading" persistent class="align-center justify-center">
    <v-progress-circular color="primary" indeterminate size="64"></v-progress-circular>
  </v-overlay>
</template>

<script>
export default {
  name: "Loading",
  props: {
    isLoading: Boolean,
  },
};
</script>