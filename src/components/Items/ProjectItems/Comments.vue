<template>
  <div class="comments">
    <button
      class="button-note"
      @click="showTextarea()"
      v-if="!this.showTextareabool"
    >
      <img
        class="img-note"
        src="../../../../public/ecrire note.png"
        alt="create note"
      />
      <p class="text-note">Ecrire une note</p>
    </button>
    <div class="hrefWraper box" v-else>
      <div class="wrapper">
        <textarea
          name="perso"
          id=""
          rows="10"
          v-bind:value="this.chargerCommentaire()"
          ref="commentaire"
        />

        <button class="controls" @click="updateJSON(3)" ref="bouton1">
          Enregistrer commentaires perso
        </button>
      </div>
    </div>
    <div class="notation">
<input     v-bind:value="this.chargerNote()" ref="notation" type="text" placeholder="Notes">

        <button class="notationbtn" @click="updateJSON(4)" ref="bouton2">
          Ok
        </button>
      </div>

    <div>
      <button
        @click="updateJSON(1)"
        ref="follow"
        class="unfollow"
        
      >
        {{ displaySuivi() }}
      </button>
      <button
        @click="updateJSON(2)"
        ref="read"
        class="unfollow"
        
      >
        {{ displayMarquerLu() }}
      </button>
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
      // ENTRÉE VIERGE
      showTextareabool: false,
      unfollow: false,
      dateLu: new Date("1970-01-01Z00:00:00:000"),
      estAJour: false,
      estExistant: false, // doit-on creer une nouvelle entrée JSON ou ecraser une entrée JSON
      commentaire: "", //format string
      notation: "",
    };
  },

  methods: {
    /*trois sources d'entrée: 
  1 : ne plus suivre
  2 : marquer lu 
  3 : ajout d'une note personnelle
  4 : ajout d'une notation */

    showTextarea() {
      this.showTextareabool = true;
    },

    chargerCommentaire() {
      return this.commentaire != null ? this.commentaire : "";
    },
        chargerNote() {
      return this.notation != null ? this.notation : "";
    },

    displaySuivi() {
      return this.unfollow ? "Suivre le projet" : "Ne plus suivre";
    },

    displayMarquerLu() {
      /* Statut vert : 
          "clic sur le bouton lu" || clic sur ne plus suivre

          Statut orange

          Si projet toujours suivi : 
          si la date du dernier "lu" est antérieure à la date du dernier commit 
          ET qu'on suiçt toujours le projet
          */

      return this.estAJour ? "Marquer non lu" : "Marquer  lu";
    },

    updateJSON(source) {
      /* sources d'entrée: 
  1 : ne plus suivre
  2 : marquer lu 
  3 : ajout d'une note personnelle
  4 : ajout d'une notation */
      /////////////////////// DEBUT UPDATE VAR LOCALE
      if (source == 1) {
        // si ça provient du bouton de suivi
        this.unfollow = !this.unfollow;
        this.estAJour =
          this.unfollow ||
          this.dateLu >= this.project.last_activity_at;
      }
      if (source == 2) {
        // si ça provient du bouton de "marquer comme lu"
        this.estAJour = !this.estAJour;

        if (this.estAJour) {
          // recuperation de la date actuelle
          var d = JSON.stringify(new Date()); //UTC0
          d = new Date(JSON.parse(d)); //UTC+2
          this.dateLu = d;
        } else {
          this.dateLu = new Date("1970-01-01Z00:00:00:000");
        }
      }

      if(source==3){
         // si ca provient du textarea des commentaires
            this.commentaire = this.$refs.commentaire.value;
      }
            if(source==4){
         // si ca provient du textarea des commentaires
            this.notation = this.$refs.notation.value;
      }
      /////////////////////// FIN UPDATE VAR LOCALE

///////////////// DEBUT CREATION VAR TEMP 

      // recuperation des membres du projet
      var membres = [];
      this.project.members.forEach((element) => {
        membres.push({
          etudiantID: element.id,
          etudiantName: element.name,
          etudiantNumber: element.username, // a priori le pseudo c'est le num etudiant
        });
      });


///////////////// DEBUT UPDATE OBJET COMMENTS 
      //  si l'entrée n'est pas definie, creer l'entrée
      if (!this.estExistant) {
          this.Comments.push({
            idProjet: this.project.id,
            commentaire: this.commentaire,
            notation : this.notation,
            unfollow: this.unfollow,
            link: this.project._links.self,
            groupe: this.project.forked_from_project.name_with_namespace,
            etudiants: membres,
            lu: this.dateLu,
            estAjour: this.estAJour
          });
          this.estExistant= !this.estExistant;
      }else{
      for (var i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
          console.log("test")
           // this.Comments[i].idProjet= this.project.id,
            this.Comments[i].commentaire= this.commentaire,
            this.Comments[i].unfollow= this.unfollow,
           // this.Comments[i].link= this.project._links.self,
           // this.Comments[i].groupe= this.project.forked_from_project.name_with_namespace,
            this.Comments[i].etudiants= membres,
            this.Comments[i].lu= this.dateLu,
            this.Comments[i].estAjour= this.estAJour,
             this.Comments[i].notation= this.notation

        }
      }
      }

///////////////// DEBUT POST JSON
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
          if (!source) {
            this.$refs.bouton1.textContent = "Commentaire enregistré";
          }
        })
        .catch((err) => {
          console.log("AXIOS ERROR: ", err);
          if (!source) {
            this.$refs.bouton1.textContent = "Enregistrement echoué";
          }
        });
   //////////////nforme le parent 
         this.$emit('childMessage', this.estAJour); 
         },
  },

  created() {
    if (this.Comments.length == 0) {
      return [];
    } else {
      for (var i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
          this.estExistant = true;
          this.estAJour =
            this.Comments[i].unfollow ||
            this.Comments[i].lu >= this.project.last_activity_at;
          this.dateLu = this.Comments[i].lu;
          this.unfollow = this.Comments[i].unfollow;
          this.commentaire = this.Comments[i].commentaire;
          this.notation = this.Comments[i].notation;
        }
      }
       //////////////nforme le parent 
                console.log("j'emets"+ this.estAJour)
         this.$emit('childMessage', this.estAJour); 

         }
  },
};
</script>

