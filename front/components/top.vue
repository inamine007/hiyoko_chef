<template>
  <v-container class="fill-height">
    <div class="top-title">
      <h1>
        There is no love sincerer than the love of food.
      </h1>
      <div class="sub">ひよこChefは創造的なレシピをシェアする主要なネットワークであり、あなたの料理ライフをサポートします。</div>
      <v-btn color="warning" dark large to="/sign_up">新規登録</v-btn>
      <figure><img src="@/assets/images/ひよこex.png" width="480" height="210"></figure>
    </div>
  </v-container>
</template>

<script>
export default {
  auth: false,
}
</script>

<style lang="scss">
$mp: 760px;
@mixin mp {
    @media (max-width: ($mp)) {
        @content;
    }
}
$sp: 500px;
@mixin sp {
    @media (max-width: ($sp)) {
        @content;
    }
}
.top-title {
  text-align: center;
  font-size: 1.2rem;
  color: #499149;
  margin: 0 auto;
  @include mp() {
    font-size: 0.8rem;
    img {
      width: 380px;
      height: 150px;
    }
    @include sp() {
      img {
        width: 240px;
        height: 100px;
      }
    }
  }
  .sub {
    font-size: 0.8rem;
    color: black;
    margin-bottom: 5px;
  }
}
</style>