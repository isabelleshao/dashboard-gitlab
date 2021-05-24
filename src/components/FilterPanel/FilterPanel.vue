<template>
  <div class="header">
    <div class="sticky">
      <h1>Filters</h1>
      <Search @new-search="addSearch" />
      <button v-on:click="resetsearch">Reset</button>
      <div><button class="exportbtn" v-on:click="exportNote">Export note</button></div>
    </div>
  </div>
</template>

<script>
import Search from "./Search/Search.vue";
export default {
  name: "FilterPanel",
  components: {
    Search,
  },
  props: ["Comments"],
  data() {
    return {
      projects: null,
      
    };
  },
  methods: {
    addSearch(s) {
      this.projects = s;
      this.$emit("new-search", s);
    },
    resetsearch() {
      this.$emit("resetsearch");
    },
    exportNote() {

      var header = [
        "Groupe",
        "idProjet",
        "NumeroEtudiant",
        "NomEtudiant",
        "Note",
        "Commentaire",
      ];
      let csvContent = "data:text/csv;charset=utf-8,";

      csvContent = csvContent += header.join("\t") + "\n";

      this.Comments.forEach((element) => {
        element.etudiants.forEach((etud) => {
          csvContent = csvContent +=
            element.groupe +
            "\t" +
            element.idProjet +
            "\t" +
            etud.etudiantNumber +
            "\t" +
            etud.etudiantName +
            "\t" +
            element.notation +
            "\t" +
            element.commentaire +
            "\n";
        });
      });

      var encodedUri = encodeURI(csvContent);
      var link = document.createElement("a");
      link.setAttribute("href", encodedUri);
      link.setAttribute("download", "mes_notes.csv");
      document.body.appendChild(link);

      link.click();
    },
  },
};
</script>

<style scoped>
.header {
  width: 20vw;
  background: rgba(223, 223, 223, 0.1);
  color: black;
  text-align: center;
}

.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 5em;
}

button {
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
button:hover{
  background-color: rgba(101,101,101,0.3);
}
</style>