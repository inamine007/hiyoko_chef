<template>
  <v-row align="center" justify="center">
    <v-col cols="12" sm="8" md="8">
      <v-card flat class="mt-16" style="position: relative">
        <v-btn absolute dark right bottom fab color="pink" to="/ingredients/new" nuxt><v-icon>mdi-plus</v-icon></v-btn>
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
        <v-card>
          <v-card-title>{{ form.name }}</v-card-title>
          <v-card-text>
            <v-form :readonly=true>
              <v-text-field
                v-model="form.trader"
                label="仕入れ先または店名"
              ></v-text-field>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model.number="form.cost"
                    label="価格"
                    suffix="円"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model.number="form.cost_used"
                    label="使用原価"
                    suffix="円"
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model="form.unit"
                    label="仕入れ単位"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model="form.unit_used"
                    label="使用単位"
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model.number="form.budomari"
                    label="歩留まり"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    v-model.number="form.converted_number"
                    label="換算数"
                  ></v-text-field>
                </v-col>
              </v-row>
              <div class="date">作成:{{ form.created }}</div>
              <div class="date">更新:{{ form.updated }}</div>
              <v-divider></v-divider>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" text @click="showDialog=false">閉じる</v-btn>
              </v-card-actions>
            </v-form>
          </v-card-text>
        </v-card>
      </v-dialog>
      <v-dialog v-model="editDialog" persistent max-width="640">
        <v-card>
          <v-card-title>食材登録</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="editIngredient(editID, editName)">
              <v-text-field
                v-model="form.name"
                label="食材名"
                :rules="[required]"
                name="name"
              ></v-text-field>
              <v-text-field
                v-model="form.trader"
                label="仕入れ先または店名"
                :rules="[required]"
                name="trader"
              ></v-text-field>
              <v-text-field
                v-model.number="form.cost"
                label="価格"
                name="cost"
                suffix="円"
                type="number"
                @keydown.69.prevent
                :rules="[required]"
              ></v-text-field>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-select
                    v-model="form.unit"
                    :items="items"
                    label="仕入れ単位"
                    name="unit"
                  ></v-select>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-select
                    v-model="form.unit_used"
                    label="使用単位"
                    :items="items"
                    name="unit_used"
                  ></v-select>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-select
                    v-model.number="form.budomari"
                    label="歩留まり"
                    :items="items2"
                    name="budomari"
                  ></v-select>
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
                  ></v-select>
                </v-col>
              </v-row>
              <v-divider></v-divider>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" text type="submit">更新</v-btn>
                <v-btn color="green darken-1" text @click="editDialog=false">キャンセル</v-btn>
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
let url = "/ingredients/"
export default {
  data() {
    return {
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
          text: '食材名',
          value: 'name'
        },
        {
          text: '仕入れ先',
          value: 'trader'
        },
        {
          text: '操作',
          value: 'edit',
          sortable: false
        }
      ],
      serverDatas: [],
      form: {
        name: '',
        trader: '',
        unit: '',
        unit_used: '',
        cost: '',
        budomari: '',
        converted_number: '',
        cost_used: ''
      },
      required: value => !!value || '必ず入力してください',
      items: ['Kg', 'L', '個', '本', '100g', '袋', '100ml', 'g', 'ml'],
      items2: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
      items3: [0.001, 0.01, 0.1, 1]
    }
  },
  mounted() {
    this.$axios.$get(url).then((res) => {
      console.log(res)
      this.serverDatas = res.data
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
    onClickEvent(data) {
      this.showDialog = true,
      this.$axios.$get(url + data.id).then((res) => {
        console.log(res);
        this.form = res.data;
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
        this.$axios.$get(url).then((res) => {
        console.log(res)
        this.serverDatas = res.data
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
        console.log(res);
        this.form = res.data;
        this.form.budomari = Number(res.data.budomari);
        this.form.converted_number = Number(res.data.converted_number);
      })
    },
    editIngredient(editID, editName) {
      this.$axios.$put(url + editID, this.form).then((res) => {
        if (res.status == 'ERROR') {
          this.$toasted.error("入力に誤りがあります")
        } else {
          console.log(res);
          this.$axios.$get(url).then((res) => {
          console.log(res)
          this.serverDatas = res.data
          this.editDialog = false;
          this.$toasted.success(editName + 'を更新しました！');
          }).catch((error) => {
          console.log(error);
        });
      }
      }).catch((error) => {
        console.log(error);
        this.$toasted.error('更新できませんでした');
      })
    }
  }
}
</script>