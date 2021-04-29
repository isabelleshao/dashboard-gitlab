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
</style>