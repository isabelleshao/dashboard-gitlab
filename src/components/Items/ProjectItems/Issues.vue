<template>
  <div class="issues">
    <div class="rightsided">
      <a
        target="_blank"
        v-bind:href="this.project.web_url + '/-/issues'"
        v-if="this.project.open_issues_count > 0"
      >
        <div class="container_issues"  ref="uptoDate">
          <img
            class="issue_icon"
            src="../../../../public/issue.png"
            alt="paper image"
          />

          <div class="btn_issues">Issues</div>
          <div class="number_issues">{{ this.project.open_issues_count }}</div>
        </div>
      </a>
      <br />
      <a
        target="_blank"
        v-bind:href="
          this.project.web_url +
          '/-/issues/new?issue%5Bassignee_id%5D=&issue%5Bmilestone_id%5D='
        "
      >
        <div class="container_create">
          <img
            class="create_icon"
            src="../../../../public/create.png"
            alt="create image"
          />
          <p class="create_text">New Issue</p>
        </div>
      </a>


    <div class="comments">
      {{ upToDateCommentaire()}}
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
            v-bind:value="this.displayCommentaires1()"
            ref="note1"
          />

          <button class="controls" @click="updateCommentaire1()" ref="bouton1">
            Enregistrer commentaires perso
          </button>
        </div>
      </div>
    </div>

    </div>


  </div>
</template>


<script>
import axios from "axios";

export default {
  name: "Issues",
  components: {},

  props: ["Comments", "token", "project", "CommentsProjetID"],
  data() {
    return {
      issues: [],
         showTextareabool: false,
    };
  },
  methods: {

      showTextarea() {
      this.showTextareabool = true;
    },

    upToDateCommentaire() {

      var dateProjet = new Date(this.project.last_activity_at);

      for (var i = 0; i < this.issues.length; i++) {
        var dateIssue = new Date(this.issues[i].updated_at);

        if (dateIssue >= dateProjet - 1000) {

          this.$refs.uptoDate.classList.value =  this.$refs.uptoDate.classList.value + " uptodate";
          return ;
        }
      }




    //  return "à corriger";
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

  created() {
    if (this.project.issues) {
      this.issues = this.project.issues;
    } else {
      // Load members of project
      axios
        .get(this.project._links.issues, {
          headers: {
            "Access-Control-Allow-Origin": "GET",
            "Content-Type": "application/json",
            "PRIVATE-TOKEN": this.$props.token,
          },
        })
        .then((res) => {
          this.issues = res.data;
          this.$emit("loadedIssues", this.issues);
        })
        .catch((error) => {
          console.error(error);
        });
    }

  },
};
</script>

<style scoped>
a {
  text-decoration: none;
}
.issues {
  width: 100%;
  display: block;
}



.container_issues {
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
}

.uptodate {
background-color: rgba(82, 197, 139, 0.64);

}



.container_issues:hover {
  background-color: rgba(101, 101, 101, 0.1);
  text-align: center;
  align-items: center;
}

.issue_icon {
  width: 20px;
  margin-right: 0.5em;
}

.number_issues {
  font-size: 12px;
  margin-left: 2em;
  padding: 0.25em;
  border-radius: 50px;
  background-color: rgba(101, 101, 101, 0.3);
}

.container_create {
  display: inline-flex;
  width: 100%;
  cursor: pointer;
  color: black;
  align-items: center;
}

.create_icon {
  width: 2em;
  margin: auto;
  margin-left: 1em;
}

.create_text {
  margin: auto;
  margin-right: 1em;
  margin-left: 0.25em;
}


.comments {
  align-items: right;
  text-align: right;
  float: right;
  display: inline-block;
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
