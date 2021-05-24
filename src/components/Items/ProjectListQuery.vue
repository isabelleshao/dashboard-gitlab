<template>
  <div class = "listProject" v-on:scroll="handleScroll">
    <div v-bind:key="project.id" v-for="project in projectsDisplay">
        <Project v-bind:project="project" v-bind:token="token"    v-bind:gitlaburl="gitlaburl"  v-bind:Comments="Comments"  v-bind:CommentsProjetID="CommentsProjetID"
          @loadedMembersProject="loadMembersProjectList" 
          @loadedTagsProject="loadTagsProjectList"
          @loadedPipelinesProject="loadPipelinesProjectList"
          @loadedIssuesProject="loadIssuesProjectList"
          />
    </div>
  </div>
</template>

<script>
import Project from './Project.vue';

export default {
  name: "ProjectListQuery",
  components: {
    Project
  },
  props: ["projects","token", "Comments","CommentsProjetID", "upToDate", "reset", "gitlaburl"],
  data(){
    return{
      indexAt: 0,
      max_projects_display: 10,
      projectsDisplay: [],
    }
  },

  created(){    
    window.addEventListener('scroll', this.handleScroll);
  },
  destroyed(){ 
    window.removeEventListener('scroll', this.handleScroll);
  },

  watch: { 
    reset: async function(){
      this.indexAt = 0;
      this.projectsDisplay = [];
    },
    projects: async function(newVal, oldVal) { // watch it
        
        if(newVal !== undefined){
            if(oldVal !== undefined){
              if(newVal.length < oldVal.length){
                this.projectsDisplay = newVal
                this.indexAt = newVal.length;
                return;
              }
            }
            else{
              this.projectsDisplay = newVal;
              this.indexAt = newVal.length;
              return;
            }
            
            console.log("ADD CONCAT")
            if(this.indexAt < this.max_projects_display){  
              var projectToAdd = this.max_projects_display

              if(newVal.length < this.indexAt + projectToAdd){
                projectToAdd = newVal.length - this.indexAt
              }
            
              this.projectsDisplay = this.projectsDisplay.concat(newVal.slice(this.indexAt, this.indexAt + projectToAdd))
              this.indexAt = this.indexAt + projectToAdd
          }
        }
    }
  },

  methods: {
      handleScroll: function(target) {
        this.target = target;

        if ((window.innerHeight + window.scrollY)>= document.body.offsetHeight - 50) {
            this.addProjects()
        }
      },

      addProjects(){
          var projectToAdd = this.max_projects_display
          if(this.projects.length < this.indexAt + projectToAdd){
            projectToAdd = this.projects.length - this.indexAt
          }

          this.projectsDisplay = this.projectsDisplay.concat(this.projects.slice(this.indexAt, this.indexAt + projectToAdd))
          this.indexAt = this.indexAt + projectToAdd + 1
      },

      loadMembersProjectList(id,members){
          this.$emit("loadedMembersProjectList",id,members)
      },
      loadTagsProjectList(id,tags){
          this.$emit("loadedTagsProjectList",id,tags)
      },
      loadPipelinesProjectList(id,pipelines){
          this.$emit("loadedPipelinesProjectList",id,pipelines)
      },
      loadIssuesProjectList(id,issues){
          this.$emit("loadedIssuesProjectList",id,issues)
      },
    }
}
</script>

<style scoped>
.listProject{
  width:80vw;
}
</style>
