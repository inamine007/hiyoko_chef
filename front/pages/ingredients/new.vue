<template>
  <div id="app">
    <v-app>
      <v-container
        class="fill-height"
        fluid
      >
        <v-row
          align="center"
          justify="center"
        >
          <v-col
            cols="12"
            sm="8"
            md="8"
          >
            <v-card>
              <v-card-title>食材登録</v-card-title>
              <v-card-text>
                <v-form @submit.prevent="createIngredient">
                  <v-text-field
                    v-model="form.name"
                    label="食材名"
                    :rules="[required]"
                    name="name"
                  >
                  </v-text-field>
                  <v-text-field
                    v-model="form.trader"
                    label="仕入れ先または店名"
                    :rules="[required]"
                    name="trader"
                  >
                  </v-text-field>
                  <v-text-field
                    v-model.number="form.cost"
                    label="価格"
                    name="cost"
                    suffix="円"
                    type="number"
                    @keydown.69.prevent
                    :rules="[required]"
                  >
                  </v-text-field>
                  <v-row>
                    <v-col cols="12" sm="6">
                      <v-select
                        v-model="form.unit"
                        :items="items"
                        value="Kg"
                        label="仕入れ単位"
                        name="unit"
                      >
                      </v-select>
                    </v-col>
                    <v-col cols="12" sm="6">
                      <v-select
                        v-model="form.unit_used"
                        label="使用単位"
                        :items="items"
                        value="g"
                        name="unit_used"
                      >
                      </v-select>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="6">
                      <v-select
                        v-model.number="form.budomari"
                        label="歩留まり"
                        :items="items2"
                        name="budomari"
                        type="number"
                        step="0.1"
                      >
                      </v-select>
                    </v-col>
                    <v-col cols="12" sm="6">
                      <v-select
                        v-model.number="form.converted_number"
                        label="換算数"
                        name="converted_number"
                        type="number"
                        :items="items3"
                        hint="Kg → g = 0.001, L → ml(cc) = 0.001, 100g → g = 0.01, 本 → 本 = 1"
                        persistent-hint
                      >
                      </v-select>
                    </v-col>
                  </v-row>
                  <v-divider></v-divider>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn type="submit" class="primary">登録</v-btn>
                  </v-card-actions>
                </v-form>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-app>
  </div>
</template>

<script>
let url = "/ingredients"
export default {
  data() {
    return {
      form: {
        name: '',
        trader: '',
        unit: 'Kg',
        unit_used: 'g',
        cost: '',
        budomari: 1,
        converted_number: 0.001
      },
      required: value => !!value || '必ず入力してください',
      // number: value => !(value > 1 || value < 0.001) || '0.001~1の数値を入力してください',
      items: ['Kg', 'L', '個', '本', '100g', '袋', '100ml', 'g', 'ml'],
      items2: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
      items3: [0.001, 0.01, 0.1, 1]
    }
  },
  methods: {
    async createIngredient() {
      await this.$axios.$post(url, this.form)
      .then((res) => {
        console.log(res);
        this.$router.replace({path: '/ingredients/'});
        this.$toasted.success(this.form.name + 'を作成しました！');
        return res
      }).catch((error) => {
        console.log(error);
        this.$toasted.error('作成できませんでした');
        return error
      })
    }
  }
}
</script>