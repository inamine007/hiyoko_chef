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
                <v-toolbar-title>ログインフォーム</v-toolbar-title>
              </v-toolbar>
              <v-card-text>
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
                <v-spacer></v-spacer>
                <v-btn type="submit" color="primary">ログイン</v-btn>
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
  export default {
    props: {
      source: String,
    },
    auth: false,
    data() {
        return {
            email: '',
            password: ''
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
        }
    }
  }
</script>