/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utils.DBUtils;
import dto.Product;
import dto.Category;
import java.util.List;


public class ProductDAO {
    public boolean createProduct(String name, int categoryID, float price, int quantity, String status) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM tblProducts WHERE name = ? AND categoryID = ?";
        try {
            try ( Connection conn = DBUtils.getConnection();  PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, name);
                checkPs.setInt(2, categoryID);
                try ( ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return false;
                    }
                }
            }
            String insertSql = "INSERT INTO tblProducts (name, categoryID, price, quantity, status) VALUES (?, ?, ?, ?, ?)";
            try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setString(1, name);
                ps.setInt(2, categoryID);
                ps.setFloat(3, price);
                ps.setInt(4, quantity);
                ps.setString(5, status);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteProduct(int id) throws Exception {
        String sql = "DELETE FROM tblProducts WHERE productID = ?";
        boolean isDeleted = false;
        try (Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, id);
            isDeleted = ps.executeUpdate() > 0;
        } 
        return isDeleted;
    }
    
    public boolean categoryExists(int categoryID) throws SQLException {
    String sql = "SELECT COUNT(*) FROM tblCategories WHERE categoryID = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, categoryID);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    };
    return false;
}
    
    public boolean updateProduct(int id, String newName, int newCategoryID, float newPrice, int newQuantity, String newStatus) throws Exception {
        String sql = "UPDATE tblProducts SET name = ?, categoryID = ?, price = ?, quantity = ?, status = ? WHERE productID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newName);
            stmt.setInt(2, newCategoryID);
            stmt.setFloat(3, newPrice);
            stmt.setInt(4, newQuantity);
            stmt.setString(5, newStatus);
            stmt.setInt(6, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public ArrayList<Product> search(String nameSearch, String cateSearch, float priceSearch, String statusSearch) throws SQLException {
        ArrayList<Product> list = new ArrayList<>();
        String sql =    "SELECT p.productID, p.name, c.categoryName, p.price, p.quantity, u.fullname, p.status\n" +
                        "FROM tblProducts p\n" +
                        "JOIN tblCategories c ON p.categoryID = c.categoryID\n" +
                        "LEFT JOIN tblUsers u ON p.sellerID = u.userID\n" +
                        "WHERE p.name LIKE ? AND c.categoryName LIKE ? AND p.status LIKE ?";
        if (priceSearch > 0) {
            sql += " AND p.price <= ?";
        }
        ResultSet rs = null;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn != null) {
                ps.setString(1, '%' + nameSearch + '%');
                ps.setString(2, '%' + cateSearch + '%');
                ps.setString(3, '%' + statusSearch + '%');
                if (priceSearch > 0) {
                    ps.setFloat(4, priceSearch);
                }
                rs = ps.executeQuery();
                while (rs.next()) {
                    int productID = rs.getInt("productID");
                    String name = rs.getString("name");
                    float price = rs.getFloat("price");
                    int quantity = rs.getInt("quantity");
                    String seller = rs.getString("fullname");
                    String status = rs.getString("status");
                    String cateName = rs.getString("categoryName");
                    list.add(new Product(productID, quantity, price, name, seller, status, cateName));
                }
            }
        } catch (Exception e) {
        } finally {
            if (rs != null) {
                rs.close();
            }
        }
        return list;
    }
    
    public List<Product> getProductsByUser(String userID) throws SQLException {
        String sql =    "SELECT p.productID, p.name, c.categoryName, p.price, p.quantity, u.fullname, p.status\n" +
                        "FROM tblProducts p\n" +
                        "JOIN tblCategories c ON p.categoryID = c.categoryID\n" +
                        "JOIN tblUsers u ON p.sellerID = u.userID\n" +
                        "WHERE p.sellerID = ?;";;
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productID = rs.getInt("productID");
                    String name = rs.getString("name");
                    Float price = Float.parseFloat(rs.getString("price")); 
                    int quantity = Integer.parseInt(rs.getString("quantity"));
                    String seller = rs.getString("fullname");
                    String status = rs.getString("status");
                    String cateName = rs.getString("categoryName");
                    list.add(new Product(productID, quantity, price, name, seller, status, cateName));
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Product getProductById(int id) throws SQLException {
    String sql = "SELECT p.productID, p.name, p.categoryID, p.price, p.quantity, p.status, p.sellerID, u.fullname " +
                 "FROM tblProducts p " +
                 "LEFT JOIN tblUsers u ON p.sellerID = u.userID " +
                 "WHERE p.productID = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String seller = rs.getString("fullname") != null ? rs.getString("fullname") : "Unknown";
                return new Product(rs.getInt("productID"), rs.getInt("categoryID"), rs.getInt("quantity"), 
                                   rs.getFloat("price"), rs.getString("name"), seller, rs.getString("status"));
            }
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    return null;
}
    
    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT categoryID, categoryName, description FROM tblCategories";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(new Category(
                    rs.getInt("categoryID"),
                    rs.getString("categoryName"),
                    rs.getString("description")
                ));
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return categories;
    }
}
