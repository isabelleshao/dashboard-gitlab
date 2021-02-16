<template>
  <div  id="projectList" >
    <div v-bind:key="project.id" v-for="project in projects">
        <Project v-bind:project="project" />
    </div>
  </div>
</template>

<script>
import Project from './Project.vue';
export default {
  name: "ProjectList",
  components: {
    Project
  },
  props: ["projects"]
}
</script>

<style scoped>
#projectList{margin-left: 300px;
    height: 100%;}
</style>
