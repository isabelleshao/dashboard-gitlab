<template>
  <div class="issues">
    <div class="rightsided">
      <a
        target="_blank"
        v-bind:href="this.project.web_url + '/-/issues'"
        v-if="this.project.open_issues_count > 0"
      >
        <div class="container_issues">
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
    </div>
  </div>
</template>


<script>
import axios from "axios";

export default {
  name: "Issues",
  components: {},
  props: ["project", "token"],

  data() {
    return {
      issues: [],
    };
  },
  methods: {},

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

.rightsided {
  align-items: right;
  text-align: right;
  float: right;
  display: inline-block;
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
</style>