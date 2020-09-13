export default function ({ redirect, store }) {
    if(store.$auth.loggedIn) {
      redirect('/')
    }
}