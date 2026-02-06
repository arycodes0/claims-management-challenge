import { Navigate, Outlet, useNavigate, useLocation } from "react-router-dom";
import { Layout, Menu } from "antd";
import { TableOutlined, UploadOutlined, LogoutOutlined } from "@ant-design/icons";
import client from "../api/client";

const { Header, Content } = Layout;

export default function ProtectedRoute() {
  const token = localStorage.getItem("token");
  const navigate = useNavigate();
  const location = useLocation();

  if (!token) return <Navigate to="/login" replace />;

  const handleMenuClick = ({ key }) => {
    if (key === "logout") {
      client.delete("/logout").catch(() => {});
      localStorage.removeItem("token");
      navigate("/login");
    } else {
      navigate(key);
    }
  };

  const menuItems = [
    { key: "/claims", icon: <TableOutlined />, label: "Claims" },
    { key: "/import", icon: <UploadOutlined />, label: "Import" },
    { key: "logout", icon: <LogoutOutlined />, label: "Logout" },
  ];

  return (
    <Layout style={{ minHeight: "100vh" }}>
      <Header>
        <Menu
          theme="dark"
          mode="horizontal"
          selectedKeys={[location.pathname]}
          items={menuItems}
          onClick={handleMenuClick}
        />
      </Header>
      <Content style={{ padding: "24px" }}>
        <Outlet />
      </Content>
    </Layout>
  );
}
