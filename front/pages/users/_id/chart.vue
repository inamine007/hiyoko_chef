<template>
  <v-container class="fill-height">
    <v-row>
      <v-col cols="12" md="4">
        <currentUser v-if="userID == id" />
        <user v-else />
      </v-col>
      <v-col cols="12" md="8">
        <v-card outlined>
          <v-row justify="center">
            <v-card-title>よく作るジャンル</v-card-title>
          </v-row>
          <doughnut-chart v-if="chartDataValues.length !== 0" :chart-data="chartData" :options="chartOptions"></doughnut-chart>
        </v-card>
        <v-row justify="center">
          <div class="text mt-5">公開レシピ</div>
        </v-row>
        <v-row dense>
          <v-col v-for="recipe in recipes" :key="recipe.id" md="6" xs="12">
            <v-card outlined max-width="320" class="mx-auto" link :to="{ name: 'recipes-id', params: { id: recipe.rid } }">
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
import User from "~/components/user.vue";
import CurrentUser from "~/components/currentUser.vue";
import colors from 'vuetify/es5/util/colors';
export default {
  components: {
    User,
    CurrentUser
  },
  data() {
    return {
      id: this.$route.params.id,
      userID: this.$auth.user.data.id,
      chartDataValues: [],
      chartColors: [
        colors.red.lighten1,
        colors.blue.lighten1,
        colors.yellow.lighten1,
        colors.green.lighten1,
        colors.purple.lighten1,
        colors.pink.lighten1,
        colors.indigo.lighten1,
        colors.cyan.lighten1,
        colors.teal.lighten1,
        colors.lime.lighten1,
        colors.amber.lighten1,
        colors.orange.lighten1,
        colors.brown.lighten1,
      ],
      chartLabels: [],
      chartOptions: {
        maintainAspectRatio: false,
        animation: {
          duration: 1500,
          easing: 'easeInOutCubic',
        },
      },
      groups: {},
      recipes: [],
      followings: [],
      images: {},
      page: 1,
      length: 0,
      pageSize: 10,
      lists: [],
    }
  },
  computed: {
    chartData() {
      return {
        datasets: [
          {
            data: this.chartDataValues,
            backgroundColor: this.chartColors,
          },
        ],
        labels: this.chartLabels,
      };
    },
  },
  mounted() {
    let url_c = `/categories/${this.id}/user_count`
    let url_g = `/groups/${this.id}/owner`
    let url_r = `/recipes/${this.id}/user`
    this.$axios.$get(url_g).then((res) => {
      this.groups = res.data;
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_c).then((res) => {
      for (let key in res.data) {
        this.chartLabels.push(key);
        this.chartDataValues.push(res.data[key]);
      };
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_r).then((res) => {
      for (let i in res.data) {
        this.lists.push(res.data[i].attributes);
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
  }
}
</script>