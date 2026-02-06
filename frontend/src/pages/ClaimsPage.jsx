import { useEffect, useState } from "react";
import { Table, Tag, Button, Space, message } from "antd";
import { DownloadOutlined } from "@ant-design/icons";
import client from "../api/client";

const statusColors = {
  pending: "blue",
  paid: "green",
  denied: "red",
};

export default function ClaimsPage() {
  const [claims, setClaims] = useState([]);
  const [loading, setLoading] = useState(false);

  const fetchClaims = async () => {
    setLoading(true);
    try {
      const { data } = await client.get("/claims");
      setClaims(data);
    } catch {
      message.error("Failed to load claims");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchClaims();
  }, []);

  const handleExport = async () => {
    try {
      const response = await client.get("/claims/export", { responseType: "blob" });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", "claims_export.csv");
      document.body.appendChild(link);
      link.click();
      link.remove();
    } catch {
      message.error("Export failed");
    }
  };

  const columns = [
    {
      title: "Claim #",
      dataIndex: "claim_number",
      key: "claim_number",
      sorter: (a, b) => a.claim_number.localeCompare(b.claim_number),
    },
    {
      title: "Patient",
      dataIndex: "patient_name",
      key: "patient_name",
      sorter: (a, b) => a.patient_name.localeCompare(b.patient_name),
    },
    {
      title: "Service Date",
      dataIndex: "service_date",
      key: "service_date",
      sorter: (a, b) => new Date(a.service_date) - new Date(b.service_date),
    },
    {
      title: "Amount",
      dataIndex: "amount",
      key: "amount",
      render: (v) => `$${Number(v).toFixed(2)}`,
      sorter: (a, b) => a.amount - b.amount,
    },
    {
      title: "Status",
      dataIndex: "status",
      key: "status",
      render: (s) => <Tag color={statusColors[s]}>{s.toUpperCase()}</Tag>,
      sorter: (a, b) => a.status.localeCompare(b.status),
    },
  ];

  return (
    <div>
      <Space style={{ marginBottom: 16, width: "100%", justifyContent: "space-between" }}>
        <h2 style={{ margin: 0 }}>Claims</h2>
        <Button icon={<DownloadOutlined />} onClick={handleExport}>
          Export CSV
        </Button>
      </Space>
      <Table
        dataSource={claims}
        columns={columns}
        rowKey="id"
        loading={loading}
        pagination={{ pageSize: 20 }}
      />
    </div>
  );
}
