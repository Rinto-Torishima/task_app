<template>
  <div class="min-h-screen bg-gray-100 py-8 px-4">
    <div class="max-w-4xl mx-auto bg-white shadow-md rounded-lg p-6">
      <h1 class="text-2xl font-bold text-gray-800 mb-6">タスク一覧</h1>
      <router-link
        to="/create"
        class="inline-block bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mb-4"
      >
        タスク作成
      </router-link>
      <ul class="space-y-4">
        <li
          v-for="task in filteredTasks"
          :key="task.id"
          class="p-4 bg-gray-50 shadow-sm rounded-md flex items-start justify-between"
        >
          <div class="w-3/4">
            <!-- タイトル -->
            <div>
              <span
                v-if="!isEditing(task.id)"
                class="text-lg font-semibold text-gray-800"
                >{{ task.title }}</span
              >
              <input
                v-else
                v-model="editForm.title"
                @keyup.enter="saveEdit(task.id)"
                placeholder="タイトルを編集"
                class="w-full p-2 border border-gray-300 rounded-md mt-2"
              />
            </div>
            <!-- 説明 -->
            <div class="mt-2">
              <span
                v-if="!isEditing(task.id)"
                class="text-gray-600"
                >{{ task.description }}</span
              >
              <textarea
                v-else
                v-model="editForm.description"
                @keyup.enter="saveEdit(task.id)"
                placeholder="説明を編集"
                class="w-full p-2 border border-gray-300 rounded-md mt-2"
              ></textarea>
            </div>
          </div>
          <div class="flex flex-col items-end space-y-2 w-1/4">
            <!-- 完了ボタン -->
            <button
              v-if="!task.completed"
              @click="markAsCompleted(task.id)"
              class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
            >
              完了
            </button>
            <!-- 編集/キャンセルボタン -->
            <div>
              <button
                v-if="!isEditing(task.id)"
                @click="startEdit(task)"
                class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600"
              >
                編集
              </button>
              <button
                v-else
                @click="cancelEdit"
                class="bg-gray-400 text-white px-4 py-2  rounded hover:bg-gray-500"
              >
                戻る
              </button>
            </div>
            <!-- 削除ボタン -->
            <button
              @click="deleteTask(task.id)"
              class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
            >
              削除
            </button>
          </div>
        </li>
      </ul>
      <button
        @click="toggleShowAll"
        class="mt-6 bg-indigo-500 text-white px-6 py-2 rounded hover:bg-indigo-600 block mx-auto"
      >
        {{ showAll ? "未完了のみ表示" : "完了済みも表示" }}
      </button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      tasks: [],
      showAll: false,
      editForm: {
        id: null,
        title: "",
        description: "",
      },
    };
  },
  computed: {
    filteredTasks() {
      return this.showAll ? this.tasks : this.tasks.filter(task => !task.completed);
    },
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
    async markAsCompleted(taskId) {
      try {
        const response = await axios.put(`/api/v1/tasks/${taskId}`, { completed: true });
        const updatedTask = response.data;

        this.tasks = this.tasks.map(task =>
          task.id === updatedTask.id ? updatedTask : task
        );
      } catch (error) {
        console.error('タスクの更新に失敗しました', error);
      }
    },
    async deleteTask(taskId) {
      try {
        await axios.delete(`/api/v1/tasks/${taskId}`);
        this.tasks = this.tasks.filter(task => task.id !== taskId);
      } catch (error) {
        console.error('タスクの削除に失敗しました', error);
      }
    },
    startEdit(task) {
      this.editForm.id = task.id;
      this.editForm.title = task.title;
      this.editForm.description = task.description;
    },
    isEditing(taskId) {
      return this.editForm.id === taskId;
    },
    cancelEdit() {
      this.editForm.id = null;
      this.editForm.title = "";
      this.editForm.description = "";
    },
    async saveEdit(taskId) {
      try {
        const response = await axios.put(`/api/v1/tasks/${taskId}`, {
          title: this.editForm.title,
          description: this.editForm.description,
        });
        const updatedTask = response.data;

        this.tasks = this.tasks.map(task =>
          task.id === updatedTask.id ? updatedTask : task
        );

        this.cancelEdit();
      } catch (error) {
        console.error('タスクの編集に失敗しました', error);
      }
    },
    toggleShowAll() {
      this.showAll = !this.showAll;
    },
  },
};
</script>