<template>
  <table>
    <thead>
      <tr>
        <th v-for="th in tHead" :key="th">{{ th }}</th>
      </tr>
    </thead>
    <tbody class="noscroll">
      <tr v-for="(row, i) in rows" :key="i">
        <td>{{ i + 1 }}</td>
        <td v-for="key in tdKeys" :key="key">{{ row[key] }}</td>
      </tr>
    </tbody>
  </table>
</template>

<script lang="js">
export default {
  props: ["tHead", "lookUp"],
  data () {
    return {
      rows: [],
      allKeys: {
        my_stats: ['room', 'place'],
        leaderboard: ['username', 'points']
      }
    }
  },
  mounted() {
    this.fetchData()
  },
  computed: {
    tdKeys() {
      return this.allKeys[this.lookUp]
    }
  },
  methods: {
    fetchData() {
      fetch(`/api/users/${this.lookUp}`, {
        headers: {
          "Authorization": `Bearer ${localStorage.getItem("liu")}`
        }
      }).then(res => res.json())
        .then(data => {
          if (data.code === 200) {
            this.rows = data.records
          }
        })
        .catch(err => err)
    }
  }
}
</script>

<style scoped>
table {
  width: inherit;
  background-color: #0050a0;
  border-radius: 8px;
  margin-top: 12vh;
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
  text-align: center;
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
