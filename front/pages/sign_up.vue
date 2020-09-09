<template>
  <v-main>
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
              <v-toolbar-title>登録フォーム</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-form @submit.prevent="signUp">
                <v-text-field
                  v-model="name"
                  label="名前"
                  name="name"
                  prepend-icon="mdi-account"
                  type="text"
                ></v-text-field>
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
                  <v-text-field
                    v-model="password_confirmation"
                    id="password_confirmation"
                    label="パスワード(確認)"
                    name="password_confirmation"
                    prepend-icon="mdi-lock"
                    type="password"
                  ></v-text-field>
                  <v-file-input
                    accept="image/*"
                    label="アイコン"
                    name="image"
                    prepend-icon="mdi-camera"
                    @change="onUpload()"
                    ref="file"
                  ></v-file-input>
                  <v-textarea
                    v-model="introduction"
                    rows="2"
                    label="自己紹介"
                    name="password_confirmation"
                    prepend-icon="mdi-text"
                    type="text"
                  ></v-textarea>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn type="submit" color="primary">登録</v-btn>
                </v-card-actions>
              </v-form>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </v-main>
</template>

<script>
let url = '/auth'
export default {
  props: {
    source: String, 
  },
  auth: false,
  data() {
    return {
      name: '',
      email: '',
      password: '',
      password_confirmation: '',
      image: '',
      introduction: '',
      }
  },
  methods: {
    onUpload() {
      this.image = event.target.files[0];
    },
    async signUp() {
      let formData = new FormData()
      formData.append('user[name]', this.name)
      formData.append('user[email]', this.email)
      formData.append('user[password]', this.password)
      formData.append('user[password_confirmation]', this.password_confirmation)
      formData.append('user[introduction]', this.introduction)
      formData.append('user[image]', this.image)
      await this.$axios.$post(url, formData).then((res) => {
        console.log(res);
        this.$auth.loginWith('local', {
          data: {
            email: this.email,
            password: this.password
          }
          }).then((res) => {
            console.log(res);
            this.$toasted.success('登録完了しました！')
            this.$router.replace({path: '/'});
          }).catch((error) => {
            console.log(error);
            this.$toasted.error('登録できませんでした')
            return error
        });
      })
    }
  }
}
</script>