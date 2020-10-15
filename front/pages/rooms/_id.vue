<template>
  <v-container>
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="8">
        <v-form @submit.prevent="createMessage">
          <v-text-field
            v-model="message"
            label="メッセージ"
            name="message"
            hide-details="auto"
            solo
          ></v-text-field>
          <v-row>
            <v-col class="text-right">
              <v-btn type="submit" class="success">送信</v-btn>
            </v-col>
          </v-row>
        </v-form>
        <v-card class="mx-auto">
          <v-card-text>
            <v-list id="scroll">
              <v-list-item v-for="(item, index) in messages" :key="index" class="mb-8">
                <v-list-item v-if="item.uid == userID" style="background-color: #a6ce39; border-radius: 5px;">
                  <v-list-item-content>
                    <v-list-item-title v-text="item.content" class="wrap-text"></v-list-item-title>
                    <v-list-item-subtitle v-text="item.created" class="wrap-text"></v-list-item-subtitle>
                  </v-list-item-content>
                  <v-list-item-avatar>
                    <v-img :src="item.image"></v-img>
                  </v-list-item-avatar>
                </v-list-item>
                <v-list-item v-else style="border: 1px solid #ddd; border-radius: 5px;">
                  <v-list-item-avatar>
                    <v-img :src="item.image"></v-img>
                  </v-list-item-avatar>
                  <v-list-item-content>
                    <v-list-item-title v-text="item.content" class="wrap-text"></v-list-item-title>
                    <v-list-item-subtitle v-text="item.created" class="wrap-text"></v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
        <v-row>
          <v-col class="text-right">
            <v-btn @click="deleteDialog=true" text color="red">ルームを削除する</v-btn>
          </v-col>
        </v-row>
        <v-dialog v-model="deleteDialog" persistent max-width="320">
        <v-card>
          <v-card-title>削除確認</v-card-title>
          <v-card-text>ルームを削除してもよろしいですか？</v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="deleteRoom">削除</v-btn>
            <v-btn color="green darken-1" text @click="deleteDialog=false">キャンセル</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  middleware: 'disable-direct-access',
  data() {
    return {
      id: this.$route.params.id,
      userID: this.$auth.user.data.id,
      deleteDialog: false,
      messages: [],
      message: '',
    }
  },
  mounted() {
    let url = `rooms/${this.id}/`;
    this.$axios.$get(url + 'messages').then((res) => {
      for (let i in res.data) {
        this.messages.push(res.data[i].attributes);
      };
    }).catch((error) => {
      console.log(error);
    });
  },
  updated() {
    this.scrollToEnd();
  },
  methods: {
    scrollToEnd() {
      var container = this.$el.querySelector("#scroll");
      container.scrollTop = container.scrollHeight;
    },
    createMessage() {
      let url = `rooms/${this.id}/messages`;
      this.$axios.$post(url, {
        content: this.message
      }).then((res) => {
        this.$axios.$get(url).then((res) => {
          this.messages = [];
          this.message = '';
          for (let i in res.data) {
            this.messages.push(res.data[i].attributes);
          };
        }).catch((error) => {
          console.log(error);
        });
      }).catch((error) => {
        console.log(error);
      });
    },
    deleteRoom() {
      let url = `rooms/${this.id}/`;
      this.$axios.$delete(url).then((res) => {
        this.$router.replace({path: '/'});
        location.reload();
        this.$toasted.success('トークルームを削除しました');
      }).catch((error) => {
        console.log(error);
      });
    }
  }
}
</script>

<style lang="scss">
.v-list#scroll{
  height:400px;/* or any height you want */
  overflow-y:auto;
}
</style>