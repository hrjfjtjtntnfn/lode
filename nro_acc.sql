-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost
-- Thời gian đã tạo: Th9 29, 2025 lúc 02:28 PM
-- Phiên bản máy phục vụ: 10.4.6-MariaDB
-- Phiên bản PHP: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `nro_acc`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessSuccessfulTransaction` (IN `p_transaction_id` VARCHAR(50), IN `p_amount` INT, IN `p_username` VARCHAR(50))  BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Update transaction status
    UPDATE mb_transactions 
    SET status = 'completed', updated_at = NOW() 
    WHERE transaction_id = p_transaction_id AND status = 'pending';
    
    -- Update user balance (uncomment and modify according to your users table)
    -- UPDATE users 
    -- SET balance = balance + p_amount 
    -- WHERE username = p_username;
    
    -- Log the transaction
    INSERT INTO transaction_logs (transaction_id, username, amount, content, status, action, description)
    SELECT transaction_id, username, amount, content, 'completed', 'balance_updated', 
           CONCAT('Balance updated by ', p_amount, ' VND')
    FROM mb_transactions 
    WHERE transaction_id = p_transaction_id;
    
    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `account`
--

CREATE TABLE `account` (
  `id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `create_time` timestamp NULL DEFAULT current_timestamp(),
  `update_time` timestamp NULL DEFAULT current_timestamp(),
  `ban` tinyint(1) NOT NULL DEFAULT 0,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `last_time_login` timestamp NOT NULL DEFAULT '2002-07-30 17:00:00',
  `last_time_logout` timestamp NOT NULL DEFAULT '2002-07-30 17:00:00',
  `ip_address` varchar(50) DEFAULT NULL,
  `active` int(11) NOT NULL DEFAULT 1,
  `thoi_vang` int(11) NOT NULL DEFAULT 0,
  `server_login` int(11) NOT NULL DEFAULT -1,
  `bd_player` double DEFAULT 1,
  `is_gift_box` tinyint(1) DEFAULT 0,
  `gift_time` varchar(255) DEFAULT '0',
  `reward` longtext DEFAULT '[]',
  `cash` int(11) NOT NULL DEFAULT 0,
  `danap` int(11) NOT NULL DEFAULT 0,
  `token` text NOT NULL,
  `xsrf_token` text NOT NULL,
  `newpass` text NOT NULL,
  `luotquay` int(11) NOT NULL DEFAULT 0,
  `vang` bigint(20) NOT NULL DEFAULT 0,
  `event_point` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT 0,
  `vip1` int(11) NOT NULL DEFAULT 0,
  `vip2` int(11) NOT NULL DEFAULT 2,
  `sotien` int(11) NOT NULL DEFAULT 0,
  `diem_da_nhan` int(11) NOT NULL DEFAULT 0,
  `hasReceivedVIP` int(11) NOT NULL DEFAULT 0,
  `hasReceivedVIP1` int(11) NOT NULL DEFAULT 0,
  `hasReceivedVIP2` int(11) NOT NULL DEFAULT 0,
  `lastTimeReceivedVIP` bigint(20) NOT NULL DEFAULT 0,
  `lastTimeReceivedVIP1` bigint(20) NOT NULL DEFAULT 0,
  `lastTimeReceivedVIP2` bigint(20) NOT NULL DEFAULT 0,
  `coin` int(11) NOT NULL DEFAULT 0,
  `gioithieu` int(11) NOT NULL DEFAULT 0,
  `admin` int(11) NOT NULL DEFAULT 0,
  `tichdiem` int(11) NOT NULL DEFAULT 0,
  `mkc2` int(11) NOT NULL DEFAULT 0,
  `gmail` varchar(225) NOT NULL,
  `server` int(11) NOT NULL DEFAULT 0,
  `avatar` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `account_mbbank`
--

