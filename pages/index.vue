<script setup lang="ts">

</script>

<template>
  <h1>Demo Website</h1>

  <div class="d-flex justify-center">
    <v-col>
      <v-btn-toggle
          v-model="toggle_one"
          shaped
      >
        <v-btn>

          <NuxtLink to="/spikes">Spikes Demo</NuxtLink>
        </v-btn>

        <!--
        For more demo applications use a normal a link, if the website is not in this nuxt application
        If you use nuxt you can use the fancier NuxtLink, which does prefetching and better transitions
        <v-btn>
          <a href="/spikes">Spikes Demo</a>
        </v-btn>
        -->
      </v-btn-toggle>
    </v-col>
  </div>
</template>

<style scoped>

</style>