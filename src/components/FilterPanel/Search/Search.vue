<template>
  <div>
    <form @submit.prevent="newSearch">
      <input type="text" v-model="title" name="title" placeholder="Project Name..." /><br />
      <input type="text" v-model="user"  name="user" placeholder="User Name..."/><br />
      <input type="text" v-model="tag"  name="tag" placeholder="Tag Name..."/><br />
      <!--<input type="text" v-model="group" name="group" placeholder="Group Name..." /><br>
    
      <input type="text" v-model="tag" name="tag" placeholder="Tag Name..." /><br>-->
      <input type="submit" value="Submit" class="btn" />
    </form>
  </div>
</template>

<script>
// import uuid from 'uuid';
//import axios from "axios";
export default {
  name: "SearchQuery",
  // props: ["projects"],
  data() {
    return {
      user: "",
      title: "",
      tag: "",
      projects: [],
    };
  },

  methods: {


createQuery(){
  if (this.title.length>0){
    return  "https://pstl.algo-prog.info/api/v4/search?scope=projects&search=" +this.title
  }

    if (this.user.length>0){
    return  "https://pstl.algo-prog.info/api/v4/search?scope=projects&search=" +this.title
  }
},
    newSearch() {
      const searchRequest = {
        name: "project-name",
        title: this.title,
        user : this.user,
        tag : this.tag,
      }
      // Send up to parent
      this.$emit('new-search', searchRequest);
      this.title = '';
      this.user = '';
      this.tag = '';
    } 
  },
};
</script>

<style scoped>

input[type="text"] {
  flex: 10;
  padding: 5px;
}
input[type="submit"] {
  flex: 2;
}


.btn{
  display: inline-flex;
  padding-left: 1em;
  padding-right: 1em;
  padding-top: 0.5em;
  padding-bottom: 0.5em;
  border: transparent;
  background-color: rgba(202, 202, 202, 0.64);
  border-radius: 5px;
  cursor: pointer;
  color: black;
  text-align: center;
  align-items: center;
  margin-bottom: 7px;
    margin-top: 7px;
  font-size: 16px;
}
</style>