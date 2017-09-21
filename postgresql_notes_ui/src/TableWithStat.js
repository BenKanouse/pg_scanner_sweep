import React from 'react';
import {
  Table,
  TableBody,
  TableHeader,
  TableHeaderColumn,
  TableRow,
  TableRowColumn,
} from 'material-ui/Table';

class TableWithStat extends React.Component {
   constructor(props) {
      super(props);
      this.state = {
         data: [{usename: 'username'}]
      }
   }

  componentDidMount() {
    var component = this;
    console.log('componentDidMount');
    fetch('http://localhost:4567/pg_activity_stats')
    .then( (response) => {
      return response.json()
    })
    .then( (myJson) => {
      component.setState({data: myJson})
    })
  }

  render() {
  var json = this.state.data
  var tableHeaders = [];
  var headers = [];
  for (var header in json[0]) {
    if (header !== 'client_addr') {
      headers.push(header);
      tableHeaders.push(<TableHeaderColumn key= { 'header_' + header} > {header} </TableHeaderColumn>);
    };
  };

  var tableRows = [];
  for (var rowIndex = 0; rowIndex < json.length; rowIndex++) {
    var tableRow = [];
    for (var columnIndex = 0; columnIndex < headers.length; columnIndex++) {
      tableRow.push(<TableRowColumn key= { 'row_column_' + rowIndex + '_' + columnIndex }> {json[rowIndex][headers[columnIndex]]} </TableRowColumn>);
    }
    tableRows.push(<TableRow key= { 'row_' + rowIndex }> {tableRow} </TableRow>);
  }

  return (
    <Table>
      <TableHeader>
        <TableRow>
          { tableHeaders }
        </TableRow>
      </TableHeader>
      <TableBody>
          { tableRows }
      </TableBody>
    </Table>
  );

  }
}
export default TableWithStat;
