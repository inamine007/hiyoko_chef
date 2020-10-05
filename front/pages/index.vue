<template>
  <loginTop v-if="$store.$auth.loggedIn" />
  <top v-else />
</template>

<script>
import LoginTop from "~/components/loginTop.vue";
import Top from "~/components/top.vue";
export default {
  components: {
    LoginTop,
    Top
  },
}
</script>