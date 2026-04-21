package com.myshop.dao;

import com.myshop.model.Product;
import com.myshop.util.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // ===== Map ResultSet thành Product =====
    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductID(rs.getInt("ProductID"));
        p.setCategoryID(rs.getInt("CategoryID"));
        p.setProductName(rs.getNString("ProductName"));
        p.setDescription(rs.getNString("Description"));
        p.setPrice(rs.getBigDecimal("Price"));
        p.setDiscountPercent(rs.getInt("DiscountPercent"));
        p.setStock(rs.getInt("Stock"));
        p.setThumbnailUrl(rs.getString("ThumbnailUrl"));
        return p;
    }

    // ===== Tìm kiếm sản phẩm =====
    public List<Product> search(String keyword, Integer categoryId) throws Exception {
        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM Products WHERE IsActive = 1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (ProductName LIKE ? OR Description LIKE ?)");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND CategoryID = ?");
        }

        try (Connection con = new DB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String k = "%" + keyword.trim() + "%";
                ps.setNString(idx++, k);
                ps.setNString(idx++, k);
            }
            if (categoryId != null && categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    // ===== Tìm sản phẩm theo ID =====
    public Product findById(int id) throws Exception {
        String sql = "SELECT * FROM Products WHERE ProductID = ?";
        try (Connection con = new DB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    // ===== Giảm tồn kho trong cùng Connection (dùng cho OrderDAO) =====
    public void reduceStock(Connection con, int productId, int quantity) throws Exception {
        String sql = "UPDATE Products SET Stock = Stock - ? " +
                     "WHERE ProductID = ? AND Stock >= ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new Exception("Không đủ tồn kho cho ProductID = " + productId);
            }
        }
    }
}
