<?php
include 'config.php';

$result = $conn->query("SELECT * FROM posts ORDER BY id DESC LIMIT 50");
$posts = [];

while ($row = $result->fetch_assoc()) {
    $posts[] = $row;
}

echo json_encode($posts);
?>
