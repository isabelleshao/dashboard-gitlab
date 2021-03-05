<template>
  <div class="project">
    <div class = "projectDiv">
        <div class = "hrefProjectwrap" @click="openProjectLink()">
            <h3 class = "projectName">{{project.name}}</h3>
        </div>
        <Tags v-bind:project="this.project" v-bind:token="token"/>
    </div>

    <div class = "date">
        <img class = "calendarIcon" src="../../../public//CalendarIcon.png" alt="Calendar image" />
        <p class = "datep">Last activity : {{this.date.dateDDMMYY}} at {{this.date.dateTime}}</p>
    </div>

    <Members v-bind:project="this.project" v-bind:token="token" @loadedMembers="loadMembers" />
    
    
    <Pipeline v-bind:project="this.project" v-bind:token="token"/>
  </div>
</template>


<script>
    import Members from "./ProjectItems/Members"
    import Pipeline from "./ProjectItems/Pipeline"
    import Tags from "./ProjectItems/Tags"
    import axios from "axios";

    export default {
        name: "Project",
        components:{
            Members,
            Pipeline,
            Tags,
        },
        props: ["project","token"],

        data(){
            return{
                displayMember: [],
                members: [],
                events: [],
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
            },

            loadMembers(members){
                this.members = members
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
                "PRIVATE-TOKEN" : this.$props.token,
            }
            })
            .then((res) => {
            this.events = res.data
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