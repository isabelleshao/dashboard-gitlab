<template>
  <div class="">
    <p class="headline"> Please select a group </p>
    <div class = "groupContainer">
      <div class = "group" v-bind:key="group.id" v-for="group in this.project_group">
          <p class = "groupp" @click="addGroupSearch(group)">{{group.full_name}}</p>
      </div>
      <p class="noGroup"> No group </p>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "GroupSelection",
  components: {
  },
  data(){
    return {
      project_group: [],
    }
  },
  props: ["gitlaburl","token"],

  created(){
    axios.get(this.gitlaburl + "/groups",{
    headers: {
        'Access-Control-Allow-Origin': 'GET',
        'Content-Type': 'application/json',
        "PRIVATE-TOKEN" : this.$props.token
    },
    params: {
      per_page: 100
    }
    })
    .then((res) => {
      this.project_group = res.data
    })
    .catch((error) => {
    console.error(error)
    })
  },

  methods:{
    addGroupSearch(group){
      this.$emit("addGroupSearch", group);
    }
  }
}
</script>

<style scoped>



.headline {
  text-align: center;
  font-size:2em;
  font-weight:bold;
}
.groupContainer{
        width:60vw;
        display: inline-blockflex;
        text-align: center;
}
.group{
    display: inline-flex;
    margin: 1em;
    padding: 0.5em;
    font-size: 1.5em;

    background-color: rgba(202,202,202,0.64);
    border-radius: 5px;
    cursor: pointer;
}
.group:hover{
    font-size: 1em;
    margin: 1em;
    padding: 0.5em;
    font-size: 1.5em;
    text-align: center;
    background-color: rgba(101,101,101,0.3);
    border-radius: 5px;
    cursor: pointer;
}

.noGroup {
  text-align: center;
  display: inline-flex;
  align-items: center;
  margin: 1em;
  padding: 0.5em;
  font-size: 1.5em;

  background-color: rgba(233,19,19,0.8);
  border-radius: 5px;
  cursor: pointer;
}

.noGroup:hover{
    font-size: 1em;
    margin: 1em;
    padding: 0.5em;
    font-size: 1.5em;
    text-align: center;
    background-color: rgba(233,19,19,0.6);
    border-radius: 5px;
    cursor: pointer;
}

</style>
