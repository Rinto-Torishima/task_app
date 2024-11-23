<template>
    <div>
      <h1>タスク一覧</h1>
      <a href="/create">タスク作成</a>
      <ul>
        <li v-for="task in tasks" :key="task.id">{{ task.title }}</li>
      </ul>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        tasks: [],
      };
    },
    created() {
      this.fetchTasks();
    },
    methods: {
      async fetchTasks() {
        try {
          const response = await axios.get('/api/v1/tasks');
          this.tasks = response.data;
        } catch (error) {
          console.error('タスクの取得に失敗しました', error);
        }
      },
    },
  };
  </script>