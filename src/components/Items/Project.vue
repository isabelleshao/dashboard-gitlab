<template>
  <div class="project">
    <h3><a :href="project.web_url" target="_blank">{{project.name}}</a></h3>
    <p>Etudiants : 
        <ul><li v-bind:key="member.id" v-for="member in displayMember">


       nom : {{member.name}}  ( <a :href="member.web_url" target="_blank"> {{member.id}}</a> ) 
       </li></ul> </p>
  
    <p>Last activity : {{project.last_activity_at}}</p>
      <p>Tags : {{project.tag_list}}</p>
   <!-- <p>Owner : {{project.owner}}</p>-->
<p> Contributions : 

      <ul><li v-bind:key="contributor.id" v-for="contributor in contributors">

       {{contributor.name}}     commits: {{contributor.commits}}  additions : {{contributor.additions}} deletions : {{contributor.deletions}}    </li></ul>
    </p>

  <p> pipelines ({{pipelines.length}}): 
            <a :href="pipelines[0].web_url" target="_blank">{{pipelines[0].id}}</a>   {{pipelines[0].status}} {{pipelines[0].updated_at}} 
            
       
      
  <!--    
      <ul><li v-bind:key="pipeline.id" v-for="pipeline in pipelines">
         
              <a :href="pipeline.web_url" target="_blank">{{pipeline.id}}</a>   {{pipeline.status}} {{pipeline.updated_at}} 
             </li></ul> 
             
    -->
</p>
  </div>
</template>

<script>

    import axios from "axios";

    export default {
        name: "Project",
        props: ["project"],

        data(){
            return{
                displayMember: [],
                members: [],
                contributors : [],
                events: [],
                pipelines: [],
            }
        },
        created(){
            // Loads events of project (add members, commits, etc...)
            axios.get(this.project._links.events,{
            headers: {
                'Access-Control-Allow-Origin': 'GET',
                'Content-Type': 'application/json',
                "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
            }
            })
            .then((res) => {
            this.events = res.data
            })
            .catch((error) => {
            console.error(error)
            })

            // Load members of project
            axios.get(this.project._links.members,{
            headers: {
                'Access-Control-Allow-Origin': 'GET',
                'Content-Type': 'application/json',
                "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
            }
            })
            .then((res) => {
            
            
            this.members = res.data
            
            // To create the list of names to display
            for(var membIndex in res.data){
                // Doesn't go in the if
                var canAdd = true;
                for(var nameIndex in this.displayMember){
                    if(this.displayMember[nameIndex].name == res.data[membIndex]['name']){
                        canAdd = false
                    }
                }
                if(canAdd){
                    this.displayMember = [...this.displayMember, {
                        name:res.data[membIndex]['name'],
                        //avatar_url:res.data[membIndex]['avatar_url'],
                        id:res.data[membIndex]['id'],
                        web_url:res.data[membIndex]['web_url'],
                        username:res.data[membIndex]['username'],
                        //web_url:res.data[membIndex]['web_url'],
                        }
                    ]

                    // Load user informations
                    axios.get("https://pstl.algo-prog.info/api/v4/users/" + res.data[membIndex]['id'],{
                    headers: {
                        'Access-Control-Allow-Origin': 'GET',
                        'Content-Type': 'application/json',
                        "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
                    }
                    })
                    .then((resUser) => {
                        this.displayMember[this.displayMember.length-1]['email'] = resUser.data.email
                        this.displayMember[this.displayMember.length-1]['avatar_url'] = resUser.data.avatar_url
                    })
                    .catch((error) => {
                    console.error(error)
                    })
                }
            }
            
            })
            .catch((error) => {
            console.error(error)
            })

            // Load contributors
            axios.get(this.project._links.self + "/repository/contributors",{
            headers: {
                'Access-Control-Allow-Origin': 'GET',
                'Content-Type': 'application/json',
                "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
            }
            })
            .then((res) => {
            
            this.contributors = res.data
            })
            .catch((error) => {
            console.error(error)
            })

            // Load pipelines
            axios.get(this.project._links.self + "/pipelines",{
            headers: {
                'Access-Control-Allow-Origin': 'GET',
                'Content-Type': 'application/json',
                "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
            }
            })
            .then((res) => {
                if(res.data.length > 0){
                    this.pipelines = res.data

                    for(var pipelineIndex in res.data){

                        // Load pipeline details
                        axios.get(this.project._links.self + "/pipelines/" + this.pipelines[pipelineIndex]['id'],{
                        headers: {
                            'Access-Control-Allow-Origin': 'GET',
                            'Content-Type': 'application/json',
                            "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
                        }
                        })
                        .then((resDetail) => {
                            this.$set(this.pipelines[pipelineIndex],"details",resDetail.data)
                            console.log(this.pipelines[pipelineIndex])
                        })
                        .catch((error) => {
                        console.error(error)
                        })
                        
                        // Load pipeline details
                        axios.get(this.project._links.self + "/pipelines/" + this.pipelines[pipelineIndex]['id'] + "/test_report",{
                        headers: {
                            'Access-Control-Allow-Origin': 'GET',
                            'Content-Type': 'application/json',
                            "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
                        }
                        })
                        .then((resSummary) => {
                            this.$set(this.pipelines[pipelineIndex],"summary",resSummary.data)
                            console.log(this.pipelines[pipelineIndex])
                        })
                        .catch((error) => {
                        console.error(error)
                        })

                    }
                }
            })
            .catch((error) => {
            console.error(error)
            })

            
            
        },
    }
</script>

<style scoped>
  .project {
    background: #f4f4f4;
    padding: 10px;
    border-bottom: 1px #ccc dotted;
  }
  .is-complete {
    text-decoration: line-through;
  }
  .del {
    background: #ff0000;
    color: #fff;
    border: none;
    padding: 5px 9px;
    border-radius: 50%;
    cursor: pointer;
    float: right;
  }
</style>