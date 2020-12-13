<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/tyylit.css">
<title>Asiakkaiden haku</title>
</head>
<body onkeydown="tutkiKey(event)">

	<table id="listaus">
		<thead>
			<tr>
				<th colspan="4" id="ilmo"></th>
				<th colspan="2" class="oikealle"><a href="lisaaasiakas.jsp"
					id="uusiAsiakas">Lisää uusi asiakas</a></th>
			</tr>
			<tr>
				<th class="oikealle">Hakusana:</th>
				<th colspan="4" class="vasemmalle"><input type="text"
					id="hakusana"></th>
				<th class="vasemmalle"><input type="button" value="hae"
					class="nappi" id="hakunappi"></th>
			</tr>
			<tr class="vasemmalle">
				<th>Asiakasnro</th>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sähköposti</th>
				<th></th>
			</tr>
		</thead>

		<tbody id="tbody">
		</tbody>
	</table>

	<script>
		haeAsiakkaat();
		document.getElementById("hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä

		function tutkiKey(event) {
			if (event.keyCode == 13) {//Enter
				haeAsiakkaat();
			}
		}

		function haeAsiakkaat() {

			document.getElementById("tbody").innerHTML = "";
			fetch("asiakkaat/" + document.getElementById("hakusana").value, {//Lähetetään kutsu backendiin
				method : 'GET'
			})
					.then(function(response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
						return response.json()
					})
					.then(
							function(responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
								var asiakkaat = responseJson.asiakkaat;
								var htmlStr = "";
								for (var i = 0; i < asiakkaat.length; i++) {
									htmlStr += "<tr>";
									//htmlStr += "<td>"+asiakkaat[i].asiakas_id +"</td>";
									htmlStr += "<td>" + asiakkaat[i].asiakas_id
											+ "</td>";
									htmlStr += "<td>" + asiakkaat[i].etunimi
											+ "</td>";
									htmlStr += "<td>" + asiakkaat[i].sukunimi
											+ "</td>";
									htmlStr += "<td>" + asiakkaat[i].puhelin
											+ "</td>";
									htmlStr += "<td>" + asiakkaat[i].sposti
											+ "</td>";
									htmlStr += "<td><a href='muutaasiakas.jsp?asiakas_id="
											+ asiakkaat[i].asiakas_id
											+ "'>Muuta</a>&nbsp;";
									htmlStr += "<span class='poista' onclick=poista('"
											+ asiakkaat[i].asiakas_id
											+ "')>Poista</span></td>";
									htmlStr += "</tr>";
								}
								document.getElementById("tbody").innerHTML = htmlStr;
							})
		}

		function poista(asiakas_id) {
			if (confirm("Poista asiakas " + asiakas_id + "?")) {
				fetch("asiakkaat/" + asiakas_id, {
					method : 'DELETE'
				})

						.then(function(response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
							return response.json()
						})
						.then(
								function(responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
									var vastaus = responseJson.response;
									if (vastaus == 0) {
										document.getElementById("ilmo").innerHTML = "Asiakkaan poisto epäonnistui.";
									} else if (vastaus == 1) {
										document.getElementById("ilmo").innerHTML = "Asiakkaan "
												+ asiakas_id
												+ " poisto onnistui.";
										haeAsiakkaat();
									}
									setTimeout(
											function() {
												document.getElementById("ilmo").innerHTML = "";
											}, 5000);
								})

			}
		}
	</script>

</body>
</html>