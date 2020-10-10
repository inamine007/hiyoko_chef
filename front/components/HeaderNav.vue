<template>
  <v-app-bar app color="green lighten-1" dark>
    <v-toolbar-title><nuxt-link to='/'><img src="@/assets/images/ひよこロゴ2.svg" alt="ひよこシェフ" width="250" height="50"></nuxt-link></v-toolbar-title>
    <v-spacer></v-spacer>
    <v-menu left bottom v-if="$vuetify.breakpoint.xs">
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          icon
          v-bind="attrs"
          v-on="on"
        ><v-icon>mdi-dots-vertical</v-icon>
        </v-btn>
      </template>
      <v-list>
        <v-list-item link to="/">
          <v-list-item-title>ホーム</v-list-item-title>
        </v-list-item>
        <v-list-item link to="/sign_up">
          <v-list-item-title>新規登録</v-list-item-title>
        </v-list-item>
        <v-list-item link to="/login">
          <v-list-item-title>ログイン</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
    <v-toolbar-items v-for="(link, i) in links" :key="i" v-else>
      <v-btn :to="link.to" text class="font-weight-bold">
        {{ link.title }}
      </v-btn>
    </v-toolbar-items>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return{
      links: [
        { title: 'ホーム', to: '/' },
        { title: '新規登録', to: '/sign_up' },
        { title: 'ログイン', to: '/login' }
      ]
    }
  }
}
</script>

<style lang="scss">
a {
  color: #fff;
  text-decoration: none;
}
</style>

