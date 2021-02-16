<template>
  <div id="sidebar">
      <h1>Groupes</h1>

        <GroupList v-bind:groups="groups"/>

  </div>

  
</template>

<script>

import GroupList from '../Items/GroupList.vue';
import axios from 'axios';
export default{
  components: { GroupList },
    name: "Sidebar",
      data(){
    return {
      groups : [],
    }
  },
    created(){
    axios.get('https://pstl.algo-prog.info/api/v4/groups',{
      headers: {
        'Access-Control-Allow-Origin': 'GET',
        'Content-Type': 'application/json',
        "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
      }
    })
    .then((res) => {
      this.groups = res.data
    })
    .catch((error) => {
      console.error(error)
    })
  },
}
</script>

<style scoped>
 div#sidebar {
    float: left;
    height: 100%;
    display: block;
    width: 300px;
    background-color: cadetblue;
}
</style>