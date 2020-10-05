<template>
  <v-row
    align="center"
    justify="center"
  >
    <v-col
      cols="12"
      sm="8"
      md="8"
    >
      <v-card flat class="mt-16" style="position: relative">
        <v-card-actions>
          <v-btn absolute dark right bottom fab color="pink" to="/recipes/new" nuxt><v-icon>mdi-plus</v-icon></v-btn>
        </v-card-actions>
      </v-card>
      <v-text-field
        v-model="search"
        prepend-inner-icon="fas fa-search"
        label="検索"
        single-line
        hide-details
      ></v-text-field>
      <v-data-table
        :headers="headers"
        :items="serverDatas"
        :items-per-page="7"
        :search="search"
        @click:row="onClickEvent"
        class="elevation-1 mt-0"
      >
        <template v-slot:[`item.edit`]="{item}">
          <v-icon @click.stop="editConfirm(item)">fas fa-edit</v-icon>
          <v-icon @click.stop="deleteConfirm(item)">fas fa-trash</v-icon>
        </template>
      </v-data-table>
      <v-dialog v-model="showDialog" persistent max-width="640">
        <v-card
          class="mx-auto"
        >
          <v-img
            v-if="showImageUrl" 
            :src="showImageUrl"
            max-width="640"
            max-height="480"
          ></v-img>
          <v-card-title class="mb-3">
            {{ recipe.name }}
          </v-card-title>
          <v-card-subtitle>
            <v-icon dense class="mr-1" color="black">fas fa-utensils</v-icon>{{ recipe.serve }}人前
            <v-icon dense class="mr-1 ml-4" color="orange">far fa-clock</v-icon>約{{ recipe.time }}分
            <v-icon dense class="mr-1 ml-4" color="blue">fas fa-dollar-sign</v-icon>{{ recipe.cost }}円
            <v-icon dense class="mr-1 ml-4" color="red">fas fa-tag</v-icon>{{ recipe.category.name }}
          </v-card-subtitle>
          <v-card-text>
            <v-simple-table class="mb-3">
              <caption>食材</caption>
              <thead>
                <tr>
                  <th class="text-left">名前</th>
                  <th class="text-left">使用量</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(ri, index) in recipe.ingredients" :key="index">
                  <td>{{ ri.name }}</td>
                  <td>{{ amounts[index] }}{{ ri.unit_used }}</td>
                </tr>
              </tbody>
            </v-simple-table>
            <p>作り方</p>
            <v-card>
              <v-card-text style="white-space: pre-wrap; word-wrap: break-word;">{{ recipe.description }}</v-card-text>
            </v-card>
          </v-card-text>
          <v-divider></v-divider>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="showDialog=false, amounts=[]">閉じる</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-dialog v-model="editDialog" persistent max-width="640">
        <v-card>
          <v-card-title>レシピ編集</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="editRecipe(editID, editName)">
              <v-text-field
                v-model="recipe.name"
                label="レシピ名"
                name="name"
                :rules="[required]"
              ></v-text-field>
              <v-row>
                <v-col cols="6" sm="6">
                  <v-text-field
                    v-model.number="recipe.time"
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
                    v-model="recipe.serve"
                    suffix="人分"
                    name="serve"
                    type="number"
                    :dense="true"
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-row justify="center">
              <v-img v-if="selectedImageUrl" :src="selectedImageUrl" max-width="300" max-height="300"></v-img>
              </v-row>
              <v-file-input
                accept="image/*, video/*"
                label="画像または動画"
                name="image"
                @change="onUpload()"
                ref="file"
                :dense="true"
                :clearable="false"
              ></v-file-input>
              <v-row>
                <v-col cols="6" sm="6">
                  <v-select
                    v-model.number="recipe.category.id"
                    label="カテゴリー"
                    name="categories"
                    :items="categories"
                    item-text="name"
                    item-value="id"
                    :dense="true"
                  ></v-select>
                    </v-col>
                    <v-col cols="6" sm="6">
                  <v-select
                    v-model.number="recipe.group_id"
                    label="グループ"
                    name="groups"
                    :items="groups"
                    item-text="name"
                    item-value="id"
                    :dense="true"
                    :clearable="true"
                  ></v-select>
                </v-col>
              </v-row>
              <v-divider class="mt-3"></v-divider>
              <v-card-title>材料</v-card-title>
              <div v-for="(ri, index) in recipe.ingredients" :key="index">
                <v-row>
                  <v-col cols="12" sm="4">
                    <v-select
                      v-model="ri.trader"
                      label="仕入れ先または店名"
                      name="trader"
                      :items="ingredients"
                      item-text="trader"
                      @change="selected(ri, index)"
                      :dense="true"
                    ></v-select>
                  </v-col>
                  <v-col cols="12" sm="4">
                    <v-text-field
                      v-if="!ri.fil"
                      v-model="ri.name"
                      label="食材名"
                      name="ingredient_name"
                      :dense="true"
                      :readonly="true"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="8" sm="2">
                    <v-text-field
                      v-if="!ri.fil"
                      v-model.number="amounts[index]"
                      label="使用量"
                      name="amount"
                      type="number"
                      @keydown.69.prevent
                      @change="setA(ri, index)"
                      :dense="true"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="4" sm="2">
                    <v-text-field
                      v-if="!ri.fil"
                      v-model="ri.unit_used"
                      label="使用単位"
                      :readonly="true"
                      :dense="true"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="4">
                    <v-select
                      v-if="ri.fil"
                      v-model.number="ri.fil.id"
                      label="食材名"
                      name="ingredient_name"
                      :items="Array.from(ri.fil)"
                      item-text="name"
                      item-value="id"
                      type="number"
                      @change="setI(ri, index)"
                      :dense="true"
                    ></v-select>
                  </v-col>
                  <v-col cols="8" sm="2">
                    <v-text-field
                      v-if="ri.fil"
                      v-model.number="ri.amount"
                      label="使用量"
                      name="amount"
                      type="number"
                      @keydown.69.prevent
                      @change="setA(ri, index)"
                      :dense="true"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="4" sm="2">
                    <v-text-field
                      v-if="ri.fil"
                      v-model="ri.unit_used"
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
                v-model="recipe.description"
                label="作り方"
                name="description"
              ></v-textarea>
              <v-switch
                v-model="recipe.status"
                label="公開"
                value="published"
              ></v-switch>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" text type="submit">更新</v-btn>
                <v-btn color="green darken-1" text @click="editDialog=false, setID=setAmount=amounts=[]">キャンセル</v-btn>
              </v-card-actions>
            </v-form>
          </v-card-text>
        </v-card>
      </v-dialog>
      <v-dialog v-model="deleteDialog" persistent max-width="320">
        <v-card>
          <v-card-title>削除確認</v-card-title>
          <v-card-text>{{ deleteName }}を削除してもよろしいですか？</v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="deleteItem(deleteID, deleteName)">削除</v-btn>
            <v-btn color="green darken-1" text @click="deleteDialog=false">キャンセル</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-col>
  </v-row>
