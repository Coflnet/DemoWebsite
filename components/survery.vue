<script setup lang="ts">

import Loading from "~/components/loading.vue";
import axios from "axios";

const file = ref(null)
const isLoading = ref(false);
const surverys = ref(null);
const headers = ref(null);

const uploadFile = async () => {
  if (file.value) {
    const formData = new FormData()
    formData.append('file', file.value)

    try {
      isLoading.value = true;
      const response = await axios.post('http://localhost:5159/api/import', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
      console.log('File uploaded successfully:', response.data)

      let el = response.data[0];
      headers.value = Object.keys(el).map(e => {
        return {
          key: e,
          title: e,
        }
      })

      console.log(headers);
      surverys.value = response.data;


    } catch (error) {
      console.error('Error uploading file:', error)
    } finally {
      isLoading.value = false;
    }
  } else {
    console.log("no file")
  }
}
</script>

<template>
  <v-container>
    <v-form v-model="isFormValid" ref="form">
      <h2 class="text-h4 mb-5">
        <span>Umfrageliste hochladen</span>
      </h2>
      <Loading :isLoading="isLoading"/>
      <v-card class="mb-3 pa-5" title="Umfrageliste">
        <v-row>
          <v-col>
            <v-file-input
                show-size
                label="File input"
                @change="selectFile"
                v-model="file"
            ></v-file-input>
          </v-col>
          <v-col>
            <v-btn class="mt-2" block @click="uploadFile">Submit</v-btn>
          </v-col>
        </v-row>
      </v-card>

      <v-card class="mb-3 pa-5" title="Ausgewertete Liste" v-if="surverys">
        <v-row>
          <v-col>
            <v-data-table :loading="isLoading" hover :items="surverys" items-per-page="20"
                          density="compact"
                          :headers="headers"></v-data-table>
          </v-col>
        </v-row>
      </v-card>
    </v-form>
  </v-container>

</template>

<style scoped>

</style>