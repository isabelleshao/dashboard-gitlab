<template>
  <div class="project">
    <div class = "projectDiv">
        <div class = "hrefProjectwrap" @click="openProjectLink()">
            <h3 class = "projectName">{{project.name}}</h3>
        </div>
        <div class = "tagsContainer">
            
            <div v-bind:key="tag.id" v-for="tag in this.tags">
                <p class = "tag" @click="openTagLink(tag.commit.web_url)">{{tag.name}}</p>
            </div>
        </div>
    </div>
    <div class = "date">
        <img class = "calendarIcon" src="../../../public//CalendarIcon.png" alt="Calendar image" />
        <p class = "datep">Last activity : {{this.date.dateDDMMYY}} at {{this.date.dateTime}}</p>
    </div>

    <div class="members">
        <div v-bind:key="member.id" v-for="member in this.members">
            <Member v-bind:member="member" />
        </div>
    </div>
  
    <div class = "pipeline">
        <div class="hrefPipelinewrap" @click="openPipelineLink(pipelines[0]['web_url'])">
            <div class = "successDiv" v-if="pipelines[0]['status'] === 'success'">
                <p class = "successp"> Lastest commit passed </p>
                <img class = "successIcon" src='../../../public/success-icon-10.png' alt = "success image"/>
            </div>
            <div v-else-if="pipelines[0]['status']==='failed'" class = "failedDiv" >
                <p class = "failedp"> Lastest commit failed </p>
                <img class = "failedIcon" src='../../../public/remove.png' alt = "success image"/>
            </div>
        </div>

        <div v-if="typeof pipelines[0]['jobs_summary'] != 'undefined'" class = "numberTestPassed">
            <p class = "numberTestPassedp"> {{pipelines[0]['jobs_summary']['success_count']}} / {{pipelines[0]['jobs_summary']['total_count']}} </p>

            <div v-bind:key="job.id" v-for="job in pipelines[0]['jobs']">
                <p @click="openJobLink(job.web_url)" v-if="job.status == 'failed'" class = "jobFailed"> {{job.name}} </p>
                <p @click="openJobLink(job.web_url)" v-if="job.status == 'skipped'" class = "jobSkipped"> {{job.name}} </p>
            </div>
        </div>
        
        

    </div>
  
    

  </div>
</template>

<script>

//          <div v-if="typeof pipelines[0]['summary'] != 'undefined'" class = "numberTestPassed">
//             <p class = "numberTestPassedp"> {{pipelines[0]['summary']['success_count']}} / {{pipelines[0]['summary']['total_count']}} </p>
//         </div>
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
                events: [],
                // Initialized status a none so it can be read in the pipeline status fail or success html
                pipelines: [
                    {   status:"none",
                        jobs:[],
                    }
                    ],
                tags: [],
                date: {},
            }
        },
        methods:{
            openProjectLink(){
                window.open(this.project.web_url,"_blank")
            },
            openTagLink(link){
                window.open(link,"_blank")
            },
            openPipelineLink(link){
                window.open(link,"_blank")
            },
            openJobLink(link){
                window.open(link,"_blank")
            }
        },

        created(){
            var date = new Date(this.project.last_activity_at).toLocaleDateString();
            var dateTime = new Date(this.project.last_activity_at).toLocaleTimeString()
            this.$set(this.date,"dateDDMMYY",date)
            this.$set(this.date,"dateTime",dateTime)
            

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

            // Loads tags of project
            axios.get(this.project._links.self + "/repository/tags",{
            headers: {
                'Access-Control-Allow-Origin': 'GET',
                'Content-Type': 'application/json',
                "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
            }
            })
            .then((res) => {
            this.tags = res.data
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

                    for(const pipelineIndex in res.data){

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
                        
                        // Load pipeline jobs
                        
                        axios.get(this.project._links.self + "/pipelines/" + this.pipelines[pipelineIndex]['id'] + "/jobs",{
                        headers: {
                            'Access-Control-Allow-Origin': 'GET',
                            'Content-Type': 'application/json',
                            "PRIVATE-TOKEN" : "SszFftmYGbwKHfoXWEzj"
                        }
                        })
                        .then((resJob) => {
                            if(this.project.id == 11){
                                console.log(resJob)
                                console.log(pipelineIndex)
                                console.log(this.pipelines[pipelineIndex]['id'])
                            }
                            
                            this.$set(this.pipelines[pipelineIndex],"jobs",resJob.data)

                            var numberSuccess = 0
                            var numberJobs = 0
                            for(const i in resJob.data){
                                if(resJob.data[i].status == "success"){
                                    numberSuccess += 1
                                }
                                numberJobs += 1
                            }

                            this.$set(this.pipelines[pipelineIndex],"jobs_summary",{'success_count': numberSuccess, 'total_count': numberJobs})
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

    .jobFailed{
        margin-left: 1em;
        background-color: rgba(233,19,19,0.8);
        border-radius: 5px;
        padding: 0.25em;
        padding-left: 0.75em;
        padding-right: 0.75em;
        color: white;
    }
    .jobFailed:hover{
        background-color: rgba(233,19,19,0.6);
        cursor: pointer;
    }

    .jobSkipped{
        margin-left: 1em;
        background-color: rgba(105,105,105,0.84);
        border-radius: 5px;
        padding: 0.25em;
        color: white;
        padding-left: 0.75em;
        padding-right: 0.75em;
    }
    .jobSkipped:hover{
        background-color: rgba(105,105,105,0.54);
        cursor: pointer;
    }

    .pipeline{
        display: inline-flex;
        width: 100%;
    }

    .hrefPipelinewrap{
        margin-left:0.5em;
        padding: 0.5em;
    }
    .hrefPipelinewrap:hover{
        background-color: rgba(101,101,101,0.3);
        border-radius: 5px;
        cursor: pointer;
        display: inline-block;
        
    }

    .numberTestPassed{
        text-align:center;
        align-items: center;
        margin-left: 1em;
        display: inline-flex;
    }

    .successDiv{
        display: inline-flex;   
    }
    .successp{
        float: left;
    }
    .successIcon{
        height: 20px;
        float: left;
        margin-left: 0.5em;
    }

    .failedDiv{
        margin-left: 0.5em;
        display: inline-flex;
        text-align: center;
    }

    .failedIcon{
        margin-left: 0.5em;
        height: 20px;
    }

    .tagsContainer{
        display: inline-table;
        width: 40%;
    }
    .tag{
        float: left;
        margin: 0.5em;
        padding: 0.25em;
        font-size: 1em;
        text-align: center;
        background-color: rgba(202,202,202,0.64);
        border-radius: 5px;
        cursor: pointer;
    }
    .tag:hover{
        float: left;
        margin: 0.5em;
        padding: 0.25em;
        font-size: 1em;
        text-align: center;
        background-color: rgba(101,101,101,0.3);
        border-radius: 5px;
        cursor: pointer;
    }

    .project{
        display: inline-block;
        width: 100%;
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
        margin-left: 0.5em;
    }
    .calendarIcon{
        margin-top: 1em;
        width: 2em;
        margin: auto;
        padding: auto;
    }

    .projectDiv{
        width: 100%;
        display: inline-flex;
        margin-bottom: 1em;
    }
    .projectName{
        text-align: center;
        display: inline-flex;
        align-items: center;
    }
    .hrefProjectwrap{
        padding: 0.5em;
        border-radius: 10px;
        display: inline-flex;
        cursor: pointer;
        text-align: center;
        font-size: 30px;
    }
    .hrefProjectwrap:hover{
        background-color: rgba(202,202,202,0.64);
        
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