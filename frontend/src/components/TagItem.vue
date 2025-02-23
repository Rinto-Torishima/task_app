<template>
    <li class="p-4 bg-gray-50 shadow-sm rounded-md flex items-start justify-between">
      <div class="w-3/4">
        <span class="text-lg font-semibold text-gray-800">{{ tag.name }}</span>
        <button
          @click="deleteTag"
          class="ml-4 text-red-500 hover:text-red-700"
        >
          削除
        </button>
      </div>
    </li>
  </template>
  
  <script>
  import axios from 'axios';

  export default {
    props: {
      tag: {
        type: Object,
        required: true,
      },
    },
    methods: {
      async deleteTag() {
        try {
          await axios.delete(`/api/v1/tags/${this.tag.id}`);
          this.$emit('tagDeleted', this.tag.id);  // 親コンポーネントに削除されたタグのIDを通知
        } catch (error) {
          console.error('タグの削除に失敗しました', error);
        }
      },
    },
  };
  </script>