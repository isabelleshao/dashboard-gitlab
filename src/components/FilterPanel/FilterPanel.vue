<template>
  <div class="header">
    <div class="sticky">
      <h1>Filters</h1>
      <Search @new-search="addSearch" v-bind:token="this.token"/>
    </div>
  </div>
</template>

<script>
import Search from "./Search/Search.vue";
export default {
  name: "FilterPanel",
    components: {
      Search,
    },
    props: ["token"],
    data() {
    return {
      projects : null
    };
  },
  methods: {
    addSearch(s) {
      this.projects = s;
      this.$emit("new-search", s);
    },
  },
};
</script>

<style scoped>
.header {
  width: 20vw;
  background: rgba(223, 223, 223, 0.1);
  color: black;
  text-align: center;
}

.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 5em;
}
</style>