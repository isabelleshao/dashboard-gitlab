<template>
  <div>
    <Header />

    <div class="flexContainer">
      <FilterPanel @new-search="addSearch2" @resetsearch="resetsearch" v-bind:token="this.token"/>
      <ProjectListQuery v-bind:projects="projectsQuery" v-bind:token="this.token" v-if="isLoaded" />
      <ProjectList v-bind:projects="projects" v-bind:token="this.token" v-else />
    </div>
  </div>
</template>

<script>
import Header from "./components/TopPanel/Header";
import ProjectList from "./components/Items/ProjectList";
import ProjectListQuery from "./components/Items/ProjectListQuery";
import FilterPanel from "./components/FilterPanel/FilterPanel";
import token from "../token.json"
import axios from "axios";

export default {
  name: "app",
  components: {
    Header,
    ProjectList,
    FilterPanel,
    ProjectListQuery,
  },
  data() {
    return {
      isLoaded: false,
      projects: [],
      filterIn: [],
      projectsQuery:[],
      token:token.token,
      gitlaburl: "https://pstl.algo-prog.info/api/v4",
    };
  },
  created() {
    axios
      .get(this.gitlaburl + "/projects", {
        headers: {
          "Access-Control-Allow-Origin": "GET",
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.token,
        },
      })
      .then((res) => {
        this.projects = res.data;
        this.projectsQuery = res.data;
      })
      .catch((error) => {
        console.error(error);
      });
  },
  methods: {
    addSearch(s) {
      this.filterIn = [];

      for (var i = 0; i < s.length; i++) {
        for (var j = 0; j < this.projects2.length; j++) {
          if (s[i].id == this.projects2[j].id) {
            this.filterIn.push(this.projects2[j]);
          }
        }
      }

      this.projects = this.filterIn;
    },

    resetsearch() {
      this.isLoaded = false
      this.projectsQuery = this.projects
    },

    async addSearch2(s) {
      if(s.title.length > 0){
        this.projectsQuery = this.getProjectByName(s.title)
        this.isLoaded = true
      }
      if(s.user.length > 0){
        this.projectsQuery = await this.getProjectByUser(s.user)
        this.isLoaded = true
      }
      if(s.tag.length > 0){
        this.projectsQuery = await this.getProjectByTag(s.tag)
        this.isLoaded = true
      } 
      

      /*
      if (s.user.length > 0) {
        this.projects =  this.getProjectByUser(s.user);
      } else {
        this.isLoaded = false;
        // this.projects = this.getProjectByName(s.title);
      }
      */

      //this.projects = this.getProjectByUser(s.title);
      // console.log(s.title);
      /*  if (s.title.length > 0) {
        this.filterIn = this.getProjectByName(s.title);
      }
      this.projects = this.getProjectByName(s.title); */
    },

    getProjectByName(strName) {
      // retourne liste des projets matchant avec le nom du projet
      var temp = [];
      if (strName.length == 0) {
        return this.projectsQuery;
      } else {
        this.projectsQuery.forEach((element) =>
          element.name.toLowerCase().includes(strName.toLowerCase())
            ? temp.push(element)
            : null
        );

        return temp;
      }
    },

    ////////////////////////////////////////////////////
    getProjectByUser_aux(proj) {
      //pour chaque projet, recupère la liste des membres et la renvoit
      return axios
      .get(proj._links.members, {
        headers: {
          "Access-Control-Allow-Origin": "GET",
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.token,
        },
      })
    },

    async getProjectByUser(strMember) {
        var userSearch = strMember.toUpperCase()
        var indexToKeep = []

        const size = this.projectsQuery.length

        for(var i = 0; i < size ; i++){ 
          var listUserProject = (await this.getProjectByUser_aux(this.projectsQuery[i])).data;
          for (var k = 0; k < listUserProject.length; k++) {
            var userUsername = listUserProject[k]['name'].normalize("NFD").replace(/[\u0300-\u036f]/g, "").toUpperCase()
            var userName = listUserProject[k]['username'].normalize("NFD").replace(/[\u0300-\u036f]/g, "").toUpperCase()

            if(userName.includes(userSearch) || userUsername.includes(userSearch)){
              indexToKeep.push(i)
            }
          }

        }
        var projectbyusers = indexToKeep.map(j => this.projectsQuery[j]);
        return projectbyusers
    },


    ////////////////////////////////////////////////////
    getProjectByTag_aux(proj) {
      //pour chaque projet, recupère la liste des membres et la renvoit
      return axios
      .get(proj._links.self + "/repository/tags",{
            headers: {
                'Access-Control-Allow-Origin': 'GET',
                'Content-Type': 'application/json',
                "PRIVATE-TOKEN" : this.token
            }
      })
    },

    async getProjectByTag(strTag) {
        var tagSearch = strTag.toUpperCase()
        var indexToKeep = []

        const size = this.projectsQuery.length

        for(var i = 0; i < size ; i++){ 
          var listTagProject = (await this.getProjectByTag_aux(this.projectsQuery[i])).data;
          
          for(var j = 0; j < listTagProject.length; j++){
            var tagName = listTagProject[j]['name'].normalize("NFD").replace(/[\u0300-\u036f]/g, "").toUpperCase()
            if(tagName.includes(tagSearch)){
              if(!indexToKeep.includes(i)){
                indexToKeep.push(i)
              }
            }

          }
        }

        var projectbytags = indexToKeep.map(j => this.projectsQuery[j]);
        return projectbytags
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
