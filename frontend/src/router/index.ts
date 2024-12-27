import { createRouter, createWebHistory } from 'vue-router';
import TaskList from '../components/TaskList.vue';
import TaskForm from '../components/TaskForm.vue';
import TagsList from '../components/TagsList.vue';
import TagsCreate from '../components/TagsCreate.vue';


const routes = [
  { path: '/', component: TaskList },
  { path: '/create', component: TaskForm },
  {
    path: '/tags',
    name: 'TagsList',
    component: TagsList,
  },
  {
    path: '/tags/create',
    name: 'TagsCreate',
    component: TagsCreate,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;