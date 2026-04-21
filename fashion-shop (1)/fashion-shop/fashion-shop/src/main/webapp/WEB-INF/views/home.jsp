<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Fashion Shop</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <style>
        /* Navbar */
        .custom-navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(8px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .custom-navbar .nav-link {
            color: #333 !important;
            font-weight: 500;
            transition: color 0.3s;
        }
        .custom-navbar .nav-link:hover,
        .custom-navbar .nav-link.active {
            color: #a67c52 !important;
        }
        .brand-logo {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            letter-spacing: 2px;
            color: #333 !important;
        }

        /* Banner */
        .banner-img {
            width: 100%;
            height: 420px;
            object-fit: cover;
        }

        /* Product */
        .product-img {
            width: 100%;
            aspect-ratio: 1 / 1;
            object-fit: cover;
            transition: transform 0.3s;
        }
        .product-img:hover {
            transform: scale(1.05);
        }

        .card {
            border: none;
            background: #fff;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .card-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem;
            font-weight: 600;
        }

        .card-body p {
            font-family: 'Montserrat', sans-serif;
            font-size: 0.85rem;
            color: #666;
        }

        .btn-primary {
            background-color: #a67c52;
            border-color: #a67c52;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-primary:hover {
            background-color: #8b6240;
            border-color: #8b6240;
        }

        /* Footer */
        .footer {
            background: #222;
            color: #eee;
            padding: 40px 0;
            margin-top: 40px;
        }
        .footer h5 {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem;
            margin-bottom: 20px;
        }
        .footer a {
            color: #ccc;
            text-decoration: none;
            display: block;
            margin-bottom: 8px;
        }
        .footer a:hover {
            color: #a67c52;
        }

        .container {
            max-width: 1300px;
        }
    </style>
</head>

<body class="bg-light">

<!-- NAVBAR -->
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
                <li class="nav-item">
                    <a class="nav-link ${selectedCid==null ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/home">Tất cả</a>
                </li>
                <c:forEach items="${categories}" var="c">
                    <li class="nav-item">
                        <a class="nav-link ${selectedCid==c.categoryID ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/home?cid=${c.categoryID}">
                            ${c.categoryName}
                        </a>
                    </li>
                </c:forEach>
            </ul>

            <form class="d-flex me-3" method="get" action="${pageContext.request.contextPath}/home">
                <input class="form-control me-2" type="search" placeholder="Tìm sản phẩm..."
                       name="q" value="${keyword}">
                <button class="btn btn-outline-dark" type="submit">Tìm</button>
            </form>

            <a class="btn btn-outline-dark d-none d-lg-block"
                href="${pageContext.request.contextPath}/cart">
                 <img src="https://cdn-icons-png.flaticon.com/512/263/263142.png" 
                    alt="Giỏ hàng" 
                    style="width:23px; height:23px;">
            </a>
        </div>
    </div>
</nav>


<!-- BANNER SLIDER 5 ẢNH -->
<div id="mainBanner" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-inner">

        <div class="carousel-item active">
            <img src="https://img3.thuthuatphanmem.vn/uploads/2019/10/14/banner-thoi-trang-dep_113856538.jpg" class="d-block w-100 banner-img" alt="Banner 1">
        </div> 

        <div class="carousel-item">
            <img src="https://badass.vn/wp-content/uploads/2025/03/BANNER-WEB-1350X490.jpg" class="d-block w-100 banner-img" alt="Banner 2">
        </div>

        <div class="carousel-item">
            <img src="https://theme.hstatic.net/200000163591/1001304285/14/ms_banner_img1.jpg?v=170" class="d-block w-100 banner-img" alt="Banner 3">
        </div>

    </div>

    <!-- Nút điều hướng -->
    <button class="carousel-control-prev" type="button" data-bs-target="#mainBanner" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#mainBanner" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>
<style>
.banner-img {
    width: 100%;
    height: 500px; /* hoặc chiều cao bạn muốn */
    object-fit: cover;       /* ảnh vẫn phủ hết khung */
    object-position: top left; /* căn từ đầu (trái trên) */
}
</style>


<!-- PRODUCTS -->
<div class="container my-5">
    <div class="row g-4">

        <c:if test="${empty products}">
            <div class="col-12 text-center py-5">
                <h5 class="text-muted">Không tìm thấy sản phẩm nào</h5>
            </div>
        </c:if>

        <c:forEach items="${products}" var="p">
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card h-100">

                    <img src="${p.thumbnailUrl}" class="card-img-top product-img"
                         alt="${p.productName}">

                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title">${p.productName}</h6>
                        <p class="flex-grow-1">${p.description}</p>

                        <div class="fw-bold mb-2">
                            ${p.finalPrice} đ
                            <c:if test="${p.discountPercent > 0}">
                                <span class="text-decoration-line-through text-muted small">
                                    ${p.price} đ
                                </span>
                            </c:if>
                        </div>

                        <form method="get" action="${pageContext.request.contextPath}/cart" class="mt-auto">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="pid" value="${p.productID}">
                            <input type="hidden" name="qty" value="1">
                            <input type="hidden" name="from" value="home">
                            <input type="hidden" name="added" value="true">

                            <button type="button"
                                    class="btn btn-primary w-100 py-2 fw-bold add-to-cart-btn"
                                    data-pid="${p.productID}">
                                Thêm vào giỏ
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>

    </div>
</div>

<c:if test="${param.added == 'true'}">
    <div id="cart-alert" class="alert alert-success text-center m-0" 
         style="position: absolute; left: 50%; transform: translateX(-50%); z-index: 1050; max-width: 90%;">
        Sản phẩm đã được thêm vào giỏ hàng.
    </div>

    <script>
        // Lấy vị trí cuộn hiện tại
        const alert = document.getElementById('cart-alert');
        const scrollY = window.scrollY || window.pageYOffset;
        alert.style.top = (scrollY + 20) + 'px'; // cách trên màn hình 20px
        // Tự ẩn sau 3 giây
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 3000);
    </script>
