<template>
  <div>
    <Header />

    <div class="flexContainer">
      <FilterPanel @new-search="addSearch2" @resetsearch="resetsearch" v-bind:token="this.token"/>
      
      <GroupSelection v-bind:gitlaburl="this.gitlaburl" v-bind:token="this.token" v-if="GroupIsNotSelected" @addGroupSearch="addGroupSearch"/>

      <ProjectListQuery v-bind:projects="projectsQuery" v-bind:token="this.token" v-if="isLoaded & !GroupIsNotSelected"/>
      <ProjectList 
        v-bind:projects="projects" 
        v-bind:token="this.token" 
        @loadedMembersProjectList="loadMembersApp"
        @loadedTagsProjectList="loadTagsApp" 
        @loadedPipelinesProjectList="loadPipelinesApp" 
        v-else-if="!GroupIsNotSelected"/>
    </div>
  </div>
</template>

<script>
import Header from "./components/TopPanel/Header";
import ProjectList from "./components/Items/ProjectList";
import ProjectListQuery from "./components/Items/ProjectListQuery";
import FilterPanel from "./components/FilterPanel/FilterPanel";
import GroupSelection from "./components/GroupSelection/GroupSelection";
import token from "../token.json"
import axios from "axios";

export default {
  name: "app",
  components: {
    Header,
    ProjectList,
    FilterPanel,
    ProjectListQuery,
    GroupSelection,
  },
  data() {
    return {
      isLoaded: false,
      GroupIsNotSelected: true,
      projects: [],
      filterIn: [],
      
      projectsQuery:[],
      token:token.token,
      gitlaburl: "https://pstl.algo-prog.info/api/v4",

      filterTitle: [],

    };
  },
  created() {
  },

  watch:{
    projects: function(newVal) {

      var projectTitleToDisplay = []
      console.log(this.filterTitle)
      if(this.filterTitle.length > 0){
          for(var proj of newVal){
            var toAdd = true
            for(var strName of this.filterTitle){
              if (strName.length > 0) {
                  if(!proj.name.toLowerCase().includes(strName.toLowerCase())){
                    toAdd = false
                  }
              }
            }
            if(toAdd){
              projectTitleToDisplay.push(proj)
            }
          }
      }
      else{
        projectTitleToDisplay = newVal
      }  

      this.projectsQuery = projectTitleToDisplay
    }  
  },
  methods: {

    loadMembersApp(id, members){
      for(const proj of this.projects){
        if(proj.id == id){
          proj.members = members
        }
      }
    },
    loadTagsApp(id, tags){
      for(const proj of this.projects){
        if(proj.id == id){
          proj.tags = tags
        }
      }
    },
    loadPipelinesApp(id, pipelines){
      for(const proj of this.projects){
        if(proj.id == id){
          proj.pipelines = pipelines
        }
      }
    },

    

    resetsearch() {
      this.filterTitle = []
      this.isLoaded = false
      this.projectsQuery = this.projects
    },

    async addSearch2(s) {

      if(s.name == "project-name"){
        this.filterTitle.push(s.title)
      }

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

    async addGroupSearch(group){
      const response = await this.getProjectByGroup(group);
      const groupProjects = response.data.projects
      var projectsToDisplay = []
      var per_page = 150

      for(const proj of groupProjects){
        axios.get(this.gitlaburl + "/projects/" + proj.id + "/forks", {        
          headers: {
            "Access-Control-Allow-Origin": "GET",
            "Content-Type": "application/json",
            "PRIVATE-TOKEN": this.token,
          },
          params: {
            page: 1,
            per_page: per_page
          }
        })
        .then((res) => {
          for(var k = 0; k < res.data.length; k++){
            projectsToDisplay.push(res.data[k])
          }
          var totalPages = res.headers["x-total-pages"];
          var i;

          
          for(i = 2; i<=totalPages; i++){
            axios
            .get(this.gitlaburl + "/projects/" + proj.id + "/forks", {        
              headers: {
                "Access-Control-Allow-Origin": "GET",
                "Content-Type": "application/json",
                "PRIVATE-TOKEN": this.token,
              },
              params: {
                page: i,
                per_page: per_page
              }
            })
            .then((resNextProj) => {
                for(var j = 0; j < resNextProj.data.length; j++){
                  projectsToDisplay.push(resNextProj.data[j])
                }
                this.projects = projectsToDisplay
              })
            .catch((error) => {
              console.error(error);
            });
          }
          this.projects = projectsToDisplay
          })
          .catch((error) => {
            console.error(error);
          })

          this.GroupIsNotSelected = false;
          this.isLoaded = true;
      }


      

      /*
      axios.get(proj + "/projects", {        
        headers: {
          "Access-Control-Allow-Origin": "GET",
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.token,
        },
        params: {
          page: 1,
          per_page: 100
        }
      })
      .then((res) => {
        this.projects = res.data;
        this.projectsQuery = res.data;

        
        var totalPages = res.headers["x-total-pages"];
        var i;
        

        for(i = 2; i<totalPages; i++){
          axios
          .get(this.gitlaburl + "/projects", {        
            headers: {
              "Access-Control-Allow-Origin": "GET",
              "Content-Type": "application/json",
              "PRIVATE-TOKEN": this.token,
            },
            params: {
              page: i,
              per_page: per_page
            }
          })
          .then((resNextProj) => {
              for(var j = 0; j < resNextProj.data.length; j++){
                this.projects.push(resNextProj.data[j])
              }
            })
          .catch((error) => {
            console.error(error);
          });
        }
        })
        .catch((error) => {
          console.error(error);
        })
      */
    },

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

    getProjectByGroup(group){
      return axios
      .get(this.gitlaburl + "/groups/" + group.id,{
            headers: {
                'Access-Control-Allow-Origin': 'GET',
                'Content-Type': 'application/json',
                "PRIVATE-TOKEN" : this.token
            }
      })
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

        console.log(projectbyusers)
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
