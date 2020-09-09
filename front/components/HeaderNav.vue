<template>
    <v-app-bar
      app
      color="indigo"
      dark
    >
      <v-toolbar-title>Application</v-toolbar-title>
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