<template>
  <div>
    <Header />

    <div class="popup" v-if="!isLogged">
      <h1 class="loginh1">Se connecter</h1>
      <form @submit.prevent="login">
        <div class="inputholder">
          <label for="userurl"> Gitlab URL </label>
          <input
            class="inputlogin"
            type="text"
            v-model="userurl"
            required
            name="userurl"
            placeholder=""
          />
          <br />
        </div>
        <div class="inputholder">
          <label for="usertoken"> Token </label>
          <input
            class="inputlogin"
            required
            type="password"
            v-model="usertoken"
            name="usertoken"
            placeholder=""
          /><br />
          <br />
        </div>
        <div class="btnholder">
          <input class="btnlogin" type="submit" value="Se connecter" />
        </div>
      </form>
    </div>

    <div class="flexContainer" v-else>
      <FilterPanel
        @new-search="addSearch2"
        @resetsearch="resetsearch"
        v-bind:Comments="Comments"
      />

      <GroupSelection
        v-bind:gitlaburl="this.gitlaburl"
        v-bind:token="this.usertoken"
        v-if="GroupIsNotSelected"
        @addGroupSearch="addGroupSearch"
      />

      <ProjectListQuery
        v-bind:projects="projectsQuery"
        v-bind:token="this.usertoken"
        v-bind:Comments="Comments"
        v-bind:CommentsProjetID="CommentsProjetID"
        v-bind:gitlaburl="this.gitlaburl"
        v-if="isLoaded & !GroupIsNotSelected"
        v-bind:reset="this.reset"
        @loadedMembersProjectList="loadMembersApp"
        @loadedTagsProjectList="loadTagsApp"
        @loadedPipelinesProjectList="loadPipelinesApp"
        @loadedIssuesProjectList="loadIssuesApp"
      />

      <br />
    </div>
  </div>
</template>

<script>
import Header from "./components/TopPanel/Header";
import ProjectListQuery from "./components/Items/ProjectListQuery";
import FilterPanel from "./components/FilterPanel/FilterPanel";
import GroupSelection from "./components/GroupSelection/GroupSelection";
import axios from "axios";

