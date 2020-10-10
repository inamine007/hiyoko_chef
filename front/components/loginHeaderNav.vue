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
        <v-list-item @click="roomDialog=true">
          <v-list-item-action>
            <v-icon color="purple">fas fa-location-arrow</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>メッセージ</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar app color="green lighten-1" dark>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title class="pl-0"><nuxt-link to='/'><img src="@/assets/images/ひよこロゴ2.svg" alt="ひよこシェフ" width="250" height="50"></nuxt-link></v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="notificationDialog=true">
        <v-icon small color="yellow" v-if="checked.includes(false)">fas fa-bell</v-icon>
        <v-icon small v-else>fas fa-bell</v-icon>
      </v-btn>
      <v-menu left bottom>
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
          ><v-icon>mdi-dots-vertical</v-icon>
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
      <v-dialog v-model="notificationDialog" persistent max-width="500">
        <v-card class="mx-auto">
          <v-card-actions>
            <v-icon color="red" @click="deleteAll()">fas fa-trash</v-icon>
          </v-card-actions>
          <v-list>
            <v-list-item v-for="(item, index) in notifications" :key="index">
              <v-list-item-content>
                <v-list-item-title class="wrap-text">{{ item.name }}にメッセージが届いています！</v-list-item-title>
                <v-list-item-subtitle v-text="item.created" class="wrap-text"></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="unchecked(), notificationDialog=false">閉じる</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-dialog v-model="roomDialog" persistent>
        <v-card max-width="500" class="mx-auto">
          <v-list>
            <v-list-item v-for="(item, index) in rooms" :key="index" @click="link(item), roomDialog=false">
              <v-list-item-content>
                <v-list-item-title v-text="item.name"></v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="roomDialog=false">閉じる</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-app-bar>
  </div>
</template>

<script>
let url = '/auth/'
let url_r = '/rooms/'
let url_n = '/notifications/'
export default {
  props: {
    source: String,
  },
  data() {
    return {
      drawer: null,
      deleteDialog: false,
      roomDialog: false,
      notificationDialog: false,
      rooms: {},
      notifications: [],
      checked: []
    }
  },
  mounted() {
    this.$axios.$get(url_r).then((res) => {
      console.log(res);
      this.rooms = res.data
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_n).then((res) => {
      for (let i in res.data) {
        this.notifications.push(res.data[i].attributes)
      };
      for (let i in this.notifications) {
        this.checked.push(this.notifications[i].checked)
      }
      console.log(this.checked);
    }).catch((error) => {
      console.log(error);
    });
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
    },
    link(item) {
      this.$router.replace({path: '/rooms/' + item.id});
    },
    deleteAll() {
      this.$axios.$get(url_n + 'destroy_all').then((res) => {
        console.log(res);
        this.notifications = res.data;
      }).catch((error) => {
        console.log(error);
      });
    },
    unchecked() {
      this.$axios.$get(url_n + 'checked').then((res) => {
        this.notifications = [];
        this.checked = [];
        for (let i in res.data) {
        this.notifications.push(res.data[i].attributes)
        };
        for (let i in this.notifications) {
          this.checked.push(this.notifications[i].checked)
        };
        console.log(this.checked)
      }).catch((error) => {
        console.log(error);
      });
    }
  }
}
</script>

<style lang="scss">
$sp: 500px;
@mixin sp {
    @media (max-width: ($sp)) {
        @content;
    }
}

@include sp() {
  img {
    width: 150px;
    height: 50px;
  }
}
</style>