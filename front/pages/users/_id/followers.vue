<template>
  <v-container class="fill-height">
    <v-row>
      <v-col cols="12" md="4">
        <currentUser v-if="userID == id" />
        <user v-else />
      </v-col>
      <v-col cols="12" md="8">
        <v-row justify="center">
          <p class="text mt-5">フォロワー</p>
        </v-row>
        <v-card max-width="500" class="mx-auto">
          <v-list>
            <v-list-item v-for="(item, index) in followers" :key="index" @click="link(item)">
              <v-list-item-avatar>
                <v-img :src="item.image"></v-img>
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title v-text="item.name"></v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
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
      followers: [],
      page: 1,
      length: 0,
      pageSize: 10,
      lists: [],
    }
  },
  mounted() {
    let url = `/users/${this.id}/followers`
    this.$axios.$get(url).then((res) => {
      console.log(res);
      for (let i in res.data) {
        // this.list.push(res.data[i].id);
        this.lists.push(res.data[i].attributes);
      };
      console.log(this.lists);
      this.length = Math.ceil(this.lists.length/this.pageSize);
      this.followers = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
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
      this.$router.replace({path: '/users/' + item.uid + '/chart'});
    }
  }
}
</script>