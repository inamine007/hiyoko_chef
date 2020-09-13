<template>
</template>

<script>
export default {
    auth: false,
    middleware: ["redirect"],
    async fetch({ query, $auth, $axios, $storage, redirect, $toast }) {
        localStorage.setItem("access-token", query.access_token)
        localStorage.setItem("client", query.client)
        localStorage.setItem("uid", query.uid)

        await $axios.$get('/users/whoami').then((res) => {
            $toast.success('ログインしました！');
            $auth.$storage.setState('user', res);
            $auth.$storage.setState('loggedIn', true);
        }).catch((error) => {
            console.log(error);
        });
        redirect(301, '/')
    
 }
}
</script>