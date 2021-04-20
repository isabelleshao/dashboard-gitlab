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
          v-bind:value="this.displayCommentaires1()"
          ref="note1"
        />

        <button
          class="controls"
          @click="updateCommentaire1(false)"
          ref="bouton1"
        >
          Enregistrer commentaires perso
        </button>
      </div>
    </div>

    <div>
      <button
        @click="updateCommentaire1(true)"
        ref="follow"
        class="unfollow"
        v-on:click="$emit('clickChildBtn')"
      >
        {{ displayStatus() }}
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
      showTextareabool: false,
      unfollow: false,
    };
  },

  methods: {
    showTextarea() {
      this.showTextareabool = true;
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

    displayStatus() {
      for (var i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
          if (this.Comments[i].unfollow) {
            this.unfollow = false;
            return "Suivre le projet";
          } else {
            this.unfollow = true;
            return "Ne plus suivre";
          }
        }
      }
      return "Ne plus suivre";
    },

    updateCommentaire1(source) {
      let commentaireExistant = false;
      // check s'il faut ecraser un commentaire
      for (let i = 0; i < this.Comments.length; i++) {
        if (this.project.id == this.Comments[i].idProjet) {
          if (source) {
            // si ça provient du bouton unfollow
            let status = this.Comments[i].unfollow;
            this.Comments[i].unfollow = !status;

            if (status) {
              this.displayStatus();
            }
          } else {
            this.Comments[i].note1 = this.$refs.note1.value;
          }
          this.Comments[i].lastCommit = this.project.last_activity_at;

          commentaireExistant = true;
        }
      }
      //  si l'entrée n'est pas definie, creer l'entrée
      if (!commentaireExistant) {
        this.unfollowProject = false;

        if (source) {
          this.Comments.push({
            idProjet: this.project.id,
            note1: "",
            lastCommit: this.project.last_activity_at,
            unfollow: true,
          });
        } else {
          this.Comments.push({
            idProjet: this.project.id,
            note1: this.$refs.note1.value,
            lastCommit: this.project.last_activity_at,
            unfollow: false,
          });
        }
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
    },
  },

  created() {},
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