export default {
  name: "app",
  components: {
    Header,
    FilterPanel,
    ProjectListQuery,
    GroupSelection,
  },
  data() {
    return {
      isLogged: false,
      isLoaded: false,
      GroupIsNotSelected: true,
      projects: [],
      filterIn: [],

      reset: 0,
      projectsQuery: [],
      gitlaburl: "",

      filterTitle: [],
      Comments: [],
      CommentsProjetID: null,

      usertoken: "",
      userurl: "",
    };
  },
  created() {},

  watch: {
    projects: function (newVal) {
      var projectTitleToDisplay = [];
      if (this.filterTitle.length > 0) {
        for (var proj of newVal) {
          var toAdd = true;
          for (var strName of this.filterTitle) {
            if (strName.length > 0) {
              if (!proj.name.toLowerCase().includes(strName.toLowerCase())) {
                toAdd = false;
              }
            }
          }
          if (toAdd) {
            projectTitleToDisplay.push(proj);
          }
        }
      } else {
        projectTitleToDisplay = newVal;
      }

      this.projectsQuery = projectTitleToDisplay;
    },
  },
  methods: {
    login() {
      this.gitlaburl = this.userurl + "/api/v4";
      this.loadData();
      this.isLogged = true;
    },

    loadData() {
      // recuperer l'identifiant de l'user :
      axios
        .get(this.gitlaburl + "/user/", {
          headers: {
            "Access-Control-Allow-Origin": "GET",
            "Content-Type": "application/json",
            "PRIVATE-TOKEN": this.usertoken,
          },
        })

        .then((res) => {
          //////recuperer tous les projets de l'user
          axios
            .get(this.gitlaburl + "/users/" + res.data.id + "/projects", {
              headers: {
                "Access-Control-Allow-Origin": "GET",
                "Content-Type": "application/json",
                "PRIVATE-TOKEN": this.usertoken,
              },
            })

            .then((res) => {
              let projetExistant = false;

              for (let i = 0; i < res.data.length; i++) {
                if (res.data[i].name == "notes") {
                  projetExistant = true;
                  this.CommentsProjetID = res.data[i].id;
                }
              }

              if (!projetExistant) {
                this.creer_Projet_Notes();
              } else {
                this.recuperer_Notes();
              }
            })

            .catch((error) => {
              console.error(error);
            });
        })

        .catch((error) => {
          console.error(error);
        });
    },

    creer_Projet_Notes() {
      let axiosConfig = {
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "PRIVATE-TOKEN": this.usertoken,
        },
      };

      axios
        .post(this.gitlaburl + "/projects", { name: "notes" }, axiosConfig)
        .then((res) => {
          this.CommentsProjetID = res.data.id;

          axios
            .post(
              this.gitlaburl +
                "/projects/" +
                res.data.id +
                "/repository/files/notes.json",
              {
                branch: "master",
                content: "[]",
                commit_message: "Creation JSON notes.",
              },
              {
                headers: {
                  "Content-Type": "application/json",
                  "Access-Control-Allow-Origin": "*",
                  "PRIVATE-TOKEN": this.usertoken,
                },
              }
            )
            .then((res) => {
              console.log("RESPONSE RECEIVED: ", res);
            })
            .catch((err) => {
              console.log("AXIOS ERROR: ", err);
            });
        })
        .catch((err) => {
          console.log("AXIOS ERROR: ", err);
        });
    },

    recuperer_Notes() {
      axios
        .get(
          this.gitlaburl +
            "/projects/" +
            this.CommentsProjetID +
            "/repository/files/notes.json/raw?ref=master",
          {
            headers: {
              "Access-Control-Allow-Origin": "GET",
              "Content-Type": "application/json",
              "PRIVATE-TOKEN": this.usertoken,
            },
          }
        )
        .then((res) => {
          this.Comments = res.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },

    loadMembersApp(id, members) {
      for (const proj of this.projects) {
        if (proj.id == id) {
          proj.members = members;
        }
      }
    },
    loadTagsApp(id, tags) {
      for (const proj of this.projects) {
        if (proj.id == id) {
          proj.tags = tags;
        }
      }
    },
    loadPipelinesApp(id, pipelines) {
      for (const proj of this.projects) {
        if (proj.id == id) {
          proj.pipelines = pipelines;
        }
      }
    },
    loadIssuesApp(id, issues) {
      for (const proj of this.projects) {
        if (proj.id == id) {
          proj.issues = issues;
        }
      }
    },

    resetsearch() {
      if(!this.projectsQuery){
        this.filterTitle = [];
        this.reset = this.reset + 1;
        this.projectsQuery = this.projects;
      }
      else{
        if(this.projectsQuery.length != this.projects.length) {
          this.filterTitle = [];
          this.reset = this.reset + 1;
          this.projectsQuery = this.projects;
        }
      }
      
      
      
    },

    async addSearch2(s) {
      if (s.name == "project-name") {
        this.filterTitle.push(s.title);
      }

      if (s.title.length > 0) {
        this.projectsQuery = this.getProjectByName(s.title);
        this.isLoaded = true;
      }
      if (s.user.length > 0) {
        this.projectsQuery = await this.getProjectByUser(s.user);
        this.isLoaded = true;
      }

      if (s.tag.length > 0) {
        this.getProjectByTag(s.tag);
        this.isLoaded = true;
      }
    },

    async addGroupSearch(group) {
      const response = await this.getProjectByGroup(group);
      const groupProjects = response.data.projects;
      var projectsToDisplay = [];
      var per_page = 100;

      for (const proj of groupProjects) {
        axios
          .get(this.gitlaburl + "/projects/" + proj.id + "/forks", {
            headers: {
              "Access-Control-Allow-Origin": "GET",
              "Content-Type": "application/json",
              "PRIVATE-TOKEN": this.usertoken,
            },
            params: {
              page: 1,
              per_page: per_page,
            },
          })
          .then((res) => {
            for (var k = 0; k < res.data.length; k++) {
              projectsToDisplay.push(res.data[k]);
            }
            var totalPages = res.headers["l-pages"];
            var i;

            for (i = 2; i <= totalPages; i++) {
              axios
                .get(this.gitlaburl + "/projects/" + proj.id + "/forks", {
                  headers: {
                    "Access-Control-Allow-Origin": "GET",
                    "Content-Type": "application/json",
                    "PRIVATE-TOKEN": this.usertoken,
                  },
                  params: {
                    page: i,
                    per_page: per_page,
                  },
                })
                .then((resNextProj) => {
                  for (var j = 0; j < resNextProj.data.length; j++) {
                    projectsToDisplay.push(resNextProj.data[j]);
                  }
                  this.projects = projectsToDisplay;
                })
                .catch((error) => {
                  console.error(error);
                });
            }
            this.projects = projectsToDisplay;
          })
          .catch((error) => {
            console.error(error);
          });

        this.GroupIsNotSelected = false;
        this.isLoaded = true;
      }
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

    getProjectByGroup(group) {
      return axios.get(this.gitlaburl + "/groups/" + group.id, {
        headers: {
          "Access-Control-Allow-Origin": "GET",
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.usertoken,
        },
      });
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

    getProjectByUser_aux(proj) {
      //pour chaque projet, recupère la liste des membres et la renvoit
      return axios.get(proj._links.members, {
        headers: {
          "Access-Control-Allow-Origin": "GET",
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.usertoken,
        },
      });
    },

    async getProjectByUser(strMember) {
      var userSearch = strMember.toUpperCase();

      var projectTemp = this.projectsQuery;
      this.projectsQuery = [];

      const size = projectTemp.length;
      for (var i = 0; i < size; i++) {
        var listUserProject;
        if (!projectTemp[i].members) {
          listUserProject = (await this.getProjectByUser_aux(projectTemp[i]))
            .data;
          projectTemp[i].members = listUserProject;
          this.loadMembersApp(projectTemp[i].id, listUserProject);
        } else {
          listUserProject = projectTemp[i].members;
        }
        for (var k = 0; k < listUserProject.length; k++) {
          var userUsername = listUserProject[k]["name"]
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .toUpperCase();
          var userName = listUserProject[k]["username"]
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .toUpperCase();

          if (
            userName.includes(userSearch) ||
            userUsername.includes(userSearch)
          ) {
            this.projectsQuery.push(projectTemp[i]);
            this.reset += 1;
          }
        }
      }
    },

    getProjectByTag_aux(proj) {
      //pour chaque projet, recupère la liste des membres et la renvoit
      return axios.get(proj._links.self + "/repository/tags", {
        headers: {
          "Access-Control-Allow-Origin": "GET",
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.usertoken,
        },
      });
    },

    async getProjectByTag(strTag) {
      var tagSearch = strTag.toUpperCase();

      var projectTemp = this.projectsQuery;
      this.projectsQuery = [];

      const size = projectTemp.length;

      for (var i = 0; i < size; i++) {
        var listTagProject;
        if (!projectTemp[i].tags) {
          listTagProject = (await this.getProjectByTag_aux(projectTemp[i]))
            .data;
          projectTemp[i].tags = listTagProject;
          this.loadTagsApp(projectTemp[i].id, listTagProject);
        } else {
          listTagProject = projectTemp[i].tags;
        }

        for (var j = 0; j < listTagProject.length; j++) {
          var tagName = listTagProject[j]["name"]
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .toUpperCase();
          if (tagName.includes(tagSearch)) {
            if (!this.projectsQuery.includes(projectTemp[i])) {
              this.projectsQuery.push(projectTemp[i]);
              this.reset += 1;
            }
          }
        }
      }
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

.inputholder {
  margin-top: 0.5em;
  display: inline-block;
  width: 90%;
  margin-left: 1em;
}
.btnholder {
  width: 100%;
  align-items: center;
  text-align: center;
}
.inputlogin {
  width: 100%;
  height: 2em;
}
.form-input-material {
  --input-default-border-color: white;
  --input-border-bottom-color: white;
}
.loginh1 {
  text-align: center;
  text-transform: uppercase;
  padding: 1em;
  font-size: 20px;
}
.loginh2 {
  text-align: left;
  font-size: 15px;
  font-weight: 600;
}

.btnlogin {
  padding: 10px 20px;
  border-radius: 6px;
  border-width: 2px;
  border-style: solid;
  font-size: 20px;
  font-family: "Ubuntu", sans-serif;
  cursor: pointer;
  transition: 0.25s ease;
}
.btnlogin:hover {
  transform: scale(0.9);
}

.popup {
  position: fixed;
  top: 30%;
  left: 50%;
  width: 50%;
  background-color: brown;
  z-index: 1;
  transform: translate(-50%, -50%);
  border-radius: 10px;

  align-items: center;
  padding: 50px 40px;
  color: white;
  background: rgba(0, 0, 0, 0.8);
  border-radius: 10px;
  box-shadow: 0 0.4px 0.4px rgba(128, 128, 128, 0.109),
    0 1px 1px rgba(128, 128, 128, 0.155),
    0 2.1px 2.1px rgba(128, 128, 128, 0.195),
    0 4.4px 4.4px rgba(128, 128, 128, 0.241),
    0 12px 12px rgba(128, 128, 128, 0.35);
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