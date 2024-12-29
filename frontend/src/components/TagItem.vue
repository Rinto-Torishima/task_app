<template>
    <li class="p-4 bg-gray-50 shadow-sm rounded-md flex items-start justify-between">
      <div class="w-3/4">
        <span class="text-lg font-semibold text-gray-800">{{ tag.name }}</span>
      </div>
    </li>
  </template>
  
  <script>
  export default {
    props: {
      tag: {
        type: Object,
        required: true,
      },
    },
  };
  </script>