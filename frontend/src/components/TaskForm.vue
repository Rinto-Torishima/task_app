<template>
    <div>
      <h1>タスク作成</h1>
      <form @submit.prevent="createTask">
        <input v-model="task.title" type="text" placeholder="タイトル" required />
        <textarea v-model="task.description" placeholder="説明"></textarea>
        <!-- <label>
          完了:
          <input type="checkbox" v-model="task.completed" />
        </label> -->
        <button type="submit">作成</button>
        <a href="/">タスク一覧</a>
      </form>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        task: {
          title: '',
          description: '',
          completed: false,
        },
      };
    },
    methods: {
      async createTask() {
        try {
          const response = await axios.post('/api/v1/tasks', {
            task: this.task,
          });
          alert('タスクが作成されました', response.data);
          // タスク作成後にフィールドをリセット
          this.task.title = '';
          this.task.description = '';
          this.task.completed = false;
        } catch (error) {
          alert('タスクの作成に失敗しました', error.response.data);
        }
      },
    },
  };
  </script>