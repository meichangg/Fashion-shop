<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt hàng thành công</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <!-- Style chung -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        .success-wrapper {
            max-width: 600px;
            margin: 0 auto;
        }
        .success-card {
            border-radius: 20px;
            padding: 40px 30px;
        }
        .success-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .success-info {
            font-size: 16px;
            color: #555;
        }
        .btn-primary-soft {
            background: #e7f1ff;
            color: #0d6efd;
            border: 1px solid #bcd8ff;
        }
        .btn-primary-soft:hover {
            background: #d8eaff;
            color: #0a58ca;
        }
    </style>
</head>

<body class="bg-light">

<div class="container my-5 success-wrapper">
    <div class="card shadow success-card text-center">

        <h3 class="success-title text-success mb-3">
            🎉 Đặt hàng thành công!
        </h3>

        <p class="success-info mb-1">
            Mã đơn hàng của bạn:
            <strong>#${orderId}</strong>
        </p>

        <p class="success-info mb-1">
            Địa chỉ giao hàng:
            <strong>${shippingAddress}</strong>
        </p>

        <p class="success-info mb-4">
            Phương thức thanh toán:
            <strong>${paymentMethod}</strong>
        </p>

        <div class="d-flex justify-content-center gap-2 mt-4">

            <a href="${pageContext.request.contextPath}/invoice-pdf?orderId=${orderId}"
               class="btn btn-primary-soft px-4">
                Xuất hóa đơn PDF
            </a>

            <a href="${pageContext.request.contextPath}/home"
               class="btn btn-outline-secondary px-4">
                Tiếp tục mua sắm
            </a>

        </div>
    </div>
</div>

</body>
</html>
