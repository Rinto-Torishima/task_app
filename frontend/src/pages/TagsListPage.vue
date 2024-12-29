<template>
    <PageLayout>
        <h1 class="text-2xl font-bold text-gray-800 mb-6">タグ一覧</h1>
        <router-link
          to="/tags/create"
          class="inline-block bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mb-4"
        >
          タグ作成
        </router-link>
        <router-link
          to="/"
          class="ml-2 inline-block bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mb-4"
        >
          タスク一覧
        </router-link>
        <ul class="space-y-4">
          <TagItem v-for="tag in tags" :key="tag.id" :tag="tag" @tagDeleted="handleTagDeleted"/>
        </ul>
      </PageLayout>
  </template>
  
  <script>
  import axios from 'axios';
  import TagItem from '@/components/TagItem.vue';
  import PageLayout from '@/components/PageLayout.vue';
  
  export default {
    components: {
      TagItem,
      PageLayout,
    },
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
      handleTagDeleted(tagId) {
        this.tags = this.tags.filter(tag => tag.id !== tagId);
        },
    },
  };
  </script>