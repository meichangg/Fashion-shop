<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt hàng - Fashion Shop</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <style>
        body {
            background-color: #f8f8f8;
            font-family: 'Montserrat', sans-serif;
        }

        /* Navbar */
        .custom-navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(8px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .nav-link {
            color: #333 !important;
            font-weight: 500;
        }

        .nav-link:hover {
            color: #a67c52 !important;
        }

        .brand-logo {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: #333 !important;
        }

        /* Form */
        .card {
            border-radius: 14px;
            border: none;
            box-shadow: 0 8px 20px rgba(0,0,0,0.07);
        }

        .card-header {
            background: #fff;
            font-family: 'Playfair Display', serif;
            font-size: 1.15rem;
            border-bottom: 1px solid #eee;
        }

        .form-control {
            border-radius: 10px;
        }

        .form-check-label {
            font-weight: 500;
        }

        .btn-primary-soft {
            background: #a67c52;
            color: white;
            padding: 10px 0;
            border-radius: 10px;
            font-weight: 600;
            transition: .25s;
            border: none;
        }

        .btn-primary-soft:hover {
            background: #8b6240;
        }

        /* Cart */
        .cart-total-box {
            background: #fff;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.07);
        }

        .cart-item {
            display: flex;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding: 12px 0;
        }

        .cart-item img {
            width: 65px;
            height: 65px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 12px;
            border: 1px solid #ddd;
            background: #fafafa;
        }

        h3, h5 {
            font-family: 'Playfair Display', serif;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg custom-navbar navbar-light py-3">
    <div class="container-fluid">
        <a class="navbar-brand brand-logo" href="${pageContext.request.contextPath}/home">FashionShop</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto"></ul>

            <form class="d-flex me-3" method="get" action="${pageContext.request.contextPath}/home">
                <input class="form-control me-2" type="search" placeholder="Tìm sản phẩm..." name="q" value="${keyword}">
                <button class="btn btn-outline-dark" type="submit">Tìm</button>
            </form>
        </div>
    </div>
</nav>

<div class="container my-4">

    <h3 class="mb-4">Đặt hàng</h3>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="row g-4">

        <!-- LEFT COLUMN -->
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header fw-semibold">Thông tin giao hàng</div>

                <div class="card-body">

                    <!-- FORM START -->
                    <form method="post" action="${pageContext.request.contextPath}/checkout" id="checkoutForm">

                        <!-- Họ tên -->
                        <div class="mb-3">
                            <label class="form-label">Họ tên</label>
                            <input type="text" class="form-control" name="fullName" value="${customer.fullName}" required>
                        </div>

                        <!-- Số điện thoại -->
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" name="phone" value="${customer.phone}" required>
                        </div>

                        <!-- Địa chỉ -->
                        <div class="mb-3">
                            <label class="form-label">Địa chỉ giao hàng</label>

                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="addressChoice" id="addrSaved" value="saved" checked>
                                <label class="form-check-label" for="addrSaved">Dùng địa chỉ đã lưu</label>
                            </div>

                            <textarea class="form-control mb-2" rows="2" name="savedAddress" id="savedAddress" required>${customer.address}</textarea>

                            <div class="form-check mt-2">
                                <input class="form-check-input" type="radio" name="addressChoice" id="addrNew" value="new">
                                <label class="form-check-label" for="addrNew">Nhập địa chỉ mới</label>
                            </div>

                            <textarea class="form-control" rows="3" name="newAddress" id="newAddress"
                                      placeholder="Nhập địa chỉ giao hàng mới..." disabled></textarea>
                        </div>

                        <!-- Thanh toán -->
                        <div class="mb-3">
                            <label class="form-label">Phương thức thanh toán</label>

                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" value="COD" checked>
                                <label class="form-check-label">Thanh toán khi nhận hàng (COD)</label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" value="Bank Transfer">
                                <label class="form-check-label">Chuyển khoản ngân hàng</label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" value="E-Wallet">
                                <label class="form-check-label">Ví điện tử (Momo, ZaloPay...)</label>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary-soft w-100 mt-2">Xác nhận đặt hàng</button>
                    </form>
                    <!-- FORM END -->

                </div>
            </div>
        </div>

        <!-- RIGHT COLUMN -->
        <div class="col-md-6">
            <div class="cart-total-box shadow-sm">
                <h5 class="fw-bold mb-3">Tổng đơn hàng</h5>

                <c:forEach items="${sessionScope.cart}" var="entry">
                    <c:set var="item" value="${entry.value}" />

                    <div class="cart-item d-flex justify-content-between align-items-center">
                        <img src="${item.product.thumbnailUrl}">
                        <div class="flex-grow-1 ms-2">
                            <div class="cart-item-name">${item.product.productName}</div>
                            <div class="text-muted">Số lượng: ${item.quantity}</div>
                        </div>
                        <div class="cart-item-total text-end" style="min-width: 110px;">
                            ${item.lineTotal} đ
                        </div>
                    </div>
                </c:forEach>

                <p class="mt-3 mb-1">Tạm tính: <strong>${cartTotal} đ</strong></p>
                <p class="mb-1">Phí vận chuyển: <strong>Miễn phí</strong></p>
                <hr>
                <h4 class="text-danger">Tổng thanh toán: <strong>${cartTotal} đ</strong></h4>
            </div>
        </div>

    </div>
</div>

<!-- FOOTER -->
<footer class="mt-5 py-5" style="background: #c19b6d;">
    <div class="container">
        <div class="row">

            <div class="col-md-4 mb-4">
                <h5 class="fw-bold text-white" style="font-family: 'Playfair Display', serif;">Liên hệ</h5>
                <p class="mb-1 text-white-50">Địa chỉ: Hà Nội</p>
                <p class="mb-1 text-white-50">Số điện thoại: 999999999</p>
            </div>

            <div class="col-md-4 mb-4">
                <h5 class="fw-bold text-white" style="font-family: 'Playfair Display', serif;">Thông tin</h5>
                <ul class="list-unstyled">
                    <li class="mb-1"><a href="#" class="text-white-50 text-decoration-none">Danh mục sản phẩm</a></li>
                    <li class="mb-1"><a href="#" class="text-white-50 text-decoration-none">Giới thiệu</a></li>
                </ul>
            </div>

            <div class="col-md-4 mb-4">
                <h5 class="fw-bold text-white" style="font-family: 'Playfair Display', serif;">Mạng xã hội</h5>
                <ul class="list-unstyled">
                    <li class="mb-1"><a href="#" class="text-white-50 text-decoration-none">Facebook</a></li>
                    <li class="mb-1"><a href="#" class="text-white-50 text-decoration-none">Instagram</a></li>
                    <li class="mb-1"><a href="#" class="text-white-50 text-decoration-none">TikTok</a></li>
                </ul>
            </div>

        </div>
    </div>
</footer>

<!-- SCRIPTS -->
<script>
    const addrSaved = document.getElementById("addrSaved");
    const addrNew = document.getElementById("addrNew");
    const newAddress = document.getElementById("newAddress");
    const savedAddress = document.getElementById("savedAddress");

    function toggleAddress() {
        if (addrNew.checked) {
            newAddress.disabled = false;
            newAddress.required = true;

            savedAddress.disabled = true;
            savedAddress.required = false;
        } else {
            newAddress.disabled = true;
            newAddress.required = false;

            savedAddress.disabled = false;
            savedAddress.required = true;
        }
    }

    addrSaved.addEventListener("change", toggleAddress);
    addrNew.addEventListener("change", toggleAddress);

    toggleAddress();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body> 
</html>
