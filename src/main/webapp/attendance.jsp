
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>


<%
if (session.getAttribute("admin") == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<%

String url = "jdbc:mysql://localhost:3306/attendance_db";
String user = "root";
String password = "Pass@96257";

String message = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con =
            DriverManager.getConnection(url, user, password)) {

            String action = request.getParameter("action");

            if ("add".equals(action)) {

                String sql =
                    "INSERT INTO employees(name, department) VALUES (?, ?)";

                try (PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setString(1, request.getParameter("name"));
                    ps.setString(2, request.getParameter("department"));

                    ps.executeUpdate();
                }

                message = "Employee added successfully!";
            }

            if ("attendance".equals(action)) {

                String sql =
                    "INSERT INTO attendance " +
                    "(employee_id, attendance_date, status) " +
                    "VALUES (?, CURDATE(), ?) " +
                    "ON DUPLICATE KEY UPDATE status = ?";

                try (PreparedStatement ps = con.prepareStatement(sql)) {

                    String status = request.getParameter("status");

                    ps.setInt(1, Integer.parseInt(
                        request.getParameter("employee_id")));

                    ps.setString(2, status);
                    ps.setString(3, status);

                    ps.executeUpdate();
                }

                message = "Attendance marked successfully!";
            }
        }

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Employee Attendance System</title>

    <style>
        body {
            font-family: Arial;
            background: #f1f5f9;
            margin: 0;
        }

        header {
            background: #1e3a8a;
            color: white;
            text-align: center;
            padding: 20px;
        }

        .container {
            width: 90%;
            max-width: 900px;
            margin: 30px auto;
        }

        .card {
            background: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0 15px;
            box-sizing: border-box;
        }

        button {
            background: #2563eb;
            color: white;
            padding: 12px;
            border: none;
            cursor: pointer;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #1e3a8a;
            color: white;
        }

        .message {
            color: green;
            font-weight: bold;
        }
    </style>
</head>

<body>


<header>
    <h1>Employee Attendance System</h1>

    <p>Employee Management and Daily Attendance</p>

    <a href="logout.jsp"
       style="color:white; background:#dc2626;
              padding:10px 20px; text-decoration:none;
              border-radius:5px;">
        Logout
    </a>
</header>


<div class="container">

    <div class="card">

        <p class="message"><%= message %></p>

        <h2>Add Employee</h2>

        <form method="post">

            <input type="hidden" name="action" value="add">

            <label>Employee Name</label>
            <input type="text" name="name" required>

            <label>Department</label>
            <input type="text" name="department" required>

            <button type="submit">Add Employee</button>

        </form>

    </div>

    <div class="card">

        <h2>Mark Attendance</h2>

        <form method="post">

            <input type="hidden" name="action" value="attendance">

            <label>Employee ID</label>
            <input type="number" name="employee_id" required>

            <label>Status</label>

            <select name="status">
                <option value="Present">Present</option>
                <option value="Absent">Absent</option>
            </select>

            <button type="submit">Mark Attendance</button>

        </form>

    </div>

    <div class="card">

        <h2>Employee Records</h2>

        <table>

            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Department</th>
            </tr>

            <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                try (Connection con =
                    DriverManager.getConnection(url, user, password);
                     Statement st = con.createStatement();
                     ResultSet rs =
                        st.executeQuery("SELECT * FROM employees")) {

                    while (rs.next()) {
            %>

            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("department") %></td>
            </tr>

            <%
                    }
                }

            } catch (Exception e) {
            %>

            <tr>
                <td colspan="3">Unable to load employee records.</td>
            </tr>

            <%
            }
            %>

        </table>

    </div>

    <div class="card">

        <h2>Attendance Records</h2>

        <table>

            <tr>
                <th>Employee ID</th>
                <th>Name</th>
                <th>Date</th>
                <th>Status</th>
            </tr>

            <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                try (Connection con =
                    DriverManager.getConnection(url, user, password);
                     Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery(
                        "SELECT e.id, e.name, a.attendance_date, a.status " +
                        "FROM attendance a JOIN employees e " +
                        "ON a.employee_id = e.id")) {

                    while (rs.next()) {
            %>

            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getDate("attendance_date") %></td>
                <td><%= rs.getString("status") %></td>
            </tr>

            <%
                    }
                }

            } catch (Exception e) {
            %>

            <tr>
                <td colspan="4">Unable to load attendance records.</td>
            </tr>

            <%
            }
            %>

        </table>

    </div>

</div>

</body>
</html>
