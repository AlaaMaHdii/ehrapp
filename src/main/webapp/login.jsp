<!DOCTYPE html>
<html lang="da">
    <head>
        <meta charset="UTF-8">
        <title>EHR - Login</title>
        <link rel="stylesheet" type="text/css" href="index.css">
    </head>

    <body>
        <section class="from my-5">
            <div class = "col-lg-5">
                <div class="container">
                    <div class="row">
                        <!-- Først kasse -->
                        <!-- <div class="col-lg-7 rounded"> -->
                            <!-- Anden kasse -->
                            <div class = "col-lg-7 rounded">
                                <!-- Logo -->
                                <img src="https://cdn.discordapp.com/attachments/948600290158977174/1018638584007368744/public-health-icon.png" class="img-fluid" style="max-width:128px;width:100%" alt="">
                                <h1>EHR System</h1>
                                <!-- Login delen -->
                                <form action="/dashboard.html" method="GET">
                                    <div class = "log-in">
                                        <label for ="username" >Brugernavn: </label><br>
                                        <input type="text" id ="username" name="username" value="Alaa"><br>
                                        <label for="password" > Kodeord:</label><br>
                                        <input type ="password" id="password" name="password" value="test"><br><br>
                                        <input type="submit" style="cursor:pointer" value="Log ind">
                                    </div>
                                    <!-- Afslut login delen -->
                                </form>
                                <!-- Andre links til hjælp. evt. oprettelse -->
                                <a href ='#'>Forgot password </a>
                                <p>Don't have an account <a href="#" >Register here</a></p>
                            </div>
                        <!--- </div> -->
                    </div>
                </div>
            </div>
        </section>
    </body>
</html>