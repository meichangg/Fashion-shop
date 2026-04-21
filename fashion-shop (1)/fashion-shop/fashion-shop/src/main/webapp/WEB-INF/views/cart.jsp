<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Fashion Shop</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Google Fonts sang trọng -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f7f7f7;
        }

        /* Navbar */
        .custom-navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(8px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .custom-navbar .nav-link {
            color: #333 !important;
            font-weight: 500;
            transition: .3s;
        }
        .custom-navbar .nav-link:hover,
        .custom-navbar .nav-link.active {
            color: #a67c52 !important;
        }
        .brand-logo {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: #333 !important;
        }

        /* Giỏ hàng */
        .cart-img {
            width: 85px;
            height: 85px;
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid #ddd;
            background: #fafafa;
        }

        .table {
            border-radius: 12px !important;
            overflow: hidden;
        }

        .table td {
            vertical-align: middle;
        }

        .remove-btn {
            background: none;
            border: none;
            font-size: 1.3rem;
            color: #cc0000;
            cursor: pointer;
            padding: 0;
            margin-top: 4px;
        }
        .remove-btn:hover {
            color: #a30000;
        }

        .summary-box {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
        }

        .summary-box h5 {
            font-family: 'Playfair Display', serif;
            font-weight: 600;
        }

        .btn-danger {
            background: #a67c52;
            border: none;
        }
        .btn-danger:hover {
            background: #8b6240;
        }

        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button {
            opacity: 1;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg custom-navbar navbar-light py-3">
    <div class="container-fluid">
        <a class="navbar-brand brand-logo" href="${pageContext.request.contextPath}/home">
            FashionShop
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <a class="btn btn-outline-dark ms-auto d-lg-none me-2"
           href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>

        <div class="collapse navbar-collapse" id="navbarNav">

            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                
            </ul>

            <form class="d-flex me-3" method="get" action="${pageContext.request.contextPath}/home">
                <input class="form-control me-2" type="search" placeholder="Tìm sản phẩm..."
                       name="q" value="${keyword}">
                <button class="btn btn-outline-dark" type="submit">Tìm</button>
            </form>
        </div>
    </div>
</nav>

<div class="container py-4">

    <h3 class="mb-4 fw-bold" style="font-family: 'Playfair Display', serif;">Giỏ hàng</h3>

    <!-- Giỏ hàng trống -->
    <c:if test="${empty sessionScope.cart}">
        <div class="text-center py-5">
            <h4 class="text-secondary mb-2">Giỏ hàng của bạn đang trống</h4>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-danger px-4">
                Quay lại cửa hàng
            </a>
        </div>
    </c:if>

    <!-- Giỏ hàng có sản phẩm -->
    <c:if test="${not empty sessionScope.cart}">
        <div class="row g-4">

            <!-- Bảng sản phẩm -->
            <div class="col-lg-8">
                <table class="table bg-white shadow-sm">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 40%">Sản phẩm</th>
                        <th class="text-center">Đơn giá</th>
                        <th class="text-center">Số lượng</th>
                        <th class="text-end">Thành tiền</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach items="${sessionScope.cart}" var="entry">
                        <c:set var="item" value="${entry.value}" />

                        <tr>

                            <!-- Product info -->
                            <td>
                                <div class="d-flex align-items-center">

                                    <img src="${item.product.thumbnailUrl}" class="cart-img me-3">

                                    <div>
                                        <div class="fw-bold">${item.product.productName}</div>

                                        <!-- Remove -->
                                        <form method="post" action="${pageContext.request.contextPath}/cart">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="pid" value="${item.product.productID}">
                                            <button type="submit" class="remove-btn">×</button>
                                        </form>
                                    </div>

                                </div>
                            </td>

                            <!-- Đơn giá -->
                            <td class="text-center fw-semibold">
                                ${item.product.finalPrice} đ
                            </td>

                            <!-- Số lượng -->
                            <td class="text-center">

                                <div class="d-flex justify-content-center align-items-center gap-1">

                                                                     
                                    <!-- Input -->
                                    <form method="post" action="${pageContext.request.contextPath}/cart">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="pid" value="${item.product.productID}">
                                        <input type="number" name="qty"
                                               value="${item.quantity}"
                                               min="1"
                                               class="form-control text-center"
                                               style="width:65px;">
                                    </form>

                                 
                                    

                                </div>

                            </td>

                            <!-- Thành tiền -->
                            <td class="text-end fw-bold text-danger">
                                ${item.lineTotal} đ
                            </td>

                        </tr>

                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Tổng bill -->
            <div class="col-lg-4">
                <div class="summary-box shadow-sm">

                    <h5 class="mb-3">Tổng kết đơn hàng</h5>

                    <div class="d-flex justify-content-between mb-2">
                        <span>Tổng tiền hàng:</span>
                        <span class="fw-bold">${cartTotal} đ</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-3">
                        <span class="fw-bold">Tổng thanh toán:</span>
                        <span class="fw-bold text-danger">${cartTotal} đ</span>
                    </div>

                    <a href="${pageContext.request.contextPath}/checkout"
                       class="btn btn-danger w-100 py-2">Đặt hàng</a>

                </div>
            </div>

        </div>
    </c:if>

</div>
<footer class="mt-5 py-5" style="background: #c19b6d        ;">
    <div class="container">

        <div class="row">

            <!-- Cột trái -->
            <div class="col-md-4 mb-4">
                <h5 class="fw-bold text-white" style="font-family: 'Playfair Display', serif;">Liên hệ</h5>
                <p class="mb-1 text-white-50">Địa chỉ: Hà Nội</p>
                <p class="mb-1 text-white-50">Số điện thoại: 999999999</p>
            </div>

            <!-- Cột giữa -->
            <div class="col-md-4 mb-4">
                <h5 class="fw-bold text-white" style="font-family: 'Playfair Display', serif;">Thông tin</h5>
                <ul class="list-unstyled">
                    <li class="mb-1">
                        <a href="#" class="text-white-50 text-decoration-none">Danh mục sản phẩm</a>
                    </li>
                    <li class="mb-1">
                        <a href="#" class="text-white-50 text-decoration-none">Giới thiệu</a>
                    </li>
                </ul>
            </div>

            <!-- Cột phải -->
            <div class="col-md-4 mb-4">
                <h5 class="fw-bold text-white" style="font-family: 'Playfair Display', serif;">Mạng xã hội</h5>
                <ul class="list-unstyled">
                    <li class="mb-1">
                        <a href="#" class="text-white-50 text-decoration-none">Facebook</a>
                    </li>
                    <li class="mb-1">
                        <a href="#" class="text-white-50 text-decoration-none">Instagram</a>
                    </li>
                    <li class="mb-1">
                        <a href="#" class="text-white-50 text-decoration-none">TikTok</a>
                    </li>
                </ul>
            </div>

        </div>

    </div>
</footer>

</body>
</html>
