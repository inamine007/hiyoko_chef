<template>
  <v-container class="fill-height" fluid>
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="6">
        <v-card class="elevation-12">
          <v-toolbar color="primary" dark flat>
            <v-toolbar-title>登録フォーム</v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-btn :href="googleLoginURL" style="text-transform: none" color="orange darken-2" dark><v-icon dark left>fab fa-google</v-icon>Googleでログイン</v-btn>
            <v-divider class="mt-5"></v-divider>
            または
            <v-form @submit.prevent="signUp">
              <v-text-field
                v-model="name"
                label="名前"
                name="name"
                prepend-icon="mdi-account"
                type="text"
                :rules="[required, name_length]"
                counter="20"
              ></v-text-field>
              <v-text-field
                v-model="email"
                label="メール"
                name="email"
                prepend-icon="mdi-email"
                type="mail"
                :rules="[required]"
              ></v-text-field>
              <v-text-field
                v-model="password"
                id="password"
                label="パスワード"
                name="password"
                prepend-icon="mdi-lock"
                type="password"
                :rules="[required]"
                hint="※6文字以上の半角英数字"
                persistent-hint
              ></v-text-field>
              <v-text-field
                v-model="password_confirmation"
                id="password_confirmation"
                label="パスワード(確認)"
                name="password_confirmation"
                prepend-icon="mdi-lock"
                type="password"
                :rules="[required]"
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
                name="introduction"
                prepend-icon="mdi-text"
                type="text"
                :rules="[introduction_length]"
                counter="70"
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
</template>

<script>
let url = '/auth'
export default {
  props: {
    source: String, 
  },
  auth: false,
  middleware: ['redirect'],
  data() {
    return {
      name: '',
      email: '',
      password: '',
      password_confirmation: '',
      image: '',
      introduction: '',
      google: {
        // url: 'http://localhost:3000/auth/google',
        // redirectUrl: 'http://localhost:8080/omniauth/google/callback'
        url: 'https://back.hiyoko-chef.com:443/auth/google',
        redirectUrl: 'https://hiyoko-chef.com:443/omniauth/google/callback'
      },
      required: value => !!value || '必ず入力してください',
      name_length: value => value.length <= 20 || '20文字以内で入力してください',
      introduction_length: value => value.length <= 70 || '70文字以内で入力してください'
    }
  },
  methods: {
    onUpload() {
      this.image = event.target.files[0];
    },
    async signUp() {
      let formData = new FormData();
      formData.append('user[name]', this.name);
      formData.append('user[email]', this.email);
      formData.append('user[password]', this.password);
      formData.append('user[password_confirmation]', this.password_confirmation);
      formData.append('user[introduction]', this.introduction);
      if (this.image) {
        formData.append('user[image]', this.image);
      };
      await this.$axios.$post(url, formData).then((res) => {
        this.$auth.loginWith('local', {
          data: {
            email: this.email,
            password: this.password
          }
          }).then((res) => {
            this.$toasted.success('登録完了しました！お気に入りのレシピを探してフォローしよう！');
            this.$router.replace({path: '/'});
          }).catch((error) => {
            console.log(error);
            this.$toasted.error('登録できませんでした');
            return error
        });
      })
    }
  },
  computed: {
    googleLoginURL() {
      return `${ this.google.url }?auth_origin_url=${ encodeURI(this.google.redirectUrl) }`
    }
  }
}
</script>