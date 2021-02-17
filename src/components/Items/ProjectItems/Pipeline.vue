<template>
<div class = "pipeline">
        <div class="hrefPipelinewrap" @click="openPipelineLink(pipelines[0]['web_url'])">

            
            <div class = "successDiv" v-if="pipelines[0]['status'] === 'success'">
                <img class="commitimg" src='../../../../public/commit.png' alt="commit image" />
                <p class = "successp"> Lastest commit passed </p>
                <img class = "successIcon" src='../../../../public/success-icon-10.png' alt = "success image"/>
            </div>
            <div v-else-if="pipelines[0]['status']==='failed'" class = "failedDiv" >
                <img class="commitimg" src='../../../../public/commit.png' alt="commit image" />
                <p class = "failedp"> Lastest commit failed </p>
                <img class = "failedIcon" src='../../../../public/remove.png' alt = "success image"/>
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
</template>


<script>
    import axios from "axios";

    export default {
        name: "Pipeline",
        components:{
        },
        props: ["project"],

        data(){
            return{
                pipelines: [
                    {   status:"none",
                        jobs:[],
                    }
                ],
            }
        },
        methods:{
            openPipelineLink(link){
                window.open(link,"_blank")
            },
            openJobLink(link){
                window.open(link,"_blank")
            }
        },

        created(){
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

.commitimg{
    width:1.25em;
    margin-right: 0.5em;
}
.numberTestPassed{
        text-align:center;
        align-items: center;
        margin-left: 1em;
        display: inline-flex;
    }

.successDiv{
    display: inline-flex;
    align-items: center;   
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
    align-items: center;
}

.failedIcon{
    margin-left: 0.5em;
    height: 20px;
}

.pipeline{
        display: inline-flex;
        width: 100%;
    }

.hrefPipelinewrap{
    margin-left:0.5em;
    padding: 0.5em;
    align-items: center;
    text-align: center;
    padding-bottom: 0.25em;
}
.hrefPipelinewrap:hover{
    background-color: rgba(101,101,101,0.3);
    border-radius: 5px;
    cursor: pointer;
    display: inline-block;
    
}
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
</style>