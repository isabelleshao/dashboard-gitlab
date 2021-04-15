<template>
  <div class="comments">
     <div :id="this.project.id">{{upToDateCommentaire() }}</div>
      <button class= "button-note" @click="showTextarea()" v-if='!this.showTextareabool'> 
          <img class = "img-note" src='../../../../public/ecrire note.png' alt = "create note"/>
          <p class = "text-note"> Ecrire une note </p>
      </button>
      <div class="hrefWraper box" v-else>
        <div class="wrapper">
          <textarea
            name="perso"
            id=""
            rows="10"
            v-bind:value="this.displayCommentaires1()"
            ref="note1"/>

            <button class="controls" @click="updateCommentaire1()" ref="bouton1">
              Enregistrer commentaires perso
            </button>
        </div>
      </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Comments",
  props: ["Comments", "token", "project", "CommentsProjetID", "issues"],

  data() {
    return {
      showTextareabool: false,
    };


  },

  methods: {


    showTextarea(){
      this.showTextareabool = true
    },

    upToDateCommentaire() {
      var dateProjet = new Date(this.project.last_activity_at);

      for (var i = 0; i < this.issues.length; i++) {
        var dateIssue = new Date(this.issues[i].updated_at);

        console.log("projet:" + dateProjet + " issue: " + dateIssue);
         console.log("projet:"+dateProjet.getTime()+ " issue: "+dateIssue.getTime())




        console.log(dateProjet + 0 + "  " + dateIssue + 0);
             console.log(dateIssue >= dateProjet-5000 );
        console.log("--------");
   

        if (dateIssue >= dateProjet-5000 && dateIssue <= dateProjet+5000) {
          return "corrigé!";
        }
      }

      return "à corriger";

      /*  for (var i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
          if (this.project.last_activity_at == this.Comments[i].lastCommit) {
            return "corrigé!";
            // this.$refs.bouton2.classList.value =  this.$refs.bouton2.classList.value + "uptodate";
          }
        }
      }
      return "à corriger";
      */
    },

    displayCommentaires1() {
      if (this.Comments.length == 0) {
        return [];
      } else {
        for (var i = 0; i < this.Comments.length; i++) {
          if (this.project.id == this.Comments[i].idProjet) {
            return this.Comments[i].note1;
          }
        }
      }
    },

    updateCommentaire1() {
      let value = this.$refs.note1.value;
      let commentaireExistant = false;
      // check s'il faut ecraser un commentaire
      for (let i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
          this.Comments[i].note1 = value;
          this.Comments[i].lastCommit = this.project.last_activity_at;
          commentaireExistant = true;
        }
      }
      //  si l'entrée n'est pas definie, creer l'entrée
      if (!commentaireExistant) {
        this.Comments.push({
          idProjet: this.project.id,
          note1: value,
          note2: this.note2,
          lastCommit: this.project.last_activity_at,
        });
      }

      var putData = {
        branch: "master",
        content: JSON.stringify(this.Comments),
        commit_message: "Update notes",
      };

      let axiosConfig = {
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "PRIVATE-TOKEN": this.$props.token,
        },
      };

      axios
        .put(
          "https://pstl.algo-prog.info/api/v4/projects/" +
            this.CommentsProjetID +
            "/repository/files/notes.json",
          putData,
          axiosConfig
        )
        .then((res) => {
          console.log("RESPONSE RECEIVED: ", res);
          this.$refs.bouton1.classList.value =
            this.$refs.bouton1.classList.value + "sent";
          this.$refs.bouton1.textContent = "Commentaire enregistré";
        })
        .catch((err) => {
          console.log("AXIOS ERROR: ", err);
          this.$refs.bouton1.classList.value =
            this.$refs.bouton1.classList.value + "error";
          this.$refs.bouton1.textContent = "Enregistrement echoué";
        });
    },
  },

  created() {},
};
</script>

<style scoped>

.comments {
    align-items: right;
    text-align: right;
    float: right; 
    display: inline-block;
}

.button-note{
  width:100%;
  background-color: transparent;
  border : none;


  display: inline-flex;
  padding-top: 0.5em;
  padding-bottom: 0.5em;
  border: transparent;
  border-radius: 5px;
  color: black;
  margin-bottom:1em;
}

.img-note{
  width: 25px;
  border-radius: 1px;
}

.text-note{
  font-size:15px;
}

button.uptodate {
  background-color: #93cf8c;
}

.Member {
  float: left;
}

div.hrefWraper {
  display: inline-block;
  width: 100%;
  height: 50%;
  cursor: pointer;
  padding: 0.25em;
  margin-bottom: 0.1em;
}

div.hrefWraper:hover {
  background-color: rgba(202, 202, 202, 0.64);
  border-radius: 10px;
}
img {
  border-radius: 50%;
  width: 25%;
  float: left;
  margin-top: 0.25em;
}
p {
  margin: auto;
  padding: 0.5em;
  display: inline-block;
}
* {
  padding: 0;
  margin: 0;
}

.box {
  display: flex;
}

.wrapper {
  background: #eee;
  border: 1px solid #999;
  width: 200px;
}

.wrapper textarea {
  background: linear-gradient(to bottom, #e5e5e5 0%, #f2f2f2 100%);
  border: none;
  width: 100%;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  border-bottom: 1px dotted #999;
  resize: vertical;
}
.wrapper textarea:focus {
  outline: none;
}
.controls {
  text-align: center;
  margin-top: -6px;
}

</style>