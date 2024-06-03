import React from 'react';
import { Modal, Form, Input } from 'antd';
import AdminRoleDropdown from './adminroledropdown';
import Adminddropdown from './adminroledropdown';

interface AddAdminsFormProps {
  visible: boolean;
  onCreate: (values: any) => void;
  onCancel: () => void;
}

const AddAdminsForm: React.FC<AddAdminsFormProps> = ({ visible, onCreate, onCancel }) => {
  const [form] = Form.useForm();

  const onFinish = (values: any) => {
    onCreate(values);
    form.resetFields();
  };

  return (
    <Modal
      visible={visible}
      title="Add Admin"
      okText="Add"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields().then((values) => {
          onFinish(values);
        });
      }}
    >
      <Form form={form} layout="vertical" >
        <Form.Item
          name="username"
          label="Username"
          rules={[{ required: true, message: 'Please enter the Username' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="password"
          label="Password"
          rules={[{ required: true, message: 'Please enter the Password' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Role"
          name="role"
          rules={[{ required: true, message: 'Please select a role' }]}
        >
          <Adminddropdown onChange={(value) => form.setFieldsValue({ Role: value })} />    
              </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddAdminsForm;
