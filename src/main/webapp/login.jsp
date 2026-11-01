
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
if (session.getAttribute("admin") != null) {
    response.sendRedirect("attendance.jsp");
    return;
}

String error = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/attendance_db",
                "root",
                "Pass@96257")) {

            String sql =
                "SELECT * FROM admin WHERE username=? AND password=?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        session.setAttribute("admin", username);

                        response.sendRedirect("attendance.jsp");
                        return;

                    } else {
                        error = "Invalid username or password!";
                    }
                }
            }
        }

    } catch (Exception e) {
        error = "Database Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Admin Login</title>

<style>
body {
    font-family: Arial;
    background: #f1f5f9;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
}

.login-box {
    background: white;
    width: 350px;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 4px 15px #ccc;
}

h2 {
    text-align: center;
    color: #1e3a8a;
}

input {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    box-sizing: border-box;
}

button {
    width: 100%;
    padding: 12px;
    background: #2563eb;
    color: white;
    border: none;
    cursor: pointer;
}

.error {
    color: red;
    text-align: center;
}
</style>

</head>

<body>

<div class="login-box">

    <h2>Admin Login</h2>

    <p class="error"><%= error %></p>

    <form method="post">

        <label>Username</label>

        <input type="text"
               name="username"
               placeholder="Enter username"
               required>

        <label>Password</label>

        <input type="password"
               name="password"
               placeholder="Enter password"
               required>

        <button type="submit">Login</button>

    </form>

</div>

</body>
</html>
