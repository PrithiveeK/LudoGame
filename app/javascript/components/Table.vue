<template>
  <table>
    <thead>
      <tr>
        <th v-for="th in tHead" :key="th">{{ th }}</th>
      </tr>
    </thead>
    <tbody class="noscroll">
      <tr v-for="i in 20" :key="i"></tr>
    </tbody>
  </table>
</template>

<script lang="js">
export default {
  props: ["tHead", "lookUp"]
}
</script>

<style scoped>
table {
  width: inherit;
  background-color: #0050a0;
  border-radius: 8px;
  margin-top: 12vh;
}
thead > tr {
  color: white;
}
tbody {
  display: block;
  max-height: calc(60vh - 105px);
  overflow: auto;
}
tr {
  display: table;
  table-layout: fixed;
  width: 100%;
  height: 50px;
}
tr {
  border-bottom: 2px solid #fff;
}
tr:nth-child(even) {
  background-color: #0050a090;
  filter: brightness(0.78);
}
th:not(:last-child) {
  border-right: 2px solid #fff;
}
</style>
