<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Asiakkaiden haku</title>
<style>
.oikealle {
	text-align: right;
}
.vasemmalle {
	text-align: left;
}

html {
font-family: verdana;
font-size: 14;
}

table {
  width: 50%;
}

th {
  background-color: #4CAF50;
  color: white;
  height: 50px;
  padding: 15px;
}

td {
 padding: 15px;
}

tr:nth-child(even) {
  background-color: #f2f2f2;
}

.nappi {font-size: 18px;}

</style>
</head>
<body>

	<table id="listaus">
		<thead>
			<tr>
				<th class="oikealle">Hakusana:</th>
				<th colspan="3" class="vasemmalle"><input type="text" id="hakusana"></th>
				<th class="vasemmalle"><input type="button" value="hae" class="nappi" id="hakunappi"></th>
			</tr>
			<tr class="vasemmalle">
				<th>Asiakasnro</th>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sähköposti</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>

	<script type="text/javascript">
		$(document).ready(function() {
			haeAsiakkaat();
			$("#hakunappi").click(function() {
				haeAsiakkaat();
			});
			$(document.body).on("keydown", function(event) {
				if (event.which == 13) { //Enteriä painettu, ajetaan haku
					haeAsiakkaat();
				}
			});
			$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
		});

		function haeAsiakkaat() {
			$("#listaus tbody").empty();
			$.ajax({
				url : "asiakkaat/" + $("#hakusana").val(),
				type : "GET",
				dataType : "json",
				success : function(result) {//Funktio palauttaa tiedot json-objektina		
					$.each(result.asiakkaat, function(i, field) {
						var htmlStr;
						htmlStr += "<tr>";
						htmlStr += "<td>" + field.asiakas_id + "</td>";
						htmlStr += "<td>" + field.etunimi + "</td>";
						htmlStr += "<td>" + field.sukunimi + "</td>";
						htmlStr += "<td>" + field.puhelin + "</td>";
						htmlStr += "<td>" + field.sposti + "</td>";
						htmlStr += "</tr>";
						$("#listaus tbody").append(htmlStr);
					});
				}
			})
		};
	</script>

</body>
</html>