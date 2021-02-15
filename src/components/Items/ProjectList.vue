<template>
  <div>
    <Project/>
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
</style>
