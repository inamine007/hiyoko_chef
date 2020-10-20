<template>
  <v-card outlined align="center">
    <v-avatar size="62" class="mt-14">
      <v-img v-if="selectedImageUrl" :src="selectedImageUrl"></v-img>
    </v-avatar>
    <v-card-text>
      <div class="name">{{ user.name }}</div>
      <div class="email">{{ user.email }}</div>
      <v-row wrap class="mb-0 box">
        <v-col cols="4">
          <div class="count">{{ groups_count }}</div>
          <nuxt-link :to="{ name: 'users-id-groups', params: { id: id } }"><div class="contents">グループ</div></nuxt-link>
        </v-col>
        <v-col cols="4">
          <div class="count">{{ followers_count }}</div>
          <nuxt-link :to="{ name: 'users-id-followers', params: { id: id } }"><div class="contents">フォロワー</div></nuxt-link>
        </v-col>
        <v-col cols="4">
          <div class="count">{{ followings_count }}</div>
          <nuxt-link :to="{ name: 'users-id-followings', params: { id: id } }"><div class="contents">お気に入り</div></nuxt-link>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-card-actions>
          <v-btn class="mb-5" outlined color="indigo" @click="editDialog=true">編集する</v-btn>
        </v-card-actions>
      </v-row>
      <v-divider></v-divider>
      <div class="text">自己紹介</div>
      <div class="introduction">{{ user.introduction }}</div>
    </v-card-text>
    <v-dialog v-model="editDialog" persistent max-width="640">
      <v-card>
        <v-card-title>プロフィール編集</v-card-title>
        <v-card-text>
          <v-form @submit.prevent="editUser()">
            <v-text-field
              v-if="provider == 'google'"
              v-model="user.nickname"
              label="名前"
              :rules="[required, name_length]"
              name="nickame"
              counter="20"
            ></v-text-field>
            <v-text-field
              v-else
              v-model="user.name"
              label="名前"
              :rules="[required, name_length]"
              name="name"
              counter="20"
            ></v-text-field>
            <v-text-field
              v-model="user.email"
              label="メールアドレス"
              name="email"
              :rules="[required]"
            ></v-text-field>
            <v-row justify="center">
              <v-img v-if="selectedImageUrl" :src="selectedImageUrl" max-width="300" max-height="300"></v-img>
            </v-row>
            <v-file-input
              accept="image/*"
              label="画像または動画"
              name="image"
              @change="onUpload()"
              ref="file"
              :dense="true"
              :clearable="false"
            ></v-file-input>
            <v-textarea
              v-model="user.introduction"
              label="自己紹介"
              name="introduction"
              counter="70"
              rows="3"
              :rules="[introduction_length]"
            ></v-textarea>
            <v-divider></v-divider>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="green darken-1" text type="submit">更新</v-btn>
              <v-btn color="green darken-1" text @click="editCancel()">キャンセル</v-btn>
            </v-card-actions>
          </v-form>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<script>
let url_re = "/relationships"
let url = "/users/whoami"
let url_e = "/auth/"
let url_gs = "/groups"
let url_r = "/recipes"
export default {
  data() {
    return {
      id: this.$auth.user.data.id,
      provider: this.$auth.user.data.provider,
      user: {},
      followings: [],
      selectedImageUrl: null,
      followings_count: '',
      followers_count: '',
      groups_count: '',
      editDialog: false,
      required: value => !!value || '必ず入力してください',
      introduction_length: value => value.length <= 70 || '70文字以内で入力してください',
      name_length: value => value.length <= 20 || '20文字以内で入力してください'
    }
  },
  mounted() {
    this.$axios.$get(url).then((res) => {
      this.user = res.data;
      this.selectedImageUrl = res.data.encode_image;
    }).catch((error) => {
      console.log(error);
    });
    let url_g = `groups/${this.id}/owner`;
    let url_fi = `users/${this.id}/followings`;
    let url_fe = `users/${this.id}/followers`;
    this.$axios.$get(url_gs).then((res) => {
      this.groups = res.data;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_re).then((res) => {
      for (let i in res.data_followings) {
        this.followings.push(res.data_followings[i].id);
      };
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_fi).then((res) => {
      this.followings_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_fe).then((res) => {
      this.followers_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_g).then((res) => {
      this.groups_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
    onUpload() {
      this.user.image = event.target.files[0];
      let reader = new FileReader()
      reader.readAsDataURL(event.target.files[0]);
      reader.addEventListener('load', () => {
        this.selectedImageUrl = reader.result;
      })
    },
    editCancel() {
      this.$axios.$get(url).then((res) => {
      this.user = res.data;
      this.editDialog = false;
      }).catch((error) => {
        console.log(error);
      });
    },
    editUser() {
      let formData = new FormData();
      formData.append('name', this.user.name);
      if (this.user.nickname) {
        formData.append('name', this.user.nickname);
        formData.append('nickname', this.user.nickname);
      }
      formData.append('email', this.user.email);
      formData.append('introduction', this.user.introduction);
      if (this.user.image) {
        formData.append('image', this.user.image);
      };
      this.$axios.$put(url_e, formData).then((res) => {
        if (res.status == 'ERROR') {
          this.$toasted.error("入力に誤りがあります");
        } else {
          this.$axios.$get(url).then((res) => {
          this.user = res.data;
          this.editDialog = false;
          this.$toasted.success('プロフィールを更新しました！');
          }).catch((error) => {
          console.log(error);
        });
      }
      }).catch((error) => {
        console.log(error);
        this.$toasted.error('更新できませんでした');
      })
    },
    follow() {
      let url_ur =`/users/${this.id}/relationships`
      this.$axios.$post(url_ur).then((res) => {
        this.$axios.$get(url_re).then((res) => {
        for (let i in res.data_followings) {
          this.followings.push(res.data_followings[i].id);
        };
        this.$toasted.success(this.user.name + 'をフォローしました！');
      }).catch((error) => {
        console.log(error);
      });
      }).catch((error) => {
        console.log(res);
      });
    },
    unfollow() {
      let url_ur =`/users/${this.id}/relationships`
      this.$axios.$delete(url_ur).then((res) => {
        this.followings = [];
        this.$toasted.success(this.user.name + 'のフォローを解除しました！');
      }).catch((error) => {
        console.log(error);
      });
    }
  }
}
</script>

<style lang="scss">
p {
  font-size: 1rem;
}
.name {
  font-weight: bold;
  color: #000;
  font-size: 1.5rem;
}
.introduction {
  white-space: pre-wrap;
  word-wrap: break-word;
  text-align: left;
}
.v-application {
  .box {
    p {
      margin-bottom: 0;
    }
    .count {
      color: #000;
    }
    .contents {
      font-size: 0.8rem;
    }
  }
}
.text {
  font-size: 1.5rem;
  color: #000;
  margin: 10px 0;
}
</style>