</template>

<script>
let url = "/recipes/"
let url_r = "/recipes/confirm"
let url_i = "/ingredients/"
let url_c = '/categories'
let url_g = '/groups'
export default {
  props: {
    source: String, 
  },
  data() {
    return {
      selectedImageUrl: null,
      showImageUrl: null,
      showDialog: false,
      editDialog: false,
      editID: null,
      editName: null,
      deleteDialog: false,
      deleteName: null,
      deleteID: null,
      search: '',
      headers: [
        {
          text: 'レシピ名',
          value: 'name'
        },
        {
          text: '仕上がり時間(分)',
          value: 'time',
          width: '30%'
        },
        {
          text: '操作',
          value: 'edit',
          sortable: false,
          width: '20%'
        }
      ],
      serverDatas: [],
      setID: [],
      setAmount: [],
      ingredients: {},
      categories: [],
      groups: [],
      amounts: [],
      recipe: {
        name: '',
        time: '',
        serve: '',
        cost: '',
        description: '',
        image: '',
        status: '',
        ingredients: [
          {
            name: '',
            trader: '',
            unit: '',
            unit_used: '',
            cost: '',
            budomari: '',
            converted_number: '',
            cost_used: '',
            user_id: '',
            amount: [],
            fil: {
              id: '',
              name: ''
            }
          }
        ],
        detail: [{
          amount: [],
          ingredient_id: ''
        }],
        category: [{
          name: ''
        }]
        },
      required: value => !!value || '必ず入力してください',
    }
  },
  mounted() {
    this.$axios.$get(url_r).then((res) => {
      console.log(res);
      this.serverDatas = res.data;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_i).then((res) => {
      console.log(res);
      this.ingredients = res.data
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_c).then((res) => {
      console.log(res);
      this.categories = res.data
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_g).then((res) => {
      console.log(res);
      this.groups = res.data;
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
    onClickEvent(data) {
      this.showDialog = true,
      this.$axios.$get(url + data.id).then((res) => {
        console.log(res);
        this.recipe = res.data;
        this.showImageUrl = res.data.encode_image
        for (let i in this.recipe.detail) {
          this.amounts.push(this.recipe.detail[i].amount)
        };
      }).catch((error) => {
        console.log(error);
      });
    },
    deleteConfirm(item) {
      this.deleteDialog = true;
      this.deleteName = item.name;
      this.deleteID = item.id;
    },
    deleteItem (deleteID, deleteName) {
    this.$axios.$delete(url + deleteID).then((res) => {
      console.log(res);
        this.$axios.$get(url_r).then((res) => {
        console.log(res);
        this.serverDatas = res.data;
        this.$toasted.success(deleteName + 'を削除しました！');
      }).catch((error) => {
        console.log(error);
      });
      }).catch((error) => {
        console.log(error);
      })
    this.deleteDialog = false;
    },
    editConfirm(item) {
      this.editDialog = true;
      this.editID = item.id;
      this.editName = item.name;
      this.$axios.$get(url + item.id).then((res) => {
        this.recipe = res.data;
        this.selectedImageUrl = res.data.encode_image;
        for (let i in this.recipe.detail) {
          this.amounts.push(this.recipe.detail[i].amount)
        };
        for (let i in this.recipe.detail) {
          this.setAmount.push(this.recipe.detail[i].amount)
        };
        for (let i in this.recipe.ingredients) {
          this.setID.push(this.recipe.ingredients[i].id)
        };
        console.log(this.setAmount)
      }).catch((error) => {
        console.log(error)
      });
    },
    onUpload() {
      this.recipe.image = event.target.files[0];
      let reader = new FileReader()
      reader.readAsDataURL(event.target.files[0]);
      reader.addEventListener('load', () => {
        this.selectedImageUrl = reader.result;
      })
    },
    setI(ri, index) {
      this.setID.splice(index, 1, ri.fil.id);
      ri.unit_used = this.ingredients.find(item => item.id === ri.fil.id).unit_used;
    },
    setA(ri, index) {
      this.setAmount.splice(index, 1, ri.amount);
    },
    selected(ri) {
      ri.fil = this.ingredients.filter(item => item.trader === ri.trader);
    },
    addItems() {
      this.recipe.ingredients.push(this.independentObejct());
    },
    removeItems(target) {
      this.recipe.ingredients.splice(target, 1);
      this.amounts.splice(target, 1);
      this.setID.splice(target, 1);
      this.setAmount.splice(target, 1);
      console.log(this.amounts);
    },
    independentObejct () {
      return {
        id: '',
            name: '',
            trader: '',
            unit: '',
            unit_used: '',
            cost: '',
            budomari: '',
            converted_number: '',
            cost_used: '',
            fil: {
              id: ''
        }
      }
    },
    editRecipe(editID, editName) {
      let formData = new FormData()
      formData.append('name', this.recipe.name);
      formData.append('description', this.recipe.description);
      formData.append('time', this.recipe.time);
      formData.append('serve', this.recipe.serve);
      formData.append('category_id', this.recipe.category.id);
      formData.append('group_id', this.recipe.group_id);
      if (this.recipe.status) {
        formData.append('status', this.recipe.status);
      };
      if (this.recipe.image) {
        formData.append('image', this.recipe.image);
      };
      for (let i = 0; i < this.setID.length && this.setAmount.length; i++) {
        let id = this.setID[i];
        let amount = this.setAmount[i]; 
        formData.append('ingredient_recipes_attributes[][ingredient_id]', id);
        formData.append('ingredient_recipes_attributes[][amount]', amount);
      };
      this.$axios.$put(url + editID, formData).then((res) => {
        console.log(res);
        if (res.status == 'ERROR') {
          this.$toasted.error("入力に誤りがあります")
        } else {
          console.log(res);
          this.$axios.$get(url_r).then((res) => {
            console.log(res)
            this.serverDatas = res.data
            this.$toasted.success(editName + 'を更新しました！');
            this.setID = []
            this.setAmount = []
            this.amounts = []
            this.editDialog = false;
            }).catch((error) => {
            console.log(error);
          });
        }
      }).catch((error) => {
        console.log(error);
        this.$toasted.error('更新できませんでした');
      });
    }
  }
}
</script>

<style lang="scss">
caption, p{
  font-size: 1.3rem;
  line-height: 1;
  text-align: left;
  background-color: rgba(0,0,0,0.5);
  color: #fff;
  padding: 5px;
}
</style>