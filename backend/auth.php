<?php
include 'config.php';

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($username) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Invalid inputs"]);
    exit;
}

// بررسی وجود کاربر
$stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // اگر کاربر بود، ورود موفق (در ابعاد آزمایشی)
    echo json_encode(["status" => "success", "message" => "Logged in"]);
} else {
    // ثبت نام جدید
    $insert = $conn->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    $insert->bind_param("ss", $username, $password);
    if ($insert->execute()) {
        echo json_encode(["status" => "success", "message" => "Registered"]);
    } else {
        echo json_encode(["status" => "error"]);
    }
}
?>
