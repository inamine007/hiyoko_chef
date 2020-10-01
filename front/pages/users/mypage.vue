<template>
  <v-container class="fill-height">
    <v-row>
      <v-col xs="12" md="4" sm="12" >
        <currentUser />
      </v-col>
      <v-col xs="12" md="8" sm="12" >
        <v-card outlined>
          <v-row justify="center">
            <v-card-title>よく作るジャンル</v-card-title>
          </v-row>
          <doughnut-chart :chart-data="chartData" :options="chartOptions"></doughnut-chart>
        </v-card>
        <v-row justify="center">
          <p class="text mt-5">公開レシピ</p>
        </v-row>
        <v-row dense>
          <v-col v-for="recipe in recipes" :key="recipe.id" md="6" xs="12">
            <v-card outlined max-width="320" class="mx-auto">
              <v-img :src='recipe.image' height="320"></v-img>
              <v-row>
                <v-col cols="7" class="pa-0">
                  <v-card-text v-text="recipe.name"></v-card-text>
                </v-col>
                <v-col cols="5" class="pa-0">
                  <v-card-actions>
                    <v-btn icon><v-icon small>fas fa-heart</v-icon>8</v-btn>
                    <v-btn icon><v-icon small>fas fa-comment-alt</v-icon>10</v-btn>
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
import CurrentUser from "~/components/currentUser.vue";
let url = "/users/whoami"
let url_e = "/auth/"
let url_c = "/categories/my_count"
let url_g = "/groups"
let url_r = "/recipes"
import colors from 'vuetify/es5/util/colors';
export default {
  components: {
    CurrentUser,
  },
  data() {
    return {
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
      images: {},
      user: {
        name: '',
        introduction: '',
        email: '',
        image: ''
      },
      editDialog: false,
      selectedImageUrl: null,
      page: 1,
      length: 0,
      pageSize: 10,
      lists: [],
      required: value => !!value || '必ず入力してください',
      introduction_length: value => value.length <= 70 || '70文字以内で入力してください',
      name_length: value => value.length <= 20 || '20文字以内で入力してください'
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
    this.$axios.$get(url_c).then((res) => {
      for (let key in res.data) {
        this.chartLabels.push(key);
        this.chartDataValues.push(res.data[key]);
      }
    }).catch((error) => {
      console.log(error);
    });
    this.$axios.$get(url_r).then((res) => {
      for (let i in res.data) {
        this.lists.push(res.data[i].attributes)
      };
      this.length = Math.ceil(this.lists.length/this.pageSize);
      this.recipes = this.lists.slice(this.pageSize*(this.page -1), this.pageSize*(this.page));
      console.log(this.recipes);
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