<style scoped>
.unfollow {
  display: inline-flex;
  padding-left: 1em;
  padding-right: 1em;
  padding-top: 0.5em;
  padding-bottom: 0.5em;
  border: transparent;
  background-color: rgba(202, 202, 202, 0.64);
  border-radius: 5px;
  cursor: pointer;
  color: black;
  text-align: center;
  align-items: center;
  margin-bottom: 1em;
  font-size: 16px;
}

.comments {
   /* align-items: right;
  text-align: right;
  float: right;
display: inline-block;*/
}
.notation{
   display: flex;
  justify-content: space-between;
}

input[type=text] {
  width: 70%;
  padding: 10px 10px;
  margin: 8px 0;
  box-sizing: border-box;

}

.notationbtn{
  display: inline-flex;
  padding-left: 1em;
  padding-right: 1em;
  padding-top: 0.5em;
  padding-bottom: 0.5em;
  border: transparent;
  background-color: rgba(202, 202, 202, 0.64);
  border-radius: 5px;
  cursor: pointer;
  color: black;
  text-align: center;
  align-items: center;
  margin-bottom: 7px;
    margin-top: 7px;
  font-size: 16px;
}
.button-note {
  width: 100%;
  background-color: transparent;
  border: none;

  display: inline-flex;
  padding-top: 0.5em;
  padding-bottom: 0.5em;
  border: transparent;
  border-radius: 5px;
  color: black;
  margin-bottom: 1em;
}

.img-note {
  width: 25px;
  border-radius: 1px;
}

.text-note {
  font-size: 15px;
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
  /*float: left;*/
  margin-top: 0.25em;
}
p {
 /* margin: auto;*/
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