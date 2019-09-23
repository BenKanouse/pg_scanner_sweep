<template>
    <div class="activity-table">
        <h2> Activity on PG </h2>
        <table class="table-hover" v-if="data">
            <thead>
                <tr>
                    <th>Pid</th>
                    <th>Datid</th>
                    <th>Datname</th>
                    <th>State</th>
                    <th>Cancel Query</th>
                    <th class="query_column">Query</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(activity, idx) in data">
                    <td>{{ activity.pid }}</td>
                    <td>{{ activity.datid }}</td>
                    <td>{{ activity.datname }}</td>
                    <td>{{ activity.state }}</td>
                    <td><button @click="killActivity(activity)">Cancel Query!</button></td>
                    <td class="query_column">{{ activity.query }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>


<script>
export default {
  data() {
    return {
      data: null
    };
  },

  mounted() {
    this.getData();
  },

  methods: {
    getData() {
      this.$http.get('pg_stat_activities.json', {responseType: 'json'}).then(response => {
        return response.body;
      }).then(jsonData => {
        this.data = jsonData;
      }).catch(e => {
        console.log('Error', e);
      });
    },
    killActivity(activity) {
      this.$http.delete('pg_stat_activities/' + activity.pid, {responseType: 'json'}).then(response => {
        return response.body;
      }).then(jsonData => {
        this.$nextTick(this.getData);
      }).catch(e => {
        console.log('Error', e);
      });
    }
  }
}
</script>

<style scoped>
.query_column {
  word-wrap: break-word;
  max-width: 400px;
}
.activity-table td,th {
  padding-top:10px;
  padding-bottom:10px;
  padding-right:10px;
}

</style>
