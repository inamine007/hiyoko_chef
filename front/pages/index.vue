<template>
<div>
    <button @click="logout">ログアウト</button>

      <!-- Base64形式であればimgタグでそのまま読み込みが可能 -->
      <img :src="user" alt="post.image">
  </div>
</template>

<script>
export default {
  auth: false,
  data() {
    return {
      user: {},
    }
  },
  methods: {
    logout() {
      this.$auth.logout();
      this.$toasted.success('ログアウト！')
    }
  },
  // setPost() {
  //   this.$axios.$get('/users', {params: {id: this.user.id}})
  //   .then(response => {
  //     this.user = response.data
  //   })
  //   .catch( error => {
  //     console.error(error)
  //   })
  // }
  asyncData({ $axios, params }) {
    return $axios.$get('/users/57')
      .then((res) => {
        console.log(res);
        return { user: res.data_image }
      })
  }
}
</script>

<style>
.container {
  margin: 0 auto;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family:
    'Quicksand',
    'Source Sans Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    Roboto,
    'Helvetica Neue',
    Arial,
    sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

.subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
}

.links {
  padding-top: 15px;
}
</style>
