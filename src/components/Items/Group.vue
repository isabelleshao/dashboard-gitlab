<template>
  <div class="group">
      <ul><li>{{group/subgroups.name}}</li></ul>

  </div>
</template>

<script>



    export default {
        name: "Group",
        props: ["group"],


    }
</script>

<style scoped>
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