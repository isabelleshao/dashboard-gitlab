<template>
  <div class="Member">
    <div class="hrefWraper" @click="openMemberLink()">
        
            <img v-bind:src=member.avatar_url alt="Profile Picture" />
            <p>
                {{ member.name }}
                <br>
                @{{member.username}}
            </p>
        
    </div>
  </div>
</template>

<script>

    export default {
        name: "Member",
        props: ["member"],

        data(){
            return{
            }
        },
        methods:{
            openMemberLink(){
                window.open(this.member.web_url,"_blank")
            }
        }
    }
</script>

<style scoped>

.Member{
    float:left;
}

div.hrefWraper{
    display: inline-block;
    width: 100%;
    height:50%;
    cursor: pointer;
    padding:0.25em;
    margin-bottom: 0.1em;
}

div.hrefWraper:hover{
    background-color: rgba(202,202,202,0.64);
    border-radius: 10px;
}
img {
  border-radius: 50%;
  width:25%;
  float:left;
  margin-top:0.25em;
}
p {
    margin: auto;
    padding: 0.5em;
    display: inline-block;
}

a:visited {
}
a {
    text-decoration: none !important;
    text-color: #000000;
    color: black;
    background: red;
}



</style>