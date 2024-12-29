import { createRouter, createWebHistory } from 'vue-router';
import TaskList from '@/pages/TaskListPage.vue';
import TaskForm from '@/pages/TaskFormPage.vue';
import TagsListPage from '@/pages/TagsListPage.vue';
import TagsCreatePage from '@/pages/TagsCreatePage.vue';

const routes = [
  { path: '/', component: TaskList },
  { path: '/create', component: TaskForm },
  {
    path: '/tags',
    name: 'TagsList',
    component: TagsListPage,
  },
  {
    path: '/tags/create',
    name: 'TagsCreate',
    component: TagsCreatePage,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;