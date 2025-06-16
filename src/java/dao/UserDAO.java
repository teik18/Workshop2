/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import dto.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBUtils;

public class UserDAO {
    public User login(String userID, String password) throws ClassNotFoundException, SQLException {
        // Debug đầu vào
        System.out.println("UserDAO.login(): userID=" + userID + ", password=" + password);

        String sql = "SELECT fullName, roleID, phone FROM tblUsers WHERE userID = ? AND password = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userID);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String fullName = rs.getString("fullName");
                    String roleID   = rs.getString("roleID");
                    String phone = rs.getString("phone");
                    System.out.println("Login successful for " + userID + ", fullName=" + fullName + ", roleID=" + roleID);
                    // *** LƯU Ý: tham số cuối "***" chỉ dùng tạm, không quan trọng
                    return new User(userID, fullName, roleID, "***", phone);
                } else {
                    System.out.println("Login failed: no matching record");
                }
            }
        }
        return null;
    }
    
}
