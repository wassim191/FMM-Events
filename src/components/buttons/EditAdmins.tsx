import React, { useEffect } from 'react';
import { Modal, Form, Input } from 'antd';
import Adminddropdown from './adminroledropdown';



interface EditAdminsFormProps {
  visible: boolean;
  initialValues: any;
  onUpdate: (values: any) => void;
  onCancel: () => void;
}

const EditAdminsForm: React.FC<EditAdminsFormProps> = ({ visible, initialValues, onUpdate, onCancel }) => {
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
      title="Edit Admin"
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => form.validateFields().then(onFinish)}
    >
      <Form form={form} layout="vertical" initialValues={initialValues}>
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

export default EditAdminsForm;
