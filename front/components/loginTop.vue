<template>
  <v-container class="fill-height">
    <v-row justify="center">
      <v-col cols="12" md="8">
        <div class="text mt-5">フォローレシピ</div>
        <v-row dense>
          <v-col v-for="recipe in recipes" :key="recipe.id" md="6" xs="12">
            <v-card outlined max-width="320" class="mx-auto" link :to="{ name: 'recipes-id', params: { id: recipe.rid } }">
              <v-card-title>
                <v-avatar size='34' class="mr-2">
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
let url = '/relationships/recipes'
export default {
  data() {
    return {
      id: this.$route.params.id,
      recipes: {},
      page: 1,
      length: 0,
      pageSize: 10,
      lists: [],
    }
  },
  mounted() {
    this.$axios.$get(url).then((res) => {
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