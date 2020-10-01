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
            <v-icon>fas fa-user</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>マイページ</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/ingredients">
          <v-list-item-action>
            <v-icon>fas fa-carrot</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>食材</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/recipes">
          <v-list-item-action>
            <v-icon>fas fa-utensils</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>レシピ</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link to="/groups">
          <v-list-item-action>
            <v-icon>fas fa-users</v-icon>
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
    </v-app-bar>
  </div>
</template>

<script>
  export default {
    props: {
      source: String,
    },
    data: () => ({
      drawer: null,
    }),
  }
</script>