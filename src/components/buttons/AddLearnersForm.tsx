import React from 'react';
import { Modal, Form, Input, Button } from 'antd';
import StatusDropdown from './IsActiveDropdown';

interface AddLearnersFormProps {
  visible: boolean;
  onCreate: (values: any) => void;
  onCancel: () => void;
}

const AddLearnersForm: React.FC<AddLearnersFormProps> = ({ visible, onCreate, onCancel }) => {
  const [form] = Form.useForm();

  const onFinish = (values: any) => {
    onCreate(values);
    form.resetFields();
  };

  return (
    <Modal
      visible={visible}
      title="Add Learner"
      okText="Add"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields().then((values) => {
          onFinish(values);
        });
      }}
    >
      <Form form={form} layout="vertical">
        <Form.Item
          name="name"
          label="name"
          rules={[{ required: true, message: 'Please enter the name' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="cin"
          label="cin"
          rules={[{ required: true, message: 'Please enter the CIN' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="email"
          label="email"
          rules={[{ required: true, message: 'Please enter the Email' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="password"
          label="password"
          rules={[{ required: true, message: 'Please enter the Password' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="isActive"
          label="isActive"
          rules={[{ required: true, message: 'Please enter the name' }]}
        >
        <StatusDropdown
            value={form.getFieldValue('isActive')}
            onChange={(value) => form.setFieldsValue({ isActive: value })}
        />   
        </Form.Item>
        {/* Add more Form.Item components for other fields */}
      </Form>
    </Modal>
  );
};

export default AddLearnersForm;
