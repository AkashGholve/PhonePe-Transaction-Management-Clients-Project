<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Uploaded Transactions</title>
<!-- Include Bootstrap CSS -->
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Include Bootstrap Datepicker CSS -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css"
	rel="stylesheet">
</head>
<body>
	<div class="container">
		<h2>Uploaded Transactions</h2>
		<!-- Search input field -->
		<div class="row mb-2">
			<div class="col-md-4">
				<input type="text" id="searchInput" placeholder="Search..."
					class="form-control">
			</div>
			<!-- Input box for transaction amount -->
			<div class="col-md-2">
				<input type="number" id="filterTransactionAmount"
					placeholder="Filter Amount" class="form-control">
			</div>
			<!-- Calendar for selecting date range -->
			<div class="col-md-4">
				<div class="input-group">
					<input type="text" id="startDatePicker" class="form-control"
						placeholder="Start Date (mmm dd, yyyy)">
					<div class="input-group-append">
						<span class="input-group-text">to</span>
					</div>
					<input type="text" id="endDatePicker" class="form-control"
						placeholder="End Date (mmm dd, yyyy)">
				</div>
			</div>
			<div class="col-md-2">
				<button id="dateFilterSubmit" class="btn btn-primary">Apply
					Date Filter</button>
			</div>
			<!-- Dropdown for transaction type -->
			<div class="col-md-2">
				<select id="filterTransactionType" class="form-control">
					<option value="">Filter Transaction Type</option>
					<option value="credit">Credit</option>
					<option value="debit">Debit</option>
				</select>
			</div>
		</div>

		<table id="transactionTable" class="table table-bordered">
			<thead>
				<tr>
					<th>Transaction ID</th>
					<th>Transaction Amount</th>
					<th>Transaction Date</th>
					<th>Transaction Type</th>
				</tr>
			</thead>
			<tbody id="transactionTableBody">
				<!-- Transaction data will be dynamically added here -->
				<c:forEach items="${transactionsPage.content}" var="transaction">
					<tr>
						<td>${transaction.transaction_id}</td>
						<td>${transaction.transaction_amount}</td>
						<td>${transaction.transaction_date}</td>
						<td>${transaction.transaction_type}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- Pagination -->
		<nav aria-label="Page navigation">
			<ul class="pagination">
				<c:if test="${transactionsPage.totalPages > 1}">
					<li class="page-item"><a class="page-link" href="?page=0">First</a></li>
					<c:forEach begin="0" end="${transactionsPage.totalPages - 1}"
						var="i">
						<li
							class="page-item ${transactionsPage.number == i ? 'active' : ''}">
							<a class="page-link" href="?page=${i}">${i + 1}</a>
						</li>
					</c:forEach>
					<li class="page-item"><a class="page-link"
						href="?page=${transactionsPage.totalPages - 1}">Last</a></li>
				</c:if>
			</ul>
		</nav>

		<!-- Clear Filters button -->
		<div class="text-center">
			<button id="clearFiltersBtn" class="btn btn-secondary">Clear
				Filters</button>
		</div>

		<!-- Add a button for CSV export -->
		<button id="exportCsvBtn" class="btn btn-success">Export as
			CSV</button>
	</div>

	<!-- Include Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<!-- Include Bootstrap Datepicker JS -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>

	<script>
		document.addEventListener('DOMContentLoaded', function() {
			// Search functionality
			document.getElementById('searchInput').addEventListener('input',
					function() {
						filterTableByCriteria();
					});

			// Filtering by transaction type
			document.getElementById('filterTransactionType').addEventListener(
					'change', function() {
						filterTableByCriteria();
					});

			// Filtering by transaction amount
			document.getElementById('filterTransactionAmount')
					.addEventListener('input', function() {
						filterTableByCriteria();
					});

			// Initialize datepickers
			$('#startDatePicker').datepicker({
				format : 'M dd, yyyy',
				autoclose : true,
				todayHighlight : true
			});

			$('#endDatePicker').datepicker({
				format : 'M dd, yyyy',
				autoclose : true,
				todayHighlight : true
			});

			// Apply date filter on button click
			document.getElementById('dateFilterSubmit').addEventListener(
					'click', function() {
						filterTableByCriteria();
					});

			// Clear Filters button functionality
			document.getElementById('clearFiltersBtn').addEventListener(
					'click', function() {
						clearFilters();
					});

			// Bind click event to export button
			document.getElementById("exportCsvBtn").addEventListener("click",
					function() {
						convertTableToCSV();
					});
		});

		// Function to filter table by criteria
		function filterTableByCriteria() {
			var searchText = document.getElementById('searchInput').value
					.toLowerCase();
			var filterTransactionType = document
					.getElementById('filterTransactionType').value
					.toLowerCase();
			var filterTransactionAmount = parseFloat(document
					.getElementById('filterTransactionAmount').value);
			var startDate = $('#startDatePicker').val();
			var endDate = $('#endDatePicker').val();

			var rows = document.querySelectorAll('#transactionTableBody tr');
			rows
					.forEach(function(row) {
						var transactionText = row.textContent.toLowerCase();
						var transactionType = row
								.querySelector('td:nth-child(4)').textContent
								.toLowerCase();
						var transactionAmount = parseFloat(row
								.querySelector('td:nth-child(2)').textContent);
						var transactionDate = row
								.querySelector('td:nth-child(3)').textContent
								.trim();
						var transactionDateObj = new Date(transactionDate);
						var startDateTime = new Date(startDate);
						var endDateTime = new Date(endDate);

						var validSearch = searchText === ''
								|| transactionText.includes(searchText);
						var validType = filterTransactionType === ''
								|| transactionType === filterTransactionType;
						var validAmount = isNaN(filterTransactionAmount)
								|| transactionAmount === filterTransactionAmount;
						var validDateRange = (startDate === '' || transactionDateObj >= startDateTime)
								&& (endDate === '' || transactionDateObj <= endDateTime);

						if (validSearch && validType && validAmount
								&& validDateRange) {
							row.style.display = '';
						} else {
							row.style.display = 'none';
						}
					});
		}

		// Function to clear all filters
		function clearFilters() {
			document.getElementById('searchInput').value = '';
			document.getElementById('filterTransactionType').value = '';
			document.getElementById('filterTransactionAmount').value = '';
			$('#startDatePicker').datepicker('setDate', null);
			$('#endDatePicker').datepicker('setDate', null);
			filterTableByCriteria();
		}

		// Function to convert table data to CSV
		function convertTableToCSV() {
			var csv = [];
			var rows = document.querySelectorAll("#transactionTableBody tr");

			// Iterate through table rows
			rows.forEach(function(row) {
				var rowData = [];
				var cols = row.querySelectorAll("td");

				// Iterate through table columns
				cols.forEach(function(col) {
					rowData.push(col.textContent.trim());
				});

				// Join column data with comma separator
				csv.push(rowData.join(","));
			});

			// Join rows with newline separator
			var csvContent = csv.join("\n");

			// Create a Blob containing the CSV data
			var blob = new Blob([ csvContent ], {
				type : "text/csv;charset=utf-8;"
			});

			// Create a temporary anchor element to trigger download
			var link = document.createElement("a");
			if (link.download !== undefined) { // feature detection
				var url = URL.createObjectURL(blob);
				link.setAttribute("href", url);
				link.setAttribute("download", "transactions.csv");
				link.style.visibility = "hidden";
				document.body.appendChild(link);
				link.click();
				document.body.removeChild(link);
			}
		}
	</script>
</body>
</html>
