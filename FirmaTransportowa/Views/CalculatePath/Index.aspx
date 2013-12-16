<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Simple Map</title>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
        <meta charset="utf-8">
        <style>
            html, body, #map-canvas {
                height: 100%;
                margin: 0px;
                padding: 0px
            }
        </style>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"> </script>
        <script type="text/javascript" src="scripts/jquery-1.8.2.min.js"> </script>
        <script>
            var bounds = new google.maps.LatLngBounds();
            var geocoder;
            var directionsDisplay;
            var directionsService = new google.maps.DirectionsService();
            var map;
            var markersPos = [];
            var distances;
            var number = 0;
            var path;

            var i = 0;

            function initialize() {
                directionsDisplay = new google.maps.DirectionsRenderer();
                var mapOptions = {
                    zoom: 7,
                    center: new google.maps.LatLng(50, 20)
                };
                map = new google.maps.Map(document.getElementById('map-canvas'),
                    mapOptions);

                google.maps.event.addListener(map, 'click', function(event) {
                    placeMarker(event.latLng);
                });
                directionsDisplay.setMap(map);
                geocoder = new google.maps.Geocoder();

            }

            function placeMarker(location) {
                var marker = new google.maps.Marker({
                    position: location,
                    map: map,
                    icon: 'https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=' + ++number + '|FF776B|000000',
                    shadow: 'https://chart.googleapis.com/chart?chst=d_map_pin_shadow'
                });
                markersPos.push(marker);
            }

            function Create2DArray(rows) {
                var arr = [];
                for (var i = 0; i < rows; i++) {
                    arr[i] = [];
                }
                return arr;
            }            

            function calculateDistances() {

                $(function () {
                    $.ajax({
                        type: 'POST',
                        url: '/CalculatePath/SetParams',
                        data: JSON.stringify([document.getElementById("iterations").value, document.getElementById("fireflies").value]),
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: distancesCallback
                    });
                });
                
            }

            function distancesCallback(response, status) {
                var service = new window.google.maps.DistanceMatrixService();
                var origins = [];
                var destinations = [];

                markersPos.forEach(function (marker) {
                    origins.push(marker.position);
                    destinations.push(marker.position);
                }
                );
                
                service.getDistanceMatrix(
                    {
                        origins: origins,
                        destinations: destinations,
                        travelMode: window.google.maps.TravelMode.DRIVING,
                        unitSystem: window.google.maps.UnitSystem.METRIC,
                        avoidHighways: false,
                        avoidTolls: false
                    }, sendDistances);

                }
            
            function sendDistances(response, status) {
                if (status != google.maps.DistanceMatrixStatus.OK) {
                    alert('Error was: ' + status);
                } else {
                    var origins = response.originAddresses;
                    var destinations = response.destinationAddresses;
                    var outputDiv = document.getElementById('content');
                    distances = Create2DArray(origins.length);
                    outputDiv.innerHTML = '';
                    for (var i = 0; i < origins.length; i++) {
                        var results = response.rows[i].elements;
                        for (var j = 0; j < results.length; j++) {
                            distances[i][j] = results[j].distance.value;
                        }
                    }
                    var outputDiv = document.getElementById('distance');
                    outputDiv.innerHTML = '';
                    outputDiv.innerHTML += "Czekaj...";
                    $(function () {
                        $.ajax({
                            type: 'POST',
                            url: '/CalculatePath',
                            data: JSON.stringify(distances),
                            contentType: 'application/json; charset=utf-8',
                            dataType: 'json',
                            success: solutionCallback
                        });
                    });
                }
            }

            function solutionCallback(msg) {
                var solution = msg.permutation;
                
                var outputDiv = document.getElementById('distance');
                outputDiv.innerHTML = '';
                outputDiv.innerHTML += msg.cost / 1000 + " km";
                
                var outputDiv2 = document.getElementById('iteration');
                outputDiv2.innerHTML = '';
                outputDiv2.innerHTML += "Rozw znalezione w "+msg.iteration+" iteracji";
                
                var outputDiv3 = document.getElementById('time');
                outputDiv3.innerHTML = '';
                outputDiv3.innerHTML += "Czas" + msg.len / 1000 + " sek";

                
                var coords = [];
                var last;
                for (var iter = 0; iter < solution.length; iter++) {
                    if (iter == 0)
                        last = markersPos[solution[iter]].position;
                    coords.push(markersPos[solution[iter]].position);
                    markersPos[solution[iter]].setIcon('https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=' + (iter + 1) + '|FF776B|000000');
                    markersPos[solution[iter]].setShadow('https://chart.googleapis.com/chart?chst=d_map_pin_shadow');

                }

                coords.push(last);
                
                if (path)
                    path.setMap(null);
                
                path = new google.maps.Polyline({
                    path: coords,
                    geodesic: true,
                    strokeColor: '#FF0000',
                    strokeOpacity: 1.0,
                    strokeWeight: 2
                });

                path.setMap(map);
            }

            function show() {
                directionsDisplay = new google.maps.DirectionsRenderer();
                directionsDisplay.setMap(map);
                calcRoute();
                var coords = [];
                markersPos.forEach(function(marker) {
                    coords.push(marker.position);
                }
                );
            }

            google.maps.event.addDomListener(window, 'load', initialize);
        </script>
    </head>
    <body>
        <div id="send" style="height: 60px; left: 0px; top: 0px; width: 100%;">
            <div id="calculate" onclick=" calculateDistances()" style="height: 100%; float:left; font-size: 40px; width: 250px; border-right: solid 1px;">Licz</div>
            <input id="iterations" type="number" placeholder="iterations"/>
            <input id="fireflies" type="number" placeholder="fireflies"/>
            <div id="distance" style="height: 100%; float:left; font-size: 40px; border-right: solid 1px;"></div>
            <div id="iteration" style="height: 100%; float:left; font-size: 40px; border-right: solid 1px;"></div>
            <div id="time" style="height: 100%; float:left; font-size: 40px; border-right: solid 1px;"></div>
        </div>
        <div id="content"></div>
        <div id="map-canvas"></div>
    </body>
</html>