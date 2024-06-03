import React from 'react';
import { Modal, Form, Input, message } from 'antd';

interface AddEquipementFormProps {
  visible: boolean;
  onCreate: (values: any) => void;
  onCancel: () => void;
}

const AddEquipementForm: React.FC<AddEquipementFormProps> = ({ visible, onCreate, onCancel }) => {
  const [form] = Form.useForm();

  const onFinish = async (values: any) => {
    try {
      onCreate(values);
      form.resetFields();
    } catch (error) {
      console.error('Error validating fields:', error);
      message.error('Failed to add Equipement');
    }
  };

  return (
    <Modal
      visible={visible}
      title="Add Equipement"
      okText="Add"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields().then((values) => {
          onFinish(values);
        });
      }} // Directly pass onFinish function
    >
      <Form form={form} layout="vertical">
        <Form.Item
          name="Equipementname"
          label="Equipement name"
          rules={[{ required: true, message: 'Please enter the Equipement name' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="quantity"
          label="Quantity"
          rules={[{ required: true, message: 'Please enter the quantity' }]}
        >
          <Input type="number" />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddEquipementForm;
