<template>
  <div class = "listProject">
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
      max_projects_display: 20,
      projectsDisplay: [],
    }
  },

  created(){    
  },

  watch: { 
    projects: async function(newVal) { // watch it
        if(this.indexAt < this.max_projects_display){  
          this.projectsDisplay = this.projectsDisplay.concat(newVal.slice(this.indexAt, this.max_projects_display))
          this.indexAt = this.max_projects_display+1
        }
    }
  }
}
</script>

<style scoped>
.listProject{
  width:80vw;
}
</style>