CREATE TABLE `account_mbbank` (
  `id` int(11) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `sessionId` text DEFAULT NULL,
  `deviceId` text DEFAULT NULL,
  `stk` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `time` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `account_mbbank`
--

INSERT INTO `account_mbbank` (`id`, `phone`, `password`, `sessionId`, `deviceId`, `stk`, `name`, `token`, `time`) VALUES
(1, '0888123456', 'matkhaucuaban', NULL, NULL, '9704xxxxxx', NULL, 'toan-token-123', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `adminpanel`
--

CREATE TABLE `adminpanel` (
  `id` int(11) NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trangthai` enum('bao_tri','hoat_dong') COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `android` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iphone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `windows` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `java` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apikey` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `taikhoanmb` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `stkmb` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tenmb` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `adminpanel`
--

INSERT INTO `adminpanel` (`id`, `domain`, `logo`, `trangthai`, `title`, `android`, `iphone`, `windows`, `java`, `apikey`, `taikhoanmb`, `stkmb`, `tenmb`) VALUES
(1, 'https://ngocrongmobi.com/', '../image/logo.gif', '', 'Ngọc Rồng Mobi - Trang Chủ', '1', '2', '3', '4', '8667F6AF5193D289A214C17E36672887', '', '', '');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `atm_check`
--

CREATE TABLE `atm_check` (
  `tranid` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `atm_check`
--

INSERT INTO `atm_check` (`tranid`) VALUES
('FT25139488813600'),
('FT25140085531013'),
('FT25140214949762'),
('FT25140384835372'),
('FT25140535308808'),
('FT25140623690002'),
('FT25140963600112'),
('FT25141089417720'),
('FT25142239990351'),
('FT25142306974191'),
('FT25142460706667'),
('FT25143805588127'),
('FT25144562645684'),
('FT25146081845008'),
('FT25149462576860'),
('MBTEST1747665901'),
('MBTEST1747666106'),
('MBTEST1747666107'),
('MBTEST1747666108'),
('MBTEST1747666110'),
('MBTEST1747666112'),
('MBTEST1747666584');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `atm_lichsu`
--

CREATE TABLE `atm_lichsu` (
  `id` int(11) NOT NULL,
  `user_nap` varchar(100) DEFAULT NULL,
  `magiaodich` varchar(100) DEFAULT NULL,
  `thoigian` varchar(100) DEFAULT NULL,
  `sotien` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `clan`
--

CREATE TABLE `clan` (
  `id` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `NAME_2` varchar(4) NOT NULL,
  `slogan` varchar(255) NOT NULL DEFAULT '',
  `img_id` int(11) NOT NULL DEFAULT 0,
  `power_point` bigint(20) NOT NULL DEFAULT 0,
  `max_member` smallint(6) NOT NULL DEFAULT 10,
  `clan_point` int(11) NOT NULL DEFAULT 0,
  `LEVEL` int(11) NOT NULL DEFAULT 1,
  `members` text NOT NULL,
  `tops` text NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `pointChienClan` int(11) NOT NULL,
  `TolaChienClan` int(11) NOT NULL,
  `TopBanDo` text NOT NULL DEFAULT '[]',
  `TopKhiGas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[0,0]' CHECK (json_valid(`TopKhiGas`)),
  `TopCDRD` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[0,0]' CHECK (json_valid(`TopCDRD`)),
  `dataDoanhTrai` text NOT NULL DEFAULT '[0,0,""]',
  `dataDungeon` text DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diem_danh_history`
--

CREATE TABLE `diem_danh_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `day` int(11) NOT NULL COMMENT 'Ngày trong tuần (0-6, 0=Thứ 2)',
  `date` date NOT NULL COMMENT 'Ngày thực tế',
  `claimed` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Đã nhận thưởng chưa',
  `claim_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Thời gian nhận thưởng'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu trữ lịch sử điểm danh hàng ngày của người chơi';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diem_danh_rewards`
--

CREATE TABLE `diem_danh_rewards` (
  `id` int(11) NOT NULL,
  `day` int(11) NOT NULL COMMENT 'Ngày trong tuần (0-6, 0=Thứ 2)',
  `item_index` int(11) NOT NULL COMMENT 'Thứ tự item trong ngày (0-5)',
  `item_id` int(11) NOT NULL COMMENT 'ID của item',
  `quantity` int(11) NOT NULL DEFAULT 1 COMMENT 'Số lượng item',
  `color` int(11) NOT NULL DEFAULT 0 COMMENT 'Màu sắc của item',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mô tả phần thưởng'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng cấu hình phần thưởng điểm danh theo ngày trong tuần';

--
-- Đang đổ dữ liệu cho bảng `diem_danh_rewards`
--

INSERT INTO `diem_danh_rewards` (`id`, `day`, `item_index`, `item_id`, `quantity`, `color`, `description`) VALUES
(1, 0, 0, 457, 100, 0, 'Ngọc xanh'),
(2, 0, 1, 457, 200, 0, 'Ngọc xanh'),
(3, 0, 2, 457, 300, 0, 'Ngọc xanh'),
(4, 0, 3, 457, 400, 0, 'Ngọc xanh'),
(5, 0, 4, 457, 500, 0, 'Ngọc xanh'),
(6, 0, 5, 457, 600, 0, 'Ngọc xanh'),
(7, 1, 0, 457, 150, 0, 'Ngọc xanh'),
(8, 1, 1, 457, 250, 0, 'Ngọc xanh'),
(9, 1, 2, 457, 350, 0, 'Ngọc xanh'),
(10, 1, 3, 457, 450, 0, 'Ngọc xanh'),
(11, 1, 4, 457, 550, 0, 'Ngọc xanh'),
(12, 1, 5, 457, 650, 0, 'Ngọc xanh'),
(13, 2, 0, 457, 200, 0, 'Ngọc xanh'),
(14, 2, 1, 457, 300, 0, 'Ngọc xanh'),
(15, 2, 2, 457, 400, 0, 'Ngọc xanh'),
(16, 2, 3, 457, 500, 0, 'Ngọc xanh'),
(17, 2, 4, 457, 600, 0, 'Ngọc xanh'),
(18, 2, 5, 457, 700, 0, 'Ngọc xanh'),
(19, 3, 0, 457, 250, 0, 'Ngọc xanh'),
(20, 3, 1, 457, 350, 0, 'Ngọc xanh'),
(21, 3, 2, 457, 450, 0, 'Ngọc xanh'),
(22, 3, 3, 457, 550, 0, 'Ngọc xanh'),
(23, 3, 4, 457, 650, 0, 'Ngọc xanh'),
(24, 3, 5, 457, 750, 0, 'Ngọc xanh'),
(25, 4, 0, 457, 300, 0, 'Ngọc xanh'),
(26, 4, 1, 457, 400, 0, 'Ngọc xanh'),
(27, 4, 2, 457, 500, 0, 'Ngọc xanh'),
(28, 4, 3, 457, 600, 0, 'Ngọc xanh'),
(29, 4, 4, 457, 700, 0, 'Ngọc xanh'),
(30, 4, 5, 457, 800, 0, 'Ngọc xanh'),
(31, 5, 0, 457, 350, 0, 'Ngọc xanh'),
(32, 5, 1, 457, 450, 0, 'Ngọc xanh'),
(33, 5, 2, 457, 550, 0, 'Ngọc xanh'),
(34, 5, 3, 457, 650, 0, 'Ngọc xanh'),
(35, 5, 4, 457, 750, 0, 'Ngọc xanh'),
(36, 5, 5, 457, 850, 0, 'Ngọc xanh'),
(37, 6, 0, 457, 500, 0, 'Ngọc xanh'),
(38, 6, 1, 457, 600, 0, 'Ngọc xanh'),
(39, 6, 2, 457, 700, 0, 'Ngọc xanh'),
(40, 6, 3, 457, 800, 0, 'Ngọc xanh'),
(41, 6, 4, 457, 900, 0, 'Ngọc xanh'),
(42, 6, 5, 457, 1000, 0, 'Ngọc xanh');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `event`
--

CREATE TABLE `event` (
  `id` int(11) NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `event`
--

INSERT INTO `event` (`id`, `name`, `data`) VALUES
(1, 'LUNNAR_NEW_YEAR', '{\"damePrecent\":0,\"hpPrecent\":0,\"mpPrecent\":0,\"papPrecent\":0}');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `forum_comments`
--

CREATE TABLE `forum_comments` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `forum_comments`
--

INSERT INTO `forum_comments` (`id`, `post_id`, `user_id`, `username`, `content`, `created_at`) VALUES
(1, 1, 2412960, '116', 'game hay', '2025-07-02 10:43:55'),
(2, 1, 2412961, '117', 'game chán', '2025-07-02 10:44:57'),
(3, 3, 2412961, 'root', 'oke vipp', '2025-07-02 10:50:25'),
(4, 3, 2412960, '116', 'gamee oikeee', '2025-07-02 10:50:41'),
(5, 5, 2412960, '116', 'game được ấy', '2025-07-02 11:02:29');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `forum_posts`
--

CREATE TABLE `forum_posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'general',
  `is_pinned` tinyint(1) DEFAULT 0,
  `view_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `forum_posts`
--

INSERT INTO `forum_posts` (`id`, `user_id`, `username`, `title`, `content`, `created_at`, `category`, `is_pinned`, `view_count`) VALUES
(1, 2412960, '116', 'game hay', 'Game Rất Ok mUốn chơi miết', '2025-07-02 10:38:48', 'general', 0, 0),
(2, 2412960, '116', 'Bài viết test', 'Nội dung test', '2025-07-02 10:49:22', 'general', 0, 0),
(3, 2412960, '116', 'gaem dc', 'ádasdasds', '2025-07-02 10:50:09', 'general', 0, 0),
(4, 2412960, '116', 'game hay đó', 'game được lắm', '2025-07-02 10:52:26', 'general', 0, 0),
(5, 2412960, '116', 'toan', 'toan', '2025-07-02 10:56:01', 'general', 0, 0),
(6, 2412965, 'toanpro', 'game nào mở vậy', 'game hay mà mở laua quá', '2025-07-02 11:22:45', 'news', 0, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `game_packages`
--

CREATE TABLE `game_packages` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `type` enum('kimcuong','vip','special') NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giftcode`
--

CREATE TABLE `giftcode` (
  `id` int(11) NOT NULL,
  `code` text NOT NULL,
  `count_left` int(11) NOT NULL,
  `detail` text NOT NULL,
  `allGender` text NOT NULL,
  `datecreate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `expired` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `giftcode`
--

INSERT INTO `giftcode` (`id`, `code`, `count_left`, `detail`, `allGender`, `datecreate`, `expired`) VALUES
(1, 'nrochay', 93268, '[{\"id\":343,\"quantity\":5,\"options\":[{\"param\":0,\"id\":83}]},{\"id\":380,\"quantity\":20,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1240,\"quantity\":1,\"options\":[{\"param\":8,\"id\":50},{\"param\":8,\"id\":77},{\"param\":8,\"id\":103},{\"param\":15,\"id\":101},{\"param\":0,\"id\":30}]}]', 'all', '2025-06-08 18:05:08', '2025-12-20 06:39:08'),
(2, 'tanthu', 92947, '[{\"id\":597,\"quantity\":10,\"options\":[{\"param\":0,\"id\":89}]},{\"id\":213,\"quantity\":1,\"options\":[{\"param\":8,\"id\":64}]},{\"id\":76,\"quantity\":5000000,\"options\":[{\"param\":32,\"id\":2}]},{\"id\":454,\"quantity\":1,\"options\":[{\"param\":0,\"id\":73}]},{\"id\":194,\"quantity\":1,\"options\":[{\"param\":0,\"id\":73}]},{\"id\":1136,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-06-08 18:00:36', '2025-12-19 08:36:40'),
(3, 'caitrang', 93925, '[{\"id\":227,\"quantity\":1,\"options\":[{\"param\":15,\"id\":50},{\"param\":15,\"id\":77},{\"param\":15,\"id\":103},{\"param\":5,\"id\":95},{\"param\":5,\"id\":96}]},{\"id\":228,\"quantity\":1,\"options\":[{\"param\":15,\"id\":50},{\"param\":15,\"id\":77},{\"param\":15,\"id\":103},{\"param\":5,\"id\":95},{\"param\":5,\"id\":96}]},{\"id\":229,\"quantity\":1,\"options\":[{\"param\":15,\"id\":50},{\"param\":15,\"id\":77},{\"param\":15,\"id\":103},{\"param\":5,\"id\":95},{\"param\":5,\"id\":96}]}]', '', '2025-06-08 18:00:29', '2025-10-19 12:19:29'),
(4, 'denbu3', 99697, '[{\"id\":1455,\"quantity\":200,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1456,\"quantity\":3,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-06-03 06:24:53', '2025-12-20 06:39:08'),
(5, 'ádcvxvwesdfs', 99999, '[{\"id\":14,\"quantity\":30,\"options\":[{\"param\":1,\"id\":100},{\"param\":0,\"id\":86}]},{\"id\":77,\"quantity\":100000000,\"options\":[{\"param\":0,\"id\":73}]},{\"id\":861,\"quantity\":100000000,\"options\":[{\"param\":0,\"id\":73}]}]', 'all', '2025-05-25 00:50:26', '2025-12-20 06:39:08'),
(6, 'ádcvxvwesdfs', 99999, '[{\"id\":1276,\"quantity\":199,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1277,\"quantity\":199,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1278,\"quantity\":199,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1305,\"quantity\":99,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1167,\"quantity\":1,\"options\":[{\"param\":5,\"id\":50},{\"param\":5,\"id\":77},{\"param\":5,\"id\":103},{\"param\":5,\"id\":95},{\"param\":5,\"id\":96}]}]', 'all', '2025-05-18 00:57:46', '2025-12-20 06:39:08'),
(7, 'open', 99555, '[{\"id\":1341,\"quantity\":1,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1099,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1100,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1101,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-06-06 11:09:03', '2025-12-20 06:39:08'),
(8, 'nrochay1', 97930, '[{\"id\":381,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":382,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":383,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":447,\"quantity\":20,\"options\":[{\"param\":5,\"id\":101}]}]', 'all', '2025-06-08 18:05:13', '2025-12-20 06:39:08'),
(9, 'code22', 99736, '[{\"id\":1181,\"quantity\":1,\"options\":[{\"param\":5,\"id\":50},{\"param\":15,\"id\":77},{\"param\":15,\"id\":103},{\"param\":5,\"id\":93},{\"param\":50,\"id\":2}]},{\"id\":1183,\"quantity\":1,\"options\":[{\"param\":5,\"id\":50},{\"param\":15,\"id\":77},{\"param\":15,\"id\":103},{\"param\":5,\"id\":93},{\"param\":50,\"id\":2}]},{\"id\":1185,\"quantity\":1,\"options\":[{\"param\":5,\"id\":50},{\"param\":15,\"id\":77},{\"param\":15,\"id\":103},{\"param\":5,\"id\":93},{\"param\":50,\"id\":2}]}]', 'all', '2025-06-06 17:44:34', '2025-12-20 06:39:08'),
(10, 'dsfcxvxc', 99447, '[{\"id\":1395,\"quantity\":99,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1099,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1100,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1101,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-05-18 00:58:14', '2025-12-20 06:39:08'),
(11, 'nrochay2', 97303, '[{\"id\":1305,\"quantity\":3,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1099,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1100,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1101,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-06-08 18:05:18', '2025-12-20 06:39:08'),
(12, '324324', 99682, '[{\"id\":1416,\"quantity\":1,\"options\":[{\"param\":26,\"id\":50},{\"param\":26,\"id\":77},{\"param\":26,\"id\":103},{\"param\":26,\"id\":101},{\"param\":15,\"id\":14}]},{\"id\":1450,\"quantity\":1,\"options\":[{\"param\":5,\"id\":50},{\"param\":3,\"id\":77},{\"param\":3,\"id\":103}]},{\"id\":1426,\"quantity\":3,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-05-18 00:58:54', '2025-10-19 12:19:29'),
(13, 'gfdgdfg', 0, '[{\"id\":1316,\"quantity\":1,\"options\":[{\"param\":30,\"id\":50},{\"param\":29,\"id\":77},{\"param\":29,\"id\":103},{\"param\":25,\"id\":101},{\"param\":15,\"id\":14}]},{\"id\":1317,\"quantity\":1,\"options\":[{\"param\":10,\"id\":50},{\"param\":10,\"id\":77},{\"param\":10,\"id\":103}]}]', 'all', '2025-05-18 00:58:58', '2025-10-19 12:19:29'),
(14, 'wresfds', 0, '[{\"id\":1320,\"quantity\":1,\"options\":[{\"param\":29,\"id\":50},{\"param\":29,\"id\":77},{\"param\":29,\"id\":103},{\"param\":15,\"id\":5},{\"param\":25,\"id\":101}]},{\"id\":1328,\"quantity\":1,\"options\":[{\"param\":16,\"id\":50},{\"param\":16,\"id\":77},{\"param\":16,\"id\":103},{\"param\":8,\"id\":14}]}]', 'all', '2025-05-18 00:59:00', '2025-12-20 06:39:08'),
(15, 'sdgvfx', 0, '[{\"id\":1316,\"quantity\":1,\"options\":[{\"param\":32,\"id\":50},{\"param\":32,\"id\":77},{\"param\":32,\"id\":103},{\"param\":15,\"id\":5},{\"param\":32,\"id\":101}]},{\"id\":1317,\"quantity\":1,\"options\":[{\"param\":12,\"id\":50},{\"param\":16,\"id\":77},{\"param\":16,\"id\":103},{\"param\":8,\"id\":14}]}]', 'all', '2025-05-18 00:59:04', '2025-12-20 06:39:08'),
(16, 'dsfcxvwregwe', 88648, '[{\"id\":380,\"quantity\":30,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1099,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1100,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1101,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-05-18 00:59:07', '2025-12-20 06:39:08'),
(17, 'dsfcxvwregwe', 99816, '[{\"id\":1247,\"quantity\":5,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1099,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1100,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]},{\"id\":1101,\"quantity\":15,\"options\":[{\"param\":0,\"id\":30}]}]', 'all', '2025-05-18 00:59:07', '2025-12-20 06:39:08'),
(18, 'caitrang1', 99902, '[{\"id\":1485,\"quantity\":1,\"options\":[{\"param\":27,\"id\":50},{\"param\":27,\"id\":77},{\"param\":27,\"id\":103},{\"param\":10,\"id\":5},{\"param\":0,\"id\":30},{\"param\":2,\"id\":93}]}]', 'all', '2025-06-08 18:05:23', '2025-07-26 14:07:52');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giftcode_diemdanh`
--

CREATE TABLE `giftcode_diemdanh` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `day` tinyint(4) NOT NULL,
  `code` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `giftcode_diemdanh`
--

INSERT INTO `giftcode_diemdanh` (`id`, `user_id`, `day`, `code`, `created_at`) VALUES
(1, 1, 1, 'EE26BACB', '2025-05-20 10:38:02'),
(2, 1, 2, '32F54CFB', '2025-05-20 10:46:58'),
(3, 1, 3, '776BCE44', '2025-05-20 10:47:00'),
(4, 1, 6, '6F644167', '2025-05-20 10:47:00'),
(5, 1, 5, 'F2945657', '2025-05-20 10:47:01'),
(6, 1, 4, '26FDC180', '2025-05-20 10:47:01'),
(7, 4, 2, 'c1044fd1', '2025-05-20 12:40:16'),
(8, 4, 3, 'e4dfbfb6', '2025-05-20 12:40:44'),
(9, 4, 6, '0134c397', '2025-05-20 12:40:44'),
(10, 4, 5, 'de2ce9c2', '2025-05-20 12:40:45'),
(11, 4, 4, '5d48d03e', '2025-05-20 12:40:45'),
(12, 1025642, 1, 'cfcd7219', '2025-05-20 15:15:14'),
(13, 1025643, 1, '4f92d631', '2025-05-20 15:43:56'),
(14, 1025645, 1, 'aea3b569', '2025-05-20 16:00:12'),
(15, 1025646, 1, 'e957c9eb', '2025-05-20 16:07:02'),
(16, 1025647, 1, '9ef74765', '2025-05-20 16:29:28'),
(18, 1025648, 1, 'a297039e', '2025-05-20 17:04:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giftcode_diemdanh_reward`
--

CREATE TABLE `giftcode_diemdanh_reward` (
  `id` int(11) NOT NULL,
  `day` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `option_param` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `giftcode_diemdanh_reward`
--

INSERT INTO `giftcode_diemdanh_reward` (`id`, `day`, `item_id`, `quantity`, `option_id`, `option_param`) VALUES
(1, 1, 457, 100000, 30, 1),
(2, 2, -2, 20, NULL, NULL),
(3, 3, 12, 1, NULL, NULL),
(4, 4, 381, 5, 30, 10),
(5, 5, -1, 200000, NULL, NULL),
(6, 6, 457, 1, 77, 15);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `history_transaction`
--

CREATE TABLE `history_transaction` (
  `id` int(11) NOT NULL,
  `player_1` varchar(255) NOT NULL,
  `player_2` varchar(255) NOT NULL,
  `item_player_1` text NOT NULL,
  `item_player_2` text NOT NULL,
  `bag_1_before_tran` text NOT NULL,
  `bag_2_before_tran` text NOT NULL,
  `bag_1_after_tran` text NOT NULL,
  `bag_2_after_tran` text NOT NULL,
  `time_tran` timestamp NOT NULL DEFAULT current_timestamp(),
  `detail_gold_1` text DEFAULT NULL,
  `detail_gold_2` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `items_web`
--

CREATE TABLE `items_web` (
  `id` int(11) NOT NULL,
  `vnd` int(11) NOT NULL,
  `items` int(11) NOT NULL,
  `slot` int(11) NOT NULL,
  `options` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Đang đổ dữ liệu cho bảng `items_web`
--

INSERT INTO `items_web` (`id`, `vnd`, `items`, `slot`, `options`) VALUES
(11, 15000, 16, 5, '[[70,9],[49,89]]'),
(12, 6464, 196, 1, '[[77,90]]'),
(13, 5000, 12, 1, '[[107,5],[49,80],[77,100]]');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ket_qua_veso`
--

CREATE TABLE `ket_qua_veso` (
  `ngay` date NOT NULL,
  `so` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `ket_qua_veso`
--

INSERT INTO `ket_qua_veso` (`ngay`, `so`) VALUES
('2025-06-02', '09552');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ket_qua_veso_nguoi_trung`
--

CREATE TABLE `ket_qua_veso_nguoi_trung` (
  `ngay` date NOT NULL,
  `giai` varchar(50) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `player_name` varchar(100) DEFAULT NULL,
  `so_trung` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `success` tinyint(1) DEFAULT 0,
  `attempt_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `login_attempts`
--

INSERT INTO `login_attempts` (`id`, `username`, `ip_address`, `success`, `attempt_time`) VALUES
(1, 'toanvip', '::1', 1, '2025-07-07 02:14:40'),
(2, 'abcbc', '::1', 1, '2025-07-07 02:46:54'),
(3, '1', '::1', 1, '2025-07-07 03:28:31'),
(4, '1', '::1', 1, '2025-07-07 03:50:38'),
(5, 'gamehayvl', '::1', 0, '2025-07-07 04:41:48'),
(6, 'toanvip', '::1', 1, '2025-07-07 04:42:06'),
(7, 'testgame', '::1', 1, '2025-07-07 06:11:38');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mbbank_log`
--

CREATE TABLE `mbbank_log` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `benAccountName` varchar(255) NOT NULL,
  `accountNo` varchar(255) NOT NULL,
  `bankName` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mbbank_transactions`
--

CREATE TABLE `mbbank_transactions` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL,
  `content` varchar(64) NOT NULL,
  `bank_account` varchar(32) NOT NULL,
  `account_name` varchar(64) NOT NULL,
  `status` enum('pending','success','failed') DEFAULT 'pending',
  `transaction_id` varchar(64) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mb_api_settings`
--

CREATE TABLE `mb_api_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `mb_api_settings`
--

INSERT INTO `mb_api_settings` (`id`, `setting_key`, `setting_value`, `description`, `updated_at`) VALUES
(1, 'api_key', '7a65a4a23e70c7bbdc05e3dc70e215a9', 'MBBank API Key from sieuthicode.net', '2025-06-29 15:18:43'),
(2, 'api_url', 'https://sieuthicode.net/api/mbbank', 'MBBank API Base URL', '2025-06-29 15:18:43'),
(3, 'callback_url', '', 'Webhook callback URL for transaction notifications', '2025-06-29 15:18:43'),
(4, 'webhook_secret', '', 'Secret key for webhook signature verification', '2025-06-29 15:18:43'),
(5, 'min_amount', '10000', 'Minimum transaction amount', '2025-06-29 15:18:43'),
(6, 'max_amount', '5000000', 'Maximum transaction amount', '2025-06-29 15:18:43'),
(7, 'auto_approve', '1', 'Auto approve successful transactions (1=yes, 0=no)', '2025-06-29 15:18:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mb_transactions`
--

CREATE TABLE `mb_transactions` (
  `id` int(11) NOT NULL,
  `transaction_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `content` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','completed','failed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `bank_account` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qr_code` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_response` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `mb_transactions`
--

INSERT INTO `mb_transactions` (`id`, `transaction_id`, `username`, `amount`, `content`, `status`, `bank_account`, `account_name`, `qr_code`, `api_response`, `created_at`, `updated_at`, `description`, `transaction_date`) VALUES
(1, 'FT25188646650388', 'testgame', 2000, '', 'pending', NULL, NULL, NULL, NULL, '2025-07-07 08:23:26', '2025-07-07 08:23:26', 'CUSTOMER donate testgame   Ma giao dich  Tra ce874512 Trace 874512', '2025-07-07 10:23:26'),
(2, 'FT25188330807070', 'testgame', 2000, '', 'pending', NULL, NULL, NULL, NULL, '2025-07-07 08:23:26', '2025-07-07 08:23:26', 'CUSTOMER donate testgame   Ma giao dich  Tra ce806882 Trace 806882', '2025-07-07 10:23:26'),
(3, 'FT25188351306397', 'testgame', 2000, '', 'pending', NULL, NULL, NULL, NULL, '2025-07-07 08:48:47', '2025-07-07 08:48:47', 'CUSTOMER donate testgame   Ma giao dich  Tra ce058129 Trace 058129', '2025-07-07 10:48:47');

--
-- Bẫy `mb_transactions`
--
DELIMITER $$
CREATE TRIGGER `mb_transaction_status_log` AFTER UPDATE ON `mb_transactions` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO transaction_logs (transaction_id, username, amount, content, status, action, description)
        VALUES (NEW.transaction_id, NEW.username, NEW.amount, NEW.content, NEW.status, 'status_changed', 
                CONCAT('Status changed from ', OLD.status, ' to ', NEW.status));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `mb_transaction_summary`
-- (See below for the actual view)
--
CREATE TABLE `mb_transaction_summary` (
`username` varchar(50)
,`total_transactions` bigint(21)
,`successful_transactions` decimal(22,0)
,`failed_transactions` decimal(22,0)
,`pending_transactions` decimal(22,0)
,`total_amount` decimal(32,0)
,`last_transaction` timestamp
);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` varchar(999) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `momo_trans`
--

CREATE TABLE `momo_trans` (
  `ID` int(11) NOT NULL,
  `tranId` varchar(255) NOT NULL,
  `io` varchar(255) NOT NULL,
  `partnerId` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `partnerName` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `millisecond` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `napthe`
--

CREATE TABLE `napthe` (
  `id` int(11) NOT NULL,
  `user_nap` varchar(100) NOT NULL,
  `telco` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `request_id` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `napthe`
--

INSERT INTO `napthe` (`id`, `user_nap`, `telco`, `serial`, `code`, `amount`, `status`, `request_id`, `created_at`) VALUES
(105, 'meo', 'VIETTEL', '10010747233563', '711684349936730', 10000, 1, '773832097', '2025-05-06 02:00:30'),
(106, 'chienpk3', 'VIETTEL', '10011139733783', '813166130368611', 10000, 99, '593615083', '2025-05-18 04:41:46'),
(107, 'vuibeboi', 'VIETTEL', '10010822809581', '617332572657362', 20000, 99, '330432834', '2025-05-18 11:49:27');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `naptien`
--

CREATE TABLE `naptien` (
  `id` int(11) NOT NULL,
  `uid` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` text NOT NULL,
  `sotien` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seri` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `loaithe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` timestamp NULL DEFAULT current_timestamp(),
  `noidung` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tinhtrang` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tranid` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `magioithieu` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `refNo` varchar(255) NOT NULL,
  `date` text NOT NULL,
  `amount` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `bank` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `payments`
--

INSERT INTO `payments` (`id`, `name`, `refNo`, `date`, `amount`, `status`, `bank`) VALUES
(283, '1', '2503', '2025-05-05 00:00:00', 10000, '1', NULL),
(284, '1', '2502', '2025-05-05 00:00:00', 10000, '1', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `player`
--

CREATE TABLE `player` (
  `id` int(11) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `name` varchar(20) NOT NULL,
  `info` text NOT NULL,
  `head` int(11) NOT NULL DEFAULT 102,
  `gender` int(11) NOT NULL,
  `have_tennis_space_ship` tinyint(1) DEFAULT 0,
  `clan_id` int(11) NOT NULL DEFAULT -1,
  `data_inventory` text NOT NULL,
  `data_location` text NOT NULL,
  `data_point` text NOT NULL,
  `data_magic_tree` text NOT NULL,
  `items_body` text NOT NULL,
  `items_bag` text NOT NULL,
  `items_box` text NOT NULL,
  `items_box_lucky_round` text NOT NULL,
  `items_daban` text NOT NULL,
  `friends` text NOT NULL,
  `enemies` text NOT NULL,
  `data_intrinsic` text NOT NULL,
  `data_item_time` text NOT NULL,
  `devndung_time` text NOT NULL,
  `data_task` text NOT NULL,
  `data_mabu_egg` text NOT NULL,
  `data_charm` text NOT NULL,
  `skills` text NOT NULL,
  `skills_shortcut` text NOT NULL,
  `pet` text NOT NULL,
  `data_black_ball` text NOT NULL,
  `data_side_task` text NOT NULL,
  `data_danh_hieu` text NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `notify` text CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `baovetaikhoan` varchar(1000) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '[]',
  `captcha` varchar(1000) NOT NULL DEFAULT '[]',
  `data_card` varchar(10000) NOT NULL DEFAULT '[]',
  `lasttimepkcommeson` bigint(20) NOT NULL DEFAULT 0,
  `bandokhobau` varchar(250) NOT NULL DEFAULT '[]',
  `conduongrandoc` varchar(255) NOT NULL DEFAULT '[]',
  `doanhtrai` varchar(250) NOT NULL DEFAULT '[]',
  `masterDoesNotAttack` text NOT NULL,
  `nhanthoivang` varchar(200) NOT NULL DEFAULT '[]',
  `ruonggo` varchar(255) NOT NULL DEFAULT '[]',
  `sieuthanthuy` varchar(255) NOT NULL DEFAULT '[]',
  `vodaisinhtu` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `rongxuong` bigint(20) NOT NULL DEFAULT 0,
  `data_item_event` varchar(1000) NOT NULL DEFAULT '[]',
  `data_luyentap` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_clan_task` varchar(255) NOT NULL DEFAULT '[]',
  `data_vip` text DEFAULT NULL,
  `rank` int(11) NOT NULL DEFAULT 0,
  `data_achievement` text NOT NULL,
  `giftcode` text NOT NULL,
  `danh_hieu_shop` varchar(50) NOT NULL DEFAULT '[0,0,0,0,0,0,0,0]',
  `data_clan` text DEFAULT NULL,
  `firstTimeLogin` timestamp NOT NULL DEFAULT current_timestamp(),
  `buarandom` varchar(50) NOT NULL DEFAULT '[1,1]',
  `dien_sukien` varchar(255) NOT NULL DEFAULT '[0,0,0]',
  `banhtet` bigint(20) NOT NULL DEFAULT 0,
  `banhchung` bigint(20) NOT NULL DEFAULT 0,
  `hoc_ky_nang` longtext DEFAULT NULL,
  `boughtSkills` longtext DEFAULT NULL,
  `DiemTaiXiu` int(11) NOT NULL DEFAULT 0,
  `KnThu` int(11) NOT NULL DEFAULT 0,
  `pointGold` bigint(20) NOT NULL DEFAULT 0,
  `data_linhhon` text NOT NULL DEFAULT '[0,0,-1]',
  `thanhtuu` text NOT NULL,
  `dataTT` text NOT NULL DEFAULT '[0,0]',
  `Thu_TrieuHoi` text NOT NULL DEFAULT '[-1]',
  `homthu` text NOT NULL,
  `dameBoss` bigint(20) DEFAULT 0,
  `data_vip_toan` text NOT NULL DEFAULT '[0,0]',
  `time_maptn_expire` bigint(20) NOT NULL DEFAULT 0,
  `BinhHutNangLuong` bigint(20) NOT NULL DEFAULT 0,
  `mocnap` text NOT NULL DEFAULT '[0,0,0,0,0,0,0,0,0,0]',
  `violate` bigint(20) NOT NULL DEFAULT 0,
  `levelMapMob` int(11) NOT NULL DEFAULT 0,
  `DiemMiniGame` bigint(20) NOT NULL DEFAULT 0,
  `diemmuahe` int(11) NOT NULL DEFAULT 0,
  `item_sieucap` text NOT NULL,
  `DiemVanTieu` int(11) DEFAULT 0,
  `pet1` text NOT NULL DEFAULT '[]',
  `immune_expire` bigint(20) DEFAULT 0,
  `dataMocNap` text NOT NULL DEFAULT '[]',
  `DanhHieu` text NOT NULL DEFAULT '[]',
  `TimeJoinClan` bigint(20) NOT NULL DEFAULT 0,
  `dungeon` bigint(20) DEFAULT 0,
  `LinhThu` text NOT NULL DEFAULT '[]',
  `pointOngGia` int(11) NOT NULL DEFAULT 0,
  `skcarot` int(11) NOT NULL DEFAULT 0,
  `thuongbinh` int(11) NOT NULL DEFAULT 0,
  `DiemSuuTam` int(11) NOT NULL DEFAULT 0,
  `DiemSuuTam1` int(11) NOT NULL DEFAULT 0,
  `itemsBox1` text NOT NULL DEFAULT '[]',
  `rankCap` int(11) NOT NULL DEFAULT 0,
  `saoRank` int(11) NOT NULL DEFAULT 0,
  `Pokemon` text NOT NULL DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `recharge`
--

CREATE TABLE `recharge` (
  `id` int(11) NOT NULL,
  `account_id` varchar(999) NOT NULL,
  `code` varchar(999) NOT NULL,
  `serial` varchar(999) NOT NULL,
  `amount` varchar(999) NOT NULL,
  `type` varchar(999) NOT NULL,
  `tranid` varchar(999) NOT NULL,
  `amount_real` varchar(999) NOT NULL,
  `status` int(11) NOT NULL,
  `time` varchar(999) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sell_item`
--

CREATE TABLE `sell_item` (
  `id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `slot` int(11) NOT NULL,
  `options` text NOT NULL,
  `users_buy` text NOT NULL,
  `status` int(11) NOT NULL,
  `time` varchar(999) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `setting`
--

CREATE TABLE `setting` (
  `id` int(11) NOT NULL,
  `img` varchar(1000) CHARACTER SET utf8mb4 NOT NULL,
  `name` varchar(1000) CHARACTER SET utf8mb4 NOT NULL,
  `vnd` int(11) NOT NULL,
  `loading` tinyint(1) NOT NULL DEFAULT 0,
  `zalo` varchar(1000) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'Null'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Đang đổ dữ liệu cho bảng `setting`
--

INSERT INTO `setting` (`id`, `img`, `name`, `vnd`, `loading`, `zalo`) VALUES
(0, '0.gif', 'Nro Muti', 999999999, 0, 'Null');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `settings`
--

CREATE TABLE `settings` (
  `Title` varchar(100) DEFAULT 'Nguyen Duc Kien',
  `Description` longtext DEFAULT NULL,
  `Keywords` longtext DEFAULT NULL,
  `SiteKey` varchar(100) DEFAULT NULL,
  `SecretKey` varchar(100) DEFAULT NULL,
  `ServerName` varchar(100) DEFAULT NULL,
  `Fanpage` varchar(100) DEFAULT NULL,
  `Group` varchar(100) DEFAULT NULL,
  `Zalo` varchar(100) DEFAULT NULL,
  `EmailSupport` varchar(50) DEFAULT NULL,
  `AccountBank` int(11) DEFAULT NULL,
  `PasswordBank` int(11) DEFAULT NULL,
  `NumberBank` varchar(225) DEFAULT NULL,
  `NameBank` varchar(225) DEFAULT NULL,
  `Android` varchar(225) DEFAULT NULL,
  `Windows` varchar(255) DEFAULT NULL,
  `Java` varchar(255) DEFAULT NULL,
  `IPhone` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `settings`
--

INSERT INTO `settings` (`Title`, `Description`, `Keywords`, `SiteKey`, `SecretKey`, `ServerName`, `Fanpage`, `Group`, `Zalo`, `EmailSupport`, `AccountBank`, `PasswordBank`, `NumberBank`, `NameBank`, `Android`, `Windows`, `Java`, `IPhone`) VALUES
('Ngọc Rồng Emti', 'Ngọc Rồng Huyền Thoại, Game chiến thuật trên mobile đề tài Dragon ball với nhiều tính năng hấp dẫn, không online vẫn nhận quà và đầy đủ các nhân vật như Songoku, Goku SS4, Vegeta, Android 18, Bulma,....', 'Dragon ball, game dragon ball, songoku, Goku SS4, vegeta, quy lão tiên sinh, game dragon ball mobile, game chiến thuật ', '6LfWe7oqAAAAALkQe40hxxCyCdSip0EDCVNq7mtq', '6LfWe7oqAAAAANjVdrApwtbqXl2Ew0lzJnHJxNp4', 'NREmti.com', 'https://www.facebook.com/people/Nr-Emti/61550060250328/', 'https://zalo.me/g/qexqrh792', 'https://zalo.me/g/qexqrh792', NULL, 1, 1, '000000742001', 'DOMINHTUAN', 'https://drive.google.com/file/d/1ifn3b1a1_EevzBK4hgWOG1cvP48JBBs2/view?usp=sharing', 'https://drive.google.com/file/d/1tVH6t89Ld3yebBUaJ7hdEW-w9uZL-XDT/view?usp=sharing', 'https://drive.google.com/file/d/1FDuMghIRCJiAmhBHGHR35KI6j0UeU5bO/view?usp=drivesdk', 'https://testflight.apple.com/join/tKC5Hk7Q');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `shop_ky_gui`
--

CREATE TABLE `shop_ky_gui` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `tab` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `gold` int(11) NOT NULL,
  `ruby` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `itemOption` text NOT NULL,
  `lasttime` bigint(20) NOT NULL,
  `isBuy` int(11) NOT NULL,
  `moneyClaimed` tinyint(1) DEFAULT 0 COMMENT 'Đánh dấu tiền đã được rút chưa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `shop_ky_gui`
--

INSERT INTO `shop_ky_gui` (`id`, `player_id`, `tab`, `item_id`, `gold`, `ruby`, `quantity`, `itemOption`, `lasttime`, `isBuy`, `moneyClaimed`) VALUES
(1, 1024223, 0, 264, 1000000000, -1, 1, '[{\"id\":\"0\",\"param\":\"1747\"},{\"id\":\"86\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"1\"}]', 1748170367496, 1, 0),
(2, 1024390, 3, 1181, -1, 10, 1, '[{\"id\":\"50\",\"param\":\"8\"},{\"id\":\"21\",\"param\":\"40\"},{\"id\":\"30\",\"param\":\"0\"},{\"id\":\"87\",\"param\":\"1\"},{\"id\":\"225\",\"param\":\"5\"},{\"id\":\"226\",\"param\":\"1000\"}]', 1748421602333, 1, 0),
(3, 1024467, 3, 221, 1, -1, 1, '[{\"id\":\"70\",\"param\":\"0\"}]', 1748496740342, 1, 0),
(4, 1023830, 3, 1185, -1, 5000, 1, '[{\"id\":\"77\",\"param\":\"15\"},{\"id\":\"21\",\"param\":\"40\"},{\"id\":\"30\",\"param\":\"0\"},{\"id\":\"87\",\"param\":\"1\"},{\"id\":\"225\",\"param\":\"5\"},{\"id\":\"226\",\"param\":\"1000\"}]', 1749093538248, 1, 0),
(5, 1023830, 3, 19, -1, 5000, 1, '[{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"2\"}]', 1749200953345, 0, 0),
(6, 1024035, 0, 564, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"3686\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"1\"}]', 1749232457213, 1, 0),
(7, 1024035, 0, 556, -1, 1, 1, '[{\"id\":\"22\",\"param\":\"55\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"2\"}]', 1749232490884, 1, 0),
(8, 1024035, 0, 562, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"4480\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"2\"}]', 1749232495993, 1, 0),
(9, 1024035, 1, 561, -1, 1, 1, '[{\"id\":\"14\",\"param\":\"15\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"1\"}]', 1749232501877, 1, 0),
(10, 1024035, 1, 563, -1, 1, 1, '[{\"id\":\"23\",\"param\":\"44\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"1\"}]', 1749232547084, 1, 0),
(11, 1024035, 0, 566, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"4293\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"1\"}]', 1749232551940, 1, 0),
(12, 1024035, 0, 564, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"3660\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"2\"}]', 1749232639315, 1, 0),
(13, 1024035, 0, 564, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"4457\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"2\"}]', 1749232648316, 1, 0),
(14, 1024035, 0, 564, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"4250\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"2\"}]', 1749233048486, 1, 0),
(15, 1024035, 0, 564, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"3721\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"1\"}]', 1749233054612, 1, 0),
(16, 1024035, 0, 562, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"3956\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"0\"}]', 1749233061500, 1, 0),
(17, 1024035, 0, 562, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"4129\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"0\"}]', 1749233066604, 1, 0),
(18, 1024035, 0, 566, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"4791\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"2\"}]', 1749233071471, 1, 0),
(19, 1024035, 0, 566, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"3968\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"1\"}]', 1749233076378, 1, 0),
(20, 1024035, 0, 562, -1, 1, 1, '[{\"id\":\"0\",\"param\":\"3805\"},{\"id\":\"209\",\"param\":\"1\"},{\"id\":\"21\",\"param\":\"18\"},{\"id\":\"87\",\"param\":\"0\"},{\"id\":\"107\",\"param\":\"0\"}]', 1749233081390, 1, 0),
(21, 1024035, 3, 1185, -1, 10000, 1, '[{\"id\":\"77\",\"param\":\"15\"},{\"id\":\"21\",\"param\":\"40\"},{\"id\":\"30\",\"param\":\"0\"},{\"id\":\"87\",\"param\":\"1\"},{\"id\":\"225\",\"param\":\"5\"},{\"id\":\"226\",\"param\":\"1000\"}]', 1749447292816, 0, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `super_rank`
--

CREATE TABLE `super_rank` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` int(11) NOT NULL,
  `last_pk_time` bigint(20) NOT NULL,
  `last_reward_time` bigint(20) NOT NULL,
  `ticket` int(11) NOT NULL,
  `win` int(11) NOT NULL,
  `lose` int(11) NOT NULL,
  `history` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `info` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `received` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `super_rank`
--

INSERT INTO `super_rank` (`id`, `player_id`, `name`, `rank`, `last_pk_time`, `last_reward_time`, `ticket`, `win`, `lose`, `history`, `info`, `received`) VALUES
(13206, 1023154, 'admin', 1, 1747473025022, 1747473025529, 3, 0, 0, '[]', '{\"head\":1655,\"def\":2,\"hp\":2500037,\"dame\":1260000,\"body\":1658,\"leg\":1659}', 1),
(13207, 1023155, 'admin1', 2, 1747458365557, 1747458366073, 3, 0, 0, '[]', '{\"head\":1655,\"def\":0,\"hp\":129000,\"dame\":11020610,\"body\":1658,\"leg\":1659}', 1),
(13208, 1023156, 'anh123', 3, 1746225008533, 1746225008542, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13209, 1023157, 'bktneee', 4, 1746296944182, 1746296944712, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13210, 1023158, 'djtmeadmin', 5, 1746271799820, 1746271799826, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13211, 1023159, 'pokokomi', 6, 1746310302785, 1746310302789, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13212, 1023160, 'owiiwo', 7, 1746313274826, 1746313274851, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13213, 1023161, 'black', 8, 1746313316417, 1746313316459, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13214, 1023162, 'tkdzvcl', 9, 1746314142460, 1746314142464, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13215, 1023163, 'tkdzvc', 10, 1746314199107, 1746314199115, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13216, 1023164, 'tkdzvl', 11, 1746314257764, 1746314257769, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13217, 1023165, 'occac', 12, 1746315146704, 1746315146709, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13218, 1023166, 'truongube', 13, 1746315890992, 1746315891001, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13219, 1023167, 's7iuanh', 14, 1746359602256, 1746359861888, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":161,\"dame\":13,\"body\":10,\"leg\":11}', 1),
(13220, 1023168, 'khanhduy', 15, 1746318633005, 1746318633008, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13221, 1023169, 'piculo', 16, 1746318813854, 1746318813862, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13222, 1023170, 'tkprovcl', 17, 1746319999219, 1746319999230, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13223, 1023171, 'tkprovc', 18, 1746356915699, 1746356931217, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":169,\"dame\":17,\"body\":16,\"leg\":17}', 1),
(13224, 1023172, 'khanhduy17', 19, 1746320303481, 1746320303487, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13225, 1023173, '123456', 20, 1746321414208, 1746321414211, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13226, 1023174, 'huynhtan', 21, 1746321598333, 1746321598337, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13227, 1023175, 'nghiaha', 22, 1746494873967, 1746494874471, 3, 0, 0, '[]', '{\"head\":126,\"def\":0,\"hp\":402,\"dame\":92,\"body\":57,\"leg\":58}', 1),
(13228, 1023176, 'gohan', 23, 1746324927947, 1746324927955, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13229, 1023177, 'windowsp', 24, 1746325524221, 1746325524263, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13230, 1023178, 'coang', 25, 1746329702804, 1746329702857, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13231, 1023179, 'xdhokm', 26, 1746390623942, 1746390624474, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":171,\"dame\":20,\"body\":16,\"leg\":17}', 1),
(13232, 1023180, 'keiatine', 27, 1746336296314, 1746336296862, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":161,\"dame\":14,\"body\":10,\"leg\":11}', 1),
(13233, 1023181, 'hhahaaha', 28, 1746332145506, 1746332145510, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13234, 1023182, 'dragon', 29, 1746465062324, 1746465062831, 3, 0, 0, '[]', '{\"head\":1597,\"def\":40,\"hp\":15371,\"dame\":54357,\"body\":1598,\"leg\":1599}', 1),
(13235, 1023183, '1onestar', 30, 1746337946318, 1746337946324, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13236, 1023184, 'picosama', 31, 1746338792194, 1746338792197, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13237, 1023185, 'linda', 32, 1746339306402, 1746421200205, 3, 0, 0, '[]', '{\"head\":347,\"def\":8,\"hp\":1056,\"dame\":1447,\"body\":348,\"leg\":349}', 1),
(13238, 1023186, 'bardock00', 33, 1746346673899, 1746346673904, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13239, 1023187, 'anhdaxanh', 34, 1746354247356, 1746354247359, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13240, 1023188, 'phuong', 35, 1746363134517, 1746363134528, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13241, 1023189, 'depzai', 36, 1746365184902, 1746365184907, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13242, 1023190, 'sungjinwo', 37, 1746373638791, 1746373638795, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13243, 1023191, 'xayzavip', 38, 1746373881308, 1746373881311, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13244, 1023192, 'mhygnv', 39, 1746374047219, 1746374047224, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13245, 1023193, 'camlansuc', 40, 1746375546383, 1746421200559, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":18583,\"dame\":580,\"body\":16,\"leg\":17}', 1),
(13246, 1023194, 'siuuuu', 41, 1746375679471, 1746375679476, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13247, 1023195, 'gagagag', 42, 1746375755108, 1746375755111, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13248, 1023196, 'tuuubast', 43, 1746376227515, 1746376227521, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13249, 1023197, 'xiusayda', 44, 1746482314336, 1746482335853, 3, 0, 0, '[]', '{\"head\":341,\"def\":3,\"hp\":163,\"dame\":23,\"body\":342,\"leg\":343}', 1),
(13250, 1023198, 'nmpem', 45, 1746442512515, 1746442513021, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":5201,\"dame\":260,\"body\":10,\"leg\":11}', 1),
(13251, 1023199, 'killer', 46, 1746377977832, 1746377977838, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13252, 1023200, 'javfullhd', 47, 1746378720953, 1746378720959, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13253, 1023201, 'ttbom', 48, 1746382678772, 1746382678781, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13254, 1023202, 'kirinkame', 49, 1746383908530, 1746383908536, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13255, 1023203, 'zazaszas', 50, 1746384355236, 1746384355246, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13256, 1023204, 'skillissue', 51, 1746385403883, 1746385403887, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13257, 1023205, 'vegitoblue', 52, 1746386529527, 1746386529529, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13258, 1023206, 'ditmemay', 53, 1746386930199, 1746386930205, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13259, 1023207, 'hitsike', 54, 1746387243525, 1746387243530, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13260, 1023208, 'huangxingg', 55, 1746395618296, 1746421200206, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":791,\"dame\":89,\"body\":10,\"leg\":11}', 1),
(13261, 1023209, 'nangly', 56, 1746395977161, 1746395977165, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13262, 1023210, 'cubtbay', 57, 1746396620901, 1746396620907, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13263, 1023211, 'trumb0m', 58, 1746396765074, 1746396765080, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13264, 1023212, 'noikhoa', 59, 1746398216204, 1746398216208, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13265, 1023213, 'metaixiu', 60, 1746398549352, 1746398549356, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13266, 1023214, 'baochimhoi', 61, 1746398597873, 1746398597883, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13267, 1023215, 'hewegodn', 62, 1746398669228, 1746398669232, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13268, 1023216, 'clxxx', 63, 1746398768290, 1746398768300, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13269, 1023217, 'top1bxh', 64, 1746402901454, 1746402901457, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13270, 1023218, 'kamejokok', 65, 1746403401848, 1746403401853, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13271, 1023219, 'adminz', 66, 1746403539516, 1746403539521, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13272, 1023220, 'consaovip', 67, 1746406562621, 1746406562625, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13273, 1023221, 'nghinghi', 68, 1746406578113, 1746406578119, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13274, 1023222, 'bom1mau', 69, 1746407913873, 1746407913879, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13275, 1023223, 'kawai', 70, 1746411137739, 1746411137748, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13276, 1023224, 'dangvhung', 71, 1746416490956, 1746416491005, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13277, 1023225, 'kkkkk', 72, 1746416727291, 1746416727296, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13278, 1023226, 'madara', 73, 1746417239974, 1746417239978, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13279, 1023227, 'prayer', 74, 1746420333634, 1746420333639, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13280, 1023228, 'zenkai', 75, 1746421114860, 1746421200419, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13281, 1023229, 'no1namec', 76, 1746424604877, 1746424604883, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13282, 1023230, 'jaycee', 77, 1746425582529, 1746425582536, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13283, 1023231, 'k3cook', 78, 1746426194516, 1746426194521, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13284, 1023232, 'boomm', 79, 1746441170000, 1746441170005, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13285, 1023233, 'adunhae', 80, 1746447033141, 1746447033149, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13286, 1023234, 'boikame', 81, 1746450127410, 1746450127414, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13287, 1023235, 'tester', 82, 1747452932515, 1747452936054, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":169,\"dame\":19,\"body\":10,\"leg\":11}', 1),
(13288, 1023236, 'chumpksv7', 83, 1746461902019, 1746461902025, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13289, 1023237, 'huiiiiia', 84, 1746466384089, 1746466384093, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13290, 1023238, 'ricks', 85, 1746467086930, 1746467086934, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13291, 1023239, 'taogtop', 86, 1746469173728, 1746469173733, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13292, 1023240, 'hackgame', 87, 1746476304908, 1746476304911, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13293, 1023241, 'boyka', 88, 1746482709490, 1746482709497, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13294, 1023242, 'dptrai0six', 89, 1746486615235, 1746486615243, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13295, 1023243, 'maydamd1', 90, 1746486684190, 1746486684196, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13296, 1023244, 'tdiie', 91, 1746487179739, 1746487179749, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13297, 1023245, 'kuruima', 92, 1746488018134, 1746488018141, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13298, 1023246, 'dwngkhoa', 93, 1746493117104, 1746493117109, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13299, 1023247, 'piccolo', 94, 1746493224714, 1746493224721, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13300, 1023248, 'onehit', 95, 1746493270085, 1746493270089, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13301, 1023249, 'kaioken8', 96, 1746494657785, 1746494657790, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13302, 1023250, 'kakaxd', 97, 1746495613462, 1746495613467, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13303, 1023251, 'napthe', 98, 1747474561876, 1747474562383, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 1),
(13304, 1023252, 'deadend', 99, 1746500693694, 1746500693701, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13305, 1023253, 'broly', 100, 1747474602296, 1747474602805, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13306, 1023254, 'tungdh', 101, 1746507348411, 1746507674101, 3, 0, 0, '[]', '{\"head\":174,\"def\":2,\"hp\":282,\"dame\":12,\"body\":175,\"leg\":176}', 1),
(13307, 1023255, 'khongcay', 102, 1747474642109, 1747474642616, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":160,\"dame\":139,\"body\":10,\"leg\":11}', 1),
(13308, 1023256, 'duy18cm', 103, 1746508130947, 1746508130964, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13309, 1023257, 'root111', 104, 1746508826027, 1746508826031, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13310, 1023258, 'nghia15', 105, 1746509134096, 1746509134105, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13311, 1023259, 'uygig', 106, 1746509231192, 1746509231200, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13312, 1023260, 'fawfggg', 107, 1746510976178, 1746510976182, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13313, 1023261, 'majibuu', 108, 1746511900546, 1746511900551, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13314, 1023262, 'thekyn', 109, 1747476850073, 1747476850577, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":16,\"body\":16,\"leg\":17}', 1),
(13315, 1023263, 'golas', 110, 1747453703750, 1747453703756, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13316, 1023264, 'demons', 111, 1747453819700, 1747453819705, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13317, 1023265, 'songoku', 112, 1747460517750, 1747460518261, 3, 0, 0, '[]', '{\"head\":332,\"def\":2,\"hp\":298,\"dame\":11,\"body\":333,\"leg\":334}', 1),
(13318, 1023266, 'hacker9999', 113, 1747454257418, 1747458000954, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":293,\"dame\":255,\"body\":14,\"leg\":15}', 1),
(13319, 1023267, 'nmcaychay', 114, 1747454316453, 1747458000971, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":17723,\"dame\":1967,\"body\":10,\"leg\":11}', 1),
(13320, 1023268, 'trumbosss', 115, 1747454704849, 1747458000855, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":2994,\"dame\":433,\"body\":14,\"leg\":15}', 1),
(13321, 1023269, 'renjiso1st', 116, 1747454725993, 1747458000683, 3, 0, 0, '[]', '{\"head\":180,\"def\":3,\"hp\":160,\"dame\":66,\"body\":181,\"leg\":182}', 1),
(13322, 1023270, 'dcmvietduc', 117, 1747455444181, 1747455444183, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13323, 1023271, 'vducbusciu', 118, 1747455604593, 1747455604599, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13324, 1023272, 'dogvietduc', 119, 1747455717870, 1747455717877, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13325, 1023273, 'anlonkoku', 120, 1747455790197, 1747455790200, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13326, 1023274, 'ducconcho', 121, 1747455956808, 1747455956815, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13327, 1023275, 'shiwan', 122, 1747456115548, 1747458000170, 3, 0, 0, '[]', '{\"head\":1380,\"def\":2,\"hp\":211,\"dame\":105,\"body\":1381,\"leg\":1382}', 1),
(13328, 1023276, 'namecc', 123, 1747457368741, 1747458000066, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":145,\"dame\":102,\"body\":10,\"leg\":11}', 1),
(13329, 1023277, 'nameccc', 124, 1747457947681, 1747458067249, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":153,\"dame\":12,\"body\":10,\"leg\":11}', 1),
(13330, 1023278, 'admincx', 125, 1747458298625, 1747458298628, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13331, 1023279, 'lanhjjj', 126, 1747460302632, 1747460302643, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13332, 1023280, 'tditmem', 127, 1747460697581, 1747460697583, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13333, 1023281, 'songohan', 128, 1747462055699, 1747462055706, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13334, 1023282, 'maychem', 129, 1747464502060, 1747464502064, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13335, 1023283, 'lommz', 130, 1747465073226, 1747465073230, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13336, 1023284, 'youkenw', 131, 1747465771746, 1747465771750, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13337, 1023285, 'hjhjhjhjhj', 132, 1747465848971, 1747465848979, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13338, 1023286, 'syxuka', 133, 1747465861510, 1747465861515, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13339, 1023287, 'syxuku', 134, 1747467033741, 1747467033746, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13340, 1023288, 'onekill', 135, 1747467540953, 1747467540959, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13341, 1023289, 'zxbicoloxz', 136, 1747467775268, 1747467775273, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13342, 1023290, 'virus', 137, 1747468004066, 1747468004070, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13343, 1023291, 'picollo', 138, 1747468849598, 1747468849604, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13344, 1023292, 'cellphones', 139, 1747468967689, 1747468967693, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13345, 1023293, 'kakarot', 140, 1747469041664, 1747469041672, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13346, 1023294, 'vegeta', 141, 1747469079974, 1747469079983, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13347, 1023295, 'namec', 142, 1747469260385, 1747469260389, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13348, 1023296, 'iphone', 143, 1747469520755, 1747469520761, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13349, 1023297, 'facebook', 144, 1747469623643, 1747469623650, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13350, 1023298, 'fangyuan', 145, 1747469837335, 1747469837340, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13351, 1023299, 'picolo', 146, 1747469985950, 1747469985954, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13352, 1023300, 'embetrathu', 147, 1747481164875, 1747481164880, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13353, 1023301, 'bunbocute', 148, 1747481935515, 1747481935518, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13354, 1023302, 'top1kame', 149, 1747482536727, 1747482536731, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13355, 1023303, 'hiihii', 150, 1747482947611, 1747482947614, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13356, 1023304, 'daxanh', 151, 1747484078100, 1747484078104, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13357, 1023305, 'kamejoko', 152, 1747484259704, 1747484259713, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13358, 1023306, 'octieu', 153, 1747484308264, 1747484308269, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13359, 1023307, 'cadic', 154, 1747484371116, 1747484371120, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13360, 1023308, 'ngocrong', 155, 1747484494937, 1747484494941, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13361, 1023309, 'dende', 156, 1747484510490, 1747484510494, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13362, 1023310, 'octiu1', 157, 1747484605582, 1747484605589, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13363, 1023311, 'otama', 158, 1747484972028, 1747484972031, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13364, 1023312, 'xayda', 159, 1747487137085, 1747487137089, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13365, 1023313, 'kukuro', 160, 1747491175158, 1747491175161, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13366, 1023314, 'gamer69', 161, 1747491902832, 1747491902837, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13367, 1023315, 'gohanvjp', 162, 1747514718508, 1747514718550, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13368, 1023316, 'omachj', 163, 1747515199404, 1747515199416, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13369, 1023317, 'anhdautroc', 164, 1747515210953, 1747515210957, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13370, 1023318, 'dsdsaasd', 165, 1747527276492, 1747527276500, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13371, 1023319, 'ninhanh', 166, 1747527892187, 1747527892203, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13372, 1023320, 'pemvang', 167, 1747528002369, 1747528002378, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13373, 1023321, 'trumsuy', 168, 1747528077141, 1747528077145, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13374, 1023322, 'linhoi', 169, 1747528229977, 1747528229984, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13375, 1023323, 'bulon123', 170, 1747528235653, 1747528235657, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13376, 1023324, 'tienbeoo', 171, 1747528406960, 1747528406965, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13377, 1023325, 'szczesny', 172, 1747528810325, 1747528810333, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13378, 1023326, 'ciara', 173, 1747528878065, 1747528878069, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13379, 1023327, 'soilaze', 174, 1747528886624, 1747528886627, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13380, 1023328, 'jack97', 175, 1747528942581, 1747528942586, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13381, 1023329, 'adminn', 176, 1747529077829, 1747529077832, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13382, 1023332, 'xayda', 177, 1747918066480, 1747918067018, 3, 0, 0, '[]', '{\"head\":383,\"def\":0,\"hp\":16709692,\"dame\":28991,\"body\":384,\"leg\":385}', 1),
(13383, 1023333, 'omachj', 195, 1748391640514, 1748354830672, 3, 0, 2, '[\"{\\\"event\\\":\\\"Thua haaju20cm[185]\\\",\\\"timestamp\\\":1748391640518}\"]', '{\"head\":383,\"def\":7200,\"hp\":1583966,\"dame\":38744,\"body\":384,\"leg\":385}', 1),
(13384, 1023334, 'iqplus', 183, 1748779672562, 1748779673069, 3, 0, 1, '[]', '{\"head\":391,\"def\":2,\"hp\":1301113,\"dame\":117707,\"body\":392,\"leg\":393}', 1),
(13385, 1023335, 'phimsex', 200, 1748366287577, 1747531589723, 3, 0, 2, '[\"{\\\"event\\\":\\\"Thua iphone[190]\\\",\\\"timestamp\\\":1748366287581}\"]', '{\"head\":128,\"def\":2,\"hp\":149,\"dame\":11,\"body\":10,\"leg\":11}', 0),
(13386, 1023336, 'tienbeoo', 185, 1748542079785, 1747544400841, 3, 0, 2, '[\"{\\\"event\\\":\\\"Thua bunbocute[182]\\\",\\\"timestamp\\\":1748542079789}\"]', '{\"head\":383,\"def\":2,\"hp\":280531,\"dame\":9100,\"body\":384,\"leg\":385}', 0),
(13387, 1023337, 'bunbocute', 181, 1749522455333, 1749522455838, 1, 2, 5, '[]', '{\"head\":867,\"def\":8643.6,\"hp\":5644034.636101632,\"dame\":180857.66260214627,\"body\":868,\"leg\":869}', 1),
(13388, 1023338, 'nobita', 193, 1748390289335, 1748271507498, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[183]\\\",\\\"timestamp\\\":1748390289338}\"]', '{\"head\":383,\"def\":3,\"hp\":3161,\"dame\":1010,\"body\":384,\"leg\":385}', 0),
(13389, 1023339, 'idsieupham', 184, 1748745488674, 1748745489179, 3, 0, 0, '[]', '{\"head\":391,\"def\":0,\"hp\":1302,\"dame\":7567,\"body\":392,\"leg\":393}', 1),
(13390, 1023340, 'phonglove', 205, 1748713495363, 1748713495866, 3, 0, 2, '[]', '{\"head\":391,\"def\":42,\"hp\":1774972,\"dame\":63432,\"body\":392,\"leg\":393}', 1),
(13391, 1023341, 'reall', 186, 1748268352217, 1748268352722, 3, 0, 0, '[]', '{\"head\":377,\"def\":2,\"hp\":570022,\"dame\":34723,\"body\":378,\"leg\":379}', 1),
(13392, 1023342, 'khanh', 187, 1747531832658, 1747531832666, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13393, 1023343, 'syxuka', 198, 1749474580539, 1749474581046, 3, 0, 1, '[]', '{\"head\":383,\"def\":42.0,\"hp\":27214.5,\"dame\":27273.0,\"body\":384,\"leg\":385}', 1),
(13394, 1023344, 'djtnhau', 189, 1747531839333, 1747531839351, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13395, 1023345, 'shijn', 210, 1749449367217, 1749449367727, 3, 0, 2, '[]', '{\"head\":127,\"def\":2.0,\"hp\":44297.95570200001,\"dame\":7988.4645120000005,\"body\":14,\"leg\":15}', 1),
(13396, 1023346, 'tobiiii', 191, 1747531847905, 1747531847932, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13397, 1023347, 'cutewa', 192, 1747531849999, 1747544400929, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":76882,\"dame\":15232,\"body\":10,\"leg\":11}', 1),
(13398, 1023348, 'lommz', 203, 1748390282303, 1747971606795, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[193]\\\",\\\"timestamp\\\":1748390282306}\"]', '{\"head\":383,\"def\":43,\"hp\":123980,\"dame\":11106,\"body\":384,\"leg\":385}', 0),
(13399, 1023349, 'nmhka', 194, 1748678840825, 1748678841330, 3, 1, 0, '[]', '{\"head\":383,\"def\":499,\"hp\":1560983,\"dame\":90717,\"body\":384,\"leg\":385}', 1),
(13400, 1023350, 'tho7mau', 204, 1748310619300, 1748135238771, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua hjhjhjhj[195]\\\",\\\"timestamp\\\":1748310619307}\"]', '{\"head\":383,\"def\":400,\"hp\":142788,\"dame\":52274,\"body\":384,\"leg\":385}', 0),
(13401, 1023351, 'trumsuy', 196, 1749485844979, 1749485845486, 3, 0, 0, '[]', '{\"head\":391,\"def\":2.0,\"hp\":1444491.9416999999,\"dame\":41870.53045056,\"body\":392,\"leg\":393}', 1),
(13402, 1023352, 'wheeyyy', 197, 1747573008941, 1747573009448, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":5739,\"dame\":590,\"body\":16,\"leg\":17}', 1),
(13403, 1023353, 'osaka', 208, 1749257720047, 1748494530696, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua matuy[198]\\\",\\\"timestamp\\\":1749257720050}\"]', '{\"head\":391,\"def\":2.0,\"hp\":1139803.542468,\"dame\":28154.849184,\"body\":392,\"leg\":393}', 0),
(13404, 1023354, 'gnurt', 199, 1749274930999, 1749274931509, 3, 0, 0, '[]', '{\"head\":870,\"def\":8199.0,\"hp\":2244152.38144,\"dame\":217775.8480758883,\"body\":871,\"leg\":872}', 1),
(13405, 1023355, 'songohan', 228, 1749257702063, 1747544400500, 3, 0, 3, '[\"{\\\"event\\\":\\\"Thua matuy[218]\\\",\\\"timestamp\\\":1749257702068}\"]', '{\"head\":127,\"def\":1602.0,\"hp\":61561.915,\"dame\":20530.72,\"body\":14,\"leg\":15}', 0),
(13406, 1023356, 'tapchoinro', 201, 1747531866646, 1747531866649, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13407, 1023357, 'phuphuc', 212, 1748794335087, 1747531866930, 3, 1, 1, '[\"{\\\"event\\\":\\\"Hạ matuy[601]\\\",\\\"timestamp\\\":1748794335103}\"]', '{\"head\":127,\"def\":2,\"hp\":285,\"dame\":11,\"body\":14,\"leg\":15}', 0),
(13408, 1023358, 'ninhanh', 213, 1749099727206, 1749099727712, 3, 0, 1, '[]', '{\"head\":870,\"def\":2.0,\"hp\":2328999.8641769597,\"dame\":234959.23405375227,\"body\":871,\"leg\":872}', 1),
(13409, 1023359, 'hjhjhjhj', 182, 1749402755140, 1749402755645, 3, 5, 4, '[\"{\\\"event\\\":\\\"Thua bunbocute[181]\\\",\\\"timestamp\\\":1749470438511}\"]', '{\"head\":1614,\"def\":7202.0,\"hp\":1002091.1411246401,\"dame\":181065.90333942408,\"body\":1615,\"leg\":1616}', 1),
(13410, 1023360, 'haaju20cm', 179, 1749470399971, 1749096068726, 3, 8, 1, '[\"{\\\"event\\\":\\\"Hạ bunbocute[182]\\\",\\\"timestamp\\\":1749470414313}\"]', '{\"head\":867,\"def\":3.0,\"hp\":5940782.854980469,\"dame\":700368.1340265768,\"body\":868,\"leg\":869}', 0),
(13411, 1023361, 'songoku', 206, 1749356024614, 1749356025132, 3, 0, 0, '[]', '{\"head\":127,\"def\":2.0,\"hp\":81989.595,\"dame\":9921.2064,\"body\":14,\"leg\":15}', 1),
(13412, 1023362, 'kokomi00', 207, 1747531885572, 1747544400734, 3, 0, 0, '[]', '{\"head\":1380,\"def\":2,\"hp\":33334,\"dame\":54571,\"body\":1381,\"leg\":1382}', 1),
(13413, 1023363, 'osoko', 218, 1749257710926, 1748494724146, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua matuy[208]\\\",\\\"timestamp\\\":1749257710930}\"]', '{\"head\":9,\"def\":2.0,\"hp\":719303.976,\"dame\":31453.228799999997,\"body\":10,\"leg\":11}', 0),
(13414, 1023364, 'bombom', 209, 1748775649892, 1748775650399, 3, 2, 0, '[]', '{\"head\":867,\"def\":7203,\"hp\":26756331,\"dame\":48608,\"body\":868,\"leg\":869}', 1),
(13415, 1023365, 'naruto', 219, 1748339846589, 1747566252585, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua namtips[210]\\\",\\\"timestamp\\\":1748339846592}\"]', '{\"head\":128,\"def\":2,\"hp\":300514,\"dame\":10369,\"body\":10,\"leg\":11}', 0),
(13416, 1023366, 'thanhtruc', 211, 1748013506370, 1748013506874, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":285,\"dame\":11,\"body\":14,\"leg\":15}', 1),
(13417, 1023367, 'kisubomm', 222, 1748497762578, 1747544400989, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua ebedi[212]\\\",\\\"timestamp\\\":1748497762583}\"]', '{\"head\":126,\"def\":3,\"hp\":23778,\"dame\":11020,\"body\":16,\"leg\":17}', 0),
(13418, 1023368, 'wanner', 223, 1748517963055, 1748024321175, 3, 1, 1, '[\"{\\\"event\\\":\\\"Hạ sskendyss[231]\\\",\\\"timestamp\\\":1748517963073}\"]', '{\"head\":383,\"def\":3,\"hp\":6829088,\"dame\":10034,\"body\":384,\"leg\":385}', 0),
(13419, 1023369, 'yennhiii', 214, 1747531895225, 1747544400989, 3, 0, 0, '[]', '{\"head\":1198,\"def\":2,\"hp\":172705,\"dame\":82968,\"body\":1199,\"leg\":1200}', 1),
(13420, 1023370, 'idchumgame', 215, 1748459678218, 1747531905375, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ matuy[601]\\\",\\\"timestamp\\\":1748459678233}\"]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13421, 1023371, 'caychay', 216, 1747588855797, 1747588856303, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":14850,\"dame\":20318,\"body\":14,\"leg\":15}', 1),
(13422, 1023372, 'diablo', 217, 1748513193845, 1748513194350, 3, 0, 0, '[]', '{\"head\":383,\"def\":2,\"hp\":1200909,\"dame\":301013,\"body\":384,\"leg\":385}', 1),
(13423, 1023373, 'bophong', 227, 1748366236141, 1747544400928, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua iphone[218]\\\",\\\"timestamp\\\":1748366236145}\"]', '{\"head\":383,\"def\":2,\"hp\":32095,\"dame\":15235,\"body\":384,\"leg\":385}', 0),
(13424, 1023374, 'moemoe', 229, 1748517944271, 1747531927183, 3, 1, 1, '[\"{\\\"event\\\":\\\"Hạ sskendyss[231]\\\",\\\"timestamp\\\":1748517944282}\"]', '{\"head\":127,\"def\":2,\"hp\":264,\"dame\":13,\"body\":14,\"leg\":15}', 0),
(13425, 1023375, 'soilaze', 220, 1747531927574, 1747531927578, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13426, 1023376, 'namtip', 221, 1748517878039, 1748056920822, 3, 4, 0, '[\"{\\\"event\\\":\\\"Hạ sskendyss[231]\\\",\\\"timestamp\\\":1748517897691}\"]', '{\"head\":383,\"def\":2,\"hp\":424004,\"dame\":26533,\"body\":384,\"leg\":385}', 0),
(13427, 1023377, 'sewashi', 232, 1749132978308, 1748271552897, 3, 5, 1, '[\"{\\\"event\\\":\\\"Hạ oncloudms[412]\\\",\\\"timestamp\\\":1749132978325}\"]', '{\"head\":126,\"def\":3.0,\"hp\":165.6,\"dame\":1543.3000000000002,\"body\":16,\"leg\":17}', 0),
(13428, 1023378, 'oseko', 233, 1748512549263, 1748512549786, 3, 0, 1, '[]', '{\"head\":391,\"def\":4,\"hp\":1002171,\"dame\":96860,\"body\":392,\"leg\":393}', 1),
(13429, 1023379, 'nappa', 224, 1748553645094, 1748553645599, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":1065753,\"dame\":44848,\"body\":384,\"leg\":385}', 1),
(13430, 1023380, 'baongoc', 225, 1748517953109, 1747971651379, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ sskendyss[231]\\\",\\\"timestamp\\\":1748517953123}\"]', '{\"head\":391,\"def\":2,\"hp\":374514,\"dame\":30782,\"body\":392,\"leg\":393}', 0),
(13431, 1023381, 'darklil', 226, 1747531974697, 1747531974705, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13432, 1023382, 'godtd', 237, 1748366224703, 1747544400388, 3, 1, 1, '[\"{\\\"event\\\":\\\"Hạ haajudzai[246]\\\",\\\"timestamp\\\":1748392082701}\"]', '{\"head\":127,\"def\":2,\"hp\":136899,\"dame\":9921,\"body\":14,\"leg\":15}', 0),
(13433, 1023383, 'bachtuhoa', 238, 1749257693129, 1749280380220, 3, 2, 1, '[]', '{\"head\":391,\"def\":7202.0,\"hp\":2275986.1100748796,\"dame\":57993.70040880001,\"body\":392,\"leg\":393}', 1),
(13434, 1023384, 'bunma', 248, 1749257684414, 1748651110751, 3, 1, 2, '[\"{\\\"event\\\":\\\"Thua matuy[238]\\\",\\\"timestamp\\\":1749257684420}\"]', '{\"head\":736,\"def\":2.0,\"hp\":360216.66835439997,\"dame\":12195.816192000002,\"body\":737,\"leg\":738}', 0),
(13435, 1023385, 'songoten', 230, 1748517907014, 1747544859091, 3, 3, 0, '[\"{\\\"event\\\":\\\"Hạ sskendyss[231]\\\",\\\"timestamp\\\":1748517907024}\"]', '{\"head\":127,\"def\":2,\"hp\":147850,\"dame\":15305,\"body\":14,\"leg\":15}', 0),
(13436, 1023386, 'blackxayda', 242, 1748497746288, 1747544400500, 3, 0, 2, '[\"{\\\"event\\\":\\\"Thua ebedi[232]\\\",\\\"timestamp\\\":1748497746292}\"]', '{\"head\":126,\"def\":100,\"hp\":275632,\"dame\":8501,\"body\":73,\"leg\":74}', 0),
(13437, 1023387, 'sskendyss', 231, 1749357232634, 1749357233138, 3, 2, 14, '[]', '{\"head\":873,\"def\":7204.0,\"hp\":1299601.402496,\"dame\":455651.69275908696,\"body\":874,\"leg\":875}', 1),
(13438, 1023388, 'idchumalze', 243, 1748390007898, 1747532007741, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[233]\\\",\\\"timestamp\\\":1748390007902}\"]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":11,\"body\":10,\"leg\":11}', 0),
(13439, 1023389, 'kitty', 234, 1749133035231, 1747544400883, 3, 2, 0, '[\"{\\\"event\\\":\\\"Hạ oncloudms[412]\\\",\\\"timestamp\\\":1749133035246}\"]', '{\"head\":383,\"def\":3.0,\"hp\":2280115.435241548,\"dame\":20014.68,\"body\":384,\"leg\":385}', 0),
(13440, 1023390, 'phoenix', 235, 1748056535643, 1748056536150, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":1281080,\"dame\":130628,\"body\":392,\"leg\":393}', 1),
(13441, 1023391, 'bamayne', 236, 1749049556588, 1749049557105, 3, 0, 0, '[]', '{\"head\":870,\"def\":7600.0,\"hp\":2209471.7657233058,\"dame\":1076081.7352967034,\"body\":871,\"leg\":872}', 1),
(13442, 1023392, 'iphone', 188, 1749257870702, 1748833967409, 2, 6, 4, '[\"{\\\"event\\\":\\\"Thua matuy[180]\\\",\\\"timestamp\\\":1749257870707}\"]', '{\"head\":383,\"def\":3.0,\"hp\":2.071442233496764E7,\"dame\":45105.4836,\"body\":384,\"leg\":385}', 0),
(13443, 1023393, 'hikoo', 258, 1749257675007, 1748684771842, 3, 0, 2, '[\"{\\\"event\\\":\\\"Thua matuy[248]\\\",\\\"timestamp\\\":1749257675015}\"]', '{\"head\":391,\"def\":2.0,\"hp\":1197126.13313,\"dame\":32591.0907,\"body\":392,\"leg\":393}', 0),
(13444, 1023394, 'taotrumok', 239, 1749380554118, 1749380554626, 3, 0, 0, '[]', '{\"head\":873,\"def\":5202.0,\"hp\":1668428.3339999998,\"dame\":1558188.993522297,\"body\":874,\"leg\":875}', 1),
(13445, 1023395, 'idchumsv', 246, 1748459769241, 1747532087819, 3, 1, 1, '[\"{\\\"event\\\":\\\"Hạ matuy[601]\\\",\\\"timestamp\\\":1748459769250}\"]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13446, 1023396, 'renjiso1st', 241, 1748774736571, 1748774737076, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":586753,\"dame\":21084,\"body\":384,\"leg\":385}', 1),
(13447, 1023397, 'dyyyyy', 252, 1748497737707, 1747544400778, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua ebedi[242]\\\",\\\"timestamp\\\":1748497737716}\"]', '{\"head\":128,\"def\":2,\"hp\":704663,\"dame\":25832,\"body\":10,\"leg\":11}', 0),
(13448, 1023398, 'gohan', 253, 1748390000498, 1748048800824, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[243]\\\",\\\"timestamp\\\":1748390000505}\"]', '{\"head\":127,\"def\":2,\"hp\":99647,\"dame\":1631,\"body\":14,\"leg\":15}', 0),
(13449, 1023399, 'aevccc', 244, 1748869878286, 1748869878793, 3, 1, 0, '[]', '{\"head\":873,\"def\":2.0,\"hp\":825494.6048,\"dame\":342491.26625863573,\"body\":874,\"leg\":875}', 1),
(13450, 1023400, 'daica', 245, 1748392057491, 1747544400518, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ haajudzai[255]\\\",\\\"timestamp\\\":1748392057496}\"]', '{\"head\":383,\"def\":3,\"hp\":723637,\"dame\":5481,\"body\":384,\"leg\":385}', 0),
(13451, 1023401, 'baokun', 255, 1748392068489, 1747544400047, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua haajudzai[246]\\\",\\\"timestamp\\\":1748392068492}\"]', '{\"head\":383,\"def\":0,\"hp\":74280,\"dame\":14657,\"body\":384,\"leg\":385}', 0),
(13452, 1023402, 'bomexp', 247, 1748616713728, 1748616714235, 3, 0, 0, '[]', '{\"head\":383,\"def\":5,\"hp\":3652222,\"dame\":62442,\"body\":384,\"leg\":385}', 1),
(13453, 1023403, 'boruto', 268, 1748794409124, 1747566207470, 3, 1, 2, '[\"{\\\"event\\\":\\\"Thua matuy[258]\\\",\\\"timestamp\\\":1748794409132}\"]', '{\"head\":391,\"def\":2,\"hp\":236361,\"dame\":8082,\"body\":392,\"leg\":393}', 0),
(13454, 1023404, 'voltex', 249, 1747602086005, 1747602086509, 3, 0, 0, '[]', '{\"head\":127,\"def\":1202,\"hp\":19617,\"dame\":6494,\"body\":14,\"leg\":15}', 1),
(13455, 1023405, 'longz', 250, 1748769772184, 1747532133932, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ trumsuyy[386]\\\",\\\"timestamp\\\":1748769772193}\"]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13456, 1023406, 'bomaytrum', 251, 1748663542759, 1748663543264, 3, 0, 0, '[]', '{\"head\":383,\"def\":7203,\"hp\":7592954,\"dame\":41475,\"body\":384,\"leg\":385}', 1),
(13457, 1023407, 'kehuydiet', 262, 1748497728286, 1748147562673, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua ebedi[252]\\\",\\\"timestamp\\\":1748497728290}\"]', '{\"head\":391,\"def\":0,\"hp\":1001908,\"dame\":33941,\"body\":392,\"leg\":393}', 0),
(13458, 1023408, '14hoo', 263, 1748389992564, 1747532151486, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[253]\\\",\\\"timestamp\\\":1748389992580}\"]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13459, 1023409, 'zenosama', 254, 1748116368827, 1748116369334, 3, 0, 0, '[]', '{\"head\":870,\"def\":42,\"hp\":1377013,\"dame\":605143,\"body\":871,\"leg\":872}', 1),
(13460, 1023410, 'armin', 264, 1748392048295, 1747544400790, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua haajudzai[255]\\\",\\\"timestamp\\\":1748392048298}\"]', '{\"head\":569,\"def\":400,\"hp\":54443,\"dame\":12288,\"body\":472,\"leg\":473}', 0),
(13461, 1023411, 'hacker9999', 256, 1749022844104, 1749022848610, 3, 0, 0, '[]', '{\"head\":383,\"def\":7202.0,\"hp\":2193111.2202664,\"dame\":114661.09810157483,\"body\":384,\"leg\":385}', 1),
(13462, 1023412, 'zenos', 257, 1747532185507, 1747532185511, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13463, 1023413, 'kuson', 278, 1748794399453, 1748572812513, 3, 0, 2, '[\"{\\\"event\\\":\\\"Thua matuy[268]\\\",\\\"timestamp\\\":1748794399471}\"]', '{\"head\":383,\"def\":3,\"hp\":2189931,\"dame\":66909,\"body\":384,\"leg\":385}', 0),
(13464, 1023414, 'radas', 259, 1747969007179, 1747969019702, 3, 0, 0, '[]', '{\"head\":383,\"def\":7,\"hp\":1482105,\"dame\":42370,\"body\":384,\"leg\":385}', 1),
(13465, 1023415, 'vietnam', 260, 1749449372968, 1749449373473, 3, 0, 0, '[]', '{\"head\":127,\"def\":2.0,\"hp\":41016.62565,\"dame\":10020.418463999998,\"body\":14,\"leg\":15}', 1),
(13466, 1023416, 'xzdravenz', 261, 1749220636072, 1749220636576, 3, 0, 0, '[]', '{\"head\":383,\"def\":3.0,\"hp\":2807303.184,\"dame\":42297.66,\"body\":384,\"leg\":385}', 1),
(13467, 1023417, '1kam3', 272, 1748497718988, 1747532236236, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua ebedi[262]\\\",\\\"timestamp\\\":1748497718992}\"]', '{\"head\":1198,\"def\":2,\"hp\":72544,\"dame\":22488,\"body\":1199,\"leg\":1200}', 0),
(13468, 1023418, 'ebedi', 202, 1748751716719, 1748751851323, 3, 7, 1, '[]', '{\"head\":870,\"def\":7206,\"hp\":1827486,\"dame\":182687,\"body\":871,\"leg\":872}', 1),
(13469, 1023419, 'trumboss', 274, 1748540534268, 1748540534776, 3, 0, 1, '[]', '{\"head\":127,\"def\":0,\"hp\":85208,\"dame\":11471,\"body\":57,\"leg\":15}', 1),
(13470, 1023420, 'tuoiloz', 265, 1748437392153, 1748437392657, 3, 0, 0, '[]', '{\"head\":383,\"def\":2,\"hp\":397398,\"dame\":177277,\"body\":384,\"leg\":385}', 1),
(13471, 1023421, 'zamasu', 266, 1748109050604, 1748109051109, 3, 0, 0, '[]', '{\"head\":427,\"def\":0,\"hp\":124252,\"dame\":41720,\"body\":428,\"leg\":429}', 1),
(13472, 1023422, 'golds', 267, 1747554606119, 1747554606623, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":68865,\"dame\":9245,\"body\":10,\"leg\":11}', 1),
(13473, 1023423, 'kisupem', 441, 1748339685598, 1747544400288, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua namtips[268]\\\",\\\"timestamp\\\":1748339685604}\"]', '{\"head\":391,\"def\":2,\"hp\":18173,\"dame\":9154,\"body\":392,\"leg\":393}', 0),
(13474, 1023424, 'berus', 269, 1747563992878, 1747563993384, 3, 0, 0, '[]', '{\"head\":127,\"def\":0,\"hp\":15843,\"dame\":5871,\"body\":57,\"leg\":58}', 1),
(13475, 1023425, 'nm001', 270, 1749049374106, 1749049374615, 3, 0, 0, '[]', '{\"head\":391,\"def\":6.0,\"hp\":12141.4,\"dame\":26039.0,\"body\":392,\"leg\":393}', 1),
(13476, 1023426, 'szczesny', 271, 1747532399184, 1747544400669, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":61644,\"dame\":25365,\"body\":392,\"leg\":393}', 1),
(13477, 1023427, 'bunrieucua', 282, 1749445191642, 1749445192151, 3, 0, 1, '[]', '{\"head\":126,\"def\":8643.6,\"hp\":1274549.10115392,\"dame\":52607.91981312,\"body\":16,\"leg\":17}', 1),
(13478, 1023428, 'mihawk', 273, 1748459760457, 1748059751106, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ matuy[601]\\\",\\\"timestamp\\\":1748459760467}\"]', '{\"head\":391,\"def\":2,\"hp\":1047797,\"dame\":29139,\"body\":392,\"leg\":393}', 0),
(13479, 1023429, 'chaian', 284, 1749133048907, 1748271600223, 3, 1, 1, '[\"{\\\"event\\\":\\\"Hạ oncloudms[412]\\\",\\\"timestamp\\\":1749133048922}\"]', '{\"head\":126,\"def\":3.0,\"hp\":5658.0,\"dame\":676.2,\"body\":16,\"leg\":74}', 0),
(13480, 1023430, 'vuatd', 275, 1747532430509, 1747532430512, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13481, 1023431, 'xayda', 276, 1748429557546, 1748429558050, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":8151767,\"dame\":30905,\"body\":384,\"leg\":385}', 1),
(13482, 1023432, 'bunbebe', 277, 1749080177664, 1749080178170, 3, 0, 0, '[]', '{\"head\":9,\"def\":7204.0,\"hp\":756048.79874232,\"dame\":20387.92,\"body\":10,\"leg\":11}', 1),
(13483, 1023433, 'updoo1', 288, 1748794389587, 1748357383121, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua matuy[278]\\\",\\\"timestamp\\\":1748794389595}\"]', '{\"head\":127,\"def\":2,\"hp\":48623,\"dame\":691,\"body\":14,\"leg\":15}', 0),
(13484, 1023434, '1kamedie', 279, 1747532495057, 1747532495060, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13485, 1023435, 'octiiu', 280, 1749449389247, 1749449389752, 3, 0, 0, '[]', '{\"head\":873,\"def\":7.0,\"hp\":1.231280727526866E8,\"dame\":56816.79405371028,\"body\":874,\"leg\":875}', 1),
(13486, 1023436, 'anhthu1', 281, 1748392004031, 1747544400621, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ haajudzai[291]\\\",\\\"timestamp\\\":1748392004039}\"]', '{\"head\":383,\"def\":3,\"hp\":6444514,\"dame\":37942,\"body\":384,\"leg\":385}', 0),
(13487, 1023437, '1kam3die', 292, 1748389966410, 1747532540128, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[282]\\\",\\\"timestamp\\\":1748389966413}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13488, 1023438, 'hankiyu', 283, 1749106476363, 1749106476872, 3, 0, 0, '[]', '{\"head\":873,\"def\":8537.0,\"hp\":962301.84,\"dame\":135869.8540927815,\"body\":874,\"leg\":875}', 1),
(13489, 1023439, 'yufoxmain', 291, 1749132880406, 1747586848681, 3, 1, 1, '[\"{\\\"event\\\":\\\"Hạ oncloudms[412]\\\",\\\"timestamp\\\":1749132880414}\"]', '{\"head\":127,\"def\":90.0,\"hp\":7700.4,\"dame\":2409.48,\"body\":71,\"leg\":72}', 0),
(13490, 1023440, 'xuneo', 285, 1748271698792, 1748271699296, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":4389,\"dame\":1401,\"body\":384,\"leg\":385}', 1),
(13491, 1023441, 'reall1', 286, 1748794346508, 1748271873588, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ matuy[601]\\\",\\\"timestamp\\\":1748794346556}\"]', '{\"head\":383,\"def\":3,\"hp\":992801,\"dame\":34207,\"body\":384,\"leg\":385}', 0),
(13492, 1023442, 'kame50m', 287, 1747532593752, 1747532593756, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13493, 1023443, 'gokublue', 298, 1748774741784, 1748774742289, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua matuy[288]\\\",\\\"timestamp\\\":1748794368467}\"]', '{\"head\":383,\"def\":2,\"hp\":1520,\"dame\":959,\"body\":384,\"leg\":385}', 1),
(13494, 1023444, 'thekid', 289, 1747532603751, 1747544400337, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":73932,\"dame\":14632,\"body\":10,\"leg\":11}', 1),
(13495, 1023445, 'haaju18cm', 290, 1748647005066, 1748647005570, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":2694,\"dame\":16941,\"body\":10,\"leg\":11}', 1),
(13496, 1023446, 'sorry', 301, 1749027933415, 1749027933920, 3, 0, 1, '[]', '{\"head\":391,\"def\":2.0,\"hp\":17480.736468,\"dame\":2487.6911200000004,\"body\":392,\"leg\":393}', 1);
INSERT INTO `super_rank` (`id`, `player_id`, `name`, `rank`, `last_pk_time`, `last_reward_time`, `ticket`, `win`, `lose`, `history`, `info`, `received`) VALUES
(13497, 1023447, 'mlkame', 302, 1749129938351, 1749129938857, 3, 0, 1, '[]', '{\"head\":383,\"def\":2.0,\"hp\":319692.680801344,\"dame\":126931.91024674037,\"body\":384,\"leg\":385}', 1),
(13498, 1023448, '14h00', 293, 1747532629508, 1747532629520, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13499, 1023449, 'kinggen', 294, 1748056558550, 1748056559054, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":1335845,\"dame\":135678,\"body\":392,\"leg\":393}', 1),
(13500, 1023450, 'kamehameha', 295, 1747532670631, 1747544400574, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":124485,\"dame\":14407,\"body\":14,\"leg\":15}', 1),
(13501, 1023451, '11hoo', 296, 1747532671596, 1747532671600, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13502, 1023452, 'tuitenhihi', 297, 1749136256575, 1747544400361, 3, 3, 0, '[\"{\\\"event\\\":\\\"Hạ bien1602[307]\\\",\\\"timestamp\\\":1749136256586}\"]', '{\"head\":391,\"def\":2.0,\"hp\":439621.2504,\"dame\":32394.263999999996,\"body\":392,\"leg\":393}', 0),
(13503, 1023453, '10hoo', 601, 1748794358405, 1747532730247, 3, 1, 1, '[\"{\\\"event\\\":\\\"Thua matuy[298]\\\",\\\"timestamp\\\":1748794358412}\"]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13504, 1023454, 'pencilk', 299, 1748993121537, 1748993122044, 3, 0, 0, '[]', '{\"head\":383,\"def\":3.0,\"hp\":2693375.693742742,\"dame\":35005.275,\"body\":384,\"leg\":385}', 1),
(13505, 1023455, 'kingtd', 300, 1747532761151, 1747532761155, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13506, 1023456, 'kingshen', 648, 1748391984535, 1747532778177, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua haajudzai[301]\\\",\\\"timestamp\\\":1748391984539}\"]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13507, 1023457, 'blackgoku', 312, 1748389950444, 1747532819191, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[302]\\\",\\\"timestamp\\\":1748389950448}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13508, 1023458, 'cadic', 303, 1748099012176, 1748099012682, 3, 0, 0, '[]', '{\"head\":377,\"def\":3,\"hp\":832058,\"dame\":19660,\"body\":378,\"leg\":379}', 1),
(13509, 1023459, 'masenko', 304, 1747532829851, 1747544400993, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":7015,\"dame\":701,\"body\":59,\"leg\":60}', 1),
(13510, 1023460, 'babybuns', 305, 1748459725277, 1747532832908, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ matuy[601]\\\",\\\"timestamp\\\":1748459725286}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13511, 1023461, 'kisukm', 306, 1749136265304, 1747544400510, 3, 2, 0, '[\"{\\\"event\\\":\\\"Hạ bien1602[307]\\\",\\\"timestamp\\\":1749136265317}\"]', '{\"head\":127,\"def\":2.0,\"hp\":12140.265582,\"dame\":6489.2016,\"body\":14,\"leg\":15}', 0),
(13512, 1023462, 'bien1602', 307, 1749220988975, 1749220989486, 2, 0, 5, '[]', '{\"head\":873,\"def\":13056.0,\"hp\":1.2110563473103666E9,\"dame\":2.1705038919231206E7,\"body\":874,\"leg\":875}', 1),
(13513, 1023463, 'godking', 308, 1747532891557, 1747532891559, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13514, 1023464, 'anhdaxanh', 309, 1747532891605, 1747544400287, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":124349,\"dame\":14284,\"body\":10,\"leg\":11}', 1),
(13515, 1023465, 'babybunss', 310, 1747532913611, 1747532913616, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13516, 1023466, 'reall2', 311, 1748283616294, 1748283637837, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":65576,\"dame\":39880,\"body\":10,\"leg\":11}', 1),
(13517, 1023467, 'lomms', 322, 1748389932562, 1747544400293, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[312]\\\",\\\"timestamp\\\":1748389932565}\"]', '{\"head\":127,\"def\":6,\"hp\":69698,\"dame\":4692,\"body\":14,\"leg\":15}', 0),
(13518, 1023468, 'babybun', 313, 1747532967775, 1747532967778, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13519, 1023469, 'toomy', 314, 1747532971425, 1747544400215, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":59046,\"dame\":15996,\"body\":14,\"leg\":15}', 1),
(13520, 1023470, 'shizuka', 315, 1750208762833, 1750208793379, 3, 0, 0, '[]', '{\"head\":383,\"def\":403.0,\"hp\":12121.6,\"dame\":1933.0,\"body\":384,\"leg\":385}', 1),
(13521, 1023471, 'kanji', 316, 1748098277045, 1748098277551, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":993426,\"dame\":23737,\"body\":14,\"leg\":15}', 1),
(13522, 1023472, 'namec', 317, 1748786437482, 1748786437986, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":669051,\"dame\":52020,\"body\":392,\"leg\":393}', 1),
(13523, 1023473, 'godnamec', 318, 1747533027777, 1747533027780, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13524, 1023474, 'facebook', 319, 1749453114486, 1749453120003, 3, 0, 0, '[]', '{\"head\":867,\"def\":8899.0,\"hp\":9215806.038186654,\"dame\":49753.07373105,\"body\":868,\"leg\":869}', 1),
(13525, 1023475, 'bemanh2k3', 320, 1748748302357, 1748748302862, 3, 0, 0, '[]', '{\"head\":873,\"def\":7202,\"hp\":1283870,\"dame\":38199,\"body\":874,\"leg\":875}', 1),
(13526, 1023476, 'sieuuu', 321, 1747533094545, 1747533094549, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13527, 1023477, 'erher', 332, 1748389661544, 1748056424801, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[322]\\\",\\\"timestamp\\\":1748389661547}\"]', '{\"head\":383,\"def\":3,\"hp\":85261,\"dame\":417,\"body\":384,\"leg\":385}', 0),
(13528, 1023478, 'zteaz', 323, 1747575515357, 1747575515867, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":1517,\"dame\":234,\"body\":14,\"leg\":15}', 1),
(13529, 1023479, 'grgeh', 324, 1749485372600, 1749485373105, 3, 0, 0, '[]', '{\"head\":867,\"def\":7203.0,\"hp\":1.220892284714102E8,\"dame\":38690.716875,\"body\":868,\"leg\":869}', 1),
(13530, 1023480, 'onehit', 325, 1747533141831, 1747544400771, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":9027,\"dame\":14615,\"body\":10,\"leg\":11}', 1),
(13531, 1023481, 'shensama', 326, 1747533148092, 1747533148095, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13532, 1023482, '13hoo', 327, 1747533188986, 1747533188993, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13533, 1023483, 'erherh', 328, 1748092638461, 1748092638971, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":88989,\"dame\":758,\"body\":16,\"leg\":17}', 1),
(13534, 1023484, 'gamelol', 329, 1748769780000, 1747533208506, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ trumsuyy[386]\\\",\\\"timestamp\\\":1748769780009}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13535, 1023485, 'erhehgf', 330, 1748096649334, 1748096649839, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":86528,\"dame\":253,\"body\":16,\"leg\":17}', 1),
(13536, 1023486, 'idchumkame', 331, 1747533242049, 1747533242052, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13537, 1023487, 'tdno1', 437, 1748389652954, 1747533243120, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[332]\\\",\\\"timestamp\\\":1748389652958}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13538, 1023488, 'gergedf', 333, 1748096640413, 1748096640924, 3, 0, 0, '[]', '{\"head\":126,\"def\":0,\"hp\":90173,\"dame\":283,\"body\":57,\"leg\":17}', 1),
(13539, 1023489, 'namec1', 334, 1748447378250, 1748447378756, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":108902,\"dame\":37207,\"body\":392,\"leg\":393}', 1),
(13540, 1023490, 'no1td', 335, 1747533280701, 1747533280706, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13541, 1023491, '13h00', 336, 1747533286895, 1747533286900, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13542, 1023492, 'sieunamec', 337, 1748879693037, 1748879693543, 3, 0, 0, '[]', '{\"head\":391,\"def\":6.0,\"hp\":543266.67,\"dame\":36447.912,\"body\":392,\"leg\":393}', 1),
(13543, 1023493, 'namecvanga', 338, 1747533313473, 1747544400751, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":347,\"dame\":164,\"body\":10,\"leg\":11}', 1),
(13544, 1023494, 'troithue', 339, 1748644236681, 1747732045830, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644236749}\"]', '{\"head\":383,\"def\":7,\"hp\":3733008,\"dame\":11440,\"body\":384,\"leg\":385}', 0),
(13545, 1023495, 'songokuz', 340, 1747533338468, 1747533338478, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13546, 1023496, 'songohanz', 341, 1747533374544, 1747533374549, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13547, 1023497, 'top1sv', 342, 1747533401926, 1747544400039, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":47751,\"dame\":6181,\"body\":10,\"leg\":11}', 1),
(13548, 1023498, 'gohansama', 343, 1747533427988, 1747533427998, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13549, 1023499, 'superbroly', 344, 1747533472204, 1747533472208, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13550, 1023500, 'gokusama', 345, 1747533522544, 1747533522548, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13551, 1023501, 'kingg', 346, 1748722575001, 1748722575504, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":1817124,\"dame\":164466,\"body\":392,\"leg\":393}', 1),
(13552, 1023502, 'himawari', 347, 1747588474024, 1747588474529, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":59181,\"dame\":10905,\"body\":16,\"leg\":17}', 1),
(13553, 1023503, 'kingsama', 348, 1747533681864, 1747533681867, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13554, 1023504, 'octiu2', 349, 1747533723153, 1747544400994, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":2985,\"dame\":24189,\"body\":10,\"leg\":11}', 1),
(13555, 1023505, 'buncaqua', 350, 1749445247989, 1749445248494, 3, 0, 0, '[]', '{\"head\":127,\"def\":8642.4,\"hp\":1062141.9524424002,\"dame\":49588.35033600001,\"body\":14,\"leg\":15}', 1),
(13556, 1023506, 'gohansan', 351, 1747533754252, 1747533754256, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13557, 1023507, 'updoo2', 352, 1749264524428, 1749264524941, 3, 0, 0, '[]', '{\"head\":870,\"def\":7204.0,\"hp\":4019146.015327456,\"dame\":223737.98107096754,\"body\":871,\"leg\":872}', 1),
(13558, 1023508, 'gokusaamaa', 353, 1747533801346, 1747533801350, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13559, 1023509, 'upupup', 354, 1747533810638, 1747544400317, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":715,\"dame\":138,\"body\":10,\"leg\":11}', 1),
(13560, 1023510, 'hisune', 355, 1747580519608, 1747580520114, 3, 0, 0, '[]', '{\"head\":126,\"def\":403,\"hp\":9055,\"dame\":2989,\"body\":16,\"leg\":17}', 1),
(13561, 1023511, '00h00', 356, 1747533878006, 1747533878009, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13562, 1023512, 'trumkame', 357, 1748768956394, 1748768967902, 3, 0, 0, '[]', '{\"head\":870,\"def\":7500,\"hp\":2285653,\"dame\":349955,\"body\":871,\"leg\":872}', 1),
(13563, 1023513, 'buscu', 358, 1749091372393, 1749091372902, 3, 0, 0, '[]', '{\"head\":383,\"def\":3.0,\"hp\":2553681.21987,\"dame\":59062.004568000004,\"body\":384,\"leg\":385}', 1),
(13564, 1023514, 'notonhat', 359, 1749215630268, 1749215630776, 3, 0, 0, '[]', '{\"head\":383,\"def\":2310.0,\"hp\":606720.0,\"dame\":21198.1,\"body\":384,\"leg\":385}', 1),
(13565, 1023515, 'sieupham', 360, 1747533919207, 1747533919212, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13566, 1023516, 'bunsbaby', 361, 1747533982313, 1747533982321, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13567, 1023517, 'cclean', 362, 1747534026340, 1747544400337, 3, 0, 0, '[]', '{\"head\":128,\"def\":42,\"hp\":10085,\"dame\":1242,\"body\":10,\"leg\":11}', 1),
(13568, 1023518, 'lazada', 363, 1749462528960, 1749462529482, 3, 0, 0, '[]', '{\"head\":391,\"def\":1602.0,\"hp\":721940.90685184,\"dame\":75437.5309065969,\"body\":392,\"leg\":393}', 1),
(13569, 1023519, 'babyak', 364, 1749299045693, 1749299046202, 3, 0, 0, '[]', '{\"head\":870,\"def\":6402.0,\"hp\":1524908.3220198401,\"dame\":60005.43171655199,\"body\":871,\"leg\":872}', 1),
(13570, 1023520, 'trumtd', 365, 1747555474476, 1747555476984, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13571, 1023521, 'xnxxvvlxx', 366, 1747534589035, 1747534589043, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13572, 1023522, 'kakarot', 367, 1748532147841, 1748532148346, 3, 0, 0, '[]', '{\"head\":383,\"def\":6403,\"hp\":691283,\"dame\":20956,\"body\":384,\"leg\":385}', 1),
(13573, 1023523, 'vlxxxnxx', 368, 1747534644488, 1747534644498, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13574, 1023527, 'namecn', 369, 1748221436929, 1748221437434, 3, 0, 0, '[]', '{\"head\":128,\"def\":6,\"hp\":172868,\"dame\":27143,\"body\":10,\"leg\":11}', 1),
(13575, 1023528, 'kanji06', 370, 1747534692748, 1747534692751, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13576, 1023529, 'hahha', 371, 1749043161040, 1749043161551, 3, 0, 0, '[]', '{\"head\":873,\"def\":806.0,\"hp\":1296254.051323794,\"dame\":60840.1264650225,\"body\":874,\"leg\":875}', 1),
(13577, 1023530, 'sextd', 372, 1747534724152, 1747534724158, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13578, 1023531, 'babybunsss', 373, 1747534794883, 1747534794894, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13579, 1023532, '12hoo', 374, 1747534814155, 1747534814159, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13580, 1023533, 'sieunamek', 375, 1747534832385, 1747534832389, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13581, 1023534, '12h00', 376, 1748644184479, 1747534849332, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644184495}\"]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13582, 1023535, 'blackz', 377, 1748647310832, 1748647311357, 3, 0, 0, '[]', '{\"head\":383,\"def\":2200,\"hp\":145218,\"dame\":10533,\"body\":384,\"leg\":385}', 1),
(13583, 1023536, '00hoo', 378, 1747534890251, 1747534890255, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13584, 1023537, 'kukuro', 379, 1747534935604, 1747534935607, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13585, 1023538, '16h00', 380, 1748127014598, 1748127015103, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13586, 1023539, '10h00', 381, 1748127050774, 1748127063286, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":141,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13587, 1023540, 'octieu', 382, 1748127087641, 1748127101156, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13588, 1023541, 'super', 383, 1748127113824, 1748127126334, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13589, 1023542, 'picotex', 384, 1748769791666, 1747535152296, 3, 2, 0, '[\"{\\\"event\\\":\\\"Hạ trumsuyy[386]\\\",\\\"timestamp\\\":1748769802415}\"]', '{\"head\":1597,\"def\":2,\"hp\":207,\"dame\":20802,\"body\":1598,\"leg\":1599}', 0),
(13590, 1023543, 'kingsaama', 385, 1748769811996, 1748127157908, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ trumsuyy[386]\\\",\\\"timestamp\\\":1748769812004}\"]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13591, 1023544, 'trumsuyy', 386, 1749484942276, 1749484942787, 3, 0, 5, '[]', '{\"head\":870,\"def\":7206.0,\"hp\":3047374.737158203,\"dame\":1.7182948105080542E8,\"body\":871,\"leg\":872}', 1),
(13592, 1023545, 'top1namec', 387, 1748127191106, 1748127203627, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13593, 1023546, 'chumpk', 388, 1748127220450, 1748127237968, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13594, 1023547, 'blacksama', 389, 1748127249639, 1748127261151, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13595, 1023548, 'blackgohan', 390, 1748127274153, 1748127288662, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 1),
(13596, 1023549, 'cong2006', 391, 1749102776083, 1749102776594, 3, 0, 0, '[]', '{\"head\":391,\"def\":7.0,\"hp\":1366069.8488016,\"dame\":50879.339909999995,\"body\":392,\"leg\":393}', 1),
(13597, 1023550, 'supergoku', 392, 1747535448103, 1747535448107, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13598, 1023551, 'top1kame', 393, 1749461701294, 1749461701799, 3, 0, 0, '[]', '{\"head\":870,\"def\":7202.0,\"hp\":2010777.8756000004,\"dame\":1607701.1873422123,\"body\":871,\"leg\":872}', 1),
(13599, 1023552, 'rimiru', 394, 1749457309624, 1749457310130, 3, 0, 0, '[]', '{\"head\":391,\"def\":863.0,\"hp\":1609416.9543,\"dame\":75108.02936966208,\"body\":392,\"leg\":393}', 1),
(13600, 1023553, 'ketamin', 395, 1747535508626, 1747535508630, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13601, 1023554, 'kingshenn', 396, 1747535533451, 1747535533455, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13602, 1023555, 'hinata', 397, 1747589046486, 1747589046990, 3, 0, 0, '[]', '{\"head\":126,\"def\":1203,\"hp\":73932,\"dame\":6435,\"body\":16,\"leg\":17}', 1),
(13603, 1023556, 'shenking', 398, 1747535575704, 1747535575709, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13604, 1023557, 'banhday', 399, 1747971680708, 1747971685222, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":11977,\"dame\":1193,\"body\":10,\"leg\":11}', 1),
(13605, 1023558, 'zenosamaa', 400, 1747535620753, 1747535620757, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13606, 1023559, 'idchumsv1', 401, 1747535660124, 1747535660127, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13607, 1023560, 'kingsuper', 402, 1747535697431, 1747535697435, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13608, 1023561, 'conggg', 403, 1749132899772, 1747535725869, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ oncloudms[412]\\\",\\\"timestamp\\\":1749132899779}\"]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(13609, 1023562, 'supermon', 404, 1747535744061, 1747535744064, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13610, 1023563, 'conggggggg', 405, 1748536286431, 1748536286935, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":306,\"dame\":39,\"body\":14,\"leg\":15}', 1),
(13611, 1023564, 'godxayda', 406, 1747548792439, 1747548857981, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":139,\"dame\":11,\"body\":10,\"leg\":11}', 1),
(13612, 1023565, 'congggggg', 407, 1748536621505, 1748536629025, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":139,\"dame\":11,\"body\":10,\"leg\":11}', 1),
(13613, 1023566, 'acquy79', 408, 1747535857588, 1747535857596, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13614, 1023567, 'kakam', 409, 1747535868275, 1747544400661, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":166,\"dame\":218,\"body\":16,\"leg\":17}', 1),
(13615, 1023568, 'trumtdd', 410, 1747535870587, 1747535870590, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13616, 1023569, 'cong1', 411, 1747535876603, 1747535876607, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13617, 1023570, 'xiizi', 422, 1749132860326, 1748690053100, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua oncloudms[412]\\\",\\\"timestamp\\\":1749132860330}\"]', '{\"head\":252,\"def\":2.0,\"hp\":279786.01392,\"dame\":30836.81664,\"body\":253,\"leg\":254}', 0),
(13618, 1023571, 'hihihaha', 413, 1749457336850, 1749457337362, 3, 0, 0, '[]', '{\"head\":383,\"def\":3.0,\"hp\":972846.99995376,\"dame\":23208.179119999997,\"body\":384,\"leg\":385}', 1),
(13619, 1023572, 'laze100m', 414, 1747535901486, 1747535901490, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13620, 1023573, 'trumxd', 415, 1747535902641, 1747535902647, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13621, 1023574, 'cong0', 416, 1747535922596, 1747535922600, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13622, 1023575, 'trumnm', 417, 1747535941840, 1747535941845, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13623, 1023576, 'godkingg', 418, 1747535946649, 1747535946653, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13624, 1023577, 'tdtrum', 419, 1747535977615, 1747535977619, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13625, 1023578, 'namecc', 420, 1748712887716, 1748712888222, 3, 0, 0, '[]', '{\"head\":391,\"def\":4006,\"hp\":746279,\"dame\":57463,\"body\":392,\"leg\":393}', 1),
(13626, 1023579, 'trumtddd', 421, 1747536012933, 1747536012941, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13627, 1023580, 'trummtd', 781, 1749132848225, 1747536047731, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua oncloudms[422]\\\",\\\"timestamp\\\":1749132848228}\"]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(13628, 1023581, 'congg', 423, 1747536078892, 1747536078896, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13629, 1023582, 'ttrumtd', 424, 1747536101485, 1747536101491, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13630, 1023583, 'congggg', 425, 1748779144072, 1748779144580, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":1942394,\"dame\":48573,\"body\":384,\"leg\":385}', 1),
(13631, 1023584, 'akatrumtd', 426, 1748428129542, 1747536143186, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ bonjou[436]\\\",\\\"timestamp\\\":1748428129550}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13632, 1023585, 'nmkibro', 427, 1747536163349, 1747544400832, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":176,\"dame\":8023,\"body\":10,\"leg\":11}', 1),
(13633, 1023586, 'weeknd', 428, 1749457301721, 1749457302235, 3, 1, 0, '[]', '{\"head\":870,\"def\":2.0,\"hp\":634133.809002,\"dame\":65704.56261264,\"body\":871,\"leg\":872}', 1),
(13634, 1023587, 'yamoshi', 429, 1748428146019, 1747544400058, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ bonjou[436]\\\",\\\"timestamp\\\":1748428146025}\"]', '{\"head\":27,\"def\":7,\"hp\":42821,\"dame\":4904,\"body\":16,\"leg\":17}', 0),
(13635, 1023588, 'xiiut', 430, 1748690020164, 1748690020671, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":321753,\"dame\":33530,\"body\":10,\"leg\":11}', 1),
(13636, 1023589, 'akatrumtdd', 431, 1747536208934, 1747536208938, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13637, 1023590, 'akatrummtd', 432, 1747536254028, 1747536254032, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13638, 1023591, 'black', 433, 1748449765127, 1748449765631, 3, 0, 0, '[]', '{\"head\":383,\"def\":8,\"hp\":1265430,\"dame\":75125,\"body\":384,\"leg\":385}', 1),
(13639, 1023592, 'onekill', 434, 1749476612663, 1749476613171, 3, 0, 0, '[]', '{\"head\":391,\"def\":6.0,\"hp\":1413021.4,\"dame\":81346.172096,\"body\":392,\"leg\":393}', 1),
(13640, 1023593, 'akatdtrum', 435, 1747536290653, 1747536290655, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13641, 1023594, 'bonjou', 436, 1748783868257, 1748783868763, 3, 0, 2, '[]', '{\"head\":383,\"def\":7200,\"hp\":1126527,\"dame\":38644,\"body\":384,\"leg\":385}', 1),
(13642, 1023595, 'akatoptop', 447, 1748389641847, 1747536382851, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[437]\\\",\\\"timestamp\\\":1748389641850}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13643, 1023596, 'bot24', 438, 1747536417614, 1747536417617, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13644, 1023597, 'bot25', 439, 1747536449514, 1747536449519, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13645, 1023598, 'iiixs', 440, 1748690069299, 1748690069805, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":321753,\"dame\":33204,\"body\":10,\"leg\":11}', 1),
(13646, 1023599, 'bot26', 748, 1748339631914, 1747536490075, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua namtips[441]\\\",\\\"timestamp\\\":1748339631919}\"]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13647, 1023600, 'hrhrfgd', 442, 1748096471370, 1748096471874, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":304,\"dame\":155,\"body\":14,\"leg\":15}', 1),
(13648, 1023601, 'hgrhhf', 443, 1748096465652, 1748096466156, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":327,\"dame\":153,\"body\":14,\"leg\":15}', 1),
(13649, 1023602, 'bot27', 444, 1747536524163, 1747536524167, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13650, 1023603, 'bot28', 445, 1747536560968, 1747536560971, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13651, 1023604, 'regergdf', 446, 1748092640970, 1748092641476, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":304,\"dame\":128,\"body\":14,\"leg\":15}', 1),
(13652, 1023605, 'gerge', 457, 1748389633680, 1748056600985, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[447]\\\",\\\"timestamp\\\":1748389633683}\"]', '{\"head\":383,\"def\":2,\"hp\":1966,\"dame\":467,\"body\":384,\"leg\":385}', 0),
(13653, 1023606, 'ggedf', 448, 1748096506161, 1748096506666, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":304,\"dame\":639,\"body\":14,\"leg\":15}', 1),
(13654, 1023607, 'bot29', 449, 1747536608573, 1747536608576, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13655, 1023608, 'laze1tr', 450, 1747730653501, 1747730654067, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":196,\"dame\":209,\"body\":10,\"leg\":11}', 1),
(13656, 1023609, 'hikocon', 451, 1748684917211, 1748684917716, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":1312245,\"dame\":41908,\"body\":384,\"leg\":385}', 1),
(13657, 1023610, 'bot30', 452, 1747536648007, 1747536648011, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13658, 1023611, 'xayda1', 453, 1747570385478, 1747570385983, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":440,\"dame\":2364,\"body\":16,\"leg\":17}', 1),
(13659, 1023612, 'bot31', 454, 1747536684731, 1747536684735, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13660, 1023613, 'kakalot', 455, 1747536699384, 1747544400784, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":2828,\"dame\":553,\"body\":16,\"leg\":17}', 1),
(13661, 1023614, 'thekyng', 456, 1749363612091, 1749363612612, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":600020.0,\"dame\":33187.7,\"body\":16,\"leg\":17}', 1),
(13662, 1023615, 'bot32', 464, 1748389609212, 1747536754610, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua kamevip[457]\\\",\\\"timestamp\\\":1748389609217}\"]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13663, 1023616, 'thanmeo', 458, 1748266332224, 1748266332728, 3, 0, 0, '[]', '{\"head\":383,\"def\":2,\"hp\":162584,\"dame\":26337,\"body\":384,\"leg\":385}', 1),
(13664, 1023617, 'bot33', 459, 1747536781649, 1747536781652, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13665, 1023618, 'bot34', 460, 1747536807732, 1747536807736, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13666, 1023619, 'julybxh', 461, 1748530439690, 1748530440195, 3, 0, 0, '[]', '{\"head\":128,\"def\":3202,\"hp\":160378,\"dame\":16136,\"body\":10,\"leg\":150}', 1),
(13667, 1023620, 'bot35', 462, 1747536833725, 1747536833730, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13668, 1023621, 'i3bom1st', 463, 1749356012126, 1749356012634, 3, 0, 0, '[]', '{\"head\":867,\"def\":1938.0,\"hp\":2215198.152791808,\"dame\":204638.95340168086,\"body\":868,\"leg\":869}', 1),
(13669, 1023622, 'kamevip', 180, 1749257738496, 1749178513496, 3, 25, 1, '[\"{\\\"event\\\":\\\"Thua matuy[178]\\\",\\\"timestamp\\\":1749257904422}\"]', '{\"head\":870,\"def\":7202.0,\"hp\":1116235.167,\"dame\":1.6817254219455525E7,\"body\":871,\"leg\":872}', 1),
(13670, 1023623, 'i3bom2st', 465, 1749303368022, 1749303368529, 3, 0, 0, '[]', '{\"head\":867,\"def\":7203.0,\"hp\":4629721.607701761,\"dame\":199193.216287446,\"body\":868,\"leg\":869}', 1),
(13671, 1023624, 'reall3', 466, 1748088459331, 1748088459838, 3, 0, 0, '[]', '{\"head\":642,\"def\":3,\"hp\":487544,\"dame\":1312,\"body\":643,\"leg\":644}', 1),
(13672, 1023625, 'sdfsdfsdf', 467, 1747537153772, 1747537153776, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13673, 1023626, 'i3bom3st', 468, 1749461898799, 1749461899305, 3, 0, 0, '[]', '{\"head\":873,\"def\":7200.0,\"hp\":1323460.0,\"dame\":47217.476306000004,\"body\":874,\"leg\":875}', 1),
(13674, 1023627, 'picollo', 469, 1747544409977, 1747544410482, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":149,\"dame\":792,\"body\":10,\"leg\":11}', 1),
(13675, 1023628, 'cellphones', 470, 1747537255775, 1747537255779, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13676, 1023629, '3iixx', 471, 1748690107906, 1748690108412, 3, 0, 0, '[]', '{\"head\":128,\"def\":6,\"hp\":321753,\"dame\":32553,\"body\":10,\"leg\":11}', 1),
(13677, 1023630, 'goku3', 472, 1747573125771, 1747573126289, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":440,\"dame\":2225,\"body\":16,\"leg\":17}', 1),
(13678, 1023631, 'xemsex', 473, 1747537495838, 1747544400014, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":124765,\"dame\":3011,\"body\":10,\"leg\":11}', 1),
(13679, 1023632, 'xiaomi', 474, 1747537530536, 1747537530539, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13680, 1023633, 'pengu', 475, 1749457330245, 1749457330767, 3, 0, 0, '[]', '{\"head\":391,\"def\":2.0,\"hp\":864583.17432,\"dame\":61336.15626931201,\"body\":392,\"leg\":393}', 1),
(13681, 1023634, 'songokuzz', 476, 1748437321684, 1748437322188, 3, 0, 0, '[]', '{\"head\":383,\"def\":402,\"hp\":192848,\"dame\":38763,\"body\":384,\"leg\":385}', 1),
(13682, 1023635, 'bot36', 477, 1747537666292, 1747537666296, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13683, 1023636, 'bot37', 478, 1747537733290, 1747537733294, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13684, 1023637, 'bot38', 479, 1747537779370, 1747537779374, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13685, 1023638, 'bot39', 480, 1747537808406, 1747537808412, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13686, 1023639, 'bot40', 481, 1747537848899, 1747537848903, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13687, 1023640, 'bot41', 482, 1747537884184, 1747537884188, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13688, 1023641, 'bilow', 483, 1747537895241, 1747537895244, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13689, 1023642, 'gohan5', 484, 1747537902396, 1747544400034, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":591,\"dame\":1558,\"body\":14,\"leg\":15}', 1),
(13690, 1023643, 'bot42', 485, 1747537912800, 1747537912803, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13691, 1023644, 'caidell', 486, 1747537962979, 1747544400496, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":163,\"dame\":3237,\"body\":10,\"leg\":11}', 1),
(13692, 1023645, 'bot43', 487, 1747537967977, 1747537967982, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13693, 1023646, '4xics', 488, 1748690136737, 1748690137242, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":321753,\"dame\":32878,\"body\":10,\"leg\":11}', 1),
(13694, 1023647, 'bot44', 489, 1747537998025, 1747537998028, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13695, 1023648, 'bot45', 490, 1747538026557, 1747538026561, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13696, 1023649, 'bot46', 491, 1747538057069, 1747538057072, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13697, 1023650, 'embetrathu', 492, 1748677520477, 1748677520985, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":686790,\"dame\":25496,\"body\":14,\"leg\":58}', 1),
(13698, 1023651, 'bot47', 493, 1747538090118, 1747538090123, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13699, 1023652, 'bot48', 494, 1747538119408, 1747538119413, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13700, 1023653, 'bot49', 495, 1747538146051, 1747538146053, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13701, 1023654, 'otama', 496, 1748412075163, 1748412088677, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":266,\"dame\":11,\"body\":14,\"leg\":15}', 1),
(13702, 1023655, 'bot50', 497, 1747538177801, 1747538177806, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13703, 1023656, 'bot51', 498, 1747538206874, 1747538206877, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13704, 1023657, 'gohan7', 499, 1747573160444, 1747573160948, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":342,\"dame\":2364,\"body\":14,\"leg\":15}', 1),
(13705, 1023658, 'kirril', 500, 1748412137919, 1748412146429, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13706, 1023659, 'ebedat', 501, 1748412173110, 1748412181624, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13707, 1023660, 'bot52', 502, 1747538464092, 1747538464099, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13708, 1023661, 'babyred', 503, 1748412209190, 1748412216695, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13709, 1023662, 'bot53', 504, 1747538506059, 1747538506062, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13710, 1023663, 'labubu', 505, 1748973464587, 1748973465092, 3, 0, 0, '[]', '{\"head\":6,\"def\":7203.0,\"hp\":600020.0,\"dame\":10923.5,\"body\":16,\"leg\":17}', 1),
(13711, 1023664, 'bot54', 506, 1747538534564, 1747538534569, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13712, 1023665, 'otaku', 507, 1748412878580, 1748412899102, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":266,\"dame\":11,\"body\":14,\"leg\":15}', 1),
(13713, 1023666, 'bot56', 508, 1747538580488, 1747538580492, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13714, 1023667, 'bot55', 509, 1747538628936, 1747538628945, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13715, 1023668, 'no1kame', 510, 1748412917859, 1748412935373, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13716, 1023669, 'bot57', 511, 1747538661656, 1747538661660, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13717, 1023670, 'yamcha', 512, 1748412948904, 1748412962417, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":266,\"dame\":11,\"body\":14,\"leg\":15}', 1),
(13718, 1023671, 'bot58', 513, 1747538691843, 1747538691851, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13719, 1023672, 'bot59', 514, 1747538724556, 1747538724560, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13720, 1023673, 'vegito', 515, 1748329129327, 1748329129832, 3, 0, 0, '[]', '{\"head\":383,\"def\":234,\"hp\":2414427,\"dame\":20370,\"body\":384,\"leg\":385}', 1),
(13721, 1023674, 'potato', 516, 1748412974607, 1748412988126, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":266,\"dame\":11,\"body\":14,\"leg\":15}', 1),
(13722, 1023675, 'bot60', 517, 1747538755625, 1747538755629, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13723, 1023676, 'autokame', 518, 1747538840559, 1747544400287, 3, 0, 0, '[]', '{\"head\":127,\"def\":0,\"hp\":37260,\"dame\":11650,\"body\":57,\"leg\":58}', 1),
(13724, 1023677, 'bot61', 519, 1747538853036, 1747538853045, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13725, 1023678, 'bot62', 520, 1747538889678, 1747538889682, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13726, 1023679, 'bot63', 521, 1747538922338, 1747538922345, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13727, 1023680, 'bot64', 522, 1747538954606, 1747538954609, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13728, 1023681, 'trumpem', 523, 1747538978764, 1747544400287, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":62124,\"dame\":37508,\"body\":10,\"leg\":11}', 1),
(13729, 1023682, 'bot65', 524, 1747538988721, 1747538988762, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13730, 1023683, 'bot66', 525, 1747539019619, 1747539019629, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13731, 1023684, '5siyt', 526, 1748691660158, 1748691660663, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":321753,\"dame\":32553,\"body\":10,\"leg\":11}', 1),
(13732, 1023685, 'thanhhien', 527, 1749044781624, 1749044782136, 3, 0, 0, '[]', '{\"head\":383,\"def\":5203.0,\"hp\":719643.754,\"dame\":26317.44,\"body\":384,\"leg\":385}', 1),
(13733, 1023686, 'bot67', 528, 1747539048691, 1747539048695, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13734, 1023687, 'yuamikami', 529, 1747539069669, 1747539069674, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13735, 1023688, 'bot68', 530, 1747539085189, 1747539085201, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13736, 1023689, '10kvnd', 531, 1747539087300, 1747544400428, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":124248,\"dame\":37260,\"body\":10,\"leg\":11}', 1),
(13737, 1023690, 'ronaldo', 532, 1747539111864, 1747539111866, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13738, 1023691, 'bot69', 533, 1747539117886, 1747539117889, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13739, 1023692, 'fukada', 534, 1748644204152, 1747539154188, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644204167}\"]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13740, 1023693, 'bot70', 535, 1747539192468, 1747539192472, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13741, 1023694, 'no1traidat', 536, 1748644290598, 1747539197260, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644290614}\"]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13742, 1023695, 'chaymayne', 537, 1748780820816, 1748780821324, 3, 0, 0, '[]', '{\"head\":870,\"def\":2002,\"hp\":912436,\"dame\":268729,\"body\":871,\"leg\":872}', 1),
(13743, 1023696, 'bot71', 538, 1747539230761, 1747539230764, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13744, 1023697, 'mickey', 539, 1747539267173, 1747539267177, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13745, 1023698, 'bot72', 540, 1747539267295, 1747539267299, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13746, 1023699, 'bot73', 541, 1747539302283, 1747539302289, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13747, 1023700, 'bot74', 542, 1747539331298, 1747539331301, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13748, 1023701, 'tidinopro', 543, 1747539332231, 1747539332234, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13749, 1023702, 'bot75', 544, 1747539401361, 1747539401365, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13750, 1023703, 'top1buff', 545, 1747539410982, 1747539410986, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13751, 1023704, 'bot76', 546, 1747539429646, 1747539429650, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13752, 1023705, 'bot77', 547, 1747539550860, 1747539550867, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13753, 1023706, 'bot78', 548, 1747539577703, 1747539577707, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13754, 1023707, 'bot79', 549, 1747539618700, 1747539618705, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13755, 1023708, 'kamii', 550, 1747539619739, 1747539619745, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13756, 1023709, 'lontham', 551, 1747539643098, 1747539643102, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13757, 1023710, 'bot80', 552, 1747539650258, 1747539650263, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13758, 1023711, 'bot81', 553, 1747539685164, 1747539685168, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13759, 1023712, 'anhdautroc', 554, 1747539687251, 1747539687256, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13760, 1023713, 'bot82', 555, 1747539717882, 1747539717886, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13761, 1023714, 'bot83', 556, 1747539746826, 1747539746830, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13762, 1023715, 'anhtocdai', 557, 1747539753642, 1747539753650, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13763, 1023716, 'bot84', 558, 1747539776525, 1747539776531, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13764, 1023717, 'anhdaden', 559, 1747539791863, 1747539791867, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13765, 1023718, 'bot85', 560, 1747539801639, 1747539801643, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13766, 1023719, 'octieu357', 561, 1748580553044, 1748580553550, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":2867,\"dame\":2963,\"body\":59,\"leg\":60}', 1),
(13767, 1023720, 'bot86', 562, 1747539832549, 1747539832553, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13768, 1023721, 'ntmikey', 563, 1748945536818, 1748945537323, 3, 0, 0, '[]', '{\"head\":867,\"def\":2000.0,\"hp\":8446441.72544,\"dame\":4.311191140141536E8,\"body\":868,\"leg\":869}', 1),
(13769, 1023722, 'bot87', 564, 1747539866908, 1747539866929, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13770, 1023723, 'chikentop', 565, 1748221648022, 1748221648525, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":66860,\"dame\":10675,\"body\":10,\"leg\":11}', 1),
(13771, 1023724, 'bot88', 566, 1747539900483, 1747539900488, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13772, 1023725, 'yamchasan', 567, 1747539925775, 1747539925778, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13773, 1023726, 'bot89', 568, 1747975001416, 1747975006923, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13774, 1023727, 'namecvangb', 569, 1747539953331, 1747544400387, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":324,\"dame\":24,\"body\":10,\"leg\":11}', 1),
(13775, 1023728, 'bot90', 570, 1748282395462, 1747539960568, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ adtoan[895]\\\",\\\"timestamp\\\":1748282395473}\"]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13776, 1023729, 'mikey', 571, 1748221690655, 1748221691160, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":49704,\"dame\":12425,\"body\":16,\"leg\":17}', 1),
(13777, 1023730, 'gohanchan', 572, 1747539969979, 1747539969983, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13778, 1023731, 'bot91', 573, 1747539990524, 1747539990528, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13779, 1023732, 'bot92', 574, 1747540023911, 1747540023916, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13780, 1023733, 'caidellgi', 575, 1747540036772, 1747540036777, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13781, 1023734, 'bot93', 576, 1747540049000, 1747540049003, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13782, 1023735, 'bot94', 577, 1747540078500, 1747540078503, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13783, 1023736, 'vaicuk', 578, 1747540081502, 1747540081505, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13784, 1023737, 'bot95', 579, 1747540107903, 1747540107910, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13785, 1023738, 'caideogi', 580, 1747540133284, 1747540133288, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13786, 1023739, 'bot96', 581, 1747540137549, 1747540137553, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13787, 1023740, 'bot97', 582, 1747540165973, 1747540165976, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13788, 1023741, 'portal', 583, 1748644300294, 1747540172100, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644300352}\"]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13789, 1023742, '6giis', 584, 1748695253984, 1748695254490, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":311601,\"dame\":34303,\"body\":10,\"leg\":11}', 1),
(13790, 1023743, 'bot98', 585, 1747540200048, 1747540200050, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13791, 1023744, 'bot99', 586, 1747540227904, 1747540227908, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13792, 1023745, 'michelin', 587, 1747540227930, 1747540227934, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13793, 1023746, 'aduvjp', 588, 1748412021767, 1748412028273, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13794, 1023747, 'aduvip', 589, 1748411968220, 1748411975729, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":271,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13795, 1023748, 'eren1', 590, 1747540377638, 1747544400982, 3, 0, 0, '[]', '{\"head\":536,\"def\":2,\"hp\":154294,\"dame\":30464,\"body\":476,\"leg\":477}', 1),
(13796, 1023749, 'tennhanvat', 591, 1748459695840, 1748411922890, 3, 4, 0, '[\"{\\\"event\\\":\\\"Hạ matuy[601]\\\",\\\"timestamp\\\":1748459736803}\"]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(13797, 1023750, 'bot10', 592, 1747540418939, 1747540418944, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13798, 1023751, 'ookaza', 593, 1748411861057, 1748411872567, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1);
INSERT INTO `super_rank` (`id`, `player_id`, `name`, `rank`, `last_pk_time`, `last_reward_time`, `ticket`, `win`, `lose`, `history`, `info`, `received`) VALUES
(13799, 1023752, 'kakaloot', 594, 1747540469428, 1747544400775, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":3032,\"dame\":1132,\"body\":16,\"leg\":17}', 1),
(13800, 1023753, 'vegeta', 595, 1748095181655, 1748095182159, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":874694,\"dame\":26756,\"body\":384,\"leg\":385}', 1),
(13801, 1023754, 'kamejoko', 596, 1747540541909, 1747544400510, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":285,\"dame\":36,\"body\":14,\"leg\":15}', 1),
(13802, 1023755, 'bot22', 597, 1747540547793, 1747540547798, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13803, 1023756, 'manhien', 598, 1749186590065, 1749186590572, 3, 0, 0, '[]', '{\"head\":870,\"def\":7202.0,\"hp\":1138673.9619999998,\"dame\":63334.65654457759,\"body\":871,\"leg\":872}', 1),
(13804, 1023757, '7hisj', 599, 1748695345066, 1748695345572, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":321753,\"dame\":29673,\"body\":10,\"leg\":11}', 1),
(13805, 1023758, 'admiin', 600, 1747540806292, 1747544400287, 3, 0, 0, '[]', '{\"head\":127,\"def\":0,\"hp\":6210,\"dame\":621,\"body\":57,\"leg\":58}', 1),
(13806, 1023759, 'matuy', 178, 1749470460418, 1749389439693, 3, 15, 13, '[\"{\\\"event\\\":\\\"Hạ bunbocute[181]\\\",\\\"timestamp\\\":1749470460439}\"]', '{\"head\":870,\"def\":7500.0,\"hp\":3249809.5202929685,\"dame\":3016401.5737194517,\"body\":871,\"leg\":872}', 1),
(13807, 1023760, 'zenis', 602, 1748496328452, 1748496328957, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":682967,\"dame\":33492,\"body\":14,\"leg\":15}', 1),
(13808, 1023761, 'kimothuoc', 603, 1747568414809, 1747568488364, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":165,\"dame\":12,\"body\":10,\"leg\":11}', 1),
(13809, 1023762, 'chumpksv', 604, 1747541097150, 1747541097155, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13810, 1023763, 'pkchumsv', 605, 1747541140880, 1747541140883, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13811, 1023764, 'pkchumgame', 606, 1747541234832, 1747541234837, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13812, 1023765, 'senpaiz', 607, 1747569232666, 1747569233172, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":165,\"dame\":20,\"body\":16,\"leg\":17}', 1),
(13813, 1023766, 'chumpks1', 608, 1747541278253, 1747541278260, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13814, 1023767, '8viss', 609, 1748754718342, 1748757413051, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":1678048,\"dame\":36972,\"body\":10,\"leg\":11}', 1),
(13815, 1023768, 'top1kam3', 610, 1747541320237, 1747541320241, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13816, 1023769, 'zesusama', 611, 1747541354882, 1747541354890, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13817, 1023770, 'zesussama', 612, 1748644271315, 1747541393447, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644271328}\"]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13818, 1023771, 'zesusamaa', 613, 1747541426673, 1747541426679, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13819, 1023772, 'sieupham1x', 614, 1747541474514, 1747541474518, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13820, 1023773, 'zesussaama', 615, 1747541509588, 1747541509593, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13821, 1023774, 'upgoke', 616, 1748644212441, 1748084051196, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644212453}\"]', '{\"head\":127,\"def\":2,\"hp\":46264,\"dame\":10239,\"body\":14,\"leg\":15}', 0),
(13822, 1023775, '16hoo', 617, 1747541547207, 1747541547209, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13823, 1023776, 'kamehentai', 618, 1747569232071, 1747569232581, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":316,\"dame\":12,\"body\":14,\"leg\":15}', 1),
(13824, 1023777, 'reall4', 619, 1748088396468, 1748088399975, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":1259400,\"dame\":937,\"body\":16,\"leg\":17}', 1),
(13825, 1023778, 'zesnosama', 620, 1747541597901, 1747541597905, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13826, 1023779, '9xuja', 621, 1748696411869, 1748696412375, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":321753,\"dame\":29172,\"body\":10,\"leg\":11}', 1),
(13827, 1023780, '15hoo', 622, 1747541667661, 1747541667668, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13828, 1023781, 'kingvegeta', 623, 1747541706054, 1747541706057, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13829, 1023782, 'kingvegeto', 624, 1747541747834, 1747541747838, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13830, 1023783, 'supermen', 625, 1748644223514, 1747541790471, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644223525}\"]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13831, 1023784, 'superman', 626, 1747541822639, 1747541822643, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13832, 1023785, 'supermann', 627, 1747541865611, 1747541865619, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13833, 1023786, 'hentaiki', 628, 1747541880111, 1747541880113, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13834, 1023787, 'supermenn', 629, 1747541909292, 1747541909296, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13835, 1023788, 'zenosasma', 630, 1747541958284, 1747541958287, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13836, 1023789, 'xinboss', 631, 1747542051697, 1747544400039, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":176,\"dame\":58,\"body\":10,\"leg\":11}', 1),
(13837, 1023790, 'daxanh', 632, 1747969484637, 1747969485143, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":118356,\"dame\":25531,\"body\":392,\"leg\":393}', 1),
(13838, 1023791, 'cuto18cm', 633, 1748282406726, 1747544400048, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ adtoan[895]\\\",\\\"timestamp\\\":1748282406734}\"]', '{\"head\":128,\"def\":2,\"hp\":2633,\"dame\":13103,\"body\":10,\"leg\":11}', 0),
(13839, 1023792, '1bomm', 634, 1748927880346, 1748927880852, 3, 0, 0, '[]', '{\"head\":867,\"def\":5.0,\"hp\":9.095554758441588E7,\"dame\":45954.413700000005,\"body\":868,\"leg\":869}', 1),
(13840, 1023793, 'godkill', 635, 1747542424185, 1747544400241, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":176,\"dame\":13,\"body\":10,\"leg\":11}', 1),
(13841, 1023794, 'bom1hp', 636, 1748093462702, 1748093463206, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":193,\"dame\":8857,\"body\":16,\"leg\":17}', 1),
(13842, 1023795, 'xd1xx', 637, 1748754391554, 1748754392061, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":159,\"dame\":709,\"body\":10,\"leg\":11}', 1),
(13843, 1023796, 'tiktok', 638, 1747971424771, 1747971425276, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":516002,\"dame\":54634,\"body\":392,\"leg\":393}', 1),
(13844, 1023797, 'dai001', 639, 1747542700088, 1747542700091, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13845, 1023798, 'maxskill', 640, 1747542722370, 1747544400287, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":176,\"dame\":41,\"body\":10,\"leg\":11}', 1),
(13846, 1023799, 'namekmecu', 641, 1747542728960, 1747544400772, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":160,\"dame\":53,\"body\":10,\"leg\":11}', 1),
(13847, 1023800, 'xd2xx', 642, 1748561691060, 1748561691567, 3, 0, 0, '[]', '{\"head\":391,\"def\":6402,\"hp\":1181902,\"dame\":84759,\"body\":392,\"leg\":393}', 1),
(13848, 1023801, 'dai002', 643, 1747542852909, 1747542852913, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13849, 1023802, 'dai003', 644, 1748644280647, 1747542916870, 3, 1, 0, '[\"{\\\"event\\\":\\\"Hạ ssssss[877]\\\",\\\"timestamp\\\":1748644280657}\"]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13850, 1023803, 'dekizuki', 645, 1749005160339, 1749005160846, 3, 0, 0, '[]', '{\"head\":867,\"def\":3.0,\"hp\":1.0562838273353014E7,\"dame\":94958.54119245314,\"body\":868,\"leg\":869}', 1),
(13851, 1023804, 'idchumlaze', 646, 1747542938467, 1747544400931, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":160,\"dame\":169,\"body\":10,\"leg\":11}', 1),
(13852, 1023805, 'dai004', 647, 1747542981099, 1747542981103, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13853, 1023806, 'idsieuchum', 658, 1748391975491, 1747542991284, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua haajudzai[648]\\\",\\\"timestamp\\\":1748391975495}\"]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13854, 1023807, 'dai005', 649, 1747543063817, 1747543063821, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13855, 1023808, 'laze99m', 650, 1747543099557, 1747543099563, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13856, 1023809, 'chumlaze', 651, 1747543156586, 1747543156597, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13857, 1023810, 'dai006', 652, 1747543177540, 1747543177543, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13858, 1023811, 'xd3xx', 653, 1748754327800, 1748754328305, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6005,\"dame\":779,\"body\":10,\"leg\":11}', 1),
(13859, 1023812, 'dai007', 654, 1747543231053, 1747543231056, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13860, 1023813, 'zamas', 655, 1748005782303, 1748005782807, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":737589,\"dame\":36170,\"body\":10,\"leg\":11}', 1),
(13861, 1023814, 'upchay', 656, 1748547080326, 1748547080830, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":971281,\"dame\":30908,\"body\":392,\"leg\":393}', 1),
(13862, 1023815, 'namec1hp', 657, 1748093470041, 1748093470545, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":500545,\"dame\":30089,\"body\":392,\"leg\":393}', 1),
(13863, 1023816, 'dai008', 665, 1748391960434, 1747543308129, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua haajudzai[658]\\\",\\\"timestamp\\\":1748391960450}\"]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13864, 1023817, 'xd0xx', 659, 1748650179277, 1748650179782, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":928483,\"dame\":36013,\"body\":10,\"leg\":11}', 1),
(13865, 1023818, 'dai009', 660, 1747543454571, 1747543454576, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13866, 1023819, 'zanis', 661, 1748005770556, 1748005771059, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":17733,\"dame\":36172,\"body\":16,\"leg\":17}', 1),
(13867, 1023820, 'dai010', 662, 1747543633244, 1747543633248, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13868, 1023821, 'dai011', 663, 1747543735983, 1747543735987, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13869, 1023822, 'dai012', 664, 1747543885412, 1747543885417, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13870, 1023823, 'dai013', 982, 1748391934944, 1747543987137, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua haajudzai[665]\\\",\\\"timestamp\\\":1748391934948}\"]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13871, 1023824, 'dai014', 666, 1747544044701, 1747544044704, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13872, 1023825, 'hiuhiu', 667, 1747544071339, 1747544400086, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":149,\"dame\":48,\"body\":10,\"leg\":11}', 1),
(13873, 1023826, 'xd4xx', 668, 1748754237164, 1748754237670, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6076,\"dame\":1120,\"body\":10,\"leg\":11}', 1),
(13874, 1023827, 'dai015', 669, 1747544156374, 1747544156378, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13875, 1023828, 'dai016', 670, 1747544205338, 1747544205346, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13876, 1023829, 'dai017', 671, 1747544302851, 1747544302856, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13877, 1023830, 'proxayda', 672, 1749469182686, 1749469183192, 3, 0, 0, '[]', '{\"head\":867,\"def\":7203.0,\"hp\":4.4843785819870725E7,\"dame\":9382872.835294291,\"body\":868,\"leg\":869}', 1),
(13878, 1023831, 'dai018', 673, 1747544361806, 1747544361809, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13879, 1023832, 'xd5xx', 674, 1748754292256, 1748754292760, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6076,\"dame\":908,\"body\":10,\"leg\":11}', 1),
(13880, 1023833, 'dai019', 675, 1747544411628, 1747544411631, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13881, 1023834, 'dai020', 676, 1747544561102, 1747544561106, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13882, 1023835, 'aevccc1', 677, 1747544611193, 1747544611195, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13883, 1023836, 'dai021', 678, 1747544654871, 1747544654875, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13884, 1023837, 'dai022', 679, 1747544702792, 1747544702795, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13885, 1023838, 'dai023', 680, 1747544748082, 1747544748087, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13886, 1023839, 'dai024', 681, 1747544830405, 1747544830408, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13887, 1023840, 'dai025', 682, 1747544877649, 1747544877652, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13888, 1023841, '1kame1boss', 683, 1749007408715, 1749007409239, 3, 0, 0, '[]', '{\"head\":870,\"def\":4.0,\"hp\":3266527.73683164,\"dame\":1483459.7174623334,\"body\":871,\"leg\":872}', 1),
(13889, 1023842, 'bigbang', 684, 1748337821879, 1748337822385, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":15092,\"dame\":8389,\"body\":16,\"leg\":17}', 1),
(13890, 1023843, 'cancasever', 685, 1747545261550, 1747545261554, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13891, 1023844, 'theflash', 686, 1748365942086, 1748365942591, 3, 0, 0, '[]', '{\"head\":391,\"def\":0,\"hp\":1032291,\"dame\":74275,\"body\":392,\"leg\":393}', 1),
(13892, 1023845, 'thuxinhgai', 687, 1747545473549, 1747545473552, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13893, 1023846, 'top1laze', 688, 1748359508270, 1748359508776, 3, 0, 0, '[]', '{\"head\":128,\"def\":90,\"hp\":9423,\"dame\":1572,\"body\":75,\"leg\":76}', 1),
(13894, 1023847, 'chichixinh', 689, 1747545878534, 1747545878539, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13895, 1023848, 'fgchj', 690, 1748370298119, 1748370298624, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":20828,\"dame\":2030,\"body\":16,\"leg\":17}', 1),
(13896, 1023849, 'chichicute', 691, 1747546213941, 1747546213945, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13897, 1023850, 'firlxinh', 692, 1747546314600, 1747546314615, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13898, 1023851, 'chichisama', 693, 1747546383747, 1747546383750, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13899, 1023852, 'shiny', 694, 1748060212584, 1748060213090, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":338,\"dame\":6154,\"body\":14,\"leg\":15}', 1),
(13900, 1023853, 'chichisan', 695, 1747546513651, 1747546513654, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13901, 1023854, 'gokusamaa', 696, 1747546597289, 1747546597294, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13902, 1023855, 'gohansamaa', 697, 1747546664019, 1747546664023, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13903, 1023856, 'kingchichi', 698, 1747546729877, 1747546729881, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13904, 1023857, 'godsayda', 699, 1747546935752, 1747546935756, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13905, 1023858, 'xtraidat', 700, 1747546982109, 1747546982112, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13906, 1023859, 'kaiosama', 701, 1747547082116, 1747547082121, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13907, 1023860, 'kaioshin', 702, 1747547140095, 1747547140099, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13908, 1023861, 'kaioshyn', 703, 1747547204233, 1747547204236, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13909, 1023862, 'putin', 704, 1748619645360, 1748619645867, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":3599,\"dame\":2376,\"body\":14,\"leg\":15}', 1),
(13910, 1023863, 'kaioshins', 705, 1747547270929, 1747547270933, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13911, 1023864, 'kaioshinx', 706, 1747547327357, 1747547327361, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13912, 1023865, 'kaioshinz', 707, 1747547387319, 1747547387323, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13913, 1023866, 'quynhmiu', 708, 1747547489678, 1747547489684, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13914, 1023867, 'mrbum', 709, 1748395937995, 1748395938499, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":2949,\"dame\":8961,\"body\":14,\"leg\":58}', 1),
(13915, 1023868, 'dragon', 710, 1747547694788, 1747547694791, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13916, 1023869, 'cutnhatsv', 711, 1747547897304, 1747547897308, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13917, 1023870, 'kaioxshin', 712, 1747547898518, 1747547898522, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13918, 1023871, 'vtraidat', 713, 1747547934815, 1747547934818, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13919, 1023872, 'kaioxshyn', 714, 1747547966606, 1747547966611, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13920, 1023873, 'kaioshjn', 715, 1747548061487, 1747548061492, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13921, 1023874, 'picolo', 716, 1747548104065, 1747548104068, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13922, 1023875, 'kaiozshjn', 717, 1747548142579, 1747548142585, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13923, 1023876, 'darknamek', 718, 1747548220678, 1747548220682, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13924, 1023877, 'zkaioshjn', 719, 1747548232247, 1747548232251, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13925, 1023878, 'trumxd1', 720, 1747548249106, 1747548249112, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13926, 1023879, 'zkaioshin', 721, 1747548290891, 1747548290895, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13927, 1023880, 'gnurt2', 722, 1747548327256, 1747548327260, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13928, 1023881, 'kaioshen', 723, 1747548419523, 1747548419527, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13929, 1023882, 'mtuoilozgi', 724, 1747548509460, 1747548509466, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13930, 1023883, 'golden1', 725, 1748395853028, 1748395853533, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":44451,\"dame\":34965,\"body\":10,\"leg\":11}', 1),
(13931, 1023884, 'straidat', 726, 1747548817879, 1747548817883, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13932, 1023885, 'golden', 727, 1748396254625, 1748396255137, 3, 0, 0, '[]', '{\"head\":128,\"def\":200,\"hp\":763810,\"dame\":36162,\"body\":149,\"leg\":150}', 1),
(13933, 1023886, 'golden9', 728, 1748126932373, 1748126932877, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":44253,\"dame\":25317,\"body\":59,\"leg\":60}', 1),
(13934, 1023887, 'golden8', 729, 1748126384804, 1748126385309, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":15843,\"dame\":27195,\"body\":59,\"leg\":60}', 1),
(13935, 1023888, 'golden7', 730, 1748126033960, 1748126034466, 3, 0, 0, '[]', '{\"head\":128,\"def\":4,\"hp\":47562,\"dame\":27195,\"body\":59,\"leg\":11}', 1),
(13936, 1023889, 'golden2', 731, 1748395890546, 1748395891050, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":79249,\"dame\":38849,\"body\":10,\"leg\":11}', 1),
(13937, 1023890, 'caros', 732, 1747549300827, 1747549300831, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13938, 1023891, 'xdtroi', 733, 1748449754856, 1748449755366, 3, 0, 0, '[]', '{\"head\":1614,\"def\":3,\"hp\":126883,\"dame\":7308,\"body\":1615,\"leg\":1616}', 1),
(13939, 1023892, 'golden3', 734, 1748124103493, 1748124103998, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":176,\"dame\":47021,\"body\":10,\"leg\":11}', 1),
(13940, 1023893, 'golden4', 735, 1748124346030, 1748124346535, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":189,\"dame\":18828,\"body\":10,\"leg\":11}', 1),
(13941, 1023894, 'golden5', 736, 1748125088634, 1748125089140, 3, 0, 0, '[]', '{\"head\":128,\"def\":10,\"hp\":13685,\"dame\":23444,\"body\":10,\"leg\":11}', 1),
(13942, 1023895, 'in4xinboss', 737, 1747549439790, 1747549439796, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13943, 1023896, 'golden6', 738, 1748125597700, 1748125598205, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":73783,\"dame\":25317,\"body\":59,\"leg\":11}', 1),
(13944, 1023897, 'in4bibos', 739, 1747549508896, 1747549508900, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13945, 1023898, 'xin1bos', 740, 1747549566319, 1747549566323, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13946, 1023899, 'idxinbos', 741, 1747549628699, 1747549628703, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13947, 1023900, 'clerboss', 742, 1747549693947, 1747549693950, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13948, 1023901, 'xinhetbos', 743, 1747549745349, 1747549745353, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13949, 1023902, 'grilbaybi', 744, 1747549822419, 1747549822422, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13950, 1023903, 'xin2boss', 745, 1747549873009, 1747549873012, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13951, 1023904, 'anhshipper', 746, 1747549940827, 1747549940831, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13952, 1023905, 'thangxtrum', 747, 1748693144238, 1748693144755, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":5050116,\"dame\":20127,\"body\":384,\"leg\":385}', 1),
(13953, 1023906, 'namercold', 1085, 1748339621743, 1747550398314, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua namtips[748]\\\",\\\"timestamp\\\":1748339621746}\"]', '{\"head\":128,\"def\":2,\"hp\":163,\"dame\":25763,\"body\":10,\"leg\":11}', 0),
(13954, 1023907, 'xinallboss', 749, 1747551045659, 1747551045665, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13955, 1023908, 'xincler', 750, 1747551150450, 1747551150455, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13956, 1023909, 'nhincailoz', 751, 1747551196547, 1747551196550, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13957, 1023910, 'xemsexko', 752, 1747551240489, 1747551240493, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13958, 1023911, 'sexkoche', 753, 1747551315355, 1747551315359, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13959, 1023912, 'xvideosex', 754, 1747551376786, 1747551376793, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13960, 1023913, 'gokuxz', 755, 1747551453218, 1747551453222, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13961, 1023914, 'xauzai', 756, 1747551502292, 1747551502295, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13962, 1023915, 'pemthue', 757, 1747552411272, 1747552411275, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13963, 1023916, 'anhmayman', 758, 1748023103960, 1748023104465, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":169340,\"dame\":3401,\"body\":384,\"leg\":385}', 1),
(13964, 1023917, 'buwin', 759, 1748702557060, 1748702557565, 3, 0, 0, '[]', '{\"head\":377,\"def\":2,\"hp\":522244,\"dame\":24278,\"body\":378,\"leg\":379}', 1),
(13965, 1023918, 'cunyeu', 760, 1747556369316, 1747556369321, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13966, 1023919, 'zetkay', 761, 1748013828225, 1748013828729, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":24989,\"dame\":3678,\"body\":16,\"leg\":17}', 1),
(13967, 1023920, 'xinhetboss', 762, 1747559766752, 1747559766756, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13968, 1023921, 'songuku', 763, 1747559812853, 1747559812856, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13969, 1023922, 'taoxinbos', 764, 1747559831692, 1747559831701, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13970, 1023923, 'gukuu', 765, 1749485345984, 1749485352492, 3, 0, 0, '[]', '{\"head\":867,\"def\":7207.0,\"hp\":1.8924615386598372E8,\"dame\":67331.5966368,\"body\":868,\"leg\":869}', 1),
(13971, 1023924, 'top2namec', 766, 1748093192247, 1748093192752, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":317868,\"dame\":27216,\"body\":392,\"leg\":393}', 1),
(13972, 1023925, 'top1hp', 767, 1748093450714, 1748093451220, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":149,\"dame\":921,\"body\":16,\"leg\":17}', 1),
(13973, 1023926, 'ebedatt', 768, 1748649316524, 1748649317030, 3, 0, 0, '[]', '{\"head\":873,\"def\":7202,\"hp\":1159427,\"dame\":56114,\"body\":874,\"leg\":875}', 1),
(13974, 1023927, 'piccoloo', 769, 1747563350306, 1747563350310, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13975, 1023928, 'kame1hp', 770, 1748393612783, 1748393613296, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":9145,\"dame\":977,\"body\":14,\"leg\":58}', 1),
(13976, 1023929, 'bom2hp', 771, 1747567047767, 1747567047791, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13977, 1023930, 'cheater', 772, 1748616197675, 1748616198181, 3, 0, 0, '[]', '{\"head\":377,\"def\":3,\"hp\":142,\"dame\":6720,\"body\":378,\"leg\":379}', 1),
(13978, 1023931, 'thichbulol', 773, 1749217260872, 1749217261381, 3, 0, 0, '[]', '{\"head\":873,\"def\":7202.0,\"hp\":470722.5445,\"dame\":73108.83669729845,\"body\":874,\"leg\":875}', 1),
(13979, 1023932, 'thang9ngon', 774, 1747570146204, 1747570146215, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(13980, 1023933, 'sontungmtp', 775, 1748090718954, 1748090719461, 3, 0, 0, '[]', '{\"head\":126,\"def\":70,\"hp\":1495368,\"dame\":27633,\"body\":73,\"leg\":74}', 1),
(13981, 1023934, 'thuydiem', 776, 1747570336435, 1747570336438, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13982, 1023935, 'fuckyou', 777, 1747571504299, 1747571504303, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13983, 1023936, 'concek', 778, 1748580378682, 1748580379190, 3, 0, 0, '[]', '{\"head\":873,\"def\":2,\"hp\":1317501,\"dame\":32021,\"body\":874,\"leg\":875}', 1),
(13984, 1023937, 'g0han', 779, 1747572370755, 1747572370759, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(13985, 1023938, 'ditcmm', 780, 1747573462757, 1747573462763, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13986, 1023939, 'test99', 1063, 1749132836314, 1747573656031, 3, 0, 1, '[\"{\\\"event\\\":\\\"Thua oncloudms[781]\\\",\\\"timestamp\\\":1749132836331}\"]', '{\"head\":127,\"def\":2.0,\"hp\":285.66,\"dame\":24.84,\"body\":14,\"leg\":15}', 0),
(13987, 1023940, 'xd6xx', 782, 1749199316862, 1749199317366, 3, 0, 0, '[]', '{\"head\":391,\"def\":2.0,\"hp\":882495.6736440001,\"dame\":68501.3529312,\"body\":392,\"leg\":393}', 1),
(13988, 1023941, 'xd7xx', 783, 1748754430181, 1748754430687, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6076,\"dame\":912,\"body\":10,\"leg\":11}', 1),
(13989, 1023942, 'pic0lo', 784, 1747574478098, 1747574478101, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(13990, 1023943, 'xd8xx', 785, 1748754721353, 1748757621291, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":590225,\"dame\":36166,\"body\":10,\"leg\":11}', 1),
(13991, 1023944, 'xd9xx', 786, 1748754401151, 1748754401662, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6076,\"dame\":1055,\"body\":10,\"leg\":11}', 1),
(13992, 1023945, 'hikohoho', 787, 1748684951625, 1748684952129, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":354071,\"dame\":20452,\"body\":14,\"leg\":15}', 1),
(13993, 1023946, '1tdxi', 788, 1748754375755, 1748754376260, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":5475,\"dame\":809,\"body\":10,\"leg\":11}', 1),
(13994, 1023947, '0tdxi', 789, 1748754326887, 1748754327394, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":633946,\"dame\":38112,\"body\":10,\"leg\":11}', 1),
(13995, 1023948, 'bulon', 790, 1748124398766, 1748124399270, 3, 0, 0, '[]', '{\"head\":128,\"def\":40,\"hp\":5635,\"dame\":2061,\"body\":67,\"leg\":76}', 1),
(13996, 1023949, '2tdxi', 791, 1748754277190, 1748754277697, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":551613,\"dame\":35474,\"body\":10,\"leg\":11}', 1),
(13997, 1023950, '3tdxi', 792, 1748754314638, 1748754315142, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":882300,\"dame\":33530,\"body\":10,\"leg\":11}', 1),
(13998, 1023951, 'buruuzu', 793, 1748047717199, 1748047717704, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":57405,\"dame\":2005,\"body\":16,\"leg\":17}', 1),
(13999, 1023952, 'noobnamec', 794, 1749094276309, 1749094276816, 3, 0, 0, '[]', '{\"head\":391,\"def\":2.0,\"hp\":360205.4,\"dame\":16273.575,\"body\":392,\"leg\":393}', 1),
(14000, 1023953, '1bom1tr', 795, 1747577015778, 1747577015781, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14001, 1023954, '111222', 796, 1748573547549, 1748573548059, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":167,\"dame\":3224,\"body\":10,\"leg\":11}', 1),
(14002, 1023955, 'dumaloz', 797, 1747577131327, 1747577131331, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14003, 1023956, '4tdxi', 798, 1748754298655, 1748754299161, 3, 0, 0, '[]', '{\"head\":128,\"def\":40,\"hp\":963752,\"dame\":35206,\"body\":67,\"leg\":11}', 1),
(14004, 1023957, 'gold1', 799, 1747577384543, 1747577384547, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14005, 1023958, 'hades', 800, 1747577659030, 1747577659034, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14006, 1023959, '1bom1boss', 801, 1748308300868, 1748308301373, 3, 0, 0, '[]', '{\"head\":383,\"def\":400,\"hp\":269554,\"dame\":40924,\"body\":384,\"leg\":385}', 1),
(14007, 1023960, 's2badao', 802, 1747578391525, 1747578391530, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14008, 1023961, 'pemvang1', 803, 1749094232388, 1749094232896, 3, 0, 0, '[]', '{\"head\":391,\"def\":402.0,\"hp\":502833.154,\"dame\":33225.4,\"body\":392,\"leg\":393}', 1),
(14009, 1023962, '5tdxi', 804, 1748754315556, 1748754316061, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":2817,\"dame\":1019,\"body\":10,\"leg\":11}', 1),
(14010, 1023963, 'xieuza1', 805, 1747579121303, 1747579121308, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14011, 1023964, '6tdxi', 806, 1748754720486, 1748757557250, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6076,\"dame\":780,\"body\":10,\"leg\":11}', 1),
(14012, 1023965, 'pemvang2', 807, 1749094253617, 1749094254148, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":89815.77432000001,\"dame\":29338.848,\"body\":10,\"leg\":11}', 1),
(14013, 1023966, 'thuoclao', 808, 1747579293975, 1747579293980, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14014, 1023967, '7tdxi', 809, 1748754278309, 1748754278816, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6578,\"dame\":1281,\"body\":10,\"leg\":11}', 1),
(14015, 1023968, 'bitheo', 810, 1747579876642, 1747579876646, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14016, 1023969, '8tdxi', 811, 1748754221460, 1748754221973, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":13448,\"dame\":1042,\"body\":10,\"leg\":11}', 1),
(14017, 1023970, 'lozzz', 812, 1748580476676, 1748580477183, 3, 0, 0, '[]', '{\"head\":873,\"def\":2,\"hp\":1315917,\"dame\":32367,\"body\":874,\"leg\":875}', 1),
(14018, 1023971, 'erherhjty', 813, 1748050098588, 1748050099099, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":138,\"dame\":138,\"body\":10,\"leg\":11}', 1),
(14019, 1023972, 'erherhkk', 814, 1748037752284, 1748037752789, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":76596,\"dame\":273,\"body\":10,\"leg\":11}', 1),
(14020, 1023973, 'gregd', 815, 1748039555222, 1748039555727, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":82271,\"dame\":279,\"body\":10,\"leg\":11}', 1),
(14021, 1023974, 'thrtg', 816, 1748050157758, 1748050158268, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":70922,\"dame\":241,\"body\":10,\"leg\":11}', 1),
(14022, 1023975, 'gergjhy', 817, 1748050177984, 1748050202515, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":139,\"dame\":11,\"body\":10,\"leg\":11}', 1),
(14023, 1023976, 'ehrhee', 818, 1747580513316, 1747580513319, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14024, 1023977, '9tdxi', 819, 1748754238314, 1748754238821, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":6578,\"dame\":1114,\"body\":10,\"leg\":11}', 1),
(14025, 1023978, 'hptop1', 820, 1747580850175, 1747580850179, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14026, 1023979, 'shopee', 821, 1748396037483, 1748396037989, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":105501,\"dame\":1920,\"body\":14,\"leg\":15}', 1),
(14027, 1023980, 'trumbucu', 822, 1747581820295, 1747581820299, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14028, 1023981, 'trumno', 823, 1747582362573, 1747582362576, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14029, 1023982, 'policebom', 824, 1748923926849, 1748923927354, 3, 0, 0, '[]', '{\"head\":126,\"def\":3.0,\"hp\":40748.8088016,\"dame\":5220.851328,\"body\":16,\"leg\":17}', 1),
(14030, 1023983, 'traidat1st', 825, 1748381527468, 1748381527973, 3, 0, 0, '[]', '{\"head\":127,\"def\":8,\"hp\":690592,\"dame\":53406,\"body\":14,\"leg\":15}', 1),
(14031, 1023984, 'kriklin', 826, 1748047795799, 1748047796304, 3, 0, 0, '[]', '{\"head\":127,\"def\":402,\"hp\":18108,\"dame\":2723,\"body\":14,\"leg\":15}', 1),
(14032, 1023985, 'zerotwo002', 827, 1747584688314, 1747584688317, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14033, 1023986, 'ditcumay', 828, 1747584757754, 1747584757758, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14034, 1023987, 'gold2', 829, 1747585330601, 1747585330604, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14035, 1023988, 'buntron', 830, 1749445286628, 1749445287135, 3, 0, 0, '[]', '{\"head\":126,\"def\":9199.2,\"hp\":1030947.354,\"dame\":43878.0384,\"body\":151,\"leg\":152}', 1),
(14036, 1023989, 'accoll', 831, 1747586086107, 1747586086110, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14037, 1023990, 'google', 832, 1748338555328, 1748338555835, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":189,\"dame\":603,\"body\":16,\"leg\":17}', 1),
(14038, 1023991, 'napan', 833, 1747586456588, 1747586456592, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14039, 1023992, 'supergohan', 834, 1747586565261, 1747586565265, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14040, 1023993, 'nro01', 835, 1747586733559, 1747586733563, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14041, 1023994, 'quylao', 836, 1747586788116, 1747586788132, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14042, 1023995, 'nro02', 837, 1747587515191, 1747587515194, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14043, 1023996, 'xaydas', 838, 1749353215440, 1749353215952, 3, 0, 0, '[]', '{\"head\":383,\"def\":0.0,\"hp\":209580.0,\"dame\":23427.0,\"body\":384,\"leg\":385}', 1),
(14044, 1023997, 'duyetdxx', 839, 1749525135349, 1749525135854, 3, 0, 0, '[]', '{\"head\":128,\"def\":5208.0,\"hp\":762731.8236,\"dame\":21383.514,\"body\":12,\"leg\":76}', 1),
(14045, 1023998, 'zzzzzzzz', 840, 1747588517280, 1747588517286, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14046, 1023999, 'nro03', 841, 1747588805630, 1747588805634, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14047, 1024000, 'anhlong', 842, 1747589056455, 1747589056460, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14048, 1024001, 'babayje', 843, 1747589100670, 1747589100674, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14049, 1024002, 'kirinn', 844, 1747589781466, 1747589781469, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14050, 1024003, 'sieukm', 845, 1747590311495, 1747590311498, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14051, 1024004, 'hieuzi', 846, 1749458452918, 1749458453424, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":297.9749268,\"dame\":7262.4384,\"body\":14,\"leg\":15}', 1),
(14052, 1024005, 'vuaanxin', 847, 1747590428952, 1747590428955, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14053, 1024006, 'xincaiten', 848, 1747590484630, 1747590484633, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14054, 1024007, 'cailoz', 849, 1747590541904, 1747590541908, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14055, 1024008, 'calicbye', 850, 1747590618392, 1747590618396, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14056, 1024009, 'xsongohan', 851, 1747590709592, 1747590709596, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14057, 1024010, 'krinlin', 852, 1747590761831, 1747590761836, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14058, 1024011, 'senacon', 853, 1747590805742, 1747590805745, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14059, 1024012, 'maxhut', 854, 1747590857971, 1747590857975, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14060, 1024013, 'watakin', 855, 1747591346834, 1747591346837, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14061, 1024014, 'amazon', 856, 1747591406812, 1747591406815, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14062, 1024015, 'trumbucuu', 857, 1747591465752, 1747591465755, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14063, 1024016, 'azsilic', 858, 1747591480092, 1747591480097, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14064, 1024017, 'nhincaixx', 859, 1747591526747, 1747591526750, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14065, 1024018, 'xxxinxxx', 860, 1747591572144, 1747591572148, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14066, 1024019, 'keanxin', 861, 1747591626531, 1747591626534, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14067, 1024020, 'xxlozxx', 862, 1747591683326, 1747591683329, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14068, 1024021, 'xxsexzz', 863, 1747591735325, 1747591735328, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14069, 1024022, 'zzvideozz', 864, 1747591802575, 1747591802578, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14070, 1024023, 'xxvcxx', 865, 1747591852613, 1747591852616, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14071, 1024024, 'mimax', 866, 1747591924509, 1747591924513, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14072, 1024025, 'maxdz', 867, 1747591972518, 1747591972520, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14073, 1024026, 'xxbulonxx', 868, 1747592072544, 1747592072548, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14074, 1024027, 'xxtikixx', 869, 1747592130505, 1747592130510, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14075, 1024028, 'kamejok0', 870, 1748829258438, 1748829258947, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":313,\"dame\":275,\"body\":14,\"leg\":15}', 1),
(14076, 1024029, '1bisx', 871, 1748649890049, 1748649890560, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":752052,\"dame\":35843,\"body\":16,\"leg\":17}', 1),
(14077, 1024030, 'taochoimsk', 872, 1748585885986, 1748585886494, 3, 0, 0, '[]', '{\"head\":873,\"def\":7202,\"hp\":292284,\"dame\":50082,\"body\":874,\"leg\":875}', 1),
(14078, 1024031, '2dissx', 873, 1749380538183, 1749380538689, 3, 0, 0, '[]', '{\"head\":867,\"def\":3.0,\"hp\":2484834.610958944,\"dame\":187838.21434356488,\"body\":868,\"leg\":869}', 1),
(14079, 1024032, '2xiusc', 874, 1748754547805, 1748754548309, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":159,\"dame\":1040,\"body\":16,\"leg\":17}', 1),
(14080, 1024033, '3disma', 875, 1748754323878, 1748754324381, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":5475,\"dame\":821,\"body\":16,\"leg\":17}', 1),
(14081, 1024034, '4disau', 876, 1748649907338, 1748649907844, 3, 0, 0, '[]', '{\"head\":383,\"def\":7203,\"hp\":5386668,\"dame\":61041,\"body\":384,\"leg\":385}', 1),
(14082, 1024035, 'ssssss', 877, 1749452369345, 1749452369849, 3, 0, 10, '[]', '{\"head\":873,\"def\":8642.4,\"hp\":4761974.895599999,\"dame\":2288982.6866455097,\"body\":874,\"leg\":875}', 1),
(14083, 1024036, 'octieuu', 878, 1747599822737, 1747599822741, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14084, 1024037, 'laze1m', 879, 1747601036696, 1747601036700, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14085, 1024038, 'wfcediu', 880, 1748271800362, 1748271800867, 3, 0, 0, '[]', '{\"head\":128,\"def\":90,\"hp\":5635,\"dame\":2305,\"body\":75,\"leg\":76}', 1),
(14086, 1024039, 'thientu', 881, 1748534538376, 1748534538884, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":77164,\"dame\":14527,\"body\":392,\"leg\":393}', 1),
(14087, 1024040, '5cisx', 882, 1748754227642, 1748754228147, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":3126,\"dame\":1160,\"body\":16,\"leg\":17}', 1),
(14088, 1024041, 'hihhi', 883, 1748744771059, 1748744771563, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":8892,\"dame\":2504,\"body\":14,\"leg\":15}', 1),
(14089, 1024042, 'adfkjfjf', 884, 1748271814944, 1748271815450, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":149,\"dame\":1057,\"body\":10,\"leg\":11}', 1),
(14090, 1024043, '0nekjll', 885, 1747604757089, 1747604757094, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14091, 1024044, 'ruldra', 886, 1747605370038, 1747605370041, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14092, 1024045, 'kkkkk', 887, 1747605446684, 1747605446689, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14093, 1024046, 'onekame', 888, 1747606202549, 1747606202553, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14094, 1024047, 'yhhyk', 889, 1747904302099, 1747904302614, 3, 0, 0, '[]', '{\"head\":1140,\"def\":2,\"hp\":280,\"dame\":12,\"body\":1141,\"leg\":1142}', 1),
(14095, 1024048, 'daniel', 890, 1748953580098, 1748953580601, 3, 0, 0, '[]', '{\"head\":127,\"def\":2.0,\"hp\":20991.005982000002,\"dame\":4161.7134719999995,\"body\":14,\"leg\":15}', 1),
(14096, 1024049, 'dsdsdsd', 891, 1747733445510, 1747733445541, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14097, 1024050, 'whyforme', 892, 1748204519798, 1748204520304, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":157336,\"dame\":26726,\"body\":10,\"leg\":11}', 1),
(14098, 1024280, 'dzvcl', 893, 1748769338490, 1748769338996, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":293020,\"dame\":26946,\"body\":392,\"leg\":393}', 1),
(14099, 1024340, 'durex', 894, 1749525595774, 1749525596279, 3, 0, 0, '[]', '{\"head\":391,\"def\":1797.0,\"hp\":933444.69864,\"dame\":90203.26866300356,\"body\":392,\"leg\":393}', 1),
(14100, 1024282, 'tester', 895, 1749526698602, 1749526710114, 3, 0, 2, '[]', '{\"head\":391,\"def\":2.0,\"hp\":3.3741419823111105E9,\"dame\":7357.40772,\"body\":392,\"leg\":393}', 1),
(14101, 1024365, 'hertz', 896, 1748762219500, 1748762220005, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":690,\"dame\":912,\"body\":16,\"leg\":17}', 1),
(14102, 1024360, 'yamkaka', 897, 1748762148259, 1748762148763, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":12888,\"dame\":9369,\"body\":14,\"leg\":15}', 1),
(14103, 1024363, 'kuyter', 898, 1747968983618, 1747976400494, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":90115,\"dame\":22531,\"body\":392,\"leg\":393}', 1),
(14104, 1024229, 'oncloud6', 899, 1749174005269, 1749174005775, 3, 0, 0, '[]', '{\"head\":873,\"def\":7202.0,\"hp\":924046.8,\"dame\":104359.50678833612,\"body\":874,\"leg\":875}', 1),
(14105, 1024374, 'heart2', 900, 1749303194084, 1749303194590, 3, 0, 0, '[]', '{\"head\":383,\"def\":2.0,\"hp\":714676.3367890801,\"dame\":57138.00587212799,\"body\":384,\"leg\":385}', 1),
(14106, 1024362, 'l7godboy', 901, 1747969040946, 1747976400617, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":21662,\"dame\":17062,\"body\":14,\"leg\":72}', 1),
(14107, 1024059, 'tdboss', 902, 1748836147440, 1748836147946, 3, 0, 0, '[]', '{\"head\":383,\"def\":402,\"hp\":778384,\"dame\":49378,\"body\":384,\"leg\":385}', 1),
(14108, 1024223, 'xaydabomm', 903, 1748780527176, 1748780527681, 3, 0, 0, '[]', '{\"head\":867,\"def\":7203,\"hp\":1442780,\"dame\":181739,\"body\":868,\"leg\":869}', 1),
(14109, 1024377, 'hertzz', 904, 1748762251212, 1748762251738, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":338,\"dame\":838,\"body\":14,\"leg\":15}', 1);
INSERT INTO `super_rank` (`id`, `player_id`, `name`, `rank`, `last_pk_time`, `last_reward_time`, `ticket`, `win`, `lose`, `history`, `info`, `received`) VALUES
(14110, 1024361, 'chichi', 905, 1748390010428, 1748390010933, 3, 0, 0, '[]', '{\"head\":377,\"def\":2,\"hp\":369118,\"dame\":33356,\"body\":378,\"leg\":379}', 1),
(14111, 1024255, 'chesm', 906, 1748142325886, 1748142326395, 3, 0, 0, '[]', '{\"head\":30,\"def\":40,\"hp\":4104,\"dame\":428,\"body\":65,\"leg\":66}', 1),
(14112, 1024375, 'vuaphahoai', 907, 1749304538503, 1749304539014, 3, 0, 0, '[]', '{\"head\":383,\"def\":3.0,\"hp\":4254016.297058495,\"dame\":29511.114528,\"body\":384,\"leg\":385}', 1),
(14113, 1024351, 'oncloud6wp', 908, 1749378036311, 1749378036818, 3, 0, 0, '[]', '{\"head\":870,\"def\":405.0,\"hp\":1785024.9482570002,\"dame\":1841245.396576961,\"body\":871,\"leg\":872}', 1),
(14114, 1024099, 'mlnmec', 909, 1749049481806, 1749049482311, 3, 0, 0, '[]', '{\"head\":391,\"def\":2.0,\"hp\":882230.9891400001,\"dame\":72918.4032,\"body\":392,\"leg\":393}', 1),
(14115, 1024293, 'binhan2302', 910, 1748686716385, 1748686716890, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":3094444,\"dame\":72908,\"body\":384,\"leg\":385}', 1),
(14116, 1024306, 'hehhe', 911, 1748993335818, 1748993336324, 3, 0, 0, '[]', '{\"head\":391,\"def\":2.0,\"hp\":345378.59156,\"dame\":51922.4730336,\"body\":392,\"leg\":393}', 1),
(14117, 1024052, 'xaydaaa', 912, 1748704936458, 1748704936962, 3, 0, 0, '[]', '{\"head\":383,\"def\":7,\"hp\":359586,\"dame\":21779,\"body\":384,\"leg\":385}', 1),
(14118, 1024227, 'vangso1', 913, 1748616759644, 1748616760151, 3, 0, 0, '[]', '{\"head\":264,\"def\":832,\"hp\":484750,\"dame\":52107,\"body\":265,\"leg\":266}', 1),
(14119, 1024228, 'golds2', 914, 1748616765874, 1748616766380, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":712643,\"dame\":29111,\"body\":345,\"leg\":346}', 1),
(14120, 1024230, 'threev', 915, 1748689767852, 1748689768359, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":769654,\"dame\":31471,\"body\":345,\"leg\":346}', 1),
(14121, 1024231, 'foriii', 916, 1748605943612, 1748605944116, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":800414,\"dame\":31503,\"body\":345,\"leg\":346}', 1),
(14122, 1024233, 'gohann', 917, 1748605858165, 1748605858670, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":800414,\"dame\":31341,\"body\":345,\"leg\":346}', 1),
(14123, 1024235, 'rokute', 918, 1748605775125, 1748605775632, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":769654,\"dame\":31373,\"body\":345,\"leg\":346}', 1),
(14124, 1024236, 'nanami', 919, 1748605949691, 1748605950196, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":1539308,\"dame\":31528,\"body\":345,\"leg\":346}', 1),
(14125, 1024058, 'reall5', 920, 1747969511507, 1747969511512, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":149,\"dame\":36,\"body\":16,\"leg\":17}', 0),
(14126, 1024237, 'hachijack', 921, 1748606072079, 1748606072584, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":799131,\"dame\":31716,\"body\":345,\"leg\":346}', 1),
(14127, 1024238, 'kyukyu', 922, 1748606161090, 1748606161599, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":826665,\"dame\":33055,\"body\":345,\"leg\":346}', 1),
(14128, 1024239, 'tenmura', 923, 1748606282654, 1748606283169, 3, 0, 0, '[]', '{\"head\":344,\"def\":492,\"hp\":712643,\"dame\":28667,\"body\":345,\"leg\":346}', 1),
(14129, 1024063, 'admin', 924, 1749443749595, 1749444245361, 3, 0, 0, '[]', '{\"head\":870,\"def\":7203.0,\"hp\":1342529.832,\"dame\":526625.2968566451,\"body\":871,\"leg\":872}', 1),
(14130, 1024061, 'dende', 925, 1749486184278, 1749486204792, 3, 0, 0, '[]', '{\"head\":391,\"def\":2002.0,\"hp\":1377558.92927264,\"dame\":111920.44180965121,\"body\":392,\"leg\":393}', 1),
(14131, 1024062, 'broly', 926, 1748874641198, 1748874677736, 3, 0, 0, '[]', '{\"head\":383,\"def\":1203.0,\"hp\":1452171.6480660988,\"dame\":8638.4417,\"body\":384,\"leg\":385}', 1),
(14132, 1024367, 'bundaugio', 927, 1749445338949, 1749445339457, 3, 0, 0, '[]', '{\"head\":128,\"def\":1716.0,\"hp\":1157676.84432,\"dame\":51017.543781119995,\"body\":476,\"leg\":477}', 1),
(14133, 1024341, 'ntc2004', 928, 1749438662106, 1749438662614, 3, 0, 0, '[]', '{\"head\":127,\"def\":0.0,\"hp\":20241.9711,\"dame\":16886.37483,\"body\":14,\"leg\":15}', 1),
(14134, 1024244, '6xixya', 929, 1749458417940, 1749458418454, 3, 0, 0, '[]', '{\"head\":128,\"def\":2.0,\"hp\":159.4728,\"dame\":716.5097999999999,\"body\":10,\"leg\":11}', 1),
(14135, 1024370, 'bundaubo', 930, 1749445376210, 1749445376719, 3, 0, 0, '[]', '{\"head\":128,\"def\":600.0,\"hp\":1109882.84616,\"dame\":47425.004928,\"body\":153,\"leg\":154}', 1),
(14136, 1024245, '7xicsap', 931, 1748754201673, 1748754202179, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":3126,\"dame\":917,\"body\":10,\"leg\":11}', 1),
(14137, 1024246, '8zitv', 932, 1748754317836, 1748754318342, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":176,\"dame\":1041,\"body\":10,\"leg\":11}', 1),
(14138, 1024247, '9sitv', 933, 1748754321573, 1748754322079, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":176,\"dame\":1062,\"body\":10,\"leg\":11}', 1),
(14139, 1024285, 'anhhiep', 934, 1748356357558, 1748356358067, 3, 0, 0, '[]', '{\"head\":538,\"def\":4003,\"hp\":779580,\"dame\":29498,\"body\":474,\"leg\":475}', 1),
(14140, 1024243, 'bomexp89', 935, 1748616890106, 1748616890618, 3, 0, 0, '[]', '{\"head\":383,\"def\":7204,\"hp\":1484201,\"dame\":257743,\"body\":384,\"leg\":385}', 1),
(14141, 1024232, 'reall7', 936, 1748057496452, 1748057496957, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":149,\"dame\":49,\"body\":16,\"leg\":17}', 1),
(14142, 1024372, 'buntomsu', 937, 1749445429523, 1749445430030, 3, 0, 0, '[]', '{\"head\":128,\"def\":589.2,\"hp\":835231.9805114398,\"dame\":47451.712896000005,\"body\":153,\"leg\":154}', 1),
(14143, 1024277, 'oncloud6ws', 938, 1749047418095, 1749047418601, 3, 0, 0, '[]', '{\"head\":383,\"def\":1202.0,\"hp\":331011.401702,\"dame\":13599.564160000002,\"body\":384,\"leg\":385}', 1),
(14144, 1024336, 'yamate', 939, 1749515286537, 1749515287042, 3, 0, 0, '[]', '{\"head\":31,\"def\":1528.0,\"hp\":582801.945,\"dame\":69424.3841903492,\"body\":472,\"leg\":473}', 1),
(14145, 1024291, 'ruongdo', 940, 1748567857796, 1748567858302, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":57638,\"dame\":15,\"body\":16,\"leg\":17}', 1),
(14146, 1024301, 'azaitheb', 941, 1747971620819, 1747971620823, 3, 0, 0, '[]', '{\"head\":128,\"def\":8,\"hp\":1031,\"dame\":131,\"body\":12,\"leg\":68}', 0),
(14147, 1024249, 'kihobobo', 942, 1748684972708, 1748684973213, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":409783,\"dame\":18035,\"body\":10,\"leg\":11}', 1),
(14148, 1024119, 'architect', 943, 1749058481761, 1749058482267, 3, 0, 0, '[]', '{\"head\":377,\"def\":4400.0,\"hp\":480240.0108,\"dame\":15601.8,\"body\":378,\"leg\":379}', 1),
(14149, 1024348, 'anhbana', 944, 1747984362106, 1747984366622, 3, 0, 0, '[]', '{\"head\":377,\"def\":808,\"hp\":82114,\"dame\":6032,\"body\":378,\"leg\":379}', 1),
(14150, 1024234, 'reall8', 945, 1747972832224, 1747972832293, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":149,\"dame\":121,\"body\":16,\"leg\":17}', 0),
(14151, 1024376, 'buncaloc', 946, 1749370502841, 1749370503347, 3, 0, 0, '[]', '{\"head\":127,\"def\":509.0,\"hp\":916346.6560800001,\"dame\":39367.82304,\"body\":157,\"leg\":158}', 1),
(14152, 1024356, 'luxury', 947, 1748764000380, 1748764000886, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":246820,\"dame\":18268,\"body\":384,\"leg\":385}', 1),
(14153, 1024095, 'kyngkong', 948, 1748442538771, 1748442539274, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":8780,\"dame\":884,\"body\":14,\"leg\":15}', 1),
(14154, 1024242, 'blackpink', 949, 1748395988683, 1748395989190, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":14315,\"dame\":2286,\"body\":14,\"leg\":15}', 1),
(14155, 1024240, 'mylove', 950, 1748399842293, 1748399842798, 3, 0, 0, '[]', '{\"head\":1533,\"def\":6,\"hp\":131906,\"dame\":39001,\"body\":1534,\"leg\":1535}', 1),
(14156, 1024292, 'supperchay', 951, 1748509963764, 1748509964269, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":263223,\"dame\":33827,\"body\":392,\"leg\":393}', 1),
(14157, 1024328, 'gerger', 952, 1748096604112, 1748096604618, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":61672,\"dame\":220,\"body\":345,\"leg\":346}', 1),
(14158, 1024329, 'hghrhr', 953, 1748096520310, 1748096520818, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":61672,\"dame\":223,\"body\":345,\"leg\":346}', 1),
(14159, 1024330, 'eteter', 954, 1748096546308, 1748096546813, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":61672,\"dame\":223,\"body\":345,\"leg\":346}', 1),
(14160, 1024331, 'hrthtr', 955, 1747977822485, 1747977822989, 3, 0, 0, '[]', '{\"head\":29,\"def\":6,\"hp\":61672,\"dame\":220,\"body\":10,\"leg\":11}', 1),
(14161, 1024076, '1bomdie', 956, 1747975238881, 1747975238896, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":30,\"body\":16,\"leg\":17}', 0),
(14162, 1024074, 'top1sayda', 957, 1747975250047, 1747975250053, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14163, 1024194, 'dfhdshh', 958, 1747975297123, 1747975297127, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14164, 1024313, 'nill111', 959, 1747975875634, 1747976400671, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":928422,\"dame\":27772,\"body\":10,\"leg\":11}', 1),
(14165, 1024314, 'nill222', 960, 1747976087022, 1747976400772, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":827198,\"dame\":25319,\"body\":10,\"leg\":11}', 1),
(14166, 1024315, 'nill333', 961, 1747976126514, 1747976400255, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":1493288,\"dame\":26476,\"body\":392,\"leg\":393}', 1),
(14167, 1024317, 'nill444', 962, 1747976159454, 1747976400185, 3, 0, 0, '[]', '{\"head\":383,\"def\":2,\"hp\":555566,\"dame\":25340,\"body\":384,\"leg\":385}', 1),
(14168, 1024318, 'nill555', 963, 1747976185725, 1747976400487, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":827198,\"dame\":25321,\"body\":16,\"leg\":17}', 1),
(14169, 1024326, 'hgerhe', 964, 1747977408385, 1748062800271, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":61672,\"dame\":221,\"body\":345,\"leg\":346}', 1),
(14170, 1024327, 'egege', 965, 1747977466957, 1748062800574, 3, 0, 0, '[]', '{\"head\":344,\"def\":2,\"hp\":61672,\"dame\":211,\"body\":345,\"leg\":346}', 1),
(14171, 1024332, 'gergeer', 966, 1747977885561, 1748062800295, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":70922,\"dame\":194,\"body\":10,\"leg\":11}', 1),
(14172, 1024358, 'geewgr', 967, 1747977908525, 1748062800781, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":76596,\"dame\":276,\"body\":10,\"leg\":11}', 1),
(14173, 1024080, 'shine', 968, 1747978915493, 1747978915498, 3, 0, 0, '[]', '{\"head\":127,\"def\":0,\"hp\":13340,\"dame\":1334,\"body\":57,\"leg\":58}', 0),
(14174, 1024100, 'mylife', 969, 1748953567918, 1748953568425, 3, 0, 0, '[]', '{\"head\":383,\"def\":3.0,\"hp\":45968.4,\"dame\":5272.0,\"body\":384,\"leg\":385}', 1),
(14175, 1024345, 'pagoda', 970, 1749462092070, 1749462092577, 3, 0, 0, '[]', '{\"head\":264,\"def\":3.0,\"hp\":4843.8,\"dame\":21162.792,\"body\":265,\"leg\":266}', 1),
(14176, 1024304, '1bom1hp', 971, 1748779300843, 1748779301348, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":69034,\"dame\":8118,\"body\":16,\"leg\":17}', 1),
(14177, 1024294, 'huynhquang', 972, 1749045785267, 1749045785778, 3, 0, 0, '[]', '{\"head\":28,\"def\":0.0,\"hp\":74000.0,\"dame\":1898.0,\"body\":57,\"leg\":58}', 1),
(14178, 1024101, 'vuatrochoi', 973, 1748322312362, 1748322312880, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":5521722,\"dame\":22551,\"body\":16,\"leg\":17}', 1),
(14179, 0, '1', 974, 1750208729872, 1750208730435, 3, 0, 0, '[]', '{\"head\":1606,\"def\":3.0,\"hp\":1.0000002E8,\"dame\":1.350000135E8,\"body\":1609,\"leg\":1610}', 1),
(14180, 1024300, 'shiken', 975, 1748211380808, 1748211381314, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":68542,\"dame\":11325,\"body\":10,\"leg\":11}', 1),
(14181, 1024094, 'thuongde', 976, 1748001032944, 1748001032947, 3, 0, 0, '[]', '{\"head\":128,\"def\":802,\"hp\":12444,\"dame\":2611,\"body\":10,\"leg\":11}', 0),
(14182, 1024284, 'kakutei', 977, 1748678346917, 1748678347422, 3, 0, 0, '[]', '{\"head\":377,\"def\":3,\"hp\":236066,\"dame\":13555,\"body\":378,\"leg\":379}', 1),
(14183, 1024321, 'fghq2k1', 978, 1748183541740, 1748183542246, 3, 0, 0, '[]', '{\"head\":126,\"def\":330,\"hp\":129986,\"dame\":9377,\"body\":151,\"leg\":152}', 1),
(14184, 1024378, 'facific', 979, 1748323495358, 1748323495862, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":132385,\"dame\":111158,\"body\":392,\"leg\":393}', 1),
(14185, 1024379, 'pcololo', 980, 1749047553219, 1749047553730, 3, 0, 0, '[]', '{\"head\":344,\"def\":2.0,\"hp\":2575.2,\"dame\":1194.032,\"body\":345,\"leg\":346}', 1),
(14186, 1024380, 'gooboy114', 981, 1748067550774, 1748067574298, 3, 0, 0, '[]', '{\"head\":126,\"def\":403,\"hp\":1240458,\"dame\":15399,\"body\":16,\"leg\":17}', 1),
(14187, 1024221, 'haajudzai', 240, 1748573595245, 1748573595750, 2, 11, 5, '[]', '{\"head\":126,\"def\":0,\"hp\":159,\"dame\":32297,\"body\":57,\"leg\":17}', 1),
(14188, 1024381, 'namdzzz', 983, 1748010837144, 1748010837147, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14189, 1024382, 'skyler2025', 984, 1748779461535, 1748779462040, 3, 0, 0, '[]', '{\"head\":383,\"def\":3,\"hp\":1221283,\"dame\":30068,\"body\":384,\"leg\":385}', 1),
(14190, 1024337, 'master', 985, 1748011252385, 1748011252390, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14191, 1024383, 'vclozz', 986, 1748786655542, 1748786656048, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":320464,\"dame\":33694,\"body\":392,\"leg\":393}', 1),
(14192, 1024384, 'vcbuoizz', 987, 1748786752272, 1748786752783, 3, 0, 0, '[]', '{\"head\":391,\"def\":2,\"hp\":386299,\"dame\":28331,\"body\":392,\"leg\":393}', 1),
(14193, 1024385, '1dam1boss', 988, 1748630414044, 1748630414549, 3, 0, 0, '[]', '{\"head\":391,\"def\":407,\"hp\":1041332,\"dame\":144210,\"body\":392,\"leg\":393}', 1),
(14194, 1024386, 'govanhan', 989, 1748762451814, 1748762452320, 3, 0, 0, '[]', '{\"head\":127,\"def\":2,\"hp\":313,\"dame\":390,\"body\":14,\"leg\":15}', 1),
(14195, 1024387, 'gamemod1', 990, 1748022419984, 1748022419987, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14196, 1024388, 'chemms', 991, 1748022469749, 1748022469753, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14197, 1024060, 'chuberong', 992, 1748651182052, 1748651182558, 3, 0, 0, '[]', '{\"head\":736,\"def\":3,\"hp\":751164,\"dame\":17499,\"body\":737,\"leg\":738}', 1),
(14198, 1024389, 'kiuytre', 993, 1748029518626, 1748029518631, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14199, 1024366, 'keketa', 994, 1748031613123, 1748031613142, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":160,\"dame\":29,\"body\":16,\"leg\":17}', 0),
(14200, 1024334, 'bokiwi', 995, 1748407431405, 1748407431910, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":79145,\"dame\":2106,\"body\":59,\"leg\":11}', 1),
(14201, 1024069, 'ptbyhauvan', 996, 1748957712531, 1748957713036, 3, 0, 0, '[]', '{\"head\":383,\"def\":2.0,\"hp\":1118946.58,\"dame\":368010.7673726745,\"body\":384,\"leg\":385}', 1),
(14202, 1024222, 'laze1hp', 997, 1748423699502, 1748423703008, 3, 0, 0, '[]', '{\"head\":29,\"def\":0,\"hp\":4449,\"dame\":15272,\"body\":59,\"leg\":60}', 1),
(14203, 1024309, 'geegeg', 998, 1748047684941, 1748047684946, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":8694,\"dame\":2235,\"body\":59,\"leg\":60}', 0),
(14204, 1024390, 'clone3', 999, 1748411535140, 1748411584686, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 1),
(14205, 1024391, 'clone4', 1000, 1748419021533, 1748419030048, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 1),
(14206, 1024392, 'clone5', 1001, 1748053173578, 1748053173583, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14207, 1024393, 'clone6', 1002, 1748053233354, 1748053233359, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14208, 1024394, 'clone7', 1003, 1748053282821, 1748053282826, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14209, 1024395, 'clone8', 1004, 1748053336820, 1748053336825, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14210, 1024396, 'clone10', 1005, 1748053393567, 1748053393570, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14211, 1024224, 'nappa1', 1006, 1748054411119, 1748054411124, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":138,\"dame\":23,\"body\":16,\"leg\":17}', 0),
(14212, 1024096, 'player', 1007, 1748058093915, 1748058093919, 3, 0, 0, '[]', '{\"head\":347,\"def\":402,\"hp\":26152,\"dame\":1068,\"body\":348,\"leg\":349}', 0),
(14213, 1024144, 'lastw', 1008, 1748058783634, 1748058783638, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14214, 1024397, 'bunga', 1009, 1748058813695, 1748058813700, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14215, 1024398, 'shope', 1010, 1748069848753, 1748069848757, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14216, 1024399, 'asafaf', 1011, 1748076555158, 1748076555161, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14217, 1024400, 'hihhhi', 1012, 1748086838624, 1748086838629, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14218, 1024401, 'danchoi', 1013, 1748096278475, 1748096278479, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14219, 1024402, 'onedrive', 1014, 1748099200583, 1748099200586, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14220, 1024403, 'anh091903', 1015, 1748105792481, 1748105792486, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14221, 1024404, 'onevv', 1016, 1748105977547, 1748105977551, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14222, 1024405, 'niichan', 1017, 1748106017867, 1748106017871, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14223, 1024406, 'santo', 1018, 1748107017418, 1748107017428, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14224, 1024407, 'yonee', 1019, 1748107063770, 1748107063774, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14225, 1024408, 'gokuu', 1020, 1748107126444, 1748107126449, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14226, 1024409, 'sixii', 1021, 1748107167767, 1748107167771, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14227, 1024410, 'nanas', 1022, 1748107538912, 1748107538917, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14228, 1024411, 'sevenn', 1023, 1748107603203, 1748107603207, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14229, 1024412, '99bra', 1024, 1748107639299, 1748107639309, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14230, 1024413, '10vip', 1025, 1748107720456, 1748107720459, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14231, 1024414, 'mmomo', 1026, 1748107807162, 1748107807165, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14232, 1024415, 'mhide', 1027, 1748107859911, 1748107859915, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14233, 1024416, 'mbrone', 1028, 1748107892250, 1748107892253, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14234, 1024417, 'monbuoi', 1029, 1748107948719, 1748107948724, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14235, 1024418, 'mamluoi', 1030, 1748107991219, 1748107991224, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14236, 1024419, 'mausuoi', 1031, 1748108026567, 1748108026570, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14237, 1024420, 'maybuoi', 1032, 1748108080303, 1748108080306, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14238, 1024421, 'mamtuoi', 1033, 1748108111962, 1748108111965, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14239, 1024422, 'gakassaa', 1034, 1748108124963, 1748108124967, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14240, 1024423, 'minchuoi', 1035, 1748108500542, 1748108500546, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14241, 1024424, 'huoimai', 1036, 1748108536889, 1748108536893, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14242, 1024425, 'kalala', 1037, 1748112363338, 1748112363348, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14243, 1024426, 'qafdqfgqw', 1038, 1748113938492, 1748113938498, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14244, 1024427, 'linh2003', 1039, 1748116837513, 1748116837528, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14245, 1024428, 'troine', 1040, 1748118317904, 1748118317908, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14246, 1024429, 'clone9', 1041, 1748121700394, 1748121700399, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14247, 1024343, 'i3bom4st', 1042, 1748124743336, 1748124743340, 3, 0, 0, '[]', '{\"head\":128,\"def\":0,\"hp\":135879,\"dame\":75950,\"body\":59,\"leg\":60}', 0),
(14248, 1024072, 'chaomynhan', 1043, 1748124773276, 1748124773282, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":149,\"dame\":591,\"body\":16,\"leg\":17}', 0),
(14249, 1024073, 'top1xayda', 1044, 1748124807847, 1748124807852, 3, 0, 0, '[]', '{\"head\":126,\"def\":3,\"hp\":149,\"dame\":640,\"body\":16,\"leg\":17}', 0),
(14250, 1024430, 'danchoi1', 1045, 1748125381113, 1748125381116, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14251, 1024431, 'goten', 1046, 1748125386132, 1748125386137, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14252, 1024432, 'regergbr', 1047, 1748125766689, 1748125766693, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14253, 1024433, 'sdfhnrfja', 1048, 1748125920962, 1748125920966, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14254, 1024434, 'hjhjrt', 1049, 1748126117173, 1748126117178, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14255, 1024435, 'fwegg', 1050, 1748126264504, 1748126264508, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14256, 1024436, 'gaerwgre', 1051, 1748126433092, 1748126433100, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14257, 1024437, 'fghhh', 1052, 1748134272600, 1748134272604, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14258, 1024438, 'ducvippro', 1053, 1748135793916, 1748135793924, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14259, 1024439, 'zalooo', 1054, 1748140623631, 1748140623636, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14260, 1024440, 'ichii', 1055, 1748143141512, 1748143141516, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14261, 1024441, 'nitori', 1056, 1748143171976, 1748143171980, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14262, 1024442, 'sanzu', 1057, 1748143201835, 1748143201840, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14263, 1024443, 'yones', 1058, 1748143228250, 1748143228255, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14264, 1024444, 'gohans', 1059, 1748143446129, 1748143446134, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14265, 1024445, 'sexko', 1060, 1748143498930, 1748143498933, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14266, 1024446, 'thatbai', 1061, 1748143512557, 1748143512560, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14267, 1024447, 'thatbat', 1062, 1748143530549, 1748143530553, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14268, 1024448, 'oncloudms', 412, 1749448508890, 1749448509397, 3, 3, 7, '[]', '{\"head\":873,\"def\":7202.0,\"hp\":3486712.1745675006,\"dame\":1617104.1849635646,\"body\":874,\"leg\":875}', 1),
(14269, 1024449, 'cuulong', 1064, 1748143546216, 1748143546219, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14270, 1024450, 'thapvl', 1065, 1748143564356, 1748143564360, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14271, 1024451, 'thapnhat', 1066, 1748143576432, 1748143576439, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14272, 1024452, 'eleven', 1067, 1748143593450, 1748143593456, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14273, 1024453, 'onesan', 1068, 1748143612583, 1748143612587, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14274, 1024454, 'motfor', 1069, 1748143629010, 1748143629015, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14275, 1024455, 'ichigo', 1070, 1748143644569, 1748143644573, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14276, 1024456, 'ichisex', 1071, 1748143658850, 1748143658854, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14277, 1024457, 'mthat', 1072, 1748143678475, 1748143678485, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14278, 1024458, 'mthachi', 1073, 1748143692394, 1748143692397, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14279, 1024459, 'mcuuu', 1074, 1748143708460, 1748143708467, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14280, 1024460, 'concuu', 1075, 1748143728028, 1748143728033, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14281, 1024462, 'bunbohue', 1076, 1748152001251, 1748152001255, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14282, 1024463, 'chaeunwoo', 1077, 1748177522723, 1748177522729, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14283, 1024464, 'maudo', 1078, 1748179530562, 1748179530566, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14284, 1024465, 'maudo1', 1079, 1748182894003, 1748182894008, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14285, 1024466, 'tohka', 1080, 1748187231704, 1748187231708, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14286, 1024467, 'hoshira', 1081, 1748189028628, 1748189028632, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14287, 1024468, 'vlcoq', 1082, 1748189401314, 1748189401318, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14288, 1024469, 'djfkjf', 1083, 1748192443310, 1748192443316, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14289, 1024470, 'klfgg', 1084, 1748192612493, 1748192612497, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14290, 1024471, 'namtips', 190, 1748927252529, 1748927253041, 3, 12, 6, '[]', '{\"head\":128,\"def\":2.0,\"hp\":587136.088,\"dame\":53983.04618606022,\"body\":10,\"leg\":11}', 1),
(14291, 1024472, '0xibimbim', 1086, 1748200964293, 1748200964298, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14292, 1024473, '3ksd3000', 1087, 1748208037122, 1748208037125, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14293, 1024474, 'hmmmm', 1088, 1748208155028, 1748208155033, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14294, 1024475, 'hk1535', 1089, 1748208310721, 1748208310724, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14295, 1024476, 'hk1605', 1090, 1748208773579, 1748208773584, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14296, 1024477, 'hashia', 1091, 1748210001782, 1748210001786, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14297, 1024478, 'kabshe', 1092, 1748210941926, 1748210941930, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14298, 1024479, 'sktt1f', 1093, 1748210969795, 1748210969799, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14299, 1024480, 'sktt2f', 1094, 1748211091578, 1748211091586, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14300, 1024481, 'sktt3v', 1095, 1748211245012, 1748211245015, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14301, 1024482, 'sktt4v', 1096, 1748211331359, 1748211331365, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14302, 1024483, 'shank', 1097, 1748215019715, 1748215019720, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14303, 1024484, 'garps', 1098, 1748215073454, 1748215073457, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14304, 1024485, 'knkzs', 1099, 1748216358679, 1748216358684, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14305, 1024486, 'kata1223', 1100, 1748221560776, 1748221560780, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14306, 1024487, 'quynhsuu', 1101, 1748269424060, 1748269424065, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14307, 1024488, 'dkdkdjdjd', 1102, 1748274725537, 1748274725542, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14308, 1024489, 'pocoloso', 1103, 1748284204787, 1748284204791, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14309, 1024490, 'duduaka', 1104, 1748288551543, 1748288551547, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14310, 1024491, 'huynhhdss', 1105, 1748318907716, 1748318907721, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14311, 1024492, 'ivann', 1106, 1748337295676, 1748337295680, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14312, 1024493, 'ivannn', 1107, 1748337368681, 1748337368686, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14313, 1024494, 'kxkxjz', 1108, 1748350779926, 1748350779929, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14314, 1024275, 'dragonzinz', 1109, 1748352030696, 1748352030703, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":30081,\"dame\":8321,\"body\":10,\"leg\":11}', 0),
(14315, 1024273, 'dragonzin', 1110, 1748352062494, 1748352062500, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":24980,\"dame\":8206,\"body\":10,\"leg\":11}', 0),
(14316, 1024495, 'fhfhfh', 1111, 1748352260396, 1748352260401, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14317, 1024496, 'timberland', 1112, 1748356516023, 1748356516026, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14318, 1024497, '12332', 1113, 1748383359621, 1748383359628, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14319, 1024498, 'xayyyyya', 1114, 1748387658723, 1748387658727, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14320, 1024499, 'xayyya', 1115, 1748389970640, 1748389970644, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14321, 1024500, 'onekiller', 1116, 1748392650557, 1748392650561, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14322, 1024288, 'nm002', 1117, 1748394026797, 1748394026804, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":397,\"dame\":13662,\"body\":10,\"leg\":11}', 0),
(14323, 1024501, 'xd001', 1118, 1748394108632, 1748394108637, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14324, 1024502, 'nameccc', 1119, 1748395353878, 1748395353884, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14325, 1024503, 'namecccc', 1120, 1748396290663, 1748396290795, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14326, 1024504, 'onepiece', 1121, 1748396608562, 1748396608574, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14327, 1024505, 'vualidon', 1122, 1748397110615, 1748397110623, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14328, 1024506, 'oneman', 1123, 1748397569952, 1748397569957, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14329, 1024507, 'oneplus', 1124, 1748398562338, 1748398562342, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14330, 1024346, 'huynek', 1125, 1748406941873, 1748406941883, 3, 0, 0, '[]', '{\"head\":128,\"def\":2,\"hp\":149,\"dame\":11,\"body\":10,\"leg\":11}', 0),
(14331, 1024508, 'vclsow', 1126, 1748411711058, 1748411711061, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14332, 1024509, 'phuhocngu', 1127, 1748411735638, 1748411735643, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14333, 1024510, '0w929e', 1128, 1748411799691, 1748411799696, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14334, 1024511, '9e9e2', 1129, 1748413078238, 1748413078242, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14335, 1024512, '0w92o2', 1130, 1748413118902, 1748413118907, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14336, 1024513, 'calithnic1', 1131, 1748414664213, 1748414664218, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14337, 1024514, 'yeuvo', 1132, 1748423624311, 1748423624317, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14338, 1024515, 'vclolll', 1133, 1748424126696, 1748424126700, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14339, 1024516, 'suythann', 1134, 1748424250318, 1748424250322, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14340, 1024517, 'suppergold', 1135, 1748424271547, 1748424271551, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14341, 1024518, 'mokeygold', 1136, 1748426195730, 1748426195736, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14342, 1024519, 'monkeygod', 1137, 1748426633712, 1748426633717, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14343, 1024520, 'hungzibar', 1138, 1748446184582, 1748446184585, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14344, 1024521, 'tuoilonn', 1139, 1748448646203, 1748448646208, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14345, 1024522, 'quylaokame', 1140, 1748448842511, 1748448842517, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14346, 1024523, 'pktraidat', 1141, 1748483264386, 1748483264390, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14347, 1024524, 'jjccjv', 1142, 1748511789408, 1748511789413, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14348, 1024525, 'kskskx', 1143, 1748511881083, 1748511881088, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14349, 1024526, 'apate2kisd', 1144, 1748512904006, 1748512904010, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14350, 1024527, 'cupomthoi', 1145, 1748518772054, 1748518772058, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14351, 1024528, 'krisama', 1146, 1748519655893, 1748519655898, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14352, 1024529, 'online', 1147, 1748523636550, 1748523636555, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14353, 1024530, 'vantop1vn', 1148, 1748525447839, 1748525447844, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14354, 1024531, 's0ng0ku', 1149, 1748531765337, 1748531765342, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14355, 1024532, '4skungfu', 1150, 1748532731559, 1748532731565, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14356, 1024533, 'pknor', 1151, 1748534023970, 1748534023975, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14357, 1024534, 'upacc7', 1152, 1748534276063, 1748534276067, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14358, 1024535, 'namecpro', 1153, 1748576552662, 1748576552667, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14359, 1024536, 'duonghi', 1154, 1748576716743, 1748576716747, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14360, 1024537, 'chill', 1155, 1748581741086, 1748581741090, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14361, 1024538, 'ssj5gt', 1156, 1748597488557, 1748597488562, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14362, 1024539, 'vantop2vn', 1157, 1748597550713, 1748597550720, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14363, 1024540, 'cloone', 1158, 1748598648162, 1748598648166, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14364, 1024541, 'buncuadong', 1159, 1748605140033, 1748605140037, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14365, 1024542, 'wskendysw', 1160, 1748617440157, 1748617440165, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14366, 1024543, 'kakalas', 1161, 1748620719852, 1748620719857, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14367, 1024544, 'bungiacay', 1162, 1748621324972, 1748621324977, 3, 0, 0, '[]', '{\"head\":9,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14368, 1024545, 'hertupv', 1163, 1748621342041, 1748621342046, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14369, 1024546, 'bunmoc', 1164, 1748621421171, 1748621421177, 3, 0, 0, '[]', '{\"head\":32,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14370, 1024547, 'hertupv2', 1165, 1748622022211, 1748622022215, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14371, 1024548, 'bundocmung', 1166, 1748623928898, 1748623928902, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14372, 1024549, 'bunbanhbeo', 1167, 1748623969008, 1748623969019, 3, 0, 0, '[]', '{\"head\":29,\"def\":2,\"hp\":120,\"dame\":10,\"body\":10,\"leg\":11}', 0),
(14373, 1024550, 'aakendyaa', 1168, 1748669290531, 1748669290536, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14374, 1024551, 'datfish', 1169, 1748671600569, 1748671600574, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14375, 1024552, 'anhdautrox', 1170, 1748675857084, 1748675857089, 3, 0, 0, '[]', '{\"head\":30,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14376, 1024553, 'khuatocdai', 1171, 1748675907127, 1748675907133, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14377, 1024554, 'pakistan', 1172, 1748675998366, 1748675998370, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14378, 1024555, 'gohome', 1173, 1748676046212, 1748676046218, 3, 0, 0, '[]', '{\"head\":64,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14379, 1024556, 'uptnsm', 1174, 1748679809249, 1748679809255, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14380, 1024557, 'bemeo', 1175, 1748681272356, 1748681272359, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14381, 1024558, 'hjiihu', 1176, 1748689268537, 1748689268541, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14382, 1024559, 'hiiihuuhj', 1177, 1748691888897, 1748691888903, 3, 0, 0, '[]', '{\"head\":6,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14383, 1024560, 'huuhio', 1178, 1748695207140, 1748695207144, 3, 0, 0, '[]', '{\"head\":27,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14384, 1024561, 'bombumbum', 1179, 1748711210137, 1748711210141, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14385, 1024562, 'hi3uz', 1180, 1748712973316, 1748712973320, 3, 0, 0, '[]', '{\"head\":31,\"def\":2,\"hp\":230,\"dame\":10,\"body\":14,\"leg\":15}', 0),
(14386, 1024258, 'pemmaychet', 1181, 1748780800205, 1748780800213, 3, 0, 0, '[]', '{\"head\":391,\"def\":402,\"hp\":726122,\"dame\":47967,\"body\":392,\"leg\":393}', 0),
(14387, 1024563, 'emtenthuan', 1182, 1748788087620, 1748788087625, 3, 0, 0, '[]', '{\"head\":28,\"def\":3,\"hp\":120,\"dame\":15,\"body\":16,\"leg\":17}', 0),
(14388, 1024564, 'adidass', 1183, 1748854581696, 1748854581702, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14389, 1024565, 'breadlove', 1184, 1748910244337, 1748910244342, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14390, 1024566, 'gemlon', 1185, 1748931696803, 1748931696807, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14391, 1024567, 'huynhunfh', 1186, 1749018882422, 1749018882426, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14392, 1024568, 'huynhquas', 1187, 1749038765154, 1749038765159, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14393, 1024569, 'braedlove', 1188, 1749176454842, 1749176454858, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14394, 1024570, 'huyhjhf', 1189, 1749208009428, 1749208009432, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14395, 1024571, 'chaien', 1190, 1749231756103, 1749231756125, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14396, 1024572, 'cssss', 1191, 1749253838554, 1749253838558, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14397, 1024573, 'adidasss', 1192, 1749377915494, 1749377915500, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14398, 1024574, 'hertwrldz', 1193, 1749405609856, 1749405609861, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14399, 1024575, 'dsdasds', 1194, 1750050160259, 1750050160298, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14400, 1024576, 'traidat', 1195, 1750052588770, 1750052588809, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14401, 1024577, 'fdfdfdf', 1196, 1750062375887, 1750062375909, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14402, 1024578, 'tttttt', 1197, 1750246502198, 1750246502221, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14403, 1024579, 't', 1198, 1750246777883, 1750246777899, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14404, 1024580, 'rtt', 1199, 1750246791286, 1750246791307, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14405, 10245790, 'dsadsd', 1200, 1750324410205, 1750324410238, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14406, 10245791, 'dasds', 1201, 1750484662633, 1750484662656, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14407, 10245792, 'rtttt', 1202, 1750487630594, 1750487630601, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14408, 10245793, 'okemen', 1203, 1750769591264, 1750769591281, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14409, 10245794, 'dsdasd', 1204, 1750934585818, 1750934585950, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14410, 10245795, 'sdasdsd', 1205, 1751162571899, 1751162571913, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14411, 10245796, 'sdsadasd', 1206, 1751430499982, 1751430500012, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14412, 10245797, 'dsdasdy', 1207, 1751458126790, 1751458126802, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14413, 10245798, 'sadasdsda', 1208, 1751461159501, 1751461159517, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14414, 10245799, 'oknhe', 1209, 1751592093387, 1751592093397, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14415, 10245800, 'toi la toi', 1210, 1751601157077, 1751601157149, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14416, 10245801, 'toanvipp', 1211, 1751681542152, 1751681542176, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14417, 10245802, 'fdsfsdf', 1212, 1751712559990, 1751712560063, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14418, 10245803, 'sdsadas', 1213, 1751852467014, 1751852467038, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14419, 10245804, 'toannn', 1214, 1751901155026, 1751901155074, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14420, 10245805, 'toannnn', 1215, 1751901633709, 1751901633760, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14421, 10245806, 'toeeeee', 1216, 1751905456839, 1751905457127, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14422, 10245807, 'dsdas', 1217, 1752057895191, 1752057895220, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14423, 10245811, 'dsadasd', 1218, 1752058987823, 1752058987903, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14424, 10245812, 'sdasds', 1219, 1752139270609, 1752139270717, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0);
INSERT INTO `super_rank` (`id`, `player_id`, `name`, `rank`, `last_pk_time`, `last_reward_time`, `ticket`, `win`, `lose`, `history`, `info`, `received`) VALUES
(14425, 10245813, 'dsadasdayu', 1220, 1752150394071, 1752150394167, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14426, 10245814, 'dsatyty', 1221, 1752153189895, 1752153189954, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14427, 10245815, 'dsdsdsdsad', 1222, 1752153852819, 1752153852871, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14428, 10245816, 'tuutuy3', 1223, 1752213311930, 1752213311942, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14429, 10245817, 'fdfsdfsdf', 1224, 1752378562365, 1752378562374, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14430, 10245818, 'sdasdsadas', 1225, 1752389737613, 1752389737621, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14431, 10245819, 'viccx', 1226, 1752496721403, 1752496721424, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14432, 10245820, 'kameha', 1227, 1752496782526, 1752496782535, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14433, 10245821, 'kingxd', 1228, 1752497120980, 1752497120989, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14434, 10245822, 'julyaov', 1229, 1752497160626, 1752497160634, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14435, 10245823, 'song0ku', 1230, 1752497168000, 1752497168008, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14436, 10245824, 'chubedan', 1231, 1752497175262, 1752497175272, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14437, 10245825, 'ultranasa', 1232, 1752497212212, 1752497212220, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14438, 10245826, 'aaaaa', 1233, 1752497402885, 1752497402893, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14439, 10245827, 'ngocrong', 1234, 1752497458901, 1752497458908, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14440, 10245828, 'xiaolaoban', 1235, 1752497462590, 1752497462599, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14441, 10245829, 'thirvgame', 1236, 1752497512811, 1752497512827, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14442, 10245830, 'octiiu', 1237, 1752497539326, 1752497539332, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14443, 10245831, 'ngocrong', 1238, 1752498037857, 1752498037882, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14444, 10245832, 'admin', 1239, 1752498041544, 1752498041555, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14445, 10245833, 'viccxayda', 1240, 1752498051030, 1752498051040, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14446, 10245834, 'songoku', 1241, 1752498055195, 1752498055216, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14447, 10245835, 'duckday', 1242, 1752498055688, 1752498055699, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14448, 10245836, 'namec', 1243, 1752498057308, 1752498057318, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14449, 10245837, 'chubedan', 1244, 1752498064790, 1752498064799, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14450, 10245838, 'broly', 1245, 1752498071804, 1752498071812, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14451, 10245839, 'chutich', 1246, 1752498074024, 1752498074031, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14452, 10245840, 'anhba', 1247, 1752498076392, 1752498076400, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14453, 10245841, 'thirvgame', 1248, 1752498077354, 1752498077362, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14454, 10245842, 'vipbro01', 1249, 1752498081001, 1752498081019, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14455, 10245843, 'vipbro02', 1250, 1752498086360, 1752498086371, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14456, 10245844, 'admin001', 1251, 1752498086810, 1752498086823, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14457, 10245845, 'kinchana', 1252, 1752498087481, 1752498087488, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14458, 10245846, 'kemma', 1253, 1752498089509, 1752498089518, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14459, 10245847, 'lienhoan', 1254, 1752498090562, 1752498090569, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14460, 10245848, 'kameha', 1255, 1752498100963, 1752498100974, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14461, 10245849, 'xiaolaoban', 1256, 1752498103159, 1752498103168, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14462, 10245850, 's1danger', 1257, 1752498103318, 1752498103328, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14463, 10245851, 'namec01', 1258, 1752498104413, 1752498104420, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14464, 10245852, 'nappa', 1259, 1752498108136, 1752498108143, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14465, 10245853, 'tulip', 1260, 1752498125958, 1752498125977, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14466, 10245854, 'lolihentai', 1261, 1752498141660, 1752498141667, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14467, 10245855, 'kingxd', 1262, 1752498150920, 1752498150928, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14468, 10245856, 'kenma', 1263, 1752498154391, 1752498154400, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14469, 10245857, 'balong73', 1264, 1752498156393, 1752498156400, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14470, 10245858, 'muathuhn', 1265, 1752498157346, 1752498157353, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14471, 10245859, 'blgokurs', 1266, 1752498169683, 1752498169694, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14472, 10245860, 'xdlovuong', 1267, 1752498175882, 1752498175890, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14473, 10245861, 'damzibzanh', 1268, 1752498178824, 1752498178832, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14474, 10245862, 'caubedan', 1269, 1752498180886, 1752498180897, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14475, 10245863, 'songokuz', 1270, 1752498193505, 1752498193513, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14476, 10245864, 'chichi', 1271, 1752498206544, 1752498206551, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14477, 10245865, 'kam3joko', 1272, 1752498216935, 1752498216942, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14478, 10245866, 'lh1st', 1273, 1752498219301, 1752498219307, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14479, 10245867, 'br0ly', 1274, 1752498296309, 1752498296316, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14480, 10245868, 'kiniemnro', 1275, 1752498307170, 1752498307181, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14481, 10245869, 'rultoichoi', 1276, 1752498315118, 1752498315129, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14482, 10245870, 'sieuvip', 1277, 1752498318032, 1752498318039, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14483, 10245871, 'tienmt', 1278, 1752498343965, 1752498343972, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14484, 10245872, 'gogeta1', 1279, 1752498396602, 1752498396618, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14485, 10245873, 'toanadmin', 1280, 1752498399681, 1752498399689, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14486, 10245874, 'xiaoxian', 1281, 1752498450720, 1752498450730, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14487, 10245875, 'tuấn mạnh', 1282, 1752498493592, 1752498493602, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14488, 10245876, 'jonhwick', 1283, 1752498496402, 1752498496412, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14489, 10245877, 'pem1hit', 1284, 1752498508897, 1752498508904, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14490, 10245878, 'julyaov', 1285, 1752498527382, 1752498527392, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14491, 10245879, 'kichsat', 1286, 1752498643359, 1752498643365, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14492, 10245880, 'thanhtruc', 1287, 1752498673963, 1752498673972, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14493, 10245881, 'pjdnd', 1288, 1752498697653, 1752498697660, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14494, 10245882, 'zenoo', 1289, 1752498739030, 1752498739037, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14495, 10245883, 'ldndh', 1290, 1752498763585, 1752498763595, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14496, 10245884, 'nroultra', 1291, 1752498997549, 1752498997557, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14497, 10245885, 'hlhuy', 1292, 1752499013035, 1752499013042, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14498, 10245886, 'oneshot', 1293, 1752499075732, 1752499075744, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14499, 10245887, 'ahihi1', 1294, 1752499075997, 1752499076021, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14500, 10245888, 'bombi', 1295, 1752499295286, 1752499295294, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14501, 10245889, 'luxury', 1296, 1752499375928, 1752499375938, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14502, 10245890, 'sogonku', 1297, 1752499630078, 1752499630094, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14503, 10245891, 'luxury1', 1298, 1752499740762, 1752499740770, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14504, 10245892, 'buomxinh', 1299, 1752499777914, 1752499777923, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14505, 10245893, 'toplaze', 1300, 1752499818351, 1752499818364, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14506, 10245894, 'trumnamec', 1301, 1752499925953, 1752499925961, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14507, 10245895, 'mmmmmmmm', 1302, 1752499994272, 1752499994279, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14508, 10245896, 'luxury2', 1303, 1752500066351, 1752500066361, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14509, 10245897, 'rambo', 1304, 1752500081732, 1752500081738, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14510, 10245898, 'agkah', 1305, 1752500115443, 1752500115451, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14511, 10245899, 'sieunhan', 1306, 1752500222091, 1752500222100, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14512, 10245900, 'okvip', 1307, 1752500223926, 1752500223932, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14513, 10245901, 'lachy', 1308, 1752500302673, 1752500302682, 3, 0, 0, '[]', '{\"head\":29,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14514, 10245902, 'lamoon', 1309, 1752500346367, 1752500346374, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14515, 10245903, 'doibuon', 1310, 1752500360913, 1752500360951, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14516, 10245904, 'gogeta', 1311, 1752500407593, 1752500407612, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14517, 10245905, 'picolo005', 1312, 1752500469557, 1752500469563, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14518, 10245906, 'trumakdm', 1313, 1752500606683, 1752500606690, 3, 0, 0, '[]', '{\"head\":64,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14519, 10245907, 'gvjhn', 1314, 1752500620698, 1752500620704, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14520, 10245908, 'vanha', 1315, 1752500634678, 1752500634685, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14521, 10245909, 'rambocon', 1316, 1752500736481, 1752500736490, 3, 0, 0, '[]', '{\"head\":6,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14522, 10245910, 'chienbuwin', 1317, 1752500819317, 1752500819347, 3, 0, 0, '[]', '{\"head\":32,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14523, 10245911, 'hgsah', 1318, 1752500927701, 1752500927718, 3, 0, 0, '[]', '{\"head\":31,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14524, 10245912, 'auysgh', 1319, 1752501079971, 1752501079995, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14525, 10245913, 'admin', 1320, 1752567864707, 1752567864735, 3, 0, 0, '[]', '{\"head\":30,\"def\":2.0,\"hp\":230.0,\"dame\":10.0,\"body\":14,\"leg\":15}', 0),
(14526, 10245914, 'namecc', 1321, 1752726853288, 1752726853325, 3, 0, 0, '[]', '{\"head\":9,\"def\":2.0,\"hp\":120.0,\"dame\":10.0,\"body\":10,\"leg\":11}', 0),
(14527, 10245915, 'xayda', 1322, 1752898648704, 1752898648746, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14528, 10245916, 'goten', 1323, 1756879635194, 1756879635235, 3, 0, 0, '[]', '{\"head\":28,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0),
(14529, 10245917, 'datbeo', 1324, 1758043172330, 1758043172376, 3, 0, 0, '[]', '{\"head\":27,\"def\":3.0,\"hp\":120.0,\"dame\":15.0,\"body\":16,\"leg\":17}', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sv1_acc`
--

CREATE TABLE `sv1_acc` (
  `id` int(11) NOT NULL,
  `account` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `sotien` decimal(10,2) DEFAULT 0.00,
  `danap` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tamkjllgift`
--

CREATE TABLE `tamkjllgift` (
  `id` int(11) NOT NULL,
  `Code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `Luot` int(11) NOT NULL,
  `Item` text NOT NULL,
  `yeucau_sm` bigint(20) DEFAULT 0,
  `yeucau_vip` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Đang đổ dữ liệu cho bảng `tamkjllgift`
--

INSERT INTO `tamkjllgift` (`id`, `Code`, `Luot`, `Item`, `yeucau_sm`, `yeucau_vip`) VALUES
(1, 'tanthu1', 919, '[{\"item\":381,\"soluong\":20,\"Option\":[{\"option\":30,\"chiso\":0}]},{\"item\":382,\"soluong\":30,\"Option\":[{\"option\":30,\"chiso\":0}]},{\"item\":383,\"soluong\":30,\"Option\":[{\"option\":30,\"chiso\":0}]}]', 0, 0),
(2, 'tanthu2', 918, '[{\"item\":1213,\"soluong\":1,\"Option\":[{\"option\":50,\"chiso\":24},{\"option\":77,\"chiso\":24},{\"option\":103,\"chiso\":24},{\"option\":95,\"chiso\":20},{\"option\":96,\"chiso\":20},{\"option\":101,\"chiso\":20},{\"option\":93,\"chiso\":4}]}]', 0, 0),
(3, 'tanthu3', 918, '[{\"item\":194,\"soluong\":1,\"Option\":[{\"option\":30,\"chiso\":0}]}]', 0, 0),
(4, 'tanthu4', 924, '[{\"item\":77,\"soluong\":400000000,\"Option\":[{\"option\":30,\"chiso\":0}]}]', 0, 0),
(5, 'tanthu5', 924, '[{\"item\":441,\"soluong\":20,\"Option\":[{\"option\":95,\"chiso\":5}]},{\"item\":442,\"soluong\":20,\"Option\":[{\"option\":96,\"chiso\":5}]},{\"item\":443,\"soluong\":20,\"Option\":[{\"option\":97,\"chiso\":5}]},{\"item\":444,\"soluong\":20,\"Option\":[{\"option\":98,\"chiso\":5}]},{\"item\":445,\"soluong\":20,\"Option\":[{\"option\":99,\"chiso\":5}]},{\"item\":446,\"soluong\":20,\"Option\":[{\"option\":100,\"chiso\":5}]},{\"item\":447,\"soluong\":20,\"Option\":[{\"option\":101,\"chiso\":5}]}]', 0, 0),
(6, 'tanthu6', 926, '[{\"item\":220,\"soluong\":100,\"Option\":[{\"option\":30,\"chiso\":100}]},{\"item\":221,\"soluong\":100,\"Option\":[{\"option\":30,\"chiso\":0}]},{\"item\":222,\"soluong\":100,\"Option\":[{\"option\":30,\"chiso\":0}]},{\"item\":223,\"soluong\":100,\"Option\":[{\"option\":30,\"chiso\":0}]},{\"item\":224,\"soluong\":50,\"Option\":[{\"option\":30,\"chiso\":0}]}]', 0, 0),
(8, 'tanthu7', 999, '[{\"item\":457,\"soluong\":30,\"Option\":[{\"option\":30,\"chiso\":0}]}]', 80000000000, 0),
(83, 'tanthu8', 951, '[{\"item\":1499,\"soluong\":1,\"Option\":[{\"option\":50,\"chiso\":10},{\"option\":77,\"chiso\":10},{\"option\":103,\"chiso\":10},{\"option\":95,\"chiso\":10},{\"option\":96,\"chiso\":10},{\"option\":93,\"chiso\":3},{\"option\":101,\"chiso\":10}]}]', 0, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tamkjll_history_code`
--

CREATE TABLE `tamkjll_history_code` (
  `id` int(11) UNSIGNED NOT NULL,
  `player_id` int(11) DEFAULT 0,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lịch sử nhận gift code';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `task_main_template`
--

CREATE TABLE `task_main_template` (
  `id` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `detail` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `task_main_template`
--

INSERT INTO `task_main_template` (`id`, `NAME`, `detail`) VALUES
(0, 'Nhiệm vụ đầu tiên', 'Chi tiết nhiệm vụ'),
(1, 'Nhiệm vụ tập luyện', 'Mộc nhân được đặt nhiều tại %1, ngay trước nhà %2\nHãy đánh ngã 5 mộc nhân, \nsau đó quay về nhà báo cáo với ông %2\nĐể đánh, hãy chạm nhanh 2 lần vào đối tượng\nThưởng 1000 sức mạnh\nThưởng 1000 tiềm năng\nThưởng 200tr vàng'),
(2, 'Nhiệm vụ tìm thức ăn', 'Tìm đến %3, tiêu diệt bọn quái %4 và nhặt về 10 đùi gà\nThưởng 1500 sức mạnh\nThưởng 1500 tiềm năng\nThưởng 300tr vàng\nHọc được kỹ năng bay'),
(3, 'Nhiệm vụ sao băng', 'Đi khám phá xem vật thể lạ vừa rơi xuống hành tinh\nThưởng 2000 sức mạnh\nThưởng 2000 tiềm năng\nThưởng 400tr vàng'),
(4, 'Nhiệm vụ thử thách', 'Khủng long mẹ sống tại Trái Đất\nLợn lòi mẹ sống tại Namếc\nQuỷ đất mẹ sống tại Xayda\nDùng tàu vũ trụ để di chuyển sang hành\nkhác\n-Thưởng 4.000 sức mạnh\n-Thưởng 4.000 tiềm năng'),
(5, 'Nhiệm vụ thử thách', 'Lợn lòi mẹ sống tại Namếc\nKhủng long mẹ sống tại Trái Đất\nQuỷ đất mẹ sống tại Xayda\nDùng tàu vũ trụ để di chuyển sang hành\nkhác\n-Thưởng 4.000 sức mạnh\n-Thưởng 4.000 tiềm năng'),
(6, 'Nhiệm vụ thử thách', 'Quỷ đất mẹ sống tại Xayda\nKhủng long mẹ sống tại Trái Đất\nLợn lòi mẹ sống tại Namếc\nDùng tàu vũ trụ để di chuyển sang hành\nkhác\n-Thưởng 4.000 sức mạnh\n-Thưởng 4.000 tiềm năng'),
(7, 'Nhiệm vụ giải cứu', 'Đến khu vực %13,\nHạ 20 con %9\n- Thưởng 8.000 sức mạnh\n- Thưởng 8.000 tiềm năng'),
(8, 'Nhiệm vụ tìm ngọc', 'Ngọc rồng 7 sao đang bị bọn\n%14 cướp đi.\nĐánh bại chúng để tìm lại.\n- Thưởng 15.000 sức mạnh\n- Thưởng 15.000 tiềm năng'),
(9, 'Nhiệm vụ bái sư', 'Tìm đường tới %11, trò chuyện với %10 và xin làm đệ tử'),
(10, 'Nhiệm vụ thử sức', 'Tiêu diệt %12 thể hiện sức mạnh cho %10 thấy'),
(11, 'Nhiệm vụ làm quen các Npc', 'Hãy gặp và làm quen với các Npc để biết chức năng của họ'),
(12, 'Nhiệm vụ xin phép', 'Quay về nhà xin %2 cho phép lên đường trở thành chiến binh'),
(13, 'Nhiệm vụ nhận quà', 'Gặp Npc Quy Lão nhận ngay đuôi khỉ đi úp cho phê'),
(14, 'Nhiệm vụ bang hội đầu tiên', 'Tiến trình sẽ nhanh gấp đôi nếu cùng phối hợp với 1 người đồng đội lên đường làm nhiệm vụ\r\nGợi ý:\r\nHeo rừng xuất hiện tại rừng Bamboo\r\nHeo da xanh xuất \r\nhiện tại núi hoa vàng\r\nHeo xayda xuất hiện tại rừng cọ\r\nHãy tới trạm tàu vũ trụ để có thể di chuyển qua các map'),
(15, 'Nhiệm vụ bang hội thứ 2', 'Tiến trình sẽ nhanh gấp đôi nếu cùng phối hợp với 1 người đồng đội lên đường làm nhiệm vụ'),
(16, 'Nhiệm vụ tiêu diệt quái vật', 'Tới các hành tinh tiêu diệt quái vật, giải cứu thường dân'),
(17, 'Nhiệm vụ giúp đỡ Cui', 'Tìm đường tới thành phố Vegeta, gặp và nói chuyện với Cui'),
(18, 'Nhiệm vụ bất khả thi', 'Đạt 50 triệu sức mạnh\nTiêu diệt bọn tay sai của Fide tại Xayda\n- Thưởng 50.000.000 sức mạnh\n- Thưởng 50.000.000 tiềm năng'),
(19, 'Nhiệm vụ tìm diệt đệ tử', 'Tiêu diệt bọn đệ tử Kuku, Mập Đầu Đinh,\nRambo của Fide đại ca tại Xayda\nCui có thể biết vị trí của chúng, nếu tìm\nkhông thấy hãy đến gặp Cui tại thành\nphố Vegeta\n- Thưởng 20.000.000 sức mạnh\n- Thưởng 20.000.000 tiềm năng'),
(20, 'Nhiệm vụ Tiểu đội sát thủ', 'Tiêu diệt Tiểu Đội Sát Thủ do Fide đại\nca gọi đến tại Xayda\n- Thưởng 20.000.000 sức mạnh\n- Thưởng 20.000.000 tiềm năng'),
(21, 'Nhiệm vụ chạm trán Fide đại ca', 'Luyện tập đạt 2 tỷ sức mạnh\nLên đường tìm diệt Fide đại ca'),
(22, 'Chú bé đến từ tương lai', 'Đến trái đất, rừng bamboo, rừng dương\nxỉ, nam Kamê tìm người lạ\nĐến đảo rùa đưa thuốc cho Quy Lão\nTheo Ca Lích đến tương lai\nGiúp họ diệt bọn bọ hung con\n- Thưởng 1.000.000 sức mạnh\n- Thưởng 1.000.000 tiềm năng'),
(23, 'Chạm chán Robot sát thủ lần 1', 'Hãy đến thành phố phía nam\nđảo balê hoặc cao nguyên\nCùng 2 đồng bang diệt 1300 Xên con cấp 3\nBáo với Bunma tương lai\n- Thưởng 1.000.000 sức mạnh\n- Thưởng 1.000.000 tiềm năng'),
(24, 'Chạm trán Robot sát thủ lần 2', 'Trở về quá khứ, đến sân sau siêu thị\nTiêu diệt bọn Rôbốt sát thủ\nBáo với Bunma tương lai\n- Thưởng 1.000.000 sức mạnh\n- Thưởng 1.000.000 tiềm năng'),
(25, 'Chạm trán Robot sát thủ lần 3', 'Đến thành phố, ngọn núi, thung lũng phía Bắc\nTiêu diệt bọn Rôbốt sát thủ\nCùng 2 đồng bang diệt 1500 Xên con cấp 5\nBáo với Bunma tương lai\n- Thưởng 1.000.000 sức mạnh\n- Thưởng 1.000.000 tiềm năng'),
(26, 'Chạm trán Xên bọ hung', 'Đến thị trấn Ginder\nTiêu diệt Xên Bọ Hung cấp 1\nTiêu diệt Xên Bọ Hung cấp 2\nTiêu diệt Xên Bọ Hung hoàn thiện\nCùng 2 đồng bang diệt 1500 Xên con cấp 8\nBáo với Bunma tương lai\n- Thưởng 1.000.000 sức mạnh\n- Thưởng 1.000.000 tiềm năng'),
(27, 'Cuộc dạo chơi của xên', 'Cẩn thận !!!\nNhững vị khách không mời mà tới\nthường tỏ ra nguy hiểm'),
(28, 'Cuộc đối đầu không cân sức', 'Vào lúc 12h trưa các ngày, bạn đến gặp NPC Ô sin tại map Đại hội võ thuật.'),
(29, 'Hành tinh băng giá', 'Đến Hang Băng\nTiêu diệt cooler'),
(30, 'Hành tinh ngục tù', 'Hành tinh ngục tù'),
(31, 'Truyền Thuyết Về Trùm Server', 'Ai mới là trùm server?'),
(32, 'Truyền thuyết về Siêu Xayda Huyền Thoại', 'Ai mới thật sự là siêu xayda huyền thoại mà Fide từng nhắc tới ?\nThưởng 10 Tr sức mạnh\nThưởng 10 Tr tiềm năng'),
(33, 'Ta sẽ trở thành TOP nhiệm vụ Server NRO Xưa', 'Cần cù bù thông minh'),
(34, 'Làm nhiệm vụ, làm nhiệm vụ nữa, làm nhiệm vụ mãi', 'Đừng lo lắng rồi mọi chuyện cũng sẽ như đb mà thôi');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `type` enum('deposit','withdraw','purchase') NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `transaction_logs`
--

CREATE TABLE `transaction_logs` (
  `id` int(11) NOT NULL,
  `transaction_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `content` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `trans_log`
--

CREATE TABLE `trans_log` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `amount` bigint(20) NOT NULL,
  `seri` text NOT NULL,
  `pin` text NOT NULL,
  `type` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `trans_id` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `giatri` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `trans_mbank`
--

CREATE TABLE `trans_mbank` (
  `id` int(11) NOT NULL,
  `tranId` varchar(1000) NOT NULL,
  `debitAmount` int(11) NOT NULL,
  `username` varchar(1000) NOT NULL,
  `postingDate` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `balance` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `mb_transaction_summary`
--
DROP TABLE IF EXISTS `mb_transaction_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mb_transaction_summary`  AS  select `mb_transactions`.`username` AS `username`,count(0) AS `total_transactions`,sum(case when `mb_transactions`.`status` = 'completed' then 1 else 0 end) AS `successful_transactions`,sum(case when `mb_transactions`.`status` = 'failed' then 1 else 0 end) AS `failed_transactions`,sum(case when `mb_transactions`.`status` = 'pending' then 1 else 0 end) AS `pending_transactions`,sum(case when `mb_transactions`.`status` = 'completed' then `mb_transactions`.`amount` else 0 end) AS `total_amount`,max(`mb_transactions`.`created_at`) AS `last_transaction` from `mb_transactions` group by `mb_transactions`.`username` ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `username` (`username`) USING BTREE;

--
-- Chỉ mục cho bảng `account_mbbank`
--
ALTER TABLE `account_mbbank`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `adminpanel`
--
ALTER TABLE `adminpanel`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `atm_check`
--
ALTER TABLE `atm_check`
  ADD PRIMARY KEY (`tranid`);

--
-- Chỉ mục cho bảng `atm_lichsu`
--
ALTER TABLE `atm_lichsu`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `clan`
--
ALTER TABLE `clan`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `diem_danh_history`
--
ALTER TABLE `diem_danh_history`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_player_day_date` (`player_id`,`day`,`date`),
  ADD KEY `idx_player_id` (`player_id`),
  ADD KEY `idx_date` (`date`),
  ADD KEY `idx_diem_danh_history_player_date` (`player_id`,`date`);

--
-- Chỉ mục cho bảng `diem_danh_rewards`
--
ALTER TABLE `diem_danh_rewards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_day_item_index` (`day`,`item_index`),
  ADD KEY `idx_day` (`day`),
  ADD KEY `idx_diem_danh_rewards_day_index` (`day`,`item_index`);

--
-- Chỉ mục cho bảng `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `forum_comments`
--
ALTER TABLE `forum_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `created_at` (`created_at`);

--
-- Chỉ mục cho bảng `forum_posts`
--
ALTER TABLE `forum_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `created_at` (`created_at`);

--
-- Chỉ mục cho bảng `game_packages`
--
ALTER TABLE `game_packages`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `giftcode`
--
ALTER TABLE `giftcode`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `giftcode_diemdanh`
--
ALTER TABLE `giftcode_diemdanh`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`day`);

--
-- Chỉ mục cho bảng `giftcode_diemdanh_reward`
--
ALTER TABLE `giftcode_diemdanh_reward`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `history_transaction`
--
ALTER TABLE `history_transaction`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `ket_qua_veso`
--
ALTER TABLE `ket_qua_veso`
  ADD PRIMARY KEY (`ngay`);

--
-- Chỉ mục cho bảng `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_username_time` (`username`,`attempt_time`),
  ADD KEY `idx_ip_time` (`ip_address`,`attempt_time`);

--
-- Chỉ mục cho bảng `mbbank_log`
--
ALTER TABLE `mbbank_log`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `mbbank_transactions`
--
ALTER TABLE `mbbank_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD KEY `idx_mbbank_user` (`username`),
  ADD KEY `idx_mbbank_status` (`status`),
  ADD KEY `idx_mbbank_created` (`created_at`);

--
-- Chỉ mục cho bảng `mb_api_settings`
--
ALTER TABLE `mb_api_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Chỉ mục cho bảng `mb_transactions`
--
ALTER TABLE `mb_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD KEY `username` (`username`),
  ADD KEY `status` (`status`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `idx_mb_transactions_status_created` (`status`,`created_at`),
  ADD KEY `idx_mb_transactions_username_status` (`username`,`status`);

--
-- Chỉ mục cho bảng `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `momo_trans`
--
ALTER TABLE `momo_trans`
  ADD PRIMARY KEY (`ID`) USING BTREE;

--
-- Chỉ mục cho bảng `napthe`
--
ALTER TABLE `napthe`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `naptien`
--
ALTER TABLE `naptien`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `account_id` (`account_id`) USING BTREE;

--
-- Chỉ mục cho bảng `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `recharge`
--
ALTER TABLE `recharge`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `sell_item`
--
ALTER TABLE `sell_item`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `shop_ky_gui`
--
ALTER TABLE `shop_ky_gui`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `super_rank`
--
ALTER TABLE `super_rank`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `sv1_acc`
--
ALTER TABLE `sv1_acc`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account` (`account`);

--
-- Chỉ mục cho bảng `tamkjllgift`
--
ALTER TABLE `tamkjllgift`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tamkjll_history_code`
--
ALTER TABLE `tamkjll_history_code`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `task_main_template`
--
ALTER TABLE `task_main_template`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `transaction_logs`
--
ALTER TABLE `transaction_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `username` (`username`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `idx_transaction_logs_transaction_action` (`transaction_id`,`action`);

--
-- Chỉ mục cho bảng `trans_log`
--
ALTER TABLE `trans_log`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `trans_mbank`
--
ALTER TABLE `trans_mbank`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `account`
--
ALTER TABLE `account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2413118;

--
-- AUTO_INCREMENT cho bảng `account_mbbank`
--
ALTER TABLE `account_mbbank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `adminpanel`
--
ALTER TABLE `adminpanel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `atm_lichsu`
--
ALTER TABLE `atm_lichsu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT cho bảng `diem_danh_history`
--
ALTER TABLE `diem_danh_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `diem_danh_rewards`
--
ALTER TABLE `diem_danh_rewards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT cho bảng `event`
--
ALTER TABLE `event`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `forum_comments`
--
ALTER TABLE `forum_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `forum_posts`
--
ALTER TABLE `forum_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `game_packages`
--
ALTER TABLE `game_packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `giftcode`
--
ALTER TABLE `giftcode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT cho bảng `giftcode_diemdanh`
--
ALTER TABLE `giftcode_diemdanh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT cho bảng `giftcode_diemdanh_reward`
--
ALTER TABLE `giftcode_diemdanh_reward`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `history_transaction`
--
ALTER TABLE `history_transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46497;

--
-- AUTO_INCREMENT cho bảng `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `mbbank_log`
--
ALTER TABLE `mbbank_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `mbbank_transactions`
--
ALTER TABLE `mbbank_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `mb_api_settings`
--
ALTER TABLE `mb_api_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `mb_transactions`
--
ALTER TABLE `mb_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT cho bảng `napthe`
--
ALTER TABLE `napthe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT cho bảng `naptien`
--
ALTER TABLE `naptien`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT cho bảng `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=285;

--
-- AUTO_INCREMENT cho bảng `player`
--
ALTER TABLE `player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10245918;

--
-- AUTO_INCREMENT cho bảng `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `recharge`
--
ALTER TABLE `recharge`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `sell_item`
--
ALTER TABLE `sell_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `setting`
--
ALTER TABLE `setting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `super_rank`
--
ALTER TABLE `super_rank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14530;

--
-- AUTO_INCREMENT cho bảng `sv1_acc`
--
ALTER TABLE `sv1_acc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tamkjllgift`
--
ALTER TABLE `tamkjllgift`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT cho bảng `tamkjll_history_code`
--
ALTER TABLE `tamkjll_history_code`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180515;

--
-- AUTO_INCREMENT cho bảng `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `transaction_logs`
--
ALTER TABLE `transaction_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `trans_log`
--
ALTER TABLE `trans_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT cho bảng `trans_mbank`
--
ALTER TABLE `trans_mbank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `player`
--
ALTER TABLE `player`
  ADD CONSTRAINT `player_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`);

--
-- Các ràng buộc cho bảng `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
