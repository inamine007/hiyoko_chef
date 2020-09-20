<template>
  <v-container
    lass="fill-height"
    fluid
  >
    <v-row
      align="center"
      justify="center"
    >
      <v-col
        cols="12"
        sm="10"
        md="7"
      >
        <v-card class="elevation-12">
          <v-card-title>レシピ作成</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="createRecipe()">
              <v-text-field
                v-model="name"
                label="レシピ名"
                name="name"
                :rules="[required]"
              ></v-text-field>
              <v-row>
                <v-col cols="6" sm="6">
                  <v-text-field
                    v-model.number="time"
                    id="time"
                    label="目安時間"
                    name="time"
                    type="number"
                    suffix="分"
                    @keydown.69.prevent
                    :dense="true"
                  ></v-text-field>
                </v-col>
                <v-col cols="6" sm="6">
                  <v-text-field
                    v-model="serve"
                    suffix="人分"
                    name="serve"
                    type="number"
                    :dense="true"
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-file-input
                accept="image/*, video/*"
                label="画像または動画"
                name="image"
                @change="onUpload()"
                ref="file"
                :dense="true"
                hint="最大８つまで"
                :multiple="true"
              ></v-file-input>
              <v-divider class="mt-3"></v-divider>
              <v-card-title>材料</v-card-title>
              <div v-for="(col, index) in cols" :key="index">
                <v-row>
                  <v-col cols="12" sm="4">
                    <v-select
                      v-model="col.trader"
                      label="仕入れ先または店名"
                      name="trader"
                      :items="ingredients"
                      item-text="trader"
                      @change="selected(col)"
                      :dense="true"
                    ></v-select>
                  </v-col>
                  <v-col cols="12" sm="4">
                    <v-select
                      v-model.number="col.ingredients.fil.id"
                      label="食材名"
                      name="ingredient_name"
                      :items="Array.from(col.ingredients.fil)"
                      item-text="name"
                      item-value="id"
                      type="number"
                      @change="setI(col, index)"
                      :dense="true"
                    ></v-select>
                  </v-col>
                  <v-col cols="8" sm="2">
                    <v-text-field
                      v-model.number="col.amount"
                      label="使用量"
                      name="amount"
                      type="number"
                      @keydown.69.prevent
                      @change="setA(col, index)"
                      :dense="true"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="4" sm="2">
                    <v-text-field
                      v-model="col.unit_used"
                      label="使用単位"
                      :readonly="true"
                      :dense="true"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn class="error" @click="removeItems(index)">削除</v-btn> 
                </v-card-actions>
              </div>
              <v-btn class="secondary" @click="addItems">追加</v-btn>
              <v-divider class="mt-3"></v-divider>
              <v-card-title>作り方</v-card-title>
              <v-textarea
                v-model="description"
                label="作り方"
                name="description"
              ></v-textarea>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn type="submit" color="primary">登録</v-btn>
              </v-card-actions>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
let url = '/recipes'
export default {
  props: {
    source: String, 
  },
  data() {
    return {
      setID: [],
      setAmount: [],
      name: '',
      description: '',
      time: '',
      serve: '',
      images: [],
      cols: [{
      trader: '',
      amount: '',
      unit_used: '',
      ingredients: {
        fil: {
          name: '',
          id: '',
        }
      },
      }],
      required: value => !!value || '必ず入力してください',
    }
  },
  asyncData({$axios}) {
    return $axios.get('/ingredients').then((res) => {
      console.log(res)
      return { ingredients: res.data.data }
    })
  },
  methods: {
    onUpload() {
      this.images = event.target.files;
    },
    setI(col, index) {
      this.setID.splice(index, 1, col.ingredients.fil.id);
      col.unit_used = this.ingredients.find(item => item.id === col.ingredients.fil.id).unit_used
    },
    setA(col, index) {
      this.setAmount.splice(index, 1, col.amount);
      console.log(this.setAmount)
    },
    createRecipe() {
      let formData = new FormData()
      formData.append('name', this.name)
      formData.append('description', this.description)
      formData.append('time', this.time)
      formData.append('serve', this.serve)
      for (let i = 0; i < this.setID.length && this.setAmount.length; i++) {
        let id = this.setID[i];
        let amount = this.setAmount[i]; 
        formData.append('ingredient_recipes_attributes[][ingredient_id]', id)
        formData.append('ingredient_recipes_attributes[][amount]', amount)
      }
      for( let i = 0; i < this.images.length; i++) {
        let image = this.images[i];
        formData.append('images[]', image);
      }
      this.$axios.$post(url, formData).then((res) => {
        console.log(res);
        if (res.status == 'ERROR') {
          var messages = [];
          for (var i=0; i<res.data.length; i++){
            messages.push(res.data[i]);
          }
          var result = messages.join('<br>')
          this.$toasted.error(result)
        } else {
            this.$router.replace({path: '/groups/'});
            this.$toasted.success(this.name + 'を作成しました！');
        }
      }).catch((error) => {
        console.log(error);
        this.$toasted.error('作成できませんでした');
        return error
      })
    },
    selected(col) {
      col.ingredients.fil = this.ingredients.filter(item => item.trader === col.trader)
      return col.ingredients.fil
    },
    addItems() {
      this.cols.push(this.independentObejct())
    },
    removeItems(col, target) {
      this.cols.splice(target, 1)
      this.setID.splice(target, 1)
      this.setAmount.splice(target, 1)
      console.log(this.setID)
      console.log(this.setAmount)

    },
    independentObejct () {
      return {
        trader: '',
        amount: '',
        ingredients: {
          fil: {
            name: '',
            id: ''
          }
        }
      }
    }
  },
}
</script>