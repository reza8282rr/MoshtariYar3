<?php
include 'config.php';

$username = $_POST['username'] ?? '';
$caption = $_POST['caption'] ?? '';
$image_base64 = $_POST['image'] ?? '';

if (empty($username) || empty($image_base64)) {
    echo json_encode(["status" => "error"]);
    exit;
}

// ساخت نام منحصر به فرد برای عکس و ذخیره آن در پوشه سرور
$image_name = time() . '_' . rand(100, 999) . '.jpg';
$path = 'uploads/' . $image_name;

if (file_put_contents($path, base64_decode($image_base64))) {
    $image_url = "http://" . $_SERVER['HTTP_HOST'] . "/backend/" . $path;
    
    $stmt = $conn->prepare("INSERT INTO posts (username, caption, image_url) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $username, $caption, $image_url);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error"]);
    }
} else {
    echo json_encode(["status" => "upload_failed"]);
}
?>
