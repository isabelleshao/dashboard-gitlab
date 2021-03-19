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
        if(this.indexAt < this.max_projects_display){  
          this.projectsDisplay = this.projectsDisplay.concat(newVal.slice(this.indexAt, this.indexAt + this.max_projects_display))
          this.indexAt = this.indexAt + this.max_projects_display + 1
        }
    }
  },

  methods: {
      handleScroll: function(target) {
        this.target = target;

        if ((window.innerHeight + window.scrollY)>= document.body.offsetHeight - 100) {
            this.addProjects()
        }
      },

      addProjects(){
          this.projectsDisplay = this.projectsDisplay.concat(this.projects.slice(this.indexAt, this.indexAt + this.max_projects_display))
          this.indexAt = this.indexAt + this.max_projects_display + 1
      }
    }
}
</script>

<style scoped>
.listProject{
  width:80vw;
}
</style>
