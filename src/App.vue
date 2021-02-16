<template>
  <div>
    <Header />
    <Search @new-search="logResult" />
    <ProjectList v-bind:projects="projects"/>
  </div>
</template>

<script>
import Header from './components/TopPanel/Header';
import ProjectList from './components/Items/ProjectList';
import Search from './components/Search/Search';
import axios from 'axios';

export default {
  name: 'app',
  components: {
    Header,
    ProjectList,
    Search,
  },
  data(){
    return {
      projects : [],
      search: [],
    }
  },
  created(){
    axios.get('https://pstl.algo-prog.info/api/v4/projects',{
      headers: {
        'Access-Control-Allow-Origin': 'GET',
        'Content-Type': 'application/json',
        "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
      }
    })
    .then((res) => {
      this.projects = res.data
    })
    .catch((error) => {
      console.error(error)
    })
  },
  methods:{
    logResult(res){
      this.search = [... this.search, res] 
    }
  }
}
</script>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }
body {
  font-family: Arial, Helvetica, sans-serif;
  line-height: 1.4;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;

  
}
</style>
