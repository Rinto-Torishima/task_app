<template>
  <PageLayout>
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

      <!-- タグ選択 -->
      <div class="mb-4">
        <label class="block text-sm font-semibold text-gray-800">タグ</label>
        <select v-model="task.tag_ids" multiple class="w-full p-2 border border-gray-300 rounded-md">
          <option v-for="tag in tags" :key="tag.id" :value="tag.id">{{ tag.name }}</option>
        </select>
      </div>

      <!-- 作成ボタン -->
      <button
        type="submit"
        class="w-full py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition"
      >
        作成
      </button>
      
      <!-- タスク一覧へのリンク -->
      <router-link to="/" class="inline-block mt-4 text-center w-full text-blue-600 hover:underline">
        タスク一覧
      </router-link>
    </form>
  </PageLayout>
</template>

<script>
import axios from 'axios';
import { useToast } from 'vue-toastification';
import PageLayout from '@/components/PageLayout.vue';

export default {
  components: {
    PageLayout,
  },
  data() {
    return {
      task: {
        title: '',
        description: '',
        completed: false,
        tag_ids: []  // タグIDを格納する配列
      },
      tags: []  // サーバーから取得したタグのリスト
    };
  },
  created() {
    this.fetchTags();  // タグのリストを取得
  },
  methods: {
    async fetchTags() {
      try {
        const response = await axios.get('/api/v1/tags');
        this.tags = response.data;
      } catch (error) {
        console.error('タグの取得に失敗しました', error);
      }
    },
    async createTask() {
      const toast = useToast();
      try {
        const response = await axios.post('/api/v1/tasks', {
          task: this.task
        });
        toast.success('タスクが作成されました');
        this.task.title = '';
        this.task.description = '';
        this.task.completed = false;
        this.task.tag_ids = [];
      } catch (error) {
        toast.error('タスクの作成に失敗しました');
      }
    }
  }
};
</script>