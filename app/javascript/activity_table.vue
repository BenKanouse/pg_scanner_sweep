<template>
    <div class="activity-table">
        <h2> Activity on PG </h2>
        <table class="table-hover" v-if="data">
            <thead>
                <tr>
                    <th>datid</th>
                    <th>datname</th>
                    <th>pid</th>
                    <th class="query_column">query</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(item, idx) in data">
                    <td>{{ item.datid }}</td>
                    <td>{{ item.datname }}</td>
                    <td>{{ item.pid }}</td>
                    <td class="query_column">{{ item.query }}</td>
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
    }
}
}
</script>

<style scoped>
.query_column {
  word-wrap: break-word;
  max-width: 400px;
}
</style>
