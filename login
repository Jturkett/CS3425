<html>
  <body>
      <form>
          Email: <input type = "text" name = "email"/> <br/>
          Password: <input type = "password" name = "password"/> <br/>
          Class: <input type = "radio" name = "class" value = "camper"/>Camper</input>
                 <input type = "radio" name = "class" value = "coach"/>Coach</input>

      </form>
  </body>
</html>

<?php
  session_start();
  if (isset($_SESSION["loggedin"])) {
    echo "You have logged in";
    return;
  }
  try {
    $config = parse_ini_file("db.ini");
    $dbh = new PDO($config('email'), $config('password'));
    $bdh->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
    if ($_POST['class'] == 'camper') {
          $statement = $dbh->prepare("Select count(password) from camper where MD5[Password:=password] == password and email =: Email");
          $result = $statement->execute(':password' => $_POST['password'], 'Email' => $_POST['email']);
          if ($result == 1) {
            $_SESSION["loggedin"] = true;
            echo "You have logged in successfully!";
          } else {
            echo "Username and password do not match.";
          }
    } else if ($_POST['class'] == 'coach') {
      $statement = $dbh->prepare("Select count(password) from coach where MD5[Password:=password] == password and email =: Email");
      $resultC = $statement->execute(':password' => $_POST['password'], 'Email' => $_POST['email']);
      if ($resultC == 1) {
        $_SESSION["loggedin"] = true;
        echo "You have logged in successfully!";
        return;
      } else {
        echo "Username and password do not match.";
      }
    }

    if(isset($_SESSION["loggedin"])) {
      header("test.html");
    }
  }


?>
