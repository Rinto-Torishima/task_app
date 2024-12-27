<template>
    <div class="min-h-screen bg-gray-100 py-8 px-4">
      <div class="max-w-4xl mx-auto bg-white shadow-md rounded-lg p-6">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">タグ一覧</h1>
        <router-link
          to="/tags/create"
          class="inline-block bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mb-4"
        >
          タグ作成
        </router-link>
        <ul class="space-y-4">
          <li
            v-for="tag in tags"
            :key="tag.id"
            class="p-4 bg-gray-50 shadow-sm rounded-md flex items-start justify-between"
          >
            <div class="w-3/4">
              <!-- タグ名 -->
              <span class="text-lg font-semibold text-gray-800">{{ tag.name }}</span>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        tags: [],  // タグリスト
      };
    },
    created() {
      this.fetchTags();
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
    },
  };
  </script>