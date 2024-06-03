import React, { useEffect } from 'react';
import { Modal, Form, Input, Button } from 'antd';
import IsActiveDropdown from './IsActiveDropdown';

interface EditLearnersFormProps {
  visible: boolean;
  initialValues: any;
  onUpdate: (values: any) => void;
  onCancel: () => void;
}

const EditLearnersForm: React.FC<EditLearnersFormProps> = ({ visible, initialValues, onUpdate, onCancel }) => {
  const [form] = Form.useForm();

  useEffect(() => {
    form.setFieldsValue(initialValues);
  }, [initialValues]); // Set form fields when initialValues change

  const onFinish = (values: any) => {
    onUpdate({ ...initialValues, ...values });
  };
  

  return (
    <Modal
      visible={visible}
      title="Edit Learner"
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields().then((values) => {
          onFinish(values);
          form.resetFields(); // Reset the form after a successful update
        });
      }}
    >
      <Form form={form} layout="vertical" initialValues={initialValues}>
        <Form.Item
          name="name"
          label="Name"
          rules={[{ required: true, message: 'Please enter the name' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="cin"
          label="CIN"
          rules={[{ required: true, message: 'Please enter the CIN' }]}
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
          name="password"
          label="Password"
          rules={[{ required: true, message: 'Please enter the Password' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="isActive"
          label="isActive"
          rules={[{ required: true, message: 'Please select the status' }]}
        >
          <IsActiveDropdown
            value={form.getFieldValue('isActive')}
            onChange={(value) => form.setFieldsValue({ isActive: value })}
          />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default EditLearnersForm;
