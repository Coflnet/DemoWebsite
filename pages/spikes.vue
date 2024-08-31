<script setup lang="ts">
import Loading from "~/components/loading.vue";
import axios from "axios";

const file = ref(null)
const brands = ref(null)

const uploadFile = async () => {
  if (file.value) {
    const formData = new FormData()
    formData.append('file', file.value)

    try {
      const response = await axios.post('http://localhost:5159/api/excel', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
      console.log('File uploaded successfully:', response.data)

      brands.value = response.data.brands.map(e => {
        return {
          "brand": e
        }
      });
      console.log(brands.value)

    } catch (error) {
      console.error('Error uploading file:', error)
    }
  } else {
    console.log("no file")
  }
}

</script>

<template>
  <h2 class="text-h2 mb-5">
    <span>Spikes Demo</span>
  </h2>

  <v-container>

    <v-form v-model="isFormValid" ref="form">
      <h2 class="text-h4 mb-5">
        <span> Unternehmensliste hochladen </span>
      </h2>
      <Loading :isLoading="isLoading"/>
      <v-card class="mb-3 pa-5">
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

        <v-row>
          <v-col v-if="brands">
            <v-data-table :loading="isLoading" hover :items="brands" items-per-page="20"
                          density="compact"
                          :headers="[{ key: 'brand', title: 'Brand' }]">
            </v-data-table>
          </v-col>
        </v-row>
      </v-card>
    </v-form>
  </v-container>


</template>

<style scoped>

</style>