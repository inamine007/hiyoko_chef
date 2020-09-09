<template>
  <loginHeaderNav v-if="$store.$auth.loggedIn" />
  <HeaderNav v-else />
</template>

<script>
import HeaderNav from "~/components/HeaderNav.vue";
import loginHeaderNav from "~/components/loginHeaderNav.vue";
export default {
    components: {
        HeaderNav,
        loginHeaderNav
    }
}
</script>