package com.myshop.dao;

import com.myshop.model.Category;
import com.myshop.util.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAllActive() throws Exception {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName, IsActive FROM Categories WHERE IsActive = 1";

        try (Connection con = new DB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryID(rs.getInt("CategoryID"));
                c.setCategoryName(rs.getNString("CategoryName"));
                c.setActive(rs.getBoolean("IsActive"));
                list.add(c);
            }
        }
        return list;
    }
}
