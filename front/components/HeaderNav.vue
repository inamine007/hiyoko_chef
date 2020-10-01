<template>
    <v-app-bar
      app
      color="indigo"
      dark
    >
      <v-toolbar-title><nuxt-link to='/'><img src="@/assets/images/ひよこロゴ.png" alt="ひよこシェフ" width="250" height="200"></nuxt-link></v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items
        v-for="(link, i) in links"
        :key="i"
      >
        <v-btn
          :to="link.to"
          text
          class="font-weight-bold"
        >
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

