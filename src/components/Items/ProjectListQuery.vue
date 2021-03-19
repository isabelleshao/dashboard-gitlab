<template>
  <div class = "listProject" v-on:scroll="handleScroll">
    <div v-bind:key="project.id" v-for="project in projectsDisplay">
        <Project v-bind:project="project" v-bind:token="token"/>
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
  props: ["projects","token"],
  data(){
    return{
      indexAt: 0,
      max_projects_display: 10,
      projectsDisplay: [],
      filtered: false,
    }
  },

  created(){    
    window.addEventListener('scroll', this.handleScroll);
  },
  destroyed(){ 
    window.removeEventListener('scroll', this.handleScroll);
  },

  watch: { 
    projects: async function(newVal) { // watch it
        if(this.filtered){
          this.projectsDisplay = newVal
        }
        else{
          if(this.indexAt < this.max_projects_display){  
            var projectToAdd = this.max_projects_display
            if(newVal.length < this.indexAt + projectToAdd){
              projectToAdd = newVal.length - this.indexAt
            }

            this.projectsDisplay = this.projectsDisplay.concat(newVal.slice(this.indexAt, this.indexAt + projectToAdd))
            this.indexAt = this.indexAt + projectToAdd + 1
          }
        }
    }
  },

  methods: {
      handleScroll: function(target) {
        if(!this.filtered){
          this.target = target;

          if ((window.innerHeight + window.scrollY)>= document.body.offsetHeight - 50) {
              this.addProjects()
          }
        }
      },

      addProjects(){
          var projectToAdd = this.max_projects_display
          if(this.projects.length < this.indexAt + projectToAdd){
            projectToAdd = this.projects.length - this.indexAt
          }

          this.projectsDisplay = this.projectsDisplay.concat(this.projects.slice(this.indexAt, this.indexAt + projectToAdd))
          this.indexAt = this.indexAt + projectToAdd + 1
      }
    }
}
</script>

<style scoped>
.listProject{
  width:80vw;
}
</style>
