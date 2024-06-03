import React, { useEffect } from 'react';
import { Modal, Form, Input, Select } from 'antd';

const { Option } = Select;

interface EditRegisteredFormProps {
  visible: boolean;
  initialValues: any;
  onUpdate: (values: any) => void;
  onCancel: () => void;
}

const EditRegisteredForm: React.FC<EditRegisteredFormProps> = ({ visible, initialValues, onUpdate, onCancel }) => {
  const [form] = Form.useForm();

  useEffect(() => {
    form.setFieldsValue(initialValues);
  }, [initialValues]); // Set form fields when initialValues change

  const onFinish = (values: any) => {
    onUpdate({ ...initialValues, ...values });
    form.resetFields(); // Reset the form after a successful update
  };

  return (
    <Modal
      visible={visible}
      title="Edit Registered"
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => form.validateFields().then(onFinish)}
    >
      <Form form={form} layout="vertical" initialValues={initialValues}>
        <Form.Item
          name="name"
          label="Name"
          rules={[{ required: true, message: 'Please enter the Name' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="email"
          label="Email"
          rules={[{ required: true, message: 'Please enter the Email' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="Profname"
          label="Prof Name"
          rules={[{ required: true, message: 'Please enter the Prof. Name' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="category"
          label="Category"
          rules={[{ required: true, message: 'Please enter the category' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="status"
          label="Status"
          rules={[{ required: true, message: 'Please select the Status' }]}
        >
          <Select>
            <Option value="Paid">Paid</Option>
            <Option value="Not Paid">Not Paid</Option>
          </Select>
        </Form.Item>
        <Form.Item
          name="Attendance"
          label="Attendance"
          rules={[{ required: true, message: 'Please select the Attendance' }]}
        >
          <Select>
            <Option value={true}>True</Option>
            <Option value={false}>False</Option>
          </Select>
        </Form.Item>
        {/* Add more form items as needed */}
      </Form>
    </Modal>
  );
};

export default EditRegisteredForm;