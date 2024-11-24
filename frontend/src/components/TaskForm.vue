<template>
  <div class="min-h-screen bg-gray-100 py-8 px-4">
    <div class="max-w-4xl mx-auto bg-white shadow-md rounded-lg p-6">
      <h1 class="text-2xl font-bold text-gray-800 mb-6">タスク作成</h1>
      <form @submit.prevent="createTask">
        <!-- タイトル -->
        <input
          v-model="task.title"
          type="text"
          placeholder="タイトル"
          required
          class="w-full p-2 mb-4 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        
        <!-- 説明 -->
        <textarea
          v-model="task.description"
          placeholder="説明"
          class="w-full p-2 mb-4 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        ></textarea>

        <!-- 完了チェックボックス (コメントアウト) -->
        <!-- <label>
          完了:
          <input type="checkbox" v-model="task.completed" />
        </label> -->

        <!-- 作成ボタン -->
        <button
          type="submit"
          class="w-full py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition"
        >
          作成
        </button>
        
        <!-- タスク一覧へのリンク -->
        <a href="/" class="inline-block mt-4 text-center w-full text-blue-600 hover:underline">
          タスク一覧
        </a>
      </form>
    </div>
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