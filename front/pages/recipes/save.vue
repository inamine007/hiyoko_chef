<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="10" md="10">
        <v-card v-for="(recipe, index) in recipes" :key="index"
          class="mx-auto"
          max-width="344"
        >
          <v-img
            src="https://cdn.vuetifyjs.com/images/cards/sunshine.jpg"
            height="200px"
          ></v-img>

          <v-card-title>
            {{ recipe.name }}
          </v-card-title>

          <v-card-subtitle>
            <v-icon>far fa-clock</v-icon><span>{{ recipe.time }}</span>分
          </v-card-subtitle>
          <v-divider></v-divider>
          <v-card-actions>
            <v-icon class="mr-1" @click="editConfirm(index)">fas fa-edit</v-icon>
            <v-icon @click="deleteConfirm(index)">fas fa-trash</v-icon>

            <v-spacer></v-spacer>

            <!-- <v-btn
              icon
              @click="show = !show"
            >
              <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
            </v-btn> -->
          </v-card-actions>

          <!-- <v-expand-transition>
            <div v-show="show">
              <v-divider></v-divider>

              <v-card-text>
                I'm a thing. But, like most politicians, he promised more than he could deliver. You won't have time for sleeping, soldier, not with all the bed making you'll be doing. Then we'll go with that data file! Hey, you add a one and two zeros to that or we walk! You're going to do his laundry? I've got to find a way to escape.
              </v-card-text>
            </div>
          </v-expand-transition> -->
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
let url = '/recipes'
export default {
  data() {
    return {
      recipes: {}
    }
  },
  asyncData({$axios}) {
    return $axios.get(url).then((res) => {
      console.log(res);
      return { recipes: res.data.data}
    })
  },

}
</script>

<style lang="scss">
span {
  font-size: 1rem;
  font-weight: bold;
}
</style>