package com.myshop.controller;

import com.myshop.util.DB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.File;
import java.math.BigDecimal;
import java.sql.*;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet(name = "InvoicePdfServlet", urlPatterns = {"/invoice-pdf"})
public class InvoicePdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderId");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid orderId");
            return;
        }

        try (Connection con = new DB().getConnection()) {

            String sql = "SELECT * FROM vw_InvoiceDetail WHERE OrderID = ? ORDER BY OrderItemID";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, orderId);

                try (ResultSet rs = ps.executeQuery()) {

                    // Nếu không có dữ liệu -> trả text dễ hiểu
                    if (!rs.next()) {
                        response.setContentType("text/plain; charset=UTF-8");
                        try (PrintWriter out = response.getWriter()) {
                            out.println("Không tìm thấy hóa đơn #" + orderId);
                        }
                        return;
                    }

                    // ----------- KIỂM TRA FONT -------------
                    String fontPath = getServletContext()
                            .getRealPath("/WEB-INF/fonts/arial.ttf");
                    File fontFile = new File(fontPath);
                    if (!fontFile.exists()) {
                        response.setContentType("text/plain; charset=UTF-8");
                        try (PrintWriter out = response.getWriter()) {
                            out.println("Font file not found: " + fontPath);
                        }
                        return;
                    }
                    // ---------------------------------------

                    // Lấy thông tin chung từ dòng đầu tiên
                    String customerName = rs.getNString("CustomerName");
                    String customerEmail = rs.getString("CustomerEmail");
                    String customerPhone = rs.getString("CustomerPhone");
                    String shippingAddress = rs.getNString("ShippingAddress");
                    String paymentMethod = rs.getNString("PaymentMethod");
                    Timestamp orderDate = rs.getTimestamp("OrderDate");
                    BigDecimal totalAmount = rs.getBigDecimal("TotalAmount");

                    // Chuẩn bị HTTP response là PDF
                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition",
                            "inline; filename=invoice-" + orderId + ".pdf");

                    Document doc = new Document(PageSize.A4, 36, 36, 36, 36);
                    PdfWriter.getInstance(doc, response.getOutputStream());
                    doc.open();

                    // ---------- FONT UNICODE (TIẾNG VIỆT) ----------
                    BaseFont bf = BaseFont.createFont(
                            fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                    Font titleFont = new Font(bf, 16, Font.BOLD);
                    Font normalFont = new Font(bf, 10, Font.NORMAL);
                    Font headerFont = new Font(bf, 10, Font.BOLD);
                    // ------------------------------------------------

                    // ----- Tiêu đề -----
                    Paragraph title = new Paragraph("HÓA ĐƠN MUA HÀNG", titleFont);
                    title.setAlignment(Element.ALIGN_CENTER);
                    title.setSpacingAfter(14f);
                    doc.add(title);

                    // ----- Thông tin shop & khách -----
                    StringBuilder sb = new StringBuilder();
                    sb.append("Fashion Shop\n");
                    sb.append("Mã đơn: #").append(orderId).append("\n");
                    sb.append("Ngày: ").append(orderDate).append("\n\n");
                    sb.append("Khách hàng: ").append(customerName).append("\n");
                    sb.append("Email: ").append(customerEmail).append("\n");
                    sb.append("Điện thoại: ").append(customerPhone).append("\n");
                    sb.append("Địa chỉ giao hàng: ").append(shippingAddress).append("\n");
                    sb.append("Thanh toán: ").append(paymentMethod).append("\n");

                    Paragraph info = new Paragraph(sb.toString(), normalFont);
                    info.setSpacingAfter(10f);
                    doc.add(info);

                    // ----- Bảng sản phẩm -----
                    PdfPTable table = new PdfPTable(4);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{4f, 1f, 2f, 2f});

                    addHeaderCell(table, "Sản phẩm", headerFont);
                    addHeaderCell(table, "SL", headerFont);
                    addHeaderCell(table, "Đơn giá", headerFont);
                    addHeaderCell(table, "Thành tiền", headerFont);

                    // Đã ở dòng đầu tiên, xử lý nó trước
                    do {
                        String name = rs.getNString("ProductName");
                        int qty = rs.getInt("Quantity");
                        BigDecimal unitPrice = rs.getBigDecimal("UnitPrice");
                        BigDecimal lineTotal = rs.getBigDecimal("LineTotal");

                        addBodyCell(table, name, normalFont);
                        addBodyCell(table, String.valueOf(qty), normalFont);
                        addBodyCell(table, unitPrice.toPlainString(), normalFont);
                        addBodyCell(table, lineTotal.toPlainString(), normalFont);
                    } while (rs.next());

                    doc.add(table);

                    // ----- Tổng tiền -----
                    Paragraph totalPara = new Paragraph(
                            "\nTổng cộng: " + totalAmount.toPlainString() + " đ",
                            normalFont);
                    totalPara.setAlignment(Element.ALIGN_RIGHT);
                    doc.add(totalPara);

                    doc.close();
                }
            }
        } catch (Exception e) {
            // Nếu có lỗi, trả text/plain để bạn đọc message chứ không phải PDF hỏng
            response.reset();
            response.setContentType("text/plain; charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.println("Lỗi khi xuất PDF:");
                out.println(e.getClass().getName() + ": " + e.getMessage());
            }
        }
    }

    private void addHeaderCell(PdfPTable table, String text, Font headerFont) {
        PdfPCell cell = new PdfPCell(new Phrase(text, headerFont));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
        cell.setPadding(5f);
        table.addCell(cell);
    }

    private void addBodyCell(PdfPTable table, String text, Font normalFont) {
        PdfPCell cell = new PdfPCell(new Phrase(text, normalFont));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(5f);
        table.addCell(cell);
    }
}
