<template>
  <div class="project">

    <div class="gauche">
    <div class="projectDiv">
      <div class="hrefProjectwrap" @click="openProjectLink()">
        <h3 class="projectName">{{ project.name }}</h3>
      </div>
      <Tags
        v-bind:project="this.project"
        v-bind:token="token"
        v-bind:refresh="this.refresh"
        @loadedTags="loadTagsProject"
      />

      
    </div>

    <div class="date">
      <img
        class="calendarIcon"
        src="../../../public//CalendarIcon.png"
        alt="Calendar image"
      />
      <p class="datep">
        Last activity : {{ this.date.dateDDMMYY }} at {{ this.date.dateTime }}
      </p>
    </div>

    <Members
      v-bind:project="this.project"
      v-bind:token="token"
      v-bind:refresh="this.refresh"
      @loadedMembers="loadMembersProject"
    />

    <Pipeline
      v-bind:project="this.project"
      v-bind:token="token"
      v-bind:refresh="this.refresh"
      @loadedPipelines="loadPipelinesProject"
    /></div>
    <button class="reloadbtn" v-on:click="reloadData">
        <img
          class="reloadIcon"
          src="../../../public//reload.png"
          alt="reload iamge"
        />
      </button>
    <Issues
      v-bind:project="this.project"
      v-bind:token="token"
      v-bind:refresh="this.refresh"
      @loadedIssues="loadIssuesProject"
      v-bind:CommentsProjetID="CommentsProjetID"
         v-bind:gitlaburl="this.gitlaburl"
      v-bind:Comments="Comments"
    />
  </div>
</template>

<script>
import Members from "./ProjectItems/Members";
import Pipeline from "./ProjectItems/Pipeline";
import Tags from "./ProjectItems/Tags";

import Issues from "./ProjectItems/Issues";

export default {
  name: "Project",
  components: {
    Members,
    Pipeline,
    Tags,

    Issues,
  },
  props: ["project", "token", "Comments", "CommentsProjetID", "gitlaburl"],

  data() {
    return {
      displayMember: [],
      members: [],
      events: [],
      tags: [],
      date: {},
      issues: [],
      refresh: 0,
    };
  },
  methods: {
    openProjectLink() {
      window.open(this.project.web_url, "_blank");
    },
    openTagLink(link) {
      window.open(link, "_blank");
    },
    openPipelineLink(link) {
      window.open(link, "_blank");
    },
    openJobLink(link) {
      window.open(link, "_blank");
    },

    loadMembersProject(members) {
      this.$emit("loadedMembersProject", this.project.id, members);
    },
    loadTagsProject(tags) {
      this.$emit("loadedTagsProject", this.project.id, tags);
    },
    loadPipelinesProject(pipelines) {
      this.$emit("loadedPipelinesProject", this.project.id, pipelines);
    },
    loadIssuesProject(issues) {
      this.issues = issues;
      this.$emit(
        "loadedIssuesProject",
        this.project.id,
        issues
      ); 
    },

    reloadData(){
      this.project.members = null
      this.project.tags = null
      this.project.issues = null
      this.project.pipelines = null
      this.refresh += 1
    }
  },

  created() {
    var date = new Date(this.project.last_activity_at).toLocaleDateString();
    var dateTime = new Date(this.project.last_activity_at).toLocaleTimeString();
    this.$set(this.date, "dateDDMMYY", date);
    this.$set(this.date, "dateTime", dateTime);
  },
};
</script>

<style scoped>


.reloadbtn{
  width: 35px;
  height: 35px;
  margin-right: 1em;
  border-radius: 15px;
  border: transparent;
  text-align: center;
  align-items: center;
  background-color: rgba(202, 202, 202, 0.64);
  cursor: pointer;
}
.reloadbtn:hover{
  background-color: rgba(101,101,101,0.3);
}
.reloadIcon{
  margin-top: 5px;
  margin-bottom: 5px;
  width:75%;
}

.issues{
  float: right;
  align: right;
  align-items: right;
}

.gauche{
  display: block;
    width: 90%;
    float: left;
}
.cols {
  display: flex;
}

.col1 {
  width: -webkit-fill-available;
}
.col2 {
  margin-left: auto;
}
.project {
  display: inline-block;
  width: 100%;
}

.projectDetails {
  display: inline-block;
  margin-top: 1em;
}

.right-side-panel {
  display: inline-block;
  align-items: right;
  width: 100%;
}

.project {
  display: flex;
  width: 100%;
}

.projectDetails {
  display: inline-block;
  margin-top: 1em;
}

.date {
  margin-left: 0.5em;
  display: inline-flex;
}

.datep {
  margin: auto;
  padding: auto;
  margin-left: 0.5em;
}
.calendarIcon {
  margin-top: 1em;
  width: 2em;
  margin: auto;
  padding: auto;
}

.projectDiv {
  width: 100%;
  display: inline-flex;
  margin-bottom: 1em;
}
.projectName {
  text-align: center;
  display: inline-flex;
  align-items: center;
}
.hrefProjectwrap {
  padding: 0.5em;
  border-radius: 10px;
  display: inline-flex;
  cursor: pointer;
  text-align: center;
  font-size: 30px;
}
.hrefProjectwrap:hover {
  background-color: rgba(202, 202, 202, 0.64);
}

.project {
  background: #f4f4f4;
  padding: 10px;
  border-bottom: 1px #ccc dotted;
}
.is-complete {
  text-decoration: line-through;
}
.del {
  background: #ff0000;
  color: #fff;
  border: none;
  padding: 5px 9px;
  border-radius: 50%;
  cursor: pointer;
  float: right;
}
</style>
