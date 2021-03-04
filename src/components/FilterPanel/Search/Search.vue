<template>
  <div>
    <form @submit.prevent="newSearch">
      <input
        type="text"
        v-model="title"
        name="title"
        placeholder="Project Name..."
      />
      <input type="submit" value="Submit" class="btn" />
    </form>
  </div>
</template>

<script>
// import uuid from 'uuid';
import axios from "axios";
export default {
  name: "SearchQuery",
  props: ["token"],
  data() {
    return {
      title:'',
    projects: [],
    };
  },

  methods: {
    newSearch() {

      axios
        .get(
          "https://pstl.algo-prog.info/api/v4/search?scope=projects&search=" +
            this.title,
          {
            headers: {
              "Access-Control-Allow-Origin": "GET",
              "Content-Type": "application/json",
              "PRIVATE-TOKEN": this.$props.token,
            },
          }
        )
        .then((res) => {
         
          this.projects = res.data;
          this.$emit("new-search", this.projects);
       this.title = '';
 
        })
        .catch((error) => {
          console.error(error);
        })
  ;

    },

    /* 

    newSearch() {
      const searchRequest = {
        name: "project-name",
        title: this.title,
      }
      // Send up to parent
      this.$emit('new-search', searchRequest);
      this.title = '';
    } */
  },
};
</script>

<style scoped>
form {
  display: flex;
}
input[type="text"] {
  flex: 10;
  padding: 5px;
}
input[type="submit"] {
  flex: 2;
}
</style>