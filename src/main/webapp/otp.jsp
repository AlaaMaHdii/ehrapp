<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<html lang="da"><head>
    <title>EHR - Log ind</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"> <!-- Ældre version fordi 5.2.2 gør log ind knappen gennemsigtig. -->
    <link href="index.css" rel="stylesheet">

</head>
<body>

<div id="main-wrapper" class="container">
    <div class="row justify-content-center">
        <div class="col-xl-10">
            <div class="card border-0" style="border-radius: 37.5px;background: #070747; box-shadow: 0 10px 30px 0 rgb(7 7 71 / 40%);">
                <div class="card-body p-0">
                    <div class="row no-gutters">
                        <div class="col-lg-6">
                            <div class="p-5">
                                <div class="mb-5">
                                    <img src="https://i.imgur.com/eP2kkTb.png" style="height: 100px" alt="logo" class="logo">
                                </div>
                                <h6 class="h5 mb-0" style=" color: #fff;">Velkommen, ${user.getName().split(" ")[0]}!</h6>
                                <p class="text-muted mt-2" style="color: #a1a1a1!important;">Vi har sendt dig en 2FA-kode til din telefon.</p>
                                <%
                                    if(request.getAttribute("message") != null){
                                %>
                                <div class="alert alert-danger" role="alert">
                                    ${message}
                                </div>

                                <% }
                                %>

                                <form action="${pageContext.request.contextPath}/otp" method="post">
                                    <div class="form-group">
                                        <label style="color: #fff;">2FA-adgangskoden</label>
                                        <div class="input-group mb-3">
                                            <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                            <input type="text" class="form-control" placeholder="Indtast 2FA" id="otp" name="otp">
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-theme">Log ind</button>
                                </form>
                            </div>
                        </div>

                        <div class="col-lg-6 d-none d-lg-inline-block">
                            <div class="billede-block">
                                <div class="overlay"></div>
                                <div class="login-citat">
                                    <p class="lead text-white" id="citat"></p>
                                    <p id="forfatter"></p>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <!-- slutningen af card-body -->
            </div>
            <!-- slutningen af card -->

            <p class="text-muted text-center mt-3 mb-0" style="color: #cccccc!important;">Har du ikke en konto? Kontakt dit ambulatorie for at få adgang.</p>

            <!-- slutning af rækken -->

        </div>
        <!-- slutning af col -->
    </div>
    <!-- Row -->
</div>

<!-- Eventuelle JS-koder -->
<script src="https://unpkg.com/typewriter-effect@latest/dist/core.js"></script>
<script>
    var typewriter_citat = new Typewriter(document.getElementById('citat'), {
        loop: false,
        delay: 30,
    });

    var typewriter_forfatter = new Typewriter(document.getElementById('forfatter'), {
        loop: false,
        delay: 20,
    });

    var citat = () => {
        fetch('https://api.quotable.io/random')
            .then((response) => response.json())
            .then((data) => {
                typewriter_forfatter.typeString("- " + data.author).start();
                typewriter_citat.typeString('"' +data.content + '"').pauseFor(10000).callFunction(()=>{typewriter_forfatter.deleteAll()}).deleteAll().callFunction(citat).start();
                //document.querySelector("#citat").setHTML('"' +data.content + '"')
                //document.querySelector("#forfatter").setHTML("- " + data.author)
            })
            // fallback hvis API'en nu skulle dø en dag.
            .catch((error) => {
                document.querySelector("#citat").setHTML("Healthy citizens are the greatest asset any country can have")
                document.querySelector("#forfatter").setHTML("- Winston Churchil")
            });
    }
    citat();
</script>
</body>
</html>