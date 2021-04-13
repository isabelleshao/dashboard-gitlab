<template>
  <div class = "listProject">
    <div v-bind:key="project.id" v-for="project in projects">
        <Project v-bind:project="project" v-bind:token="token" 
          @loadedMembersProject="loadMembersProjectList" 
          @loadedTagsProject="loadTagsProjectList"
          @loadedPipelinesProject="loadPipelinesProjectList"/>
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
  props: ["projects","token"],
  methods:{  
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
    },
  created(){
    // console.log(this.projects)
  }
}
</script>

<style scoped>
.listProject{
  width:80vw;
}
</style>
