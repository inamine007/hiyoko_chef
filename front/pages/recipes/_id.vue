<template>
  <v-container class="fill-height">
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="8">
        <v-card class="mx-auto">
          <v-card-title>
            <nuxt-link :to="{ name: 'users-id-chart', params: { id: recipe.user_id } }">
            <v-avatar size='34' class="mr-2">
              <v-img v-if="recipe.encode_uimage" :src="recipe.encode_uimage"></v-img>
            </v-avatar>
            {{ recipe.uname }}
            </nuxt-link>
          </v-card-title>
          <v-img
            v-if="recipe.encode_image" 
            :src="recipe.encode_image"
            max-width="960"
            max-height="680"
          ></v-img>
          <v-card-actions class="pt-0 pb-0">
            <v-btn icon v-if="favoritesUserID.includes(Number(userID))" @click="unfavorites"><v-icon small color="pink">fas fa-heart</v-icon>{{ favoritesCount }}</v-btn>
            <v-btn icon v-else @click="favorites"><v-icon small>fas fa-heart</v-icon>{{ favoritesCount }}</v-btn>
            <v-btn icon @click="commentsDialog=true"><v-icon small>fas fa-comment-alt</v-icon>{{ listsC.length }}</v-btn>
          </v-card-actions>
          <v-card-actions class="pt-0 pb-0 pl-0">
            <v-btn color="green darken-1" small text @click="commentDialog=true">コメントする</v-btn>
            <v-btn color="blue darken-1" small text @click="favoritesDialog=true">いいねした人</v-btn>
          </v-card-actions>
          <v-card-title class="pt-0 mb-5">
            {{ recipe.name }}
          </v-card-title>
          <v-card-subtitle>
            <v-icon dense class="mr-1" color="black">fas fa-utensils</v-icon>{{ recipe.serve }}人前
            <v-icon dense class="mr-1 ml-4" color="orange">far fa-clock</v-icon>約{{ recipe.time }}分
            <v-icon dense class="mr-1 ml-4" color="blue">fas fa-dollar-sign</v-icon>{{ recipe.cost }}円
            <v-icon dense class="mr-1 ml-4" color="red">fas fa-tag</v-icon>{{ recipe.category.name }}
          </v-card-subtitle>
          <v-card-text>
            <v-simple-table class="mb-3">
              <caption style="font-size: 1.2rem;" class="text-left">食材</caption>
              <thead>
                <tr>
                  <th class="text-left">名前</th>
                  <th class="text-left">使用量</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(ri, index) in recipe.ingredients" :key="index">
                  <td>{{ ri.name }}</td>
                  <td>{{ amounts[index] }}{{ ri.unit_used }}</td>
                </tr>
              </tbody>
            </v-simple-table>
            <p>作り方</p>
            <v-card>
              <v-card-text style="white-space: pre-wrap; word-wrap: break-word;">{{ recipe.description }}</v-card-text>
            </v-card>
          </v-card-text>
        </v-card>
        <v-dialog v-model="commentsDialog" persistent max-width="680">
        <v-card outlined>
          <v-card-text class="pl-1 pr-1">
            <v-list>
              <v-list-item v-for="(item, index) in comments" :key="index">
                <v-list-item-avatar>
                  <v-img :src="item.uimage"></v-img>
                </v-list-item-avatar>
                <v-list-item-content align="left">
                  <v-list-item-subtitle>{{ item.user.name }}<br>{{ item.created }}</v-list-item-subtitle>
                  <v-list-item-title v-text="item.content" class="wrap-text"></v-list-item-title>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn v-if="item.user.id == userID" color="red darken-1" small text @click="deleteConfirm(item)">消す</v-btn>
                  </v-card-actions>
                </v-list-item-content>
              </v-list-item>
            </v-list>
            <v-pagination
              v-model="pageComment"
              :length="lengthC"
              @input = "pageChangeC"
            ></v-pagination>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="commentsDialog=false">閉じる</v-btn>
          </v-card-actions>
        </v-card>
        </v-dialog>
        <v-dialog v-model="favoritesDialog" persistent max-width="680">
        <v-card outlined>
          <v-card-text class="pl-1 pr-1">
            <v-list>
              <v-list-item v-for="(item, index) in favoritesUser" :key="index" @click="link(item)">
                <v-list-item-avatar>
                  <v-img :src="item.image"></v-img>
                </v-list-item-avatar>
                <v-list-item-content align="left">
                  <v-list-item-title v-text="item.name"></v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list>
            <v-pagination
              v-model="pageFavorite"
              :length="lengthF"
              @input = "pageChangeF"
            ></v-pagination>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="green darken-1" text @click="favoritesDialog=false">閉じる</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
        <v-dialog v-model="commentDialog" persistent max-width="680">
          <v-card outlined>
            <v-card-text>
              <v-form @submit.prevent="createComment">
                <v-textarea
                  v-model="content"
                  label="コメント"
                  name="コメント"
                  counter="140"
                  rows="3"
                  :rules="[comment_length, required]"></v-textarea>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="green darken-1" text type="submit">コメントする</v-btn>
                  <v-btn color="green darken-1" text @click="commentDialog=false">閉じる</v-btn>
                </v-card-actions>
              </v-form>
            </v-card-text>
          </v-card>
        </v-dialog>
        <v-dialog v-model="deleteDialog" persistent max-width="320">
          <v-card>
            <v-card-title>削除確認</v-card-title>
            <v-card-text>コメントを削除してもよろしいですか？</v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="green darken-1" text @click="deleteComment">削除</v-btn>
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
  data() {
    return {
      id: this.$route.params.id,
      favoritesUserID: [],
      favoritesUser: [],
      userID: this.$auth.user.data.id,
      deleteID: '',
      favoritesCount: '',
      commentsCount: '',
      commentDialog: false,
      commentsDialog: false,
      favoritesDialog: false,
      deleteDialog: false,
      comments: {},
      content: '',
      recipe: {
        category: [{
          name: ''
        }]
      },
      amounts: [],
      pageComment: 1,
      lengthC: 0,
      pageSizeC: 7,
      listsC: [],
      pageFavorite: 1,
      lengthF: 0,
      pageSizeF: 7,
      listsF: [],
      required: value => !!value || '必ず入力してください',
      comment_length: value => value.length <= 140 || '140文字以内で入力してください',
    }
  },
  mounted() {
    let url = `recipes/${this.id}/`;
    this.$axios.$get(url).then((res) => {
      console.log(res);
      this.recipe = res.data;
      for (let i in this.recipe.detail) {
        this.amounts.push(this.recipe.detail[i].amount)
      };
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'favorites').then((res) => {
      console.log(res);
      this.favoritesUserID = res.data;
      this.favoritesCount = res.data.length;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'comments').then((res) => {
      for (let i in res.data) {
        this.listsC.push(res.data[i].attributes)
      };
      this.lengthC = Math.ceil(this.listsC.length/this.pageSizeC);
      this.comments = this.listsC.slice(this.pageSizeC*(this.pageComment -1), this.pageSizeC*(this.pageComment));
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'favorites/users').then((res) => {
      for (let i in res.data) {
        this.listsF.push(res.data[i].attributes)
      };
      this.lengthF = Math.ceil(this.listsF.length/this.pageSizeF);
      this.favoritesUser = this.listsF.slice(this.pageSizeF*(this.pageFavorite -1), this.pageSizeF*(this.pageFavorite));
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
    pageChangeC(pageNumber) {
      this.comments = this.listsC.slice(this.pageSizeC * (pageNumber - 1),
      this.pageSizeC * (pageNumber));
    },
    pageChangeF(pageNumber) {
      this.favoritesUser = this.listsF.slice(this.pageSizeF * (pageNumber - 1),
      this.pageSizeF * (pageNumber));
    },
    favorites() {
      let url = `recipes/${this.id}/favorites/`;
      this.$axios.$post(url).then((res) => {
        console.log(res);
        this.$axios.$get(url).then((res) => {
          console.log(res);
          this.listsF = [];
          this.$axios.$get(url + 'users').then((res) => {
            for (let i in res.data) {
              this.listsF.push(res.data[i].attributes)
            };
            this.lengthF = Math.ceil(this.listsF.length/this.pageSizeF);
            this.favoritesUser = this.listsF.slice(this.pageSizeF*(this.pageFavorite -1), this.pageSizeF*(this.pageFavorite));
          }).catch((error) => {
            console.log(error);
          });
          this.favoritesUserID = res.data;
          this.favoritesCount = res.data.length;
        }).catch((error) => {
          console.log(error);
        });
      }).catch((error) => {
        console.log(error);
      });
    },
    unfavorites() {
      let url = `recipes/${this.id}/favorites/`;
      this.$axios.$delete(url).then((res) => {
        console.log(res);
        this.$axios.$get(url).then((res) => {
          console.log(res);
          this.listsF = [];
          this.$axios.$get(url + 'users').then((res) => {
            for (let i in res.data) {
              this.listsF.push(res.data[i].attributes)
            };
          this.lengthF = Math.ceil(this.listsF.length/this.pageSizeF);
          this.favoritesUser = this.listsF.slice(this.pageSizeF*(this.pageFavorite -1), this.pageSizeF*(this.pageFavorite));
        }).catch((error) => {
          console.log(error);
        });
        this.favoritesUserID = res.data;
        this.favoritesCount = res.data.length;
        }).catch((error) => {
          console.log(error);
        });
      }).catch((error) => {
        console.log(error);
      });
    },
    createComment() {
      let url = `recipes/${this.id}/comments`;
      this.$axios.$post(url, {
        content: this.content
      }).then((res) => {
        console.log(res);
        if (res.status == 'ERROR') {
          var messages = [];
          for (var i=0; i<res.data.length; i++){
            messages.push(res.data[i]);
          }
          var result = messages.join('<br>')
          this.$toasted.error(result)
        } else {
          this.listsC = [];
          this.$axios.$get(url).then((res) => {
            for (let i in res.data) {
              this.listsC.push(res.data[i].attributes)
            };
            this.lengthC = Math.ceil(this.listsC.length/this.pageSizeC);
            this.comments = this.listsC.slice(this.pageSizeC*(this.pageComment -1), this.pageSizeC*(this.pageComment));
          }).catch((error) => {
            console.log(error);
          });
          this.commentDialog = false;
          this.commentsDialog = true;
          this.content = '';
          this.$toasted.success(this.recipe.name + 'にコメントしました！');
        }
      }).catch((error) => {
        console.log(error);
      });
    },
    deleteConfirm(item) {
      this.deleteDialog = true;
      this.deleteID = item.cid;
      console.log(this.deleteID)
    },
    deleteComment() {
      let url = `recipes/${this.id}/comments`;
      this.$axios.$delete(url, {
        params: { id: this.deleteID }
      }).then((res) => {
        console.log(res);
        this.listsC = [];
        this.$axios.$get(url).then((res) => {
          for (let i in res.data) {
            this.listsC.push(res.data[i].attributes)
          };
          this.lengthC = Math.ceil(this.listsC.length/this.pageSizeC);
          this.comments = this.listsC.slice(this.pageSizeC*(this.pageComment -1), this.pageSizeC*(this.pageComment));
        }).catch((error) => {
          console.log(error);
        });
        this.deleteDialog = false;
        this.commentsDialog = true;
        this.$toasted.success('コメントを削除しました');
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