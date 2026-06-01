document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.ranking-table').forEach(function (table) {
    var mainBody = table.querySelector('tbody');
    var collapseBody = table.querySelector('tbody.collapse');
    table.querySelectorAll('th.sortable').forEach(function (th) {
      th.style.cursor = 'pointer';
      th.addEventListener('click', function () {
        var column = parseInt(th.dataset.column, 10);
        var order = th.dataset.order === 'asc' ? 'desc' : 'asc';
        th.dataset.order = order;
        var rows = Array.from(table.querySelectorAll('tbody tr'));
        rows.sort(function (a, b) {
          var aText = a.children[column].textContent.replace(/\s+/g, '').replace(',', '.');
          var bText = b.children[column].textContent.replace(/\s+/g, '').replace(',', '.');
          var aVal = parseFloat(aText) || 0;
          var bVal = parseFloat(bText) || 0;
          return order === 'asc' ? aVal - bVal : bVal - aVal;
        });
        if (collapseBody) {
          collapseBody.innerHTML = '';
        }
        mainBody.innerHTML = '';
        rows.forEach(function (row, index) {
          if (index < 10 || !collapseBody) {
            mainBody.appendChild(row);
          } else {
            collapseBody.appendChild(row);
          }
        });
      });
    });
  });
});