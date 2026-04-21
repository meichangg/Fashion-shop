package com.myshop.dao;

import com.myshop.model.Customer;
import com.myshop.util.DB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CustomerDAO {

    public Customer findById(int id) throws Exception {
        String sql = "SELECT CustomerID, FullName, Email, Phone, Address FROM Customers WHERE CustomerID = ?";
        try (Connection con = new DB().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setCustomerID(rs.getInt("CustomerID"));
                    c.setFullName(rs.getNString("FullName"));
                    c.setEmail(rs.getString("Email"));
                    c.setPhone(rs.getString("Phone"));
                    c.setAddress(rs.getNString("Address"));
                    return c;
                }
            }
        }
        return null;
    }
}
