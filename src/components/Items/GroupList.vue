<template>
  <div id="groupList" >

    <div v-bind:key="group.id" v-for="group in groups"> 
             <Group v-bind:group="group" />
    </div>
  </div>
</template>

<script>
import Group from './Group.vue';
export default {
  name: "GroupList",
  components: {
    Group
  },
  props: ["groups"]
}
</script>

<style scoped>

</style>
