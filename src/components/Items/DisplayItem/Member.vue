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

div.hrefWraper{
    width:12.5%;
    height:50%;
    padding-bottom:1em;
    cursor: pointer;
    
}

div.hrefWraper:hover{
    background-color: rgba(202,202,202,0.64);
    border-radius: 10px;
}
img {
  border-radius: 50%;
  width:25%;
  float:left;
  margin-top:7px;
  margin-left: 1em;
}
p {
    width: 10em;
    padding-top:10px;
    margin-left: 5em;
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