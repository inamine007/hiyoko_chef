<template>
  <div id="app">
    <v-container class="fill-height" fluid>
      <v-row align="center" justify="center">
        <v-col cols="12" sm="8" md="8">
          <v-card class="mt-16">
            <v-card-title>グループ作成</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="createGroup">
                <v-text-field
                  v-model="form.name"
                  label="グループ名"
                  :rules="[required, name_length]"
                  name="name"
                  counter="20"
                ></v-text-field>
                <v-textarea
                  v-model="form.introduction"
                  label="説明文"
                  name="introduction"
                  counter="140"
                  rows="3"
                  :rules="[introduction_length]"
                ></v-textarea>
                <v-text-field
                  v-model.number="form.password"
                  label="パスワード"
                  name="password"
                  type="number"
                  prepend-icon="mdi-lock"
                  @keydown.69.prevent
                  :rules="[required, password_length]"
                  hint="4桁の数字"
                ></v-text-field>
                <v-divider></v-divider>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn type="submit" class="primary">作成</v-btn>
                </v-card-actions>
              </v-form>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
let url = "/groups"
export default {
  data() {
    return {
      form: {
        name: '',
        introduction: '',
        password: '',
      },
      required: value => !!value || '必ず入力してください',
      password_length: value => String(value).length === 4 || '4桁の数字を入力してください',
      introduction_length: value => value.length <= 140 || '140文字以内で入力してください',
      name_length: value => value.length <= 20 || '20文字以内で入力してください'
    }
  },
  methods: {
    async createGroup() {
      await this.$axios.$post(url, this.form)
      .then((res) => {
        console.log(res);
        if (res.status == 'ERROR') {
          var messages = [];
          for (var i=0; i<res.data.length; i++){
            messages.push(res.data[i]);
          }
          var result = messages.join('<br>')
          this.$toasted.error(result)
        } else {
            this.$router.replace({path: '/groups/'});
            this.$toasted.success(this.form.name + 'を作成しました！');
        }
      }).catch((error) => {
        console.log(error);
        this.$toasted.error('作成できませんでした');
        return error
      })
    }
  }
}
</script>