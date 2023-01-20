<%--
  Created by IntelliJ IDEA.
  User: Alaa Mahdi
  Date: 19-01-2023
  Time: 21:07
  To change this template use File | Settings | File Templates.
--%>
<!doctype html>
<html lang="da">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="//cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">

    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/bs5/jszip-2.5.0/dt-1.12.1/af-2.4.0/b-2.2.3/b-colvis-2.2.3/b-html5-2.2.3/b-print-2.2.3/cr-1.5.6/date-1.1.2/kt-2.7.0/r-2.3.0/sl-1.4.0/sr-1.1.1/datatables.min.css" />
    <link rel="stylesheet" type="text/css" href="css/datatables.min.css" />
    <link rel="stylesheet" type="text/css" href="css/editor.bootstrap5.css" />
    <title>EHR - Overblik</title>
</head>
<body style="background: linear-gradient(to bottom, #485563, #29323c);height: 100%;margin: 0;background-repeat: no-repeat;background-attachment: fixed;">

<nav class="navbar navbar-expand-lg navbar-dark" style="background: #070747">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img src="https://i.imgur.com/eP2kkTb.png" alt="" height="24" class="d-inline-block align-text-top"> EHR System</a>



        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Aktiver navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">

            <ul class="ms-auto navbar-nav">

                <li class="nav-item">
                    <a class="nav-link active" href="#">Min behandling</a>
                </li>
            </ul>

            <ul class="ms-auto navbar-nav">

                <li class="nav-item">
                    <a class="nav-link" href="#">Log ud</a>
                </li>
            </ul>
        </div>
    </div>
</nav>


<div class="container-xxl rounded-3 m-5 mx-auto align-content-center p-3" id="chartContainer" style="background-color: #f3f3f3; height: 35em;">
</div>

<script src="//cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-u1OknCvxWvY5kfmNBILK2hRnQC3Pr17a+RTT6rIHI7NnikvbZlHgTPOOmMi466C8" crossorigin="anonymous"></script>
<script src="//code.jquery.com/jquery-3.6.1.min.js" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/v/bs5/jszip-2.5.0/dt-1.12.1/af-2.4.0/b-2.2.3/b-colvis-2.2.3/b-html5-2.2.3/b-print-2.2.3/cr-1.5.6/date-1.1.2/kt-2.7.0/r-2.3.0/sl-1.4.0/sr-1.1.1/datatables.min.js"></script>
<script src="//cdn.datatables.net/1.12.1/js/dataTables.bootstrap5.min.js" crossorigin="anonymous"></script>
<script src="js/dataTables.editor.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/locale/da.min.js" crossorigin="anonymous"></script>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"> </script>
<script src="js/ekg.js" crossorigin="anonymous"></script>

<script src="js/consults.js" crossorigin="anonymous"></script>
</body>
</html>