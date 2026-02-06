import { useState } from "react";
import { Upload, Button, message, Card, Alert, Table } from "antd";
import { UploadOutlined } from "@ant-design/icons";
import client from "../api/client";

export default function ImportPage() {
  const [result, setResult] = useState(null);
  const [uploading, setUploading] = useState(false);

  const handleUpload = async (file) => {
    const formData = new FormData();
    formData.append("file", file);
    setUploading(true);

    try {
      const { data } = await client.post("/claim_imports", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      setResult(data);
      message.success(`Imported ${data.processed_records} of ${data.total_records} records`);
    } catch {
      message.error("Import failed");
    } finally {
      setUploading(false);
    }

    return false;
  };

  const errorColumns = [
    { title: "Row", dataIndex: "row", key: "row" },
    { title: "Error", dataIndex: "error", key: "error" },
  ];

  return (
    <div>
      <h2>Import Claims from CSV</h2>
      <Card style={{ marginBottom: 16 }}>
        <p>
          Upload a CSV file with columns: <code>patient_first_name</code>,{" "}
          <code>patient_last_name</code>, <code>patient_dob</code>,{" "}
          <code>claim_number</code>, <code>service_date</code>,{" "}
          <code>amount</code>, <code>status</code>
        </p>
        <Upload beforeUpload={handleUpload} accept=".csv" showUploadList={false}>
          <Button icon={<UploadOutlined />} type="primary" loading={uploading}>
            Select CSV File
          </Button>
        </Upload>
      </Card>

      {result && (
        <Card title="Import Results">
          <p>File: {result.file_name}</p>
          <p>Total records: {result.total_records}</p>
          <p>Processed: {result.processed_records}</p>
          <p>Failed: {result.failed_records}</p>

          {result.errors?.length > 0 && (
            <>
              <Alert type="warning" message="Some rows had errors" style={{ marginBottom: 16 }} />
              <Table
                dataSource={result.errors}
                columns={errorColumns}
                rowKey="row"
                size="small"
                pagination={false}
              />
            </>
          )}
        </Card>
      )}
    </div>
  );
}
