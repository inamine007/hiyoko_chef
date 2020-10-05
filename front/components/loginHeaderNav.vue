<template>
  <div>
    <v-navigation-drawer v-model="drawer" app>
      <v-list dense>
        <v-list-item link to="/">
          <v-list-item-action>
            <v-icon>mdi-home</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>ホーム</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/users/mypage">
          <v-list-item-action>
            <v-icon color="red">far fa-user-circle</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>マイページ</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/users/">
          <v-list-item-action>
            <v-icon color="pink">fas fa-user</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>ユーザー一覧</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/recipes/search">
          <v-list-item-action>
            <v-icon color="green">fas fa-search</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>検索</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/ingredients">
          <v-list-item-action>
            <v-icon color="orange">fas fa-carrot</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>食材</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/recipes">
          <v-list-item-action>
            <v-icon color="black">fas fa-utensils</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>レシピ</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/groups">
          <v-list-item-action>
            <v-icon color="blue">fas fa-users</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>グループ</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar app color="indigo" dark>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title><nuxt-link to='/'><img src="@/assets/images/ひよこロゴ.svg" alt="ひよこシェフ" width="250" height="200"></nuxt-link></v-toolbar-title>
      <v-spacer></v-spacer>
      <v-menu left bottom>
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
          ><v-icon large>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item @click="logout">
            <v-list-item-title>ログアウト</v-list-item-title>
          </v-list-item>
          <v-divider></v-divider>
          <v-list-item @click="deleteDialog=true">
            <v-list-item-title style="color: red;">退会</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-dialog v-model="deleteDialog" persistent max-width="480">
        <v-card>
          <v-card-title>退会確認</v-card-title>
          <v-card-text>退会すると作成した全てのデータは削除されます。退会しますか？</v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="deleteItem()">退会</v-btn>
            <v-btn color="green darken-1" text @click="deleteDialog=false">キャンセル</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-app-bar>
  </div>
</template>

<script>
let url = '/auth/'
export default {
  props: {
    source: String,
  },
  data() {
    return {
      drawer: null,
      deleteDialog: false
    }
  },      
  methods: {
    logout() {
      this.$auth.logout();
      this.$toasted.success('ログアウトしました!');
    },
    deleteItem() {
      this.$axios.$delete(url).then((res) => {
        console.log(res);
        this.$auth.logout();
        // this.$router.replace({path: '/'});
        this.$toasted.success('アカウントを削除しました。ご利用ありがとうございました！');
      }).catch((error) => {
        console.log(error);
      });
    }
  }
}
</script>