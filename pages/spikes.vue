<script setup lang="ts">
import Loading from "~/components/loading.vue";
import axios from "axios";

const file = ref(null)
const brands = ref(null)
const noChangeNecessary = ref(null)
const mapped = ref(null);
const unmappable = ref(null);
const isLoading = ref(false);

const uploadFile = async () => {
  if (file.value) {
    const formData = new FormData()
    formData.append('file', file.value)

    try {
      isLoading.value = true;
      const response = await axios.post('https://demo.coflnet.com/api/excel', formData, {
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

      noChangeNecessary.value = response.data.noChangeNecessary.map(brand => {
        return {
          "input": brand,
          "output": brand
        }
      })

      mapped.value = response.data.mapped;

      unmappable.value = response.data.unmappable.map(e => {
        return {
          "inputBrand": e.inputBrand,
          "inputProduct": e.inputProduct,
          "output": "-"
        }
      })

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
  <h2 class="text-h2 mb-5">
    <span>Spikes Demo</span>
  </h2>

  <v-container>

    <v-form v-model="isFormValid" ref="form">
      <h2 class="text-h4 mb-5">
        <span> Unternehmensliste hochladen </span>
      </h2>
      <Loading :isLoading="isLoading"/>
      <v-card class="mb-3 pa-5" title="Upload von Unternehmensdateien">
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

      <v-card class="pa-5 mb-3 py-8" title="Erkannte Unternehmen">
        <v-row>
          <v-col v-if="brands">
            <v-data-table :loading="isLoading" hover :items="brands" items-per-page="20"
                          density="compact"
                          :headers="[{ key: 'brand', title: 'Brand' }]">
            </v-data-table>
          </v-col>
        </v-row>
      </v-card>

      <v-card class="py-16 pa-5 mb-3 " title="Keine Änderungen notwendig">
        <v-row>
          <v-col v-if="noChangeNecessary">
            <v-data-table :loading="isLoading" hover :items="noChangeNecessary" items-per-page="20"
                          density="compact"
                          :headers="[{ key: 'input', title: 'Eingabwert aus Excel' }, { key: 'output', title: 'Ausgabewert' }]">
            </v-data-table>
          </v-col>
        </v-row>
      </v-card>

      <v-card class="pa-5 mb-3 py-16">
        <v-row>
          <v-col v-if="mapped" title="Änderungen wurden durchgeführt">
            <v-data-table :loading="isLoading" hover :items="mapped" items-per-page="20"
                          density="compact"
                          :headers="[{ key: 'inputBrand', title: 'Eingabwert des Unternehmens aus Excel' }, { key: 'inputProduct', title: 'Eingabewert des Produkts aus Excel'} , { key: 'output', title: 'Ausgabewert' }]">
            </v-data-table>
          </v-col>
        </v-row>
      </v-card>

      <v-card class="pa-5 mb-3 py-16" title="Keine Änderung möglich">
        <v-row>
          <v-col v-if="unmappable">
            <v-data-table :loading="isLoading" hover :items="unmappable" items-per-page="20"
                          density="compact"
                          :headers="[{ key: 'inputBrand', title: 'Eingabwert des Unternehmens aus Excel' }, { key: 'inputProduct', title: 'Eingabewert des Produkts aus Excel'} , { key: 'output', title: 'Ausgabewert' }]">
            </v-data-table>
          </v-col>
        </v-row>
      </v-card>
    </v-form>
  </v-container>


</template>

<style scoped>

</style>