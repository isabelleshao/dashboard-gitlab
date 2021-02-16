<template>
  <div class="project">
    <h3>{{project.name}}</h3>
    <div v-bind:key="member.id" v-for="member in displayMember">
        <h5>{{member}} </h5>
    </div>
    <p>Last activity : {{project.last_activity_at}}</p>
    <p>Tags : {{project.tag_list}}</p>
    <p>Owner : {{project.owner}}</p>

    <div v-bind:key="contributor.id" v-for="contributor in contributors">
        <h4> Contributions </h4>
        <h5>{{contributor}} </h5>
    </div>

    <p> pipelines : {{ pipelines}} </p>
    

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
                        avatar_url:res.data[membIndex]['avatar_url'],
                        id:res.data[membIndex]['id'],
                        username:res.data[membIndex]['username'],
                        web_url:res.data[membIndex]['web_url'],
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