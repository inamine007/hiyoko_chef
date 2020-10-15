<template>
  <v-card outlined align="center">
    <v-avatar size="62" class="mt-14">
      <v-img v-if="selectedImageUrl" :src="selectedImageUrl"></v-img>
    </v-avatar>
    <v-card-text>
      <div class="name">{{ user.name }}</div>
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
          <v-btn v-if="followings.includes(Number(id))" class="mb-5" outlined color="indigo" @click="unfollow">フォロー解除</v-btn>
          <v-btn v-else class="mb-5" outlined color="indigo" @click="follow">フォローする</v-btn>
          <v-btn v-if="!roomUser.includes(Number(id))" class="mb-5" outlined color="green" @click="roomDialog=true">メッセージ</v-btn>
        </v-card-actions>
      </v-row>
      <v-dialog v-model="roomDialog" persistent max-width="640">
        <v-card>
          <v-card-title>ルーム作成</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="room()">
              <v-text-field
                v-model="room_name"
                label="ルーム名"
                name="room"
                counter="20"
                :rules="[required, name_length]"
              ></v-text-field>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" text type="submit">作成</v-btn>
                <v-btn color="green darken-1" text @click="roomDialog=false">キャンセル</v-btn>
              </v-card-actions>
            </v-form>
          </v-card-text>
        </v-card>
      </v-dialog>
      <v-divider></v-divider>
      <div class="text">自己紹介</div>
      <div class="introduction">{{ user.introduction }}</div>
    </v-card-text>
  </v-card>
</template>

<script>
let url_re = "/relationships"
let url_ro = "/rooms"
export default {
  data() {
    return {
      id: this.$route.params.id,
      user: {},
      roomUser: [],
      followings: [],
      selectedImageUrl: null,
      followings_count: '',
      followers_count: '',
      groups_count: '',
      roomDialog: false,
      room_name: '',
      required: value => !!value || '必ず入力してください',
      name_length: value => value.length <= 20 || '20文字以内で入力してください',
    }
  },
  mounted() {
    let url = `/users/${this.id}/`;
    let url_g = `groups/${this.id}/owner`;
    this.$axios.$get(url).then((res) => {
      this.user = res.data;
      this.selectedImageUrl = res.data.encode_image;
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
    this.$axios.$get(url + 'followings').then((res) => {
      this.followings_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'followers').then((res) => {
      this.followers_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_g).then((res) => {
      this.groups_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_ro).then((res) => {
      for (let i in res.data) {
        this.roomUser.push(res.data[i].user_id)
      };
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
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
        console.log(res);
      });
    },
    room() {
      this.$axios.$post(url_ro, {
        user_id: this.id,
        name: this.room_name
      }).then((res) => {
        if ( this.room_name) {
          this.$router.replace({path: `/rooms/${res.data.id}`});
        } else {
          this.$toasted.error('ルーム名を記入してください');
        }
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