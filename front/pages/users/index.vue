<template>
  <v-container class="fill-height">
    <v-row justify="center">
      <v-col cols="12" md="8" sm="8">
        <div class="text mt-5">ユーザー一覧</div>
        <v-form @submit.prevent="searchUser">
          <v-text-field
            solo
            v-model="search"
            label="検索"
            prepend-inner-icon="fas fa-search"
            hide-details="auto"
          ></v-text-field>
          <v-row>
            <v-col class="text-right">
              <v-btn type="submit" class="success">検索</v-btn>
            </v-col>
          </v-row>
        </v-form>
        <v-card max-width="500" class="mx-auto">
          <v-list>
            <v-list-item v-for="(item, index) in users" :key="index" @click="link(item)">
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
let url = '/users'
export default {
  data() {
    return {
      id: this.$route.params.id,
      userID: this.$auth.user.data.id,
      users: {},
      search: '',
      page: 1,
      length: 0,
      pageSize: 20,
      lists: [],
    }
  },
  mounted() {
    this.$axios.$get(url).then((res) => {
      console.log(res);
      for (let i in res.data) {
        this.lists.push(res.data[i].attributes);
      };
      console.log(this.lists);
      this.length = Math.ceil(this.lists.length/this.pageSize);
      this.users = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
    pageChange(pageNumber) {
      this.users = this.lists.slice(this.pageSize * (pageNumber - 1),
      this.pageSize * (pageNumber));
      },
    searchUser() {
      this.$axios.$get(url, {
        params: {name: this.search}
      }).then((res) => {
        this.lists = [];
        for (let i in res.data) {
          this.lists.push(res.data[i].attributes)
        };
        this.length = Math.ceil(this.lists.length/this.pageSize);
        this.users = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
      }).catch((error) => {
        console.log(error);
      });
    },
    link(item) {
      this.$router.replace({path: '/users/' + item.uid + '/chart'});
    }
  }
}
</script>