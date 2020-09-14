<template>
  <v-container
    class="fill-height"
    fluid
  >
    <v-row
      align="center"
      justify="center"
    >
      <v-col
        cols="12"
        sm="8"
        md="4"
      >
        <v-card class="elevation-12">
          <v-toolbar
            color="primary"
            dark
            flat
          >
            <v-toolbar-title>ログインフォーム</v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-btn :href="googleLoginURL" style="text-transform: none" color="orange darken-2" dark><v-icon dark left>fab fa-google</v-icon>Googleでログイン</v-btn>
            <v-divider class="mt-5"></v-divider>
            または
            <v-form @submit.prevent="loginUser">
              <v-text-field
                v-model="email"
                label="メール"
                name="email"
                prepend-icon="mdi-email"
                type="mail"
              ></v-text-field>

              <v-text-field
                v-model="password"
                id="password"
                label="パスワード"
                name="password"
                prepend-icon="mdi-lock"
                type="password"
              ></v-text-field>
              <v-card-actions>
                <v-btn type="submit" color="primary">ログイン</v-btn>
              </v-card-actions>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  export default {
    props: {
      source: String,
    },
    auth: false,
    middleware: ['redirect'],
    data() {
      return {
        email: '',
        password: '',
        google: {
          url: 'http://localhost:3000/auth/google',
          redirectUrl: 'http://localhost:8080/oauth/google/callback'
        }
      }
    },
    methods: {
      async loginUser() {
        await this.$auth.loginWith('local', {
          data: {
            email: this.email,
            password: this.password
          }
          }).then((res) => {
            this.$router.replace({path: '/'});
            this.$toasted.success('ログインしました！');
            return res
          }).catch((error) => {
            this.$toasted.error('ログインできませんでした');
            return error
        });
      },
    },
    computed: {
      googleLoginURL() {
        return `${ this.google.url }?auth_origin_url=${ encodeURI(this.google.redirectUrl) }`
      }
    }
  }
</script>