<template>
<div class = "tagsContainer">
    <div v-bind:key="tag.id" v-for="tag in this.tags">
        <p class = "tag" @click="openTagLink(tag.commit.web_url)">{{tag.name}}</p>
    </div>
</div>
</template>

<script>
    import axios from "axios";

    export default {
        name: "Tags",
        components:{
        },
        props: ["project","token","refresh"],

        data(){
            return{
                tags: [],
            }
        },
        methods:{
            openTagLink(link){
                window.open(link,"_blank")
            },
            loadDataTags(){
                if(this.project.tags){
                    this.tags = this.project.tags
                }
                else{
                    axios.get(this.project._links.self + "/repository/tags",{
                    headers: {
                        'Access-Control-Allow-Origin': 'GET',
                        'Content-Type': 'application/json',
                        "PRIVATE-TOKEN" : this.$props.token
                    }
                    })
                    .then((res) => {
                    this.tags = res.data
                    this.$emit("loadedTags",this.tags)
                    })
                    .catch((error) => {
                    console.error(error)
                    })
                }
            }
        },

        created(){
            this.loadDataTags()
        },

        watch:{
            refresh:function(){
                this.loadDataTags();
            }
        }
    }
</script>

<style scoped>
.tagsContainer{
        display: contents;
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
</style>