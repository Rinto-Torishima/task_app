<template>
    <PageLayout>
        <h1 class="text-2xl font-bold text-gray-800 mb-6">タグ作成</h1>
        <form @submit.prevent="createTag">
          <!-- タグ名 -->
          <input
            v-model="tag.name"
            type="text"
            placeholder="タグ名"
            required
            class="w-full p-2 mb-4 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
  
          <!-- 作成ボタン -->
          <button
            type="submit"
            class="w-full py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition"
          >
            作成
          </button>
  
          <!-- タグ一覧へのリンク -->
          <router-link to="/tags" class="inline-block mt-4 text-center w-full text-blue-600 hover:underline">
            タグ一覧
          </router-link>
          <router-link to="/" class="inline-block mt-4 text-center w-full text-blue-600 hover:underline">
            タスク一覧
          </router-link>
        </form>
      </PageLayout>
    </template>
    
    <script>
    import axios from 'axios';
    import { useToast } from "vue-toastification";
    import PageLayout from '@/components/PageLayout.vue';
import router from '@/router';
    
    export default {
      components: {
        PageLayout,
      },
      data() {
        return {
          tag: {
            name: '',  // タグ名
          },
        };
      },
      methods: {
        async createTag() {
          const toast = useToast();
          try {
            const response = await axios.post('/api/v1/tags', {
              tag: this.tag,
            });
            toast.success("タグが作成されました");
            // フィールドをリセット
            this.tag.name = '';
          } catch (error) {
            toast.error("タグの作成に失敗しました");
          }
        },
      },
    };
    </script>