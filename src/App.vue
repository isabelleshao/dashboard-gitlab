<template>
  <div>
    <Header />

    <div class="flexContainer">
      <FilterPanel @new-search="addSearch" v-bind:token="this.token"/>
      <ProjectList v-bind:projects="projects" v-bind:token="this.token"/>
    </div>
  </div>
</template>

<script>
import Header from "./components/TopPanel/Header";
import ProjectList from "./components/Items/ProjectList";
import FilterPanel from "./components/FilterPanel/FilterPanel";
import token from "../token.json"
import axios from "axios";

export default {
  name: "app",
  components: {
    Header,
    ProjectList,
    FilterPanel,
  },
  data() {
    return {
      projects: [],
      search: [],
      projects2:[],
      token:token.token,

    };
  },
  created() {
    axios
      .get("https://pstl.algo-prog.info/api/v4/projects", {
        headers: {
          "Access-Control-Allow-Origin": "GET",
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.token,
        },
      })
      .then((res) => {
        this.projects = res.data;
         this.projects2 = res.data;
      })
      .catch((error) => {
        console.error(error);
      });
  },
  methods: {
    addSearch(s) {

      this.search= [];

      for (var i = 0; i < s.length; i++) {
        for (var j = 0; j < this.projects2.length; j++) {

          if (s[i].id == this.projects2[j].id) {
            this.search.push(this.projects2[j]);
          }
        }
      }

      this.projects = this.search
    },


  },
};
</script>

<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
body {
  font-family: Arial, Helvetica, sans-serif;
  line-height: 1.4;
}

.flexContainer {
  display: flex;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
