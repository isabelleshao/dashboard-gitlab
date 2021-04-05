<template>
  <div class="Comments">
    <div class="hrefWraper">
      <div class="box">
        <div class="wrapper">
          <textarea
            name="perso"
            id=""
            rows="10"
            v-bind:value="this.displayCommentaires()"
            ref="note1"
          >
          </textarea>
          <div class="controls">
            <button @click="updateCommentaire()" ref="bouton1">
              Enregistrer commentaires perso
            </button>
          </div>
        </div>

        <div class="wrapper">
          <textarea
            name="somename"
            id=""
            rows="10"
            v-model="Comments[0].note2"
            ref="note2"
          ></textarea>
          <div class="controls">
            <button>Envoyer à l'élève les commentaires</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Comments",
  props: ["Comments", "token", "project"],

  data() {
    return {
      updatedNotes: [],
    };
  },



  methods: {

          upToDateCommentaire(){
      for (var i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
           if (this.project.last_activity_at == this.Comments[i].lastCommit){
//this.$refs.bouton1.classList.value = 'aCorriger';



            console.log("bllaaa")
           }
        }
      }
            
        },
    
    displayCommentaires() {
      for (var i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
          return this.Comments[i].note1;
        }
      }
    },

    updateCommentaire() {

      let value = this.$refs.note1.value;
      let commentaireExistant = false;

      // check s'il faut ecraser un commentaire
      for (let i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
        //  alert("commentaire existant !");
          this.Comments[i].note1 = value;
          this.Comments[i].lastCommit = this.project.last_activity_at,
          commentaireExistant = true;
        }
      }
      //  si l'entrée n'est pas definie, creer l'entrée
      if (!commentaireExistant) {
        //alert("commentaire non existant !");
        this.Comments.push({
          idProjet: this.project.id,
          note1: value,
          note2: this.note2,
          lastCommit: this.project.last_activity_at,
        });
      }

      console.log(value);
      this.Comments[0].note1 = value;
      this.updatedNotes = this.Comments;

      var postD = {
        branch: "master",
        content: JSON.stringify(this.Comments),
        commit_message: "TEST???",
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
          "https://pstl.algo-prog.info/api/v4/projects/1320/repository/files/notes.json",
          postD,
          axiosConfig
        )
        .then((res) => {
          console.log("RESPONSE RECEIVED: ", res);
        })
        .catch((err) => {
          console.log("AXIOS ERROR: ", err);
        });
    },
  },

            created(){
              //this.$refs["bouton1"].style.backgroundColor = '#000';
            
        },
};
</script>

<style scoped>
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
  resize: none;
}
.wrapper textarea:focus {
  outline: none;
}
.controls {
  text-align: right;
  margin-top: -6px;
}
button {
  background: linear-gradient(to bottom, #ffffff 0%, #e5e5e5 100%);
  border: 1px solid #999;
  padding: 10px 25px;
  font-weight: bold;
  color: rgb(77, 77, 77);
  border-width: 1px 0 0 1px;
}
</style>