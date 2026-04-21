package com.myshop.dao;

import com.myshop.model.CartItem;
import com.myshop.util.DB;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

public class OrderDAO {

    public int createOrder(int customerId,
                           String shippingAddress,
                           String paymentMethod,
                           Map<Integer, CartItem> cart) throws Exception {

        if (cart == null || cart.isEmpty()) {
            throw new IllegalArgumentException("Cart is empty");
        }

        try (Connection con = new DB().getConnection()) {
            con.setAutoCommit(false);

            try {
                // ===== 1. Tính tổng tiền =====
                BigDecimal total = BigDecimal.ZERO;
                for (CartItem item : cart.values()) {
                    total = total.add(item.getLineTotal());
                }

                // ===== 2. Insert vào Orders =====
                String sqlOrder = "INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, " +
                                  "ShippingAddress, Status, PaymentMethod) " +
                                  "OUTPUT INSERTED.OrderID VALUES (?, SYSDATETIME(), ?, ?, N'Pending', ?)";

                int orderId;
                try (PreparedStatement ps = con.prepareStatement(sqlOrder)) {
                    ps.setInt(1, customerId);
                    ps.setBigDecimal(2, total);
                    ps.setNString(3, shippingAddress);
                    ps.setNString(4, paymentMethod);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new Exception("Cannot retrieve new OrderID");
                        }
                        orderId = rs.getInt(1);
                    }
                }

                // ===== 3. Insert OrderItems =====
                String sqlItem = "INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) " +
                                 "VALUES (?, ?, ?, ?)";

                try (PreparedStatement psItem = con.prepareStatement(sqlItem)) {
                    for (CartItem item : cart.values()) {
                        psItem.setInt(1, orderId);
                        psItem.setInt(2, item.getProduct().getProductID());
                        psItem.setInt(3, item.getQuantity());
                        psItem.setBigDecimal(4, item.getProduct().getFinalPrice());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }

                // ===== 4. Giảm tồn kho (dùng cùng connection!) =====
                ProductDAO productDAO = new ProductDAO();
                for (CartItem item : cart.values()) {
                    productDAO.reduceStock(con,
                            item.getProduct().getProductID(),
                            item.getQuantity());
                }

                // ===== 5. Commit =====
                con.commit();
                return orderId;

            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        }
    }
}
// Giảm tồn kho sử dụng cùng Connection (đảm bảo nằm trong transaction)
