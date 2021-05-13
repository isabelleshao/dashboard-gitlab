<template>
  <table class="table">
    <thead>
      <tr>
        <th scope="col">#</th>
           <th scope="col">Nom du projet</th>
        <th scope="col">Note</th>
        <th scope="col">A jour</th>
           <th scope="col">Groupe</th>
        <th scope="col">Unfollow</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="c in Comments" :key="c.idProjet">
        <th scope="row">{{ c.idProjet }}</th>
        <td>{{ c.note1 }}</td>
        <td>{{ c.lastCommit }}</td>
        <td>{{ c.unfollow }}</td>
            <td>{{ c.unfollow }}</td>
                <td>{{ c.unfollow }}</td>
      </tr>
    </tbody>
  </table>
</template>

<script>
//import axios from "axios";
export default {
  name: "PersonalNotes",
  props: ["Comments", "DetailedComments","token"],
  created() {
    //this.recupererNotes();
   this.parcourirNotes() ;
  },
    methods: {
        parcourirNotes() {
            this.Comments.forEach(element => console.log(element.idProjet));


        },

/*     peupler_Notes() {
      axios
        .get("https://pstl.algo-prog.info/api/v4/projects/"

 this.CommentsProjetID +
            "/repository/files/notes.json/raw?ref=master",
          {
            headers: {
              "Access-Control-Allow-Origin": "GET",
              "Content-Type": "application/json",
              "PRIVATE-TOKEN": this.token,
            },
          }
        )
        .then((res) => {
          this.Comments = res.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
 */

    }
};
</script>

<style scoped>
.table thead th {
  vertical-align: bottom;
  border-bottom: 2px solid #dee2e6;
}

.table {
  width: 100%;
  max-width: 100%;
  margin-bottom: 1rem;
}

.table td,
.table th {
  padding: 0.75rem;
  vertical-align: top;
  border-top: 1px solid #dee2e6;
}
</style>