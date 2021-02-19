<template>
<div class="members">
    <div v-bind:key="member.id" v-for="member in this.members">
        <Member v-bind:member="member" />
    </div>
</div>
</template>


<script>
    import Member from "./MemberItems/Member"
    import axios from "axios";

    export default {
        name: "Members",
        components:{
            Member,
        },
        props: ["project"],

        data(){
            return{
                members: [],
            }
        },
        methods:{
        },

        created(){
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
        },
    }
</script>