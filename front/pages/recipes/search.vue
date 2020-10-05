<template>
  <v-container class="fill-height">
    <v-row justify="center">
      <v-col cols="12" md="8">
        <p class="text mt-5">レシピ一覧</p>
        <v-form>
          <v-text-field
            solo
            v-model="search"
            label="検索"
            prepend-inner-icon="fas fa-search"
            hide-details="auto"
          ></v-text-field>
          <v-row>
            <v-col class="text-right">
              <v-btn @click="searchName" class="success">レシピ名で検索</v-btn>
              <v-btn @click="searchCategory" class="indigo" dark>カテゴリー名で検索</v-btn>
            </v-col>
          </v-row>
        </v-form>
        <v-row dense>
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
          v-model="page"
          :length="length"
          @input = "pageChange"
        ></v-pagination>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
let url_r = '/recipes/search'
let url_c = '/categories/search'
export default {
  data() {
    return {
      id: this.$route.params.id,
      recipes: {},
      search: '',
      page: 1,
      length: 0,
      pageSize: 10,
      lists: [],
    }
  },
  mounted() {
    this.$axios.$get(url_r).then((res) => {
      for (let i in res.data) {
        this.lists.push(res.data[i].attributes)
      };
      this.length = Math.ceil(this.lists.length/this.pageSize);
      this.recipes = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
    }).catch((error) => {
      console.log(error);
    });
  },
  methods: {
    pageChange(pageNumber) {
      this.recipes = this.lists.slice(this.pageSize * (pageNumber - 1),
      this.pageSize * (pageNumber));
    },
    searchName() {
      this.$axios.$get(url_r, {
        params: {name: this.search}
      }).then((res) => {
        this.lists = [];
      for (let i in res.data) {
        this.lists.push(res.data[i].attributes)
      };
      this.length = Math.ceil(this.lists.length/this.pageSize);
      this.recipes = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
    }).catch((error) => {
      console.log(error);
    });
    },
    searchCategory() {
      this.$axios.$get(url_c, {
        params: {name: this.search}
      }).then((res) => {
        this.lists = [];
      for (let i in res.data) {
        this.lists.push(res.data[i].attributes)
      };
      this.length = Math.ceil(this.lists.length/this.pageSize);
      this.recipes = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
    }).catch((error) => {
      console.log(error);
    });
    }
  },
}
</script>

<style lang="scss">
.text {
  font-size: 1.5rem;
  color: #000;
  margin: 10px 0;
}
</style>