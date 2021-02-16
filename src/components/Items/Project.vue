<template>
  <div class="project">
    <div class = "projectName">
        <div class = "hrefProjectwrap" @click="openProjectLink()">
            <h3>{{project.name}}</h3>
        </div>
    </div>
    <div class = "date">
        <img class = "calendarIcon" src="../../../public//CalendarIcon.png" alt="Calendar image" />
        <p class = "datep">Last activity : {{this.date.dateDDMMYY}} at {{this.date.dateTime}}</p>
    </div>

    <div class="members">
        <div v-bind:key="member.id" v-for="member in displayMember">
            <Member v-bind:member="member" />
        </div>
    </div>
  
    <div class = "projectDetails">
        
        <p>Tags : {{project.tag_list}}</p>
        <p>Owner : {{project.owner}}</p>

        <div v-bind:key="contributor.id" v-for="contributor in contributors">
            <h4> Contributions </h4>
            <h5>{{contributor}} </h5>
        </div>

        <p> pipelines : {{ pipelines}} </p>
    </div>
  
    

  </div>
</template>

<script>
    import Member from "./DisplayItem/Member"
    import axios from "axios";

    export default {
        name: "Project",
        components:{
            Member,
        },
        props: ["project"],

        data(){
            return{
                displayMember: [],
                members: [],
                contributors : [],
                events: [],
                pipelines: [],
                date: {},
            }
        },
        methods:{
            openProjectLink(){
                window.open(this.project.web_url,"_blank")
            }
        },

        created(){
            var date = new Date(this.project.last_activity_at).toLocaleDateString();
            var dateTime = new Date(this.project.last_activity_at).toLocaleTimeString()
            this.$set(this.date,"dateDDMMYY",date)
            this.$set(this.date,"dateTime",dateTime)
            console.log(this.date)
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
                        })
                        .catch((error) => {
                        console.error(error)
                        })
                        
                        // Load pipeline test report
                        axios.get(this.project._links.self + "/pipelines/" + this.pipelines[pipelineIndex]['id'] + "/test_report",{
                        headers: {
                            'Access-Control-Allow-Origin': 'GET',
                            'Content-Type': 'application/json',
                            "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
                        }
                        })
                        .then((resSummary) => {
                            this.$set(this.pipelines[pipelineIndex],"summary",resSummary.data)
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

    .project{
        display: inline-block;
        width: 100%;
    }
    .members{

    }

    .projectDetails{
        display: inline-block;
        margin-top: 1em;
    }

    .date{
        margin-left:0.5em;
        display: inline-flex;
    }

    .datep{
        margin: auto;
        padding: auto;
    }
    .calendarIcon{
        margin-top: 1em;
        width: 2em;
        margin: auto;
        padding: auto;
    }

    .projectName{
        width: 100%;
        display: inline-flex;
    }
    .hrefProjectwrap{
        margin-left:2em;
        padding: 0.5em;
        border-radius: 10px;
        display: inline-flex;
        cursor: pointer;
    }
    .hrefProjectwrap:hover{
        background-color: rgba(202,202,202,0.64);
        
    }
    h3{
        margin: auto;
        text-align: center;
        font-size: 30px;
    }
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