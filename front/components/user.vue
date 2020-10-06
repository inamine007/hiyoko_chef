<template>
  <v-card outlined align="center">
    <v-avatar size="62" class="mt-14">
      <v-img v-if="selectedImageUrl" :src="selectedImageUrl"></v-img>
    </v-avatar>
    <v-card-text>
      <p class="name">{{ user.name }}</p>
      <v-row wrap class="mb-0 box">
        <v-col cols="4">
          <p class="count">{{ groups_count }}</p>
          <nuxt-link :to="{ name: 'users-id-groups', params: { id: id } }"><p class="contents">グループ</p></nuxt-link>
        </v-col>
        <v-col cols="4">
          <p class="count">{{ followers_count }}</p>
          <nuxt-link :to="{ name: 'users-id-followers', params: { id: id } }"><p class="contents">フォロワー</p></nuxt-link>
        </v-col>
        <v-col cols="4">
          <p class="count">{{ followings_count }}</p>
          <nuxt-link :to="{ name: 'users-id-followings', params: { id: id } }"><p class="contents">お気に入り</p></nuxt-link>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-card-actions>
          <v-btn v-if="followings.includes(Number(id))" class="mb-5" outlined color="indigo" @click="unfollow">フォロー解除</v-btn>
          <v-btn v-else class="mb-5" outlined color="indigo" @click="follow">フォローする</v-btn>
          <v-btn v-if="!roomUser.includes(Number(id))" class="mb-5" outlined color="green" @click="room">メッセージ</v-btn>
        </v-card-actions>
      </v-row>
      <v-divider></v-divider>
      <div class="text">自己紹介</div>
      <p class="introduction">{{ user.introduction }}</p>
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
      groups_count: ''
    }
  },
  mounted() {
    let url = `/users/${this.id}/`;
    let url_g = `groups/${this.id}/owner`;
    this.$axios.$get(url).then((res) => {
      console.log(res);
      this.user = res.data;
      this.selectedImageUrl = res.data.encode_image;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_re).then((res) => {
      for (let i in res.data_followings) {
        this.followings.push(res.data_followings[i].id)
      };
      console.log(this.followings);
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'followings').then((res) => {
      console.log(res);
      this.followings_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'followers').then((res) => {
      console.log(res);
      this.followers_count = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_g).then((res) => {
      console.log(res);
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
        console.log(res);
        this.$axios.$get(url_re).then((res) => {
        for (let i in res.data_followings) {
          this.followings.push(res.data_followings[i].id)
        };
        this.$toasted.success(this.user.name + 'をフォローしました！')
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
        console.log(res);
        this.followings = [];
        this.$toasted.success(this.user.name + 'のフォローを解除しました！')
      }).catch((error) => {
        console.log(res);
      });
    },
    room() {
      this.$axios.$post(url_ro, {
        user_id: this.id
      }).then((res) => {
        console.log(res);
        this.$router.replace({path: `/rooms/${res.data.id}`});
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