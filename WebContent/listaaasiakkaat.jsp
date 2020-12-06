<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/tyylit.css">
<title>Asiakkaiden haku</title>
</head>
<body>

	<table id="listaus">
		<thead>
			<tr>
				<th colspan="6" class="oikealle"><span id="uusiAsiakas">Lis�� uusi asiakas</span></th>
			</tr>
			<tr>
				<th class="oikealle">Hakusana:</th>
				<th colspan="4" class="vasemmalle"><input type="text" id="hakusana"></th>
				<th class="vasemmalle"><input type="button" value="hae" class="nappi" id="hakunappi"></th>
			</tr>
			<tr class="vasemmalle">
				<th>Asiakasnro</th>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>S�hk�posti</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>

	<script type="text/javascript">
		$(document).ready(function() {
			
			$("#uusiAsiakas").click(function() {
				document.location="lisaaasiakas.jsp";
			});
			
			haeAsiakkaat();
			$("#hakunappi").click(function() {
				haeAsiakkaat();
			});
			$(document.body).on("keydown", function(event) {
				if (event.which == 13) { //Enteri� painettu, ajetaan haku
					haeAsiakkaat();
				}
			});
			$("#hakusana").focus();//vied��n kursori hakusana-kentt��n sivun latauksen yhteydess�
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
						htmlStr += "<tr id='rivi_"+field.asiakas_id +"'>";
						htmlStr += "<td>" + field.asiakas_id + "</td>";
						htmlStr += "<td>" + field.etunimi + "</td>";
						htmlStr += "<td>" + field.sukunimi + "</td>";
						htmlStr += "<td>" + field.puhelin + "</td>";
						htmlStr += "<td>" + field.sposti + "</td>";
						htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+field.asiakas_id+"'>Muuta</a>&nbsp;";
						htmlStr+="<span class='poista' onclick=poista('"+field.asiakas_id+"')>Poista</span></td>";
						htmlStr += "</tr>";
						$("#listaus tbody").append(htmlStr);
					});
				}
			})
		};
	
		
		function poista(asiakas_id){
			if(confirm("Poista asiakas " + asiakas_id +"?")){
				$.ajax({url:"asiakkaat/"+asiakas_id, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
			        if(result.response==0){
			        	$("#ilmo").html("Asiakkaan poisto ep�onnistui.");
			        }else if(result.response==1){
			        	$("#rivi_"+asiakas_id).css("background-color", "red"); //V�rj�t��n poistetun asiakkaan rivi
			        	alert("Asiakkaan " + asiakas_id +" poisto onnistui.");
			        	haeAsiakkaat();        	
					}
			    }});
			}
		}	
	</script>

</body>
</html>