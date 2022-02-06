<template>
  <div
    class="group flex flex-row items-center mt-6 w-5/6 h-32 bg-gray-100 rounded-xl drop-shadow-md"
  >
    <div class="h-full w-1/4 flex items-center justify-center ring-0">
      <div
        class="flex items-center justify-center bg-blue-300 w-3/4 h-3/4 rounded-lg"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="z-10 h-8 w-8 text-indigo-900"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            :d="svg_path"
          />
        </svg>
      </div>
    </div>
    <div class="grid grid-cols-2 grid-rows-2 h-3/4 w-3/4 font-spline">
      <div class="flex flex-col items-center justify-center bg-3 row-span-2">
        <span class="font-bold group-hover:underline">{{ name1 }}</span>
        <span
          class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150"
          >{{ data1 }}</span
        >
      </div>
      <div class="flex flex-col items-center justify-center bg-3 row-span-2">
        <span class="font-bold group-hover:underline">{{ name2 }}</span>
        <span
          class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150"
          >{{ data2 }}</span
        >
      </div>
      <div class="flex flex-col items-center justify-center bg-3 row-span-2">
        <span class="font-bold group-hover:underline">{{ name3 }}</span>
        <span
          class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150"
          >{{ data3 }}</span
        >
      </div>
      <div class="flex flex-col items-center justify-center bg-3 row-span-2">
        <span class="font-bold group-hover:underline">{{ name4 }}</span>
        <span
          class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150"
          >{{ data4 }}</span
        >
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "InfoBox",
  props: [
    "data1",
    "data2",
    "data3",
    "data4",
    "name1",
    "name2",
    "name3",
    "name4",
    "svg_path",
  ],
};
</script>
