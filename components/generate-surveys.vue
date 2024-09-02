<script setup lang="ts">

import Loading from "~/components/loading.vue";
import axios from "axios";

const file = ref(null)
const isLoading = ref(false);
const surverys = ref(null);
const headers = ref(null);
const count = ref(100);
const asExcel = ref(false);

const uploadFile = async () => {
  if (file.value) {
    const formData = new FormData()
    formData.append('file', file.value)

    try {
      isLoading.value = true;

      let url = `https://demo.coflnet.com/api/import/generate?count=${count.value}`;
      if (asExcel.value) {
        let filename = `whatever.xlsx`;
        const formData = new FormData()
        formData.append('file', file.value)

        let res = await fetch(`http://localhost:5159/api/import/generateExcel/${count.value}`, {
          method: 'POST',
          body: formData,
        });
        let blob = await res.blob();

        const url = window.URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.style.display = "none";
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);

        return;
      }

      const response = await axios.post(url, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })

      if (asExcel.value) {
        // response.data is the raw bytes

        const blob = new Blob([response.data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.style.display = 'none';
        a.href = url;
        a.download = 'survey.xlsx';
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);

        return;
      }

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
        <span>Umfrageliste generieren</span>
      </h2>
      <Loading :isLoading="isLoading"/>
      <v-card class="mb-3 pa-5" title="Umfrageliste generieren">
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
            <v-number-input
                :max="10000"
                :min="0"
                v-model="count"
            >
            </v-number-input>
          </v-col>
          <v-col>
            <v-checkbox label="As Excel" v-model="asExcel"></v-checkbox>
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
