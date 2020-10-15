<template>
  <v-container class="fill-height">
    <v-row>
      <v-col cols="12" md="4">
        <currentUser v-if="userID == id" />
        <user v-else />
      </v-col>
      <v-col cols="12" md="8">
        <v-row justify="center">
          <div class="text mt-5">オーナーグループ</div>
        </v-row>
        <v-card max-width="500" class="mx-auto" v-for="(item, index) in groups" :key="index">
          <v-card-title>
            <nuxt-link @click.native="groupConfirm(item)" :to="{ name: 'users-id-groups', params: { id: id } }">{{ item.name }}</nuxt-link>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>{{ item.introduction }}</v-card-text>
        </v-card>
        <v-dialog v-model="addDialog" persistent max-width="640">
          <v-card>
            <v-card-title>参加する</v-card-title>
            <v-card-text>
              <v-form @submit.prevent="addGroup(groupID, groupName)">
                <v-text-field
                  v-model.number="password"
                  label="パスワード"
                  name="password"
                  type="number"
                  prepend-icon="mdi-lock"
                  @keydown.69.prevent
                ></v-text-field>
                <v-divider></v-divider>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="green darken-1" text type="submit">参加する</v-btn>
                  <v-btn color="green darken-1" text @click="addDialog=false">キャンセル</v-btn>
                </v-card-actions>
              </v-form>
            </v-card-text>
          </v-card>
        </v-dialog>
        <v-dialog v-model="removeDialog" persistent max-width="640">
        <v-card>
          <v-card-title>現在参加中です</v-card-title>
          <v-card-text>
            <v-divider></v-divider>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" text @click="link()">グループページにいく</v-btn>
                <v-btn color="green darken-1" text @click="removeDialog=false">キャンセル</v-btn>
              </v-card-actions>
            </v-card-text>
          </v-card>
        </v-dialog>
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
let url ="groups/new/add_user"
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
      addDialog: false,
      removeDialog: false,
      groupID: '',
      groupName: '',
      password: '',
      groups: {},
      member_id: [],
      page: 1,
      length: 0,
      pageSize: 10,
      lists: [],
    }
  },
  mounted() {
    let url = `/groups/${this.id}/owner`
    this.$axios.$get(url).then((res) => {
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
    groupConfirm(item) {
      let url = `groups/${item.id}`
      this.$axios.$get(url).then((res) => {
        for (let i in res.data_members) {
        this.member_id.push(res.data_members[i].id);
      };
      if (this.member_id.includes(Number(this.userID))) {
        this.removeDialog = true;
      } else {
        this.addDialog = true;
      };
      }).catch((error) => {
        console.log(error);
      });
      this.groupID = item.id;
      this.groupName = item.name;
    },
    addGroup(groupID) {
      this.$axios.$post(url, {
        id: groupID,
        password: this.password
      }).then ((res) => {
        if (res.status == 'ERROR') {
          this.$toasted.error('参加できませんでした');
        } else {
          this.$router.push({path: '/groups/'});
          this.$toasted.success(this.groupName + 'に参加しました!');
        };
      }).catch((error) => {
        console.log(error);
      });
    },
    link() {
      this.$router.push({path: `/groups/${this.groupID}`});
    }
  }
}
</script>