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
import dto.Category;


public class CategoryDAO {
    public boolean createCategory(String categoryName, String description) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM tblCategories WHERE categoryName = ? AND description = ?";
        try {
            try ( Connection conn = DBUtils.getConnection();  PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, categoryName);
                checkPs.setString(2, description);
                try ( ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return false;
                    }
                }
            }
            String insertSql = "INSERT INTO tblCategories (categoryName, description) VALUES (?, ?)";
            try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setString(1, categoryName);
                ps.setString(2, description);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteCategory(int id) throws Exception {
        String sql = "DELETE FROM tblCategories WHERE categoryID = ?";
        boolean isDeleted = false;
        try (Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, id);
            isDeleted = ps.executeUpdate() > 0;
        } 
        return isDeleted;
    }
    
    public ArrayList<Category> search(String search) throws SQLException {
        ArrayList<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM tblCategories WHERE categoryName LIKE ?";
        ResultSet rs = null;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (conn != null) {
                ps.setString(1, '%' + search + '%');
                rs = ps.executeQuery();
                while (rs.next()) {
                    int categoryID = rs.getInt("categoryID");
                    String categoryName = rs.getString("categoryName");
                    String description = rs.getString("description");
                    list.add(new Category(categoryID, categoryName, description));
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

    public Category getCategoryById(int id) throws SQLException {
        String sql = "SELECT * FROM tblCategories WHERE categoryID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(rs.getInt("categoryID"), rs.getString("categoryName"), rs.getString("description"));
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateCategory(int id, String newName, String newDescription) throws Exception {
        String sql = "UPDATE tblCategories SET categoryName = ?, description = ? WHERE categoryID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newName);
            stmt.setString(2, newDescription);
            stmt.setInt(3, id);
            return stmt.executeUpdate() > 0;
        }
    }
}
