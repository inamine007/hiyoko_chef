<template>
  <v-container class="fill-height">
    <v-row>
      <v-col cols="12" md="4">
        <currentUser v-if="userID == id" />
        <user v-else />
      </v-col>
      <v-col cols="12" md="8">
        <v-row justify="center">
          <p class="text mt-5">オーナーグループ</p>
        </v-row>
        <v-card max-width="500" class="mx-auto" v-for="(item, index) in groups" :key="index">
        <v-card-title><nuxt-link to="#">{{ item.name }}</nuxt-link></v-card-title>
          <v-divider></v-divider>
          <v-card-text>{{ item.introduction }}</v-card-text>
        </v-card>
        <v-pagination
          v-model="page"
          :length="length"
          @input = "pageChange"
        ></v-pagination>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import User from "~/components/user.vue";
import CurrentUser from "~/components/currentUser.vue";
export default {
  components: {
    User,
    CurrentUser
  },
  data() {
    return {
      id: this.$route.params.id,
      userID: this.$auth.user.data.id,
      groups: {},
      page: 1,
      length: 0,
      pageSize: 10,
      lists: [],
    }
  },
  mounted() {
    let url = `/groups/${this.id}/owner`
    this.$axios.$get(url).then((res) => {
      console.log(res);
      this.lists = res.data;
      this.length = Math.ceil(this.lists.length/this.pageSize);
      this.groups = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
  pageChange(pageNumber) {
    this.followers = this.lists.slice(this.pageSize * (pageNumber - 1),
    this.pageSize * (pageNumber));
    },
    link(item) {
      this.$router.replace({path: '/users/' + item.id + '/chart'});
    }
  }
}
</script>