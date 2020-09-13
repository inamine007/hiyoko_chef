<template>
  <v-container>
    <div class="top-title">
      <h1>
        There is no love sincerer than the love of food.
      </h1>
      <p>ひよこChefは創造的なレシピをシェアする主要なネットワークであり、あなたの料理ライフをサポートします。</p>
      <v-btn color="warning" dark large to="/sign_up">新規登録</v-btn>
      <button @click="logout">ログアウト</button>
    </div>
  </v-container>
</template>

<script>
export default {
  methods: {
    logout() {
      this.$auth.logout();
      this.$toasted.success('ログアウトしました!');
    }
  }
}
</script>

<style lang="scss">
.top-title {
  text-align: center;
  font-size: 1.2rem;
  margin: 130px;
  p {
    font-size: 0.8rem;
  }
}
</style>

