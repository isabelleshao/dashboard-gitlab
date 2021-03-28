<template>
  <div class="Comments">
    <div class="hrefWraper">
      <div class="box">
        <div class="wrapper">
          <textarea
            name="perso"
            id=""
            rows="10"
            v-model="Comments[0].note1"
            ref="note1"
          >
          </textarea>
          <div class="controls">
            <button @click="saveNote1()">Enregistrer commentaires perso</button>
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
  props: ["Comments"],

  data() {
    return {
      updatedNotes: [],
    };
  },
  methods: {
    /*    saveNote1() {
      let value = this.$refs.note1.value;
      console.log(value);
      this.Comments[0].note1 = value;
      this.updatedNotes = this.Comments;


   axios.put("https://pstl.algo-prog.info/api/v4/projects/1320/repository/files/README.md",{
    headers: {
        'Content-Type': 'application/json',
        "PRIVATE-TOKEN" : this.$props.token
    },

    content: {
        branch: "master",
        content: "testsss",
        commit_message: "update file",
      },

    })
    .then((res) => {
   console.log(res.data);

    // this.$emit("loadedTags",this.tags)
    })
    .catch((error) => {
    console.error(error)
    })


    },*/
    saveNote1() {
      let value = this.$refs.note1.value;
      console.log(value);
      this.Comments[0].note1 = value;
      this.updatedNotes = this.Comments;

      var postD = {
        branch: 'master',
        content: 'LUL',
        commit_message: 'updatefile',
      };

      let axiosConfig = {
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Access-Control-Allow-Origin": "*",
          "PRIVATE-TOKEN": this.$props.token,
        },
      };

      axios
        .post(
          "https://pstl.algo-prog.info/api/v4/projects/1320/repository/files/blublu.json",
          postD,
          axiosConfig
        )
        .then((res) => {
          console.log("RESPONSE RECEIVED: ", res);
        })
        .catch((err) => {
          console.log("AXIOS ERROR: ", err);
        });

      /*   axios
      .put(
          "https://pstl.algo-prog.info/api/v4/projects/1320/repository/files/README.md",    {
            branch: "master",   content: " LUL",  commit_message: "update file"},
            {headers: 
             {"Content-Type": "application/json","PRIVATE-TOKEN": this.$props.token,}},
    
        )
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.log(error);
        });*/

      /*     const url =
        "https://pstl.algo-prog.info/api/v4/projects/1320/repository/files/blublu.md";
      const config = {
        headers: {
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": this.$props.token,
          "Access-Control-Allow-Origin": "POST",
        },
      };
      const content = {
        "branch": "master",
        "content": "testsss",
        "commit_message": "update file",
      };

      axios.post(url, content, config).then((response) => {
        console.log(response.data);
      });
*/
    },
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