</c:if>
<!-- FOOTER -->
<footer class="mt-5 py-5" style="background: #c19b6d;">
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


<script>
document.addEventListener("DOMContentLoaded", function () {
    const buttons = document.querySelectorAll(".add-to-cart-btn");

    buttons.forEach(btn => {
        btn.addEventListener("click", function () {
            const pid = this.getAttribute("data-pid");

            fetch("${pageContext.request.contextPath}/cart", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "action=add&pid=" + pid + "&qty=1"
            })
            .then(res => res.text())
            .then(data => {
                // Tạo toast
                const toast = document.createElement("div");
                toast.className = "alert alert-success text-center";
                toast.innerText = "Sản phẩm đã được thêm vào giỏ hàng.";

                // CSS cố định theo viewport
                toast.style.position = "fixed";           // fixed để dính theo màn hình
                toast.style.top = "20px";                 // cách trên viewport 20px
                toast.style.left = "50%";                 // căn giữa
                toast.style.transform = "translateX(-50%) translateY(-20px)";
                toast.style.zIndex = "1050";
                toast.style.maxWidth = "90%";
                toast.style.opacity = "0";
                toast.style.transition = "opacity 0.5s, transform 0.5s";
                toast.style.pointerEvents = "none";      // không chặn click

                document.body.appendChild(toast);

                // Hiển thị từ từ
                requestAnimationFrame(() => {
                    toast.style.opacity = "1";
                    toast.style.transform = "translateX(-50%) translateY(0)";
                });

                // Ẩn sau 2.5 giây
                setTimeout(() => {
                    toast.style.opacity = "0";
                    toast.style.transform = "translateX(-50%) translateY(-20px)";
                    setTimeout(() => toast.remove(), 500);
                }, 2500);
            })
            .catch(err => console.error(err));
        });
    });
});
</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
