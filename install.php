<?php
// install.php

// ۱. اطلاعات دیتابیس خود را اینجا وارد کنید
$host = "localhost";
$user = "DB_USERNAME"; // نام کاربری دیتابیس شما (مثلاً user_insta)
$pass = "DB_PASSWORD"; // رمز عبور دیتابیس شما
$dbname = "instagram_db"; // نام دیتابیس شما (مثلاً db_insta)

// ۲. اتصال به سرور
$conn = new mysqli($host, $user, $pass);
if ($conn->connect_error) {
    die("<h3 style='color:red;'>خطا در اتصال به هاست: " . $conn->connect_error . "</h3>");
}

echo "<h2>در حال راه‌اندازی اینستاگرام ایرانی شما...</h2>";

// ۳. ساخت دیتابیس در صورت عدم وجود
$sql = "CREATE DATABASE IF NOT EXISTS `$dbname` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
if ($conn->query($sql) === TRUE) {
    echo "<p style='color:green;'>✓ دیتابیس با موفقیت آماده شد.</p>";
} else {
    die("<p style='color:red;'>خطا در ایجاد دیتابیس: " . $conn->error . "</p>");
}

// انتخاب دیتابیس
$conn->select_db($dbname);

// ۴. ساخت جدول کاربران
$tableUsers = "CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

if ($conn->query($tableUsers) === TRUE) {
    echo "<p style='color:green;'>✓ جدول کاربران (users) با موفقیت ساخته شد.</p>";
} else {
    echo "<p style='color:red;'>خطا در ساخت جدول کاربران: " . $conn->error . "</p>";
}

// ۵. ساخت جدول پست‌ها
$tablePosts = "CREATE TABLE IF NOT EXISTS `posts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL,
  `caption` TEXT,
  `image_url` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

if ($conn->query($tablePosts) === TRUE) {
    echo "<p style='color:green;'>✓ جدول پست‌ها (posts) با موفقیت ساخته شد.</p>";
} else {
    echo "<p style='color:red;'>خطا در ساخت جدول پست‌ها: " . $conn->error . "</p>";
}

// ۶. ساخت خودکار فایل تنظیمات اصلی (config.php) برای برنامه‌های بعدی
$configContent = "<?php
\$host = '$host';
\$user = '$user';
\$pass = '$pass';
\$dbname = '$dbname';
\$conn = new mysqli(\$host, \$user, \$pass, \$dbname);
if (\$conn->connect_error) { die('اتصال ناموفق: ' . \$conn->connect_error); }
\$conn->set_charset('utf8mb4');
?>";

file_put_contents('config.php', $configContent);
echo "<p style='color:green;'>✓ فایل تنظیمات ارتباطی (config.php) خودکار ساخته شد.</p>";

// ایجاد پوشه آپلود تصاویر در صورت عدم وجود
if (!file_exists('uploads')) {
    mkdir('uploads', 0755, true);
    echo "<p style='color:green;'>✓ پوشه ذخیره تصاویر (uploads) ساخته شد.</p>";
}

echo "<h3 style='color:blue;'>🎉 تبریک! دیتابیس و جدول‌ها با موفقیت ساخته شدند و برنامه آماده استفاده است.</h3>";
echo "<p style='color:orange;'>⚠️ برای امنیت بیشتر، پس از اتمام کار حتماً فایل install.php را از روی هاست خود حذف کنید.</p>";

$conn->close();
?>
