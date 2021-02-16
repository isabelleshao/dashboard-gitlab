<template>
  <div>
    <form @submit.prevent="newSearch">
      <input type="text" v-model="title" name="title" placeholder="Project Name...">
      <input type="submit" value="Submit" class="btn">
    </form>
  </div>
</template>

<script>
// import uuid from 'uuid';
export default {
  name: "AddTodo",
  data() {
    return {
      title: ''
    }
  },
  methods: {
    newSearch() {
      const searchRequest = {
        name: "project-name",
        title: this.title,
      }
      // Send up to parent
      this.$emit('new-search', searchRequest);
      this.title = '';
    }
  }
}
</script>

<style scoped>
  form {
    display: flex;
  }
  input[type="text"] {
    flex: 10;
    padding: 5px;
  }
  input[type="submit"] {
    flex: 2;
  }
</style>