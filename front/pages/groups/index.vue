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
          <v-btn absolute dark right bottom fab color="pink" to="/groups/new" nuxt><v-icon>mdi-plus</v-icon></v-btn>
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
        :headers-length=1
      >
        <template v-slot:[`item.edit`]="{item}">
          <v-icon v-if="$auth.user.data.id == item.owner_id" @click.stop="editConfirm(item)">fas fa-edit</v-icon>
          <v-icon v-if="$auth.user.data.id == item.owner_id" @click.stop="deleteConfirm(item)">fas fa-trash</v-icon>
          <v-icon v-else @click.stop="removeConfirm(item)">fas fa-sign-out-alt</v-icon>
        </template>
      </v-data-table>
      
      <v-dialog v-model="showDialog" persistent max-width="640">
        <v-card>
          <v-card-title>{{ form.name }}<v-spacer></v-spacer><v-icon class="mr-2">fas fa-users</v-icon>{{ member_count }}</v-card-title>
          <v-card-text>
            <v-form :readonly=true>
              <v-textarea
                v-model="form.introduction"
                label="説明文"
              >
              </v-textarea>
              <v-list>
                <v-list-item v-for="item in members" :key="item.id">
                  <v-list-item-content>
                    <v-list-item-title v-text="item.name"></v-list-item-title>
                  </v-list-item-content>
                  <!-- <v-list-item-avatar>
                    <v-img :src="item.avatar"></v-img>
                  </v-list-item-avatar> -->
                </v-list-item>
              </v-list>
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
            <v-card-title>グループ編集</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="editGroup(editID, editName)">
                <v-text-field
                  v-model="form.name"
                  label="グループ名"
                  :rules="[required, name_length]"
                  name="name"
                >
                </v-text-field>
                <v-textarea
                  v-model="form.introduction"
                  label="説明文"
                  name="introduction"
                  counter="140"
                  rows="3"
                  :rules="[introduction_length]"
                >
                </v-textarea>
                <v-text-field
                  v-model.number="form.password"
                  label="パスワード"
                  name="password"
                  type="number"
                  prepend-icon="mdi-lock"
                  @keydown.69.prevent
                  :rules="[required, password_length]"
                  hint="4桁の数字"
                >
                </v-text-field>
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
      <v-dialog v-model="removeDialog" persistent max-width="320">
        <v-card>
          <v-card-title>退会確認</v-card-title>
          <v-card-text>{{ removeName }}を退会してもよろしいですか？</v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="removeItem(removeID, removeName)">退会</v-btn>
            <v-btn color="green darken-1" text @click="removeDialog=false">キャンセル</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-col>
  </v-row>
</template>

<script>
let url = "/groups/"
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
      removeDialog: false,
      removeName: null,
      removeID: null,
      search: '',
      member_count: '',
      members: '',
      headers: [
        {
          text: 'グループ名',
          value: 'name',
        },
        {
          text: '操作',
          value: 'edit',
          width: '10%',
          sortable: false

        }
      ],
      serverDatas: [],
      form: {
        name: '',
        introduction: '',
        password: '',
      },
      required: value => !!value || '必ず入力してください',
      password_length: value => String(value).length === 4 || '4桁の数字を入力してください',
      introduction_length: value => value.length <= 140 || '140文字以内で入力してください',
      name_length: value => value.length <= 20 || '20文字以内で入力してください'
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
        this.member_count = res.data_count;
        this.members = res.data_members;
      }).catch((error) => {
        console.log(error);
      });
    },
    deleteConfirm(item) {
      this.deleteDialog = true;
      this.deleteName = item.name;
      this.deleteID = item.id;
    },
    deleteItem(deleteID, deleteName) {
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
      })
    },
    editGroup(editID, editName) {
      this.$axios.$put(url + editID, this.form).then((res) => {
        console.log(res);
        this.$axios.$get(url).then((res) => {
        console.log(res)
        this.serverDatas = res.data
        this.$toasted.success(editName + 'を更新しました！');
      }).catch((error) => {
        console.log(error);
      });
      }).catch((error) => {
        console.log(error);
        this.$toasted.error('更新できませんでした！');
      })
    this.editDialog = false;
    },
    removeConfirm(item) {
      this.removeDialog = true;
      this.removeName = item.name;
      this.removeID = item.id;
    },
    removeItem(removeID, removeName) {
    this.$axios.$post(url + removeID + '/remove_user').then((res) => {
      console.log(res);
        this.$axios.$get(url).then((res) => {
        console.log(res)
        this.serverDatas = res.data
        this.$toasted.success(removeName + 'を退会しました！');
      }).catch((error) => {
        console.log(error);
      });
      }).catch((error) => {
        console.log(error);
      })
    this.removeDialog = false;
    },
  }
}
</script>

<style lang="scss">

.v-data-table {
  table-layout: fixed;
  td {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
   }
} 
</style>