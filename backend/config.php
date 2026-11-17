<?php
$host = "localhost";
$user = "DB_USERNAME"; // نام کاربری دیتابیس
$pass = "DB_PASSWORD"; // رمز دیتابیس
$dbname = "instagram_db"; // نام دیتابیس

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$conn->set_charset("utf8mb4");
?>
