<template>
  <v-container class="fill-height">
    <v-row>
      <v-col cols="12" md="4">
        <v-card outlined align="center">
          <v-card-text>
            <div class="name mb-3">{{ group.name }}</div>
            <v-icon class="mr-2">fas fa-users</v-icon>{{ member_count }}
            <v-list>
              <v-list-item v-for="(item, index) in members" :key="index" @click="link(item)">
                <v-list-item-avatar>
                  <v-img :src="item.image"></v-img>
                </v-list-item-avatar>
                <v-list-item-content align="left">
                  <v-list-item-title v-text="item.name"></v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list>
            <v-pagination
              v-model="pageMember"
              :length="lengthM"
              @input = "pageChangeM"
            ></v-pagination>
            <v-divider class="mt-5"></v-divider>
            <div class="text">自己紹介</div>
            <div class="introduction">{{ group.introduction }}</div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="8">
        <v-row justify="center">
          <div class="text mt-5">グループレシピ</div>
        </v-row>
        <v-row dense>
          <div v-if="recipes.length === 0" class="nothing">グループレシピはありません</div>
          <v-col v-for="recipe in recipes" :key="recipe.id" md="6" xs="12">
            <v-card outlined max-width="320" class="mx-auto" link :to="{ name: 'recipes-id', params: { id: recipe.rid } }">
              <v-card-title>
                <v-avatar size='34'>
                  <v-img v-if="recipe.uimage" :src="recipe.uimage"></v-img>
                </v-avatar>
                {{ recipe.uname }}
              </v-card-title>
              <v-img :src='recipe.image' height="320"></v-img>
              <v-row>
                <v-col cols="7" class="pa-0">
                  <v-card-text v-text="recipe.name"></v-card-text>
                </v-col>
                <v-col cols="5" class="pa-0">
                  <v-card-actions>
                    <v-btn icon><v-icon small>fas fa-heart</v-icon>{{ recipe.favorites.length }}</v-btn>
                    <v-btn icon><v-icon small>fas fa-comment-alt</v-icon>{{ recipe.comments.length }}</v-btn>
                  </v-card-actions>
                </v-col>
              </v-row>
            </v-card>
          </v-col>
        </v-row>
        <v-pagination
          v-model="pageRecipe"
          :length="lengthR"
          @input = "pageChangeR"
        ></v-pagination>
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
      member_count: '',
      group: {},
      recipes: [],
      members: [],
      images: {},
      pageRecipe: 1,
      lengthR: 0,
      pageSizeR: 10,
      listsR: [],
      pageMember: 1,
      lengthM: 0,
      pageSizeM: 7,
      listsM: [],
    }
  },
  mounted() {
    let url = `/groups/${this.id}/`;
    this.$axios.$get(url).then((res) => {
      console.log(res);
      this.group = res.data;
      this.member_count = res.data_count;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'mygroup').then((res) => {
      for (let i in res.data) {
        this.listsR.push(res.data[i].attributes)
      };
      this.lengthR = Math.ceil(this.listsR.length/this.pageSizeR);
      this.recipes = this.listsR.slice(this.pageSizeR*(this.pageRecipe -1), this.pageSizeR*(this.pageRecipe));
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url + 'members').then((res) => {
      for (let i in res.data) {
        this.listsM.push(res.data[i].attributes)
      };
      this.lengthM = Math.ceil(this.listsM.length/this.pageSizeM);
      this.members = this.listsM.slice(this.pageSizeM*(this.pageMember -1), this.pageSizeM*(this.pageMember));
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
    pageChangeR(pageNumber) {
      this.recipes = this.listsR.slice(this.pageSizeR * (pageNumber - 1),
      this.pageSizeR * (pageNumber));
    },
    pageChangeM(pageNumber) {
      this.members = this.listsM.slice(this.pageSizeM * (pageNumber - 1),
      this.pageSizeM * (pageNumber));
    },
    link(item) {
      this.$router.replace({path: '/users/' + item.uid + '/chart'});
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