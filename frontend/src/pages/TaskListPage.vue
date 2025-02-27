<template>
  <PageLayout>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">タスク一覧</h1>
    <router-link
      to="/create"
      class="inline-block bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mb-4"
    >
      タスク作成
    </router-link>
    <router-link
      to="/tags/create"
      class="ml-2 inline-block bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mb-4"
    >
      タグ作成
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
              placeholder="説明を編集"
              class="w-full p-2 border border-gray-300 rounded-md mt-2"
            ></textarea>
          </div>
          <div v-if="isEditing(task.id)" class="mt-2">
            <button @click="saveEdit(task.id)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">保存</button>
          </div>
          <div v-if="task.tags && task.tags.length > 0" class="mt-2">
            <span
              v-for="tag in task.tags"
              :key="tag.id"
              class="inline-block bg-gray-200 text-gray-700 px-2 py-1 rounded-full text-sm mr-2"
            >
              {{ tag.name }}
            </span>
          </div>
          <div v-if="isEditing(task.id)" class="mt-4">
            <h3 class="text-gray-700 font-semibold mb-2">タグ編集</h3>
            <div>
              <label
                v-for="tag in allTags"
                :key="tag.id"
                class="inline-flex items-center mr-4"
              >
                <input
                  type="checkbox"
                  :value="tag.id"
                  v-model="editForm.tag_ids"
                  class="mr-1"
                />
                {{ tag.name }}
              </label>
            </div>
          </div>
        </div>
        <div class="flex flex-col items-end space-y-2 w-1/4">
          <!-- 完了・未完了ボタン -->
          <button
            v-if="task.completed"
            @click="markAsIncomplete(task.id)"
            class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600"
          >
            未完了
          </button>
          <button
            v-else
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
  </PageLayout>
</template>

<script>
import axios from 'axios';
import PageLayout from '@/components/PageLayout.vue';

export default {
  components: {
    PageLayout,
  },
  data() {
    return {
      tasks: [],
      allTags: [],
      showAll: false,
      editForm: {
        id: null,
        title: "",
        description: "",
        tag_ids: [],
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
    this.fetchTags();
  },
  methods: {
    async fetchTasks() {
      try {
        const response = await axios.get('/api/v1/tasks');
        this.tasks = response.data.sort((a, b) => {
          // 未完了の優先度が高い（false が上）
          return a.completed - b.completed;
        });      
      } catch (error) {
        console.error('タスクの取得に失敗しました', error);
      }
    },
    async fetchTags() {
      try {
        const response = await axios.get('/api/v1/tags');
        this.allTags = response.data;
      } catch (error) {
        console.error('タグの取得に失敗しました', error);
      }
    },
    async markAsCompleted(taskId) {
      try {
        const response = await axios.put(`/api/v1/tasks/${taskId}`, { completed: true });
        const updatedTask = response.data;

        this.tasks = this.tasks.map(task =>
          task.id === updatedTask.id ? updatedTask : task
        );

        // 編集中のタスクが削除された場合に編集状態をリセット
        if (this.editForm.id === taskId) {
          this.cancelEdit();
        }

      } catch (error) {
        console.error('タスクの更新に失敗しました', error);
      }
    },
    async markAsIncomplete(taskId) {
      try {
        const response = await axios.put(`/api/v1/tasks/${taskId}`, { completed: false });
        const updatedTask = response.data;

        this.tasks = this.tasks.map(task =>
          task.id === updatedTask.id ? updatedTask : task
        );

        if (this.editForm.id === taskId) {
          this.cancelEdit();
        }

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
      this.editForm.tag_ids = task.tags.map(tag => tag.id);
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
          tag_ids: this.editForm.tag_ids
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