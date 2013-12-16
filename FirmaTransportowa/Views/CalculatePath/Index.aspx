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
        <link type="text/css" rel="stylesheet" href="Content/themes/base/css" />
        <link type="text/css" rel="stylesheet" href="Content/css" />
        <script type="text/javascript" src="bundles/jquery"> </script>
        <script type="text/javascript" src="bundles/bootstrap"> </script>
        <script type="text/javascript" src="bundles/path"> </script>
    </head>
    <body>
        <div style="width:100%; height: 100%;">
            <div style="float:left; width:25%; height: 100%;">
                <div class="panel panel-default">
                  <div class="panel-heading">Parametry</div>
                  <div class="panel-body">
                    <div class="table" id="send">
                        <tr>
                            <td>
                                <ul style="display: inline-block" class="list-group">
                                  <li class="list-group-item">
                                       <span class="label label-default">Iteracje: </span>
                                      <input class="form-control" id="iterations" type="number" value="200"/>
                                  </li>
                                  <li class="list-group-item">
                                      <span class="label label-default">Świetliki: </span>
                                      <input class="form-control" id="fireflies" type="number" value="20"/>
                                  </li>
                                </ul>
                            </td>
                            <td>
                                <ul style="display: inline-block" class="list-group">
                                  <li class="list-group-item">
                                       <span class="label label-default">W której iteracji znaleziono rozwiązanie: <span id="iteration"></span></span>
                                  </li>
                                  <li class="list-group-item">
                                      <span class="label label-default">Czas trwania algorytmu: <span id="time"></span></span>
                                  </li>
                                  <li class="list-group-item">
                                       <span class="label label-default">Długość znalezionej ścieżki: <span id="distance"></span></span>
                                  </li>
                                </ul>
                            </td>
                        </tr>                               
                    </div>
                    <button id="calculate" onclick="calculateDistances()"type="button" class="btn btn-default">Licz</button>  
                  </div>
                </div>                
            </div>

            <div style="float:left; width:75%; height: 100%;">                
                <div class="panel panel-default" style="width:100%; height:100%">
                  <div class="panel-heading">Mapa</div>
                  <div id="map-canvas"class="panel-body" style="width:100%; height:100%">
                  </div>
                </div>               
            </div>
        </div>


    </body>